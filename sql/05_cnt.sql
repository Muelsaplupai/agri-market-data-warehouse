USE agrimarket;
set hive.stats.column.autogather=false;
WITH tmp_catch_cnt AS(
    SELECT (SELECT COUNT(*) FROM dwd_price WHERE ) AS price_cnt,
           (SELECT COUNT(DISTINCT pz) FROM dwd_price) AS pz_cnt,
           (SELECT COUNT(DISTINCT market) FROM dwd_price) AS market_cnt,
           (SELECT COUNT(*) FROM ads_enterprise) AS enterprise_cnt
)
INSERT OVERWRITE TABLE dwb_catch_cnt_daily
    SELECT pz_cnt,
           market_cnt,
           price_cnt AS data_cnt,
           enterprise_cnt,
           CURRENT_DATE AS release_date
    FROM tmp_catch_cnt;

WITH all_data_cnt AS(
    SELECT SUM(pz_cnt) FROM dwb_catch_cnt_daily
)
INSERT OVERWRITE TABLE ads_catch_cnt_daily
    SELECT pz_cnt, market_cnt, data_cnt, enterprise_cnt FROM dwb_catch_cnt_daily WHERE release_date = CURRENT_DATE;