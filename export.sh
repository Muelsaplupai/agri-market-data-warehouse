#!/bin/bash

# MySQL 连接配置
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
MYSQL_DB="agri_db"
MYSQL_USER="root"
MYSQL_PASS="root"

# Hive 表和对应的 MySQL 表
declare -A TABLES
TABLES["ads_market"]="/agrimarket/ads/ads_market"
TABLES["ads_market_type_cnt"]="/agrimarket/ads/ads_market_type_cnt"
TABLES["ads_market_opening_year_cnt"]="/agrimarket/ads/ads_market_opening_year_cnt"
TABLES["ads_price_rise"]="/agrimarket/ads/ads_price_rise"
TABLES["ads_price"]="/agrimarket/ads/ads_price"
TABLES["ads_pz"]="/agrimarket/ads/ads_pz"

# 导出表的列名映射
declare -A COLUMNS
COLUMNS["ads_market"]="prvc,opening_date,addr,manager,manager_phone,tel,characteristic,content"
COLUMNS["ads_market_type_cnt"]="unit_type,cnt"
COLUMNS["ads_market_opening_year_cnt"]="cnt_before_2000,cnt_2000_2010,cnt_2010_2020,cnt_after_2020" COLUMNS["ads_price_rise"]="release_date,prvc,pz,price,rise" 
COLUMNS["ads_price"]="market,prvc,pz,highest,lowest,average,release_date" 
COLUMNS["ads_pz"]="pz" 
# 循环导出每张表
for TABLE in "${!TABLES[@]}"; do
  echo "Exporting $TABLE to MySQL..."
  
  sqoop export \
    --connect jdbc:mysql://$MYSQL_HOST:$MYSQL_PORT/$MYSQL_DB \
    --username $MYSQL_USER \
    --password $MYSQL_PASS \
    --table $TABLE \
    --export-dir ${TABLES[$TABLE]} \
    --input-fields-terminated-by '\t' \
    --input-lines-terminated-by '\n' \
    --columns ${COLUMNS[$TABLE]}
  
  if [ $? -eq 0 ]; then
    echo "Successfully exported $TABLE."
  else
    echo "Failed to export $TABLE."
  fi
done
