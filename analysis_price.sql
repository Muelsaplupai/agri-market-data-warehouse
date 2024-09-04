INSERT OVERWRITE dwd_price /* 提取省份 */
SELECT
    market,
    CASE 
        WHEN market LIKE '%北京%' OR market LIKE '%北园%' THEN '北京市'
        WHEN market LIKE '%上海%' THEN '上海市'
        WHEN market LIKE '%天津%' THEN '天津市'
        WHEN market LIKE '%重庆%' THEN '重庆市'
        WHEN market LIKE '%广东%' OR market LIKE '%佛山%' OR market LIKE '%广州%' OR market LIKE '%珠海%' OR market LIKE '%东莞%' OR market LIKE '%中山%' OR market LIKE '%粤%' THEN '广东省'
        WHEN market LIKE '%江苏%' OR market LIKE '%南京%' OR market LIKE '%苏州%' OR market LIKE '%无锡%' OR market LIKE '%常州%' OR market LIKE '%徐州%' THEN '江苏省'
        WHEN market LIKE '%浙江%' OR market LIKE '%杭州%' OR market LIKE '%宁波%' OR market LIKE '%温州%' OR market LIKE '%绍兴%' OR market LIKE '%台州%' THEN '浙江省'
        WHEN market LIKE '%山东%' OR market LIKE '%济南%' OR market LIKE '%青岛%' OR market LIKE '%烟台%' OR market LIKE '%威海%' OR market LIKE '%临沂%' OR market LIKE '%寿光%' OR market LIKE '%滕州%' OR market LIKE '%金乡%' OR market LIKE '%鲁南%' THEN '山东省'
        WHEN market LIKE '%河南%' OR market LIKE '%焦作%' OR market LIKE '%洛阳%' OR market LIKE '%郑州%' OR market LIKE '%三门峡%' OR market LIKE '%南阳%' OR market LIKE '%周口%' THEN '河南省'
        WHEN market LIKE '%河北%' OR market LIKE '%保定%' OR market LIKE '%石家庄%' OR market LIKE '%唐山%' OR market LIKE '%邯郸%' OR market LIKE '%永年%' OR market LIKE '%张北%' THEN '河北省'
        WHEN market LIKE '%湖南%' OR market LIKE '%长沙%' OR market LIKE '%株洲%' OR market LIKE '%湘潭%' OR market LIKE '%岳阳%' OR market LIKE '%娄底%' OR market LIKE '%邵阳%' OR market LIKE '%红星%' THEN '湖南省'
        WHEN market LIKE '%安徽%' OR market LIKE '%蚌埠%' OR market LIKE '%合肥%' OR market LIKE '%马鞍山%' OR market LIKE '%芜湖%' OR market LIKE '%阜阳%' THEN '安徽省'
        WHEN market LIKE '%贵州%' OR market LIKE '%贵阳%' OR market LIKE '%遵义%' OR market LIKE '%安顺%' THEN '贵州省'
        WHEN market LIKE '%四川%' OR market LIKE '%成都%' OR market LIKE '%绵阳%' OR market LIKE '%德阳%' OR market LIKE '%达州%' OR market LIKE '%自贡%' OR market LIKE '%新大兴%' OR market LIKE '%汉源%' THEN '四川省'
        WHEN market LIKE '%湖北%' OR market LIKE '%武汉%' OR market LIKE '%黄冈%' OR market LIKE '%黄石%' OR market LIKE '%宜昌%' OR market LIKE '%荆州%' OR market LIKE '%襄阳%' OR market LIKE '%两湖%' OR market LIKE '%潜江%' THEN '湖北省'
        WHEN market LIKE '%福建%' OR market LIKE '%福州%' OR market LIKE '%厦门%' OR market LIKE '%泉州%' OR market LIKE '%漳州%' THEN '福建省'
        WHEN market LIKE '%江西%' OR market LIKE '%南昌%' OR market LIKE '%九江%' OR market LIKE '%赣州%' OR market LIKE '%景德镇%' THEN '江西省'
        WHEN market LIKE '%陕西%' OR market LIKE '%西安%' OR market LIKE '%咸阳%' OR market LIKE '%宝鸡%' OR market LIKE '%铜川%' OR market LIKE '%欣桥%' THEN '陕西省'
        WHEN market LIKE '%云南%' OR market LIKE '%元谋%' OR market LIKE '%通海%' THEN '云南省'
        WHEN market LIKE '%广西%' OR market LIKE '%南宁%' OR market LIKE '%柳州%' OR market LIKE '%桂林%' OR market LIKE '%梧州%' THEN '广西壮族自治区'
        WHEN market LIKE '%内蒙%' OR market LIKE '%呼和浩特%' OR market LIKE '%包头%' OR market LIKE '%鄂尔多斯%' OR market LIKE '%乌兰察布%' THEN '内蒙古自治区'
        WHEN market LIKE '%新疆%' OR market LIKE '%乌鲁木齐%' OR market LIKE '%克拉玛依%' OR market LIKE '%喀什%' OR market LIKE '%哈密%' OR market LIKE '%石河子%' THEN '新疆维吾尔自治区'
        WHEN market LIKE '%西藏%' OR market LIKE '%拉萨%' THEN '西藏自治区'
        WHEN market LIKE '%宁夏%' OR market LIKE '%银川%' OR market LIKE '%石嘴山%' OR market LIKE '%吴忠%' THEN '宁夏回族自治区'
        WHEN market LIKE '%青海%' OR market LIKE '%西宁%' OR market LIKE '%海东%' OR market LIKE '%黄南%' OR market LIKE '%青藏%' THEN '青海省'
        WHEN market LIKE '%甘肃%' OR market LIKE '%兰州%' OR market LIKE '%白银%' OR market LIKE '%天水%' OR market LIKE '%平凉%' THEN '甘肃省'
        WHEN market LIKE '%海南%' OR market LIKE '%海口%' OR market LIKE '%三亚%' THEN '海南省'
        WHEN market LIKE '%辽宁%' OR market LIKE '%沈阳%' OR market LIKE '%大连%' OR market LIKE '%鞍山%' OR market LIKE '%抚顺%' THEN '辽宁省'
        WHEN market LIKE '%山西%' OR market LIKE '%太原%' OR market LIKE '%晋城%' OR market LIKE '%运城%' OR market LIKE '%长治%' OR market LIKE '%孝义%' THEN '山西省'
        WHEN market LIKE '%吉林%' OR market LIKE '%长春%' OR market LIKE '%吉林市%' OR market LIKE '%四平%' OR market LIKE '%辽源%' THEN '吉林省'
        WHEN market LIKE '%黑龙江%' OR market LIKE '%哈尔滨%' OR market LIKE '%齐齐哈尔%' OR market LIKE '%牡丹江%' OR market LIKE '%佳木斯%' THEN '黑龙江省'
        WHEN market LIKE '%港%' THEN '香港特别行政区'
        WHEN market LIKE '%澳%' THEN '澳门特别行政区'
        ELSE '其他'
    END AS prvc,
    pz,
    highest,
    lowest,
    average,
    release_time AS release_date
FROM ods_price;


/* 计算统计各省份各品种各日的平均价 */
INSERT OVERWRITE TABLE dwb_prvc_price
SELECT
    prvc,
    pz,
    AVG(average) AS average,
    release_date
FROM
    dwd_price
GROUP BY
    prvc, pz, release_date;


-- 计算价格涨幅
INSERT OVERWRITE TABLE dws_prvc_price_rise
SELECT
    prvc,
    pz,
    average AS price,
    COALESCE(average - LAG(average) OVER (PARTITION BY prvc, pz ORDER BY release_date), 0) AS rise,
    release_date
FROM
    dwb_prvc_price;


-- 创建临时表以存储计算结果
CREATE TEMPORARY TABLE ranked_price_rise AS
SELECT
    prvc,
    pz,
    price,
    rise,
    release_date,
    ROW_NUMBER() OVER (PARTITION BY prvc, release_date ORDER BY rise DESC) AS rank
FROM
    dws_prvc_price_rise;

-- 将涨幅排名前十的品种插入目标表
INSERT OVERWRITE TABLE ads_price_rise
SELECT
    prvc,
    pz,
    price,
    rise,
    release_date
FROM
    ranked_price_rise
WHERE
    rank <= 10;

-- 历史价格
INSERT INTO TABLE ads_price
SELECT
    market,
    prvc,
    pz,
    highest,
    lowest,
    average,
    release_date
FROM
    dwd_price

-- pz表
INSERT INTO TABLE ads_price_pz
SELECT DISTINCT pz
FROM dwd_price;






