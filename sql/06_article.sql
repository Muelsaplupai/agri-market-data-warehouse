set hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions = 2048;
SET hive.exec.max.dynamic.partitions.pernode = 256;
WITH prvcs AS (
    SELECT short_name FROM utils_prvc
    UNION ALL
    SELECT '全国' AS short_name
)
INSERT OVERWRITE TABLE dwd_article PARTITION (release_date)
    SELECT title, link, prvc, release_date
    FROM ods_article
    WHERE title IS NOT NULL AND title != ''
        AND link RLIKE '^https?://[a-zA-Z0-9.-]+(?:/[^/]+)*$'
        AND prvc IN (SELECT short_name FROM prvcs)
        AND release_date IS NOT NULL;

INSERT OVERWRITE TABLE ads_article
    SELECT title, link, release_date, prvc
    FROM dwd_article;

set hive.exec.dynamic.partition.mode=nonstrict;
SET hive.exec.max.dynamic.partitions=1000;
SET hive.exec.max.dynamic.partitions.pernode=1000;
INSERT OVERWRITE TABLE dwd_guide
    SELECT g.title, g.brief, g.link, COALESCE(MAX(p.pz), '其他') AS pz, g.release_date
    FROM ods_guide g
    LEFT JOIN ads_price_pz p ON g.title LIKE CONCAT('%', p.pz, '%')
    WHERE g.title IS NOT NULL AND g.title != ''
        AND g.link RLIKE '^https?://[a-zA-Z0-9.-]+(?:/[^/]+)*$'
        AND g.brief IS NOT NULL AND g.brief != ''
        AND g.release_date IS NOT NULL
    GROUP BY g.title, g.brief, g.link, g.release_date;

INSERT OVERWRITE TABLE ads_guide
    SELECT title, release_date, brief, link, pz
    FROM dwd_guide;