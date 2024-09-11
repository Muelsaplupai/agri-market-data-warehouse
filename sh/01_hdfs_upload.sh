#!/bin/bash

# 定义文件路径
PRICES_FILE="/export/agrimarket/ods/prices.csv"
PRICE_INDEX_FILE="/export/agrimarket/ods/ods_price_index.csv"

# 定义HDFS目标路径
HDFS_TARGET_DIR_PRICE="/agrimarket/ods/ods_price"
HDFS_TARGET_DIR_PRICE_INDEX="/agrimarket/ods/ods_price_index"

# 上传文件到HDFS
/export/server/hadoop/bin/hdfs dfs -put -f $PRICES_FILE $HDFS_TARGET_DIR_PRICE
/export/server/hadoop/bin/hdfs dfs -put -f $PRICE_INDEX_FILE $HDFS_TARGET_DIR_PRICE_INDEX
