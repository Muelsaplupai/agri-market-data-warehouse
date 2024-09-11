use agrimarket;
set hive.stats.column.autogather=false;

WITH analysis_index AS(
    SELECT u.pl, u.type, i.index, i.release_date
    FROM ods_price_index i
    JOIN utils_index u ON u.name=i.name
    -- WHERE i.release_date=DATE_SUB(CURRENT_DATE, 1)
)
INSERT INTO dwd_price_index
    SELECT pl, type, index, release_date
    FROM analysis_index;

INSERT OVERWRITE TABLE dws_price_index
SELECT t.pl,
       t.type,
       t.index,
       CASE WHEN y1.index IS NOT NULL THEN (t.index - y1.index) END AS rise_1_day,
       CASE WHEN y3.index IS NOT NULL THEN (t.index - y3.index) END AS rise_3_days,
       CASE WHEN y5.index IS NOT NULL THEN (t.index - y5.index) END AS rise_5_days,
       0 AS qoq
FROM dwd_price_index t
         LEFT JOIN dwd_price_index y1 ON t.pl = y1.pl AND t.type = y1.type AND y1.release_date = DATE_SUB(t.release_date, 1)
         LEFT JOIN dwd_price_index y3 ON t.pl = y3.pl AND t.type = y3.type AND y3.release_date = DATE_SUB(t.release_date, 3)
         LEFT JOIN dwd_price_index y5 ON t.pl = y5.pl AND t.type = y5.type AND y5.release_date = DATE_SUB(t.release_date, 5)
WHERE t.release_date = DATE_SUB(CURRENT_DATE, 1);


INSERT OVERWRITE TABLE ads_price_index
    SELECT pl, type, index, ROUND(rise, 2) AS rise, ROUND(rise3, 2) AS rise3, ROUND(rise5, 2) AS rise5, qoq FROM dws_price_index;