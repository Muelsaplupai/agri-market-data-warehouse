#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import requests
import pandas as pd
from datetime import datetime, timedelta


def fetch_data():
    # 定义目标 URL
    url = "http://www.agri.cn/nyb/getIndexByTenDay"

    # 请求头部，模拟浏览器请求
    headers = {
        "Accept": "application/json, text/javascript, */*; q=0.01",
        "Accept-Encoding": "gzip, deflate",
        "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
        "Connection": "keep-alive",
        "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
        "Cookie": "wdcid=3703b3ca9756f248; SF_cookie_75=24268472; wdses=7b279c7cc4f345c3; wdlast=1725081661",
        "Host": "www.agri.cn",
        "Origin": "http://www.agri.cn",
        "Referer": "http://www.agri.cn/sj/",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) "
                      "Chrome/128.0.0.0 Safari/537.36 Edg/128.0.0.0",
        "X-Requested-With": "XMLHttpRequest"
    }

    # 请求体，包含 token 参数
    payload = {
        "token": "3cec8829-8aba-452e-8c9a-e0deca77853b"
    }

    # 发送 POST 请求
    response = requests.post(url, headers=headers, data=payload)
    data = response.json()  # 解析 JSON 响应

    # 获取昨天的日期
    yesterday = (datetime.now() - timedelta(1)).strftime("%Y-%m-%d")

    # 处理数据
    rows = []
    try:
        if "code" in data and data["code"] == 200 and data["message"] == "请求处理成功":
            for entry in data.get("content", []):
                date = entry.get("publishDate", "")
                if date == yesterday:
                    for index in entry.get("indexData", []):
                        rows.append({
                            "Date": date,
                            "IndexName": index.get("indexName", ""),
                            "IndexValue": index.get("indexValue", "")
                        })
        else:
            print("请求失败或数据格式不符")
    except KeyError as e:
        print("数据处理时出现 KeyError: {}".format(e))

    # 创建 DataFrame 并导出 CSV
    df = pd.DataFrame(rows)
    df.to_csv("/export/agrimarket/ods/ods_price_index.csv", index=False, encoding='utf-8-sig')

    print("今日价格指数已导出。")


if __name__ == "__main__":
    fetch_data()
