-- 清洗数据并插入dwd_market
INSERT OVERWRITE TABLE dwd_market
PARTITION (prvc)
SELECT
    name,
    CASE
        WHEN unit_type IS NULL OR unit_type = '' THEN '综合类'
        ELSE CASE
            WHEN size(split(unit_type, ',')) > 1 THEN '综合类'
            ELSE CASE
                WHEN trim(unit_type) IN ('肉禽蛋类', '蔬菜类', '果品类', '粮油类') THEN trim(unit_type)
                ELSE '综合类'
            END
        END
    END AS unit_type,
     CASE
        WHEN addr IS NULL THEN '暂无'
        ELSE trim(addr)
    END AS addr,
    CASE
        WHEN opening_date IS NOT NULL THEN opening_date
        ELSE '1970-01-01' -- 默认值
    END AS opening_date,
    CASE
        WHEN manager_phone IS NULL THEN '暂无'
        ELSE trim(manager_phone)
    END AS manager_phone,
    CASE
        WHEN tel IS NULL THEN '暂无'
        ELSE trim(tel)
    END AS tel,
    CASE
        WHEN characteristic IS NULL THEN '暂无'
        ELSE trim(characteristic)
    END AS characteristic,
    CASE
        WHEN content IS NULL THEN '暂无'
        WHEN regexp_replace(content, '[^0-9]', '') != '' THEN '暂无'
        ELSE regexp_replace(content, '[\r\n]+', ' ')
    END AS content,
    CASE
        WHEN prvc IS NULL THEN '暂无'
        ELSE trim(prvc)
    END AS prvc
FROM ods_market
WHERE prvc IS NOT NULL;  -- 只插入具有省份信息的数据

CREATE TABLE IF NOT EXISTS ads_market_type_cnt
(
    unit_type STRING COMMENT '市场类型',
    cnt INTEGER COMMENT '数量'
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/agrimarket/ads/ads_market_type_cnt';

-- 市场类型统计
INSERT OVERWRITE TABLE ads_market_type_cnt
SELECT
    unit_type,
    COUNT(*) AS cnt
FROM dwd_market
GROUP BY unit_type;

-- 市场的开放时间统计
CREATE TABLE IF NOT EXISTS ads_market_opening_year_cnt
(
    cnt_before_2000 INTEGER COMMENT '开放时间早于2000年的数量',
    cnt_2000_2010 INTEGER COMMENT '开放时间在2000-2010数量',
    cnt_2010_2020 INTEGER COMMENT '开放时间在2010-2020数量',
    cnt_after_2020 INTEGER COMMENT '开放时间在2020之后的市场数量'
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/agrimarket/ads/ads_market_opening_year_cnt';

INSERT OVERWRITE TABLE ads_market_opening_year_cnt
SELECT
    COUNT(CASE WHEN YEAR(opening_date) < 2000 AND opening_date != '1970-01-01' THEN 1 END) AS cnt_before_2000,
    COUNT(CASE WHEN YEAR(opening_date) BETWEEN 2000 AND 2010 AND opening_date != '1970-01-01' THEN 1 END) AS cnt_2000_2010,
    COUNT(CASE WHEN YEAR(opening_date) BETWEEN 2010 AND 2020 AND opening_date != '1970-01-01' THEN 1 END) AS cnt_2010_2020,
    COUNT(CASE WHEN YEAR(opening_date) > 2020 AND opening_date != '1970-01-01' THEN 1 END) AS cnt_after_2020
FROM dwd_market;

