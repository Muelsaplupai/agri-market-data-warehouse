CREATE EXTERNAL TABLE IF NOT EXISTS ods_price
    (market STRING COMMENT '市场名称',
    pz STRING COMMENT '品种名称',
    province STRING COMMENT '省份名称',
    release_date DATE COMMENT '发布时间',
    highest DOUBLE COMMENT '最高价格',
    lowest DOUBLE COMMENT '最低价格',
    average DOUBLE COMMENT '平均价格',
    rise DOUBLE COMMENT '均价涨幅',
    pl STRING COMMENT '品类信息')
    COMMENT 'ODS价格信息'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    LOCATION '/agrimarket/ods/ods_price';

CREATE EXTERNAL TABLE IF NOT EXISTS ods_guide
    (title STRING COMMENT '文章标题',
    release_date DATE COMMENT '发布时间',
    brief STRING COMMENT '简介',
    link STRING COMMENT '链接',
    pz STRING COMMENT '品种名称')
    COMMENT 'ODS农事指导'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    LOCATION '/agrimarket/ods/ods_guide';

CREATE EXTERNAL TABLE IF NOT EXISTS ods_article
    (title STRING COMMENT '资讯标题',
    link STRING COMMENT '来源网址',
    release_date STRING COMMENT '发布日期',
    prvc STRING COMMENT '省份')
    COMMENT 'ODS农业资讯'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    LOCATION '/agrimarket/ods/ods_article';

CREATE EXTERNAL TABLE IF NOT EXISTS ods_market
    (name STRING COMMENT '市场名称',
    abbrev STRING COMMENT '名称缩写',
    unit_type STRING COMMENT '经营类型',
    addr STRING COMMENT '地址',
    entry_date DATE COMMENT '注册时间',
    opening_date DATE COMMENT '开放时间',
    manager STRING COMMENT '负责人姓名',
    manager_phone STRING COMMENT '负责人手机号',
    tel STRING COMMENT '电话',
    characteristic STRING COMMENT '特色',
    content STRING COMMENT '简介',
    prvc STRING COMMENT '省份')
    COMMENT 'ODS市场信息'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    LOCATION '/agrimarket/ods/ods_market';

CREATE EXTERNAL TABLE IF NOT EXISTS ods_price_index
    (release_date DATE COMMENT '发布时间',
    name STRING COMMENT '指数名称',
    index STRING COMMENT '指数值')
    COMMENT 'ODS价格指数'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    LOCATION '/agrimarket/ods/ods_price_index';

CREATE EXTERNAL TABLE IF NOT EXISTS ods_supply_and_demand
    (pz STRING COMMENT '品种名称',
    release_year DATE COMMENT '发布年度',
    seed_area DOUBLE COMMENT '播种面积',
    harvest_area DOUBLE COMMENT '收获面积',
    yield_per_unit DOUBLE COMMENT '单产',
    yield DOUBLE COMMENT '产量',
    imports DOUBLE COMMENT '进口量',
    consumption DOUBLE COMMENT '消费量',
    exports DOUBLE COMMENT '出口量',
    balance DOUBLE COMMENT '结余库存',
    balance_change DOUBLE COMMENT '结余变化')
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    LOCATION '/agrimarket/ods/ods_supply_and_demand';

CREATE EXTERNAL TABLE IF NOT EXISTS ods_enterprise
    (name STRING COMMENT '企业名称',
    demand_type STRING COMMENT '需求类型',
    manager STRING COMMENT '负责人',
    email STRING COMMENT '邮箱',
    phone STRING COMMENT '手机号',
    fixed_phone STRING COMMENT '电话',
    qq STRING COMMENT 'QQ',
    addr STRING COMMENT '地址')
    COMMENT 'ODS企业信息'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    LOCATION '/agrimarket/ods/ods_enterprise';

CREATE EXTERNAL TABLE IF NOT EXISTS ods_consumption_person
    (type STRING COMMENT '品类',
    prvc STRING COMMENT '省份名称',
    city_consumption DOUBLE COMMENT '城镇人均消费量(kg)',
    rural_consumption DOUBLE COMMENT '农村人均消费量(kg)')
    COMMENT 'ODS人均消费量'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
    LOCATION '/agrimarket/ods/ods_consumption_person';

/************************************************************************
 * ------------------------- DWD层 -------------------------------------*
 ************************************************************************/

CREATE TABLE IF NOT EXISTS dwd_price
    (market STRING COMMENT '市场名称',
     prvc STRING COMMENT '省份名称',
     pz STRING COMMENT '品种名称',
     highest DOUBLE COMMENT '最高价',
     lowest DOUBLE COMMENT '最低价',
     average DOUBLE COMMENT '平均价')
    COMMENT 'DWD历史价格明细'
    PARTITIONED BY (release_date DATE COMMENT '发布日期')
    STORED AS ORC
    LOCATION '/agrimarket/dwd/dwd_price';

CREATE TABLE IF NOT EXISTS dwd_guide
    (title STRING COMMENT '文章标题',
    brief STRING COMMENT '简介',
    link STRING COMMENT '来源网址',
    pz STRING COMMENT '品种名称')
    COMMENT 'DWD农事指导明细'
    PARTITIONED BY (release_date DATE COMMENT '发布日期')
    STORED AS ORC
    LOCATION '/agrimarket/dwd/dwd_guide';

CREATE TABLE IF NOT EXISTS dwd_article
    (title STRING COMMENT '资讯标题',
    link STRING COMMENT '来源网址',
    prvc STRING COMMENT '省份名称')
    COMMENT 'DWD农业资讯明细'
    PARTITIONED BY (release_date DATE COMMENT '发布日期')
    STORED AS ORC
    LOCATION '/agrimarket/dwd/dwd_article';

CREATE TABLE IF NOT EXISTS dwd_market
    (name STRING COMMENT '市场名称',
    unit_type STRING COMMENT '经营类型',
    addr STRING COMMENT '地址',
    entry_date DATE COMMENT '注册时间',
    opening_date DATE COMMENT '开放时间',
    manager STRING COMMENT '负责人姓名',
    manager_phone STRING COMMENT '负责人手机号',
    tel STRING COMMENT '电话',
    characteristic STRING COMMENT '特色',
    content STRING COMMENT '简介')
    COMMENT 'DWD市场信息明细'
    PARTITIONED BY (prvc STRING COMMENT '省份名称')
    STORED AS ORC
    LOCATION '/agrimarket/dwd/dwd_market';

CREATE TABLE IF NOT EXISTS dwd_price_index
    (pl STRING COMMENT '品类名称',
    type STRING COMMENT '指数类型',
    index DOUBLE COMMENT '指数')
    COMMENT 'DWD价格指数明细'
    PARTITIONED BY (release_date DATE COMMENT '发布时间')
    STORED AS ORC
    LOCATION '/agrimarket/dwd/dwd_price_index';

CREATE TABLE IF NOT EXISTS dwd_supply_and_demand
    (pz STRING COMMENT '品种名称',
    seed_area DOUBLE COMMENT '播种面积',
    harvest_area DOUBLE COMMENT '收获面积',
    yield_per_unit DOUBLE COMMENT '单产',
    imports DOUBLE COMMENT '产量',
    consumption DOUBLE COMMENT '消费',
    exports DOUBLE COMMENT '出口',
    balance DOUBLE COMMENT '库存结余',
    balance_change DOUBLE COMMENT '结余变化')
    COMMENT 'DWD供需数据明细'
    PARTITIONED BY (release_date DATE COMMENT '发布日期')
    STORED AS ORC
    LOCATION '/agrimarket/dwd/dwd_supply_and_demand';

CREATE TABLE IF NOT EXISTS dwd_enterprise
    (name STRING COMMENT '名称',
    prvc STRING COMMENT '省份名称',
    pz STRING COMMENT '需求品种',
    supply_type STRING COMMENT '供求类型',
    manager STRING COMMENT '负责人',
    email STRING COMMENT '邮箱',
    phone STRING COMMENT '手机',
    fixed_phone STRING COMMENT '电话',
    qq STRING COMMENT 'QQ',
    addr STRING COMMENT '地址')
    COMMENT 'DWD企业数据明细'
    STORED AS ORC
    LOCATION '/agrimarket/dwd/dwd_enterprise';

CREATE TABLE IF NOT EXISTS dwd_consumption_person
    (name STRING COMMENT '品类名称',
    prvc STRING COMMENT '省份',
    city_consumption DOUBLE COMMENT '城镇人均消费量',
    rural_consumption DOUBLE COMMENT '农村人均消费量')
    COMMENT 'DWD人均消费数据明细'
    STORED AS ORC
    LOCATION '/agrimarket/dwd/dwd_consumption_person';

/************************************************************************
 * ------------------------- DWB层 -------------------------------------*
 ************************************************************************/

CREATE TABLE IF NOT EXISTS dwb_price
    (prvc STRING COMMENT '省份名称',
     pz STRING COMMENT '品种名称',
     average DOUBLE COMMENT '平均价格')
    COMMENT 'DWB各省价格汇总'
    PARTITIONED BY (release_date DATE COMMENT '发布日期')
    STORED AS ORC
    LOCATION '/agrimarket/dwb/dwb_price';

CREATE TABLE IF NOT EXISTS dwb_catch_cnt_daily
    (pz_cnt INTEGER COMMENT '品种总数',
    market_cnt INTEGER COMMENT '市场总数',
    data_cnt INTEGER COMMENT '价格数据总数',
    article_cnt INTEGER COMMENT '资讯总数')
    COMMENT 'DWB全国每日抓取数据量汇总'
    PARTITIONED BY (release_date DATE COMMENT '发布日期')
    STORED AS ORC
    LOCATION '/agrimarket/dwb/dwb_catch_cnt_daily';

/************************************************************************
 * ------------------------- DWS层 -------------------------------------*
 ************************************************************************/

CREATE TABLE IF NOT EXISTS dws_prvc_price_rise
    (prvc STRING COMMENT '省份名称',
    pz STRING COMMENT '品种名称',
    price STRING COMMENT '价格',
    rise STRING COMMENT '涨幅')
    COMMENT 'DWS各省价格分析'
    PARTITIONED BY (release_date DATE COMMENT '发布日期')
    STORED AS ORC
    LOCATION '/agrimarket/dws/dws_prvc_price_rise';

CREATE TABLE IF NOT EXISTS dws_price_index
    (pl STRING COMMENT '品类名称',
     type STRING COMMENT '指数类型',
     index DOUBLE COMMENT '指数',
     rise DOUBLE COMMENT '涨幅',
     qoq DOUBLE COMMENT '环比')
    COMMENT 'DWS今日价格指数分析'
    STORED AS ORC
    LOCATION '/agrimarket/dws/dws_price_index';

CREATE TABLE IF NOT EXISTS dws_supply_and_demand
    (pz STRING COMMENT '品类名称',
    yield_rise DOUBLE COMMENT '产量涨幅',
    consumption_rise DOUBLE COMMENT '消费涨幅',
    port_change DOUBLE COMMENT '进出口量变化')
    COMMENT 'DWS供需数据分析'
    PARTITIONED BY (release_date DATE COMMENT '发布日期')
    STORED AS ORC
    LOCATION '/agrimarket/dws/dws_supply_and_demand';

/************************************************************************
 * ------------------------- ADS层 -------------------------------------*
 ************************************************************************/

CREATE TABLE IF NOT EXISTS ads_price_pz
    (pz STRING COMMENT '品种名称')
    COMMENT 'ADS品种表'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_price_pz';

CREATE TABLE IF NOT EXISTS ads_price
    (market STRING COMMENT '市场名称',
    prvc STRING COMMENT '省份名称',
    pz STRING COMMENT '品种名称',
    highest DOUBLE COMMENT '最高价',
    lowest DOUBLE COMMENT '最低价',
    average DOUBLE COMMENT '平均价',
    release_date DOUBLE COMMENT '发布日期')
    COMMENT 'ADS历史价格'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_price';

CREATE TABLE IF NOT EXISTS ads_price_rise
    (prvc STRING COMMENT '省份名称',
    pz STRING COMMENT '品种名称',
    price DOUBLE COMMENT '价格',
    rise DOUBLE COMMENT '涨幅',
    release_date DATE COMMENT '发布日期')
    COMMENT 'ADS各省价格涨幅前十名'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_price_rise';

CREATE TABLE IF NOT EXISTS ads_price_fall
    (prvc STRING COMMENT '省份名称',
     pz STRING COMMENT '品种名称',
     price DOUBLE COMMENT '价格',
     fall DOUBLE COMMENT '跌幅',
     release_date DATE COMMENT '发布日期')
    COMMENT 'ADS各省价格跌幅前十名'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_price_rise';

CREATE TABLE IF NOT EXISTS ads_guide
    (title STRING COMMENT '文章标题',
    release_date DATE COMMENT '发布日期',
    brief STRING COMMENT '简介',
    link STRING COMMENT '来源网址',
    pz STRING COMMENT '品种名称')
    COMMENT 'ADS农事指导'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_guide';

CREATE TABLE IF NOT EXISTS ads_article
    (title STRING COMMENT '资讯标题',
    link STRING COMMENT '来源网址',
    release_date DATE COMMENT '发布日期',
    prvc STRING COMMENT '省份名称')
    COMMENT 'ADS农业资讯'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_article';

CREATE TABLE IF NOT EXISTS ads_market
    (name STRING COMMENT '市场名称',
    prvc STRING COMMENT '省份',
    unit_type STRING COMMENT '经营类型',
    addr STRING COMMENT '地址',
    opening_date DATE COMMENT '开放时间',
    manager STRING COMMENT '负责人姓名',
    manager_phone STRING COMMENT '负责人手机号',
    tel STRING COMMENT '电话',
    characteristic STRING COMMENT '特色',
    content STRING COMMENT '简介')
    COMMENT 'ADS市场信息'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_market';

CREATE TABLE IF NOT EXISTS ads_catch_cnt_daily
    (pz_cnt INTEGER COMMENT '品种总数',
    market_cnt INTEGER COMMENT '市场总数',
    data_cnt INTEGER COMMENT '价格数据总数',
    article INTEGER COMMENT '资讯总数')
    COMMENT 'ADS全国每日抓取数量'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_catch_cnt_daily';

CREATE TABLE IF NOT EXISTS ads_price_index
    (pl STRING COMMENT '品类名称',
    type STRING COMMENT '指数类型',
    index DOUBLE COMMENT '指数',
    rise DOUBLE COMMENT '涨幅',
    qoq DOUBLE COMMENT '环比')
    COMMENT 'ADS今日价格指数'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_price_index';

CREATE TABLE IF NOT EXISTS ads_supply_and_demand
    (pl STRING COMMENT '品类名称',
    seed_area DOUBLE COMMENT '播种面积',
    harvest_area DOUBLE COMMENT '收获面积',
    yield_per_unit DOUBLE COMMENT '单产',
    yield DOUBLE COMMENT '产量',
    imports DOUBLE COMMENT '进口量',
    consumption DOUBLE COMMENT '消费量',
    exports DOUBLE COMMENT '出口量',
    balance DOUBLE COMMENT '库存结余',
    balance_change DOUBLE COMMENT '结余变化',
    yield_rise DOUBLE COMMENT '产量涨幅',
    consumption_rise DOUBLE COMMENT '消费量涨幅',
    port_change DOUBLE COMMENT '进出口量变化')
    COMMENT 'ADS本月供需数据'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '/t'
    LOCATION '/agrimarket/ads/ads_supply_and_demand';

CREATE TABLE IF NOT EXISTS ads_enterprise
    (name STRING COMMENT '名称',
    prvc STRING COMMENT '省份',
    pz STRING COMMENT '需求品种',
    supply_type STRING COMMENT '供求类型',
    manager STRING COMMENT '负责人',
    email STRING COMMENT '邮箱',
    phone STRING COMMENT '手机',
    fixed_phone STRING COMMENT '电话',
    qq STRING COMMENT 'QQ',
    addr STRING COMMENT '地址')
    COMMENT 'ADS企业数据'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_enterprise';

CREATE TABLE IF NOT EXISTS ads_consumption_person
    (pl STRING COMMENT '品类名称',
    prvc STRING COMMENT '省份',
    city_consumption STRING COMMENT '城镇人均消费量',
    rural_consumption STRING COMMENT '农村人均消费量')
    COMMENT 'ADS人均消费数据'
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LOCATION '/agrimarket/ads/ads_consumption_person';