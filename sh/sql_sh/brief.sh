#!/bin/bash
/export/server/hive/bin/hive -e "use agrimarket;
set hive.stats.column.autogather=false;
set hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE dwb_brief_market_pz_cnt
    SELECT market, COUNT(DISTINCT pz) AS pz_cnt
    FROM dwd_price
    GROUP BY market;

INSERT OVERWRITE TABLE dwb_brief_market_diff
    SELECT DISTINCT m.market,
           m.pz,
           (m.average - p.average) AS diff_price
    FROM dwd_price m
    JOIN dwb_price p ON (m.prvc = p.prvc) AND (m.pz = p.pz) AND m.release_date = p.release_date
    WHERE m.release_date = DATE_SUB(CURRENT_DATE, 1);

WITH top_above AS (
    SELECT market, pz, diff_price,
           ROW_NUMBER() OVER (PARTITION BY market ORDER BY diff_price DESC) AS rank
    FROM dwb_brief_market_diff
    WHERE diff_price > 0
),
top_below AS (
    SELECT market, pz, diff_price,
           ROW_NUMBER() over (PARTITION BY market ORDER BY diff_price) AS rank
    FROM dwb_brief_market_diff
    WHERE diff_price < 0
)
INSERT OVERWRITE TABLE ads_brief_market
    SELECT c.market,
           c.pz_cnt,
           CONCAT_WS('、', COLLECT_SET(b.pz)) AS low_pz,
           CONCAT_WS('、', COLLECT_SET(a.pz)) AS high_pz
    FROM dwb_brief_market_pz_cnt c
    LEFT JOIN (SELECT market, pz FROM top_above WHERE rank <= 5) a ON a.market = c.market
    LEFT JOIN (SELECT market, pz FROM top_below WHERE rank <= 5) b ON b.market = c.market
    GROUP BY c.market, c.pz_cnt;

WITH top5_pz AS (
    SELECT prvc, CONCAT_WS('、', COLLECT_SET(pz)) AS main_pz
    FROM(SELECT prvc, pz,
                ROW_NUMBER() OVER (PARTITION BY prvc ORDER BY COUNT(*) DESC) AS rn
         FROM dwd_price
         GROUP BY prvc, pz) tmp
    WHERE rn <= 5
    GROUP BY prvc
)
INSERT OVERWRITE TABLE dwb_brief_prvc
    SELECT m.prvc, m.market_cnt, main_pz
    FROM (SELECT prvc, COUNT(DISTINCT market) AS market_cnt FROM dwd_price GROUP BY prvc) m
    LEFT JOIN top5_pz p ON m.prvc = p.prvc;

INSERT OVERWRITE TABLE dwb_brief_prvc_diff
    SELECT DISTINCT p.prvc, p.pz, (p.average - COALESCE(NULLIF(c.average, 0), p.average)) AS diff_price
    FROM dwb_price p
    LEFT JOIN dwb_price c ON c.pz = p.pz AND c.prvc = '全国' AND p.release_date = c.release_date
    WHERE p.release_date = DATE_SUB(CURRENT_DATE, 1);

WITH top_abovec AS (
    SELECT prvc, pz, diff_price,
           ROW_NUMBER() OVER (PARTITION BY prvc ORDER BY diff_price DESC) AS rank
    FROM dwb_brief_prvc_diff
    WHERE diff_price > 0
),
top_belowc AS (
    SELECT prvc, pz, diff_price,
           ROW_NUMBER() OVER (PARTITION BY prvc ORDER BY diff_price) AS rank
    FROM dwb_brief_prvc_diff
    WHERE diff_price > 0
)
INSERT OVERWRITE TABLE ads_brief_prvc
    SELECT p.prvc,
           p.market_cnt AS market_num,
           p.main_pz,
           CONCAT_WS('、', COLLECT_SET(b.pz)) AS low_pz,
           CONCAT_WS('、', COLLECT_SET(a.pz)) AS high_pz
    FROM dwb_brief_prvc p
    LEFT JOIN (SELECT prvc, pz FROM top_abovec WHERE rank <= 5) a ON a.prvc = p.prvc
    LEFT JOIN (SELECT prvc, pz FROM top_belowc WHERE rank <= 5) b ON b.prvc = p.prvc
    GROUP BY p.prvc, p.market_cnt, p.main_pz;

WITH high_prvc AS(
    SELECT pz, prvc, diff_price,
           ROW_NUMBER() OVER (PARTITION BY pz ORDER BY diff_price DESC) AS rank
    FROM dwb_brief_prvc_diff
    WHERE diff_price > 0
),
low_prvc AS(
    SELECT pz, prvc, diff_price,
           ROW_NUMBER() OVER (PARTITION BY pz ORDER BY diff_price) AS rank
    FROM dwb_brief_prvc_diff
    WHERE diff_price < 0
)
INSERT OVERWRITE TABLE dwb_brief_pz
    SELECT p.pz,
           CONCAT_WS('、', COLLECT_SET(l.prvc)) AS low_prvc,
           CONCAT_WS('、', COLLECT_SET(h.prvc)) AS high_prvc
    FROM ads_price_pz p
    LEFT JOIN (SELECT prvc, pz FROM high_prvc WHERE rank <= 5) h ON h.pz = p.pz
    LEFT JOIN (SELECT prvc, pz FROM low_prvc WHERE rank <= 5) l ON l.pz = p.pz
    GROUP BY p.pz;

INSERT OVERWRITE TABLE ads_brief_pz
    SELECT b.pz,
           ROUND(p.average, 2) AS average,
           b.low_prvc,
           b.high_prvc
    FROM dwb_brief_pz b
    LEFT JOIN (SELECT pz, average, ROW_NUMBER() OVER (PARTITION BY pz ORDER BY average) AS rn
               FROM dwb_price
               WHERE prvc = '全国' AND release_date = DATE_SUB(CURRENT_DATE, 1)) p ON p.pz = b.pz AND p.rn = 1;

 INSERT OVERWRITE TABLE ads_price_variation_daily
    SELECT t.pz, t.market, ROUND(MAX((t.average - COALESCE(y.average, t.average))), 2) AS variation
    FROM dwd_price t
    LEFT JOIN dwd_price y ON y.pz = t.pz AND y.market = t.market AND y.release_date = DATE_SUB(t.release_date, 1)
    WHERE t.release_date = DATE_SUB(CURRENT_DATE, 1)
    GROUP BY t.pz, t.market;

INSERT OVERWRITE TABLE ads_price_prvc_variation_daily
    SELECT t.pz, t.prvc, ROUND(MAX(t.average - COALESCE(y.average, t.average)), 2) AS variation
    FROM dwb_price t
    LEFT JOIN dwb_price y ON y.pz = t.pz AND y.prvc = t.prvc AND y.release_date = DATE_SUB(t.release_date, 1)
    WHERE t.release_date = DATE_SUB(CURRENT_DATE, 1)
    GROUP BY t.pz, t.prvc;

INSERT OVERWRITE TABLE ads_price_prvc_peak_daily
    SELECT prvc, pz,
           MAX(COALESCE(NULLIF(highest, 0), NULLIF(average, 0), NULLIF(lowest, 0), 0)) AS highest,
           MIN(COALESCE(NULLIF(lowest, 0), NULLIF(average, 0), NULLIF(highest, 0), 0)) AS lowest
    FROM dwd_price
    WHERE release_date = DATE_SUB(CURRENT_DATE, 1)
    GROUP BY prvc, pz;"