#!/bin/bash
/export/server/hive/bin/hive -e "use agrimarket;
set hive.stats.column.autogather=false;
set hive.exec.dynamic.partition.mode=nonstrict;

WITH analysis_index AS(
    SELECT u.pl, u.type, i.index, i.release_date
    FROM ods_price_index i
    JOIN utils_index u ON u.name=i.name
    WHERE i.release_date=DATE_SUB(CURRENT_DATE, 2)
)
INSERT INTO dwd_price_index
    SELECT pl, type, index, release_date
    FROM analysis_index;

INSERT OVERWRITE TABLE dws_price_index
    SELECT t.pl,
           t.type,
           t.index,
           CASE WHEN y.index IS NOT NULL THEN (t.index - y.index)
               END AS rise,
           0 AS qoq
    FROM dwd_price_index t
    LEFT JOIN dwd_price_index y ON t.pl=y.pl AND t.type=y.type AND y.release_date = DATE_SUB(t.release_date, 1)
    WHERE t.release_date=DATE_SUB(CURRENT_DATE, 1);

INSERT OVERWRITE TABLE ads_price_index
    SELECT pl, type, index, ROUND(rise, 2) AS rise, qoq FROM dws_price_index;"