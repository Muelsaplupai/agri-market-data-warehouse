#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')
from bs4 import BeautifulSoup
import requests
import pandas as pd
from datetime import datetime, timedelta


# 提取市场名和品种名
def extract_words_between_chars(input_string, char1, char2):
    start_index = input_string.find(char1) + 1
    end_index = input_string.find(char2, input_string.find(char1))
    if start_index < 0 or end_index < 0 or start_index >= end_index:
        return None
    return input_string[start_index:end_index].strip()


# 设置要爬取的接口
base_url = 'http://price.cnveg.com/market/{}/{}/'
# 设置请求头
headers = {
    'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1'
}


# 创建一个空的 DataFrame 来存储所有数据
all_data = pd.DataFrame()

for i in range (1,300): #1,300 
    for j in range(1,100): #1,100
        url = base_url.format(i,j)
        print(url)
        # 创建一个空的 DataFrame 来存储数据
        df = pd.DataFrame(columns=['market', 'pz', 'date', 'highest', 'lowest', 'average'])
        try:
            response = requests.get(url, headers=headers, timeout=10)
            response.raise_for_status()  # 检查响应状态码
            if response.status_code != 200:
                print("请求失败，状态码: ", response.status_code)
                continue
            response.raise_for_status()  # 检查响应状态码
        except requests.exceptions.RequestException as e:
            print("请求失败: {}".format(e))
            continue
        if response.status_code == 200:
            soup = BeautifulSoup(response.content, 'html.parser', from_encoding='utf-8')
            # 找到<title>标签
            title_tag = soup.title

            # 提取<title>标签的内容
            title_content = title_tag.string

            # 提取"年"和"价格行情"中间的词(品种名)
            word_between_year_and_price = extract_words_between_chars(title_content, "年", "价格行情")
            
            # 提取两个"-"中间的内容(市场名)
            content_between_hyphens = extract_words_between_chars(title_content, "- ", " - CN蔬菜网")

            # 找到所有的<tr>标签
            tr_tags = soup.find_all('tr')

            # 遍历每个<tr>标签，提取日期和价格信息
            for tr in tr_tags:
                # 找到所有的<td>标签
                td_tags = tr.find_all('td')
                
                # 如果td_tags长度不等于5，说明不是我们想要的数据行，跳过
                if len(td_tags) != 5:
                    continue
                
                # 提取日期和价格信息
                date = td_tags[0].text.strip()  # 提取日期
                low_price = td_tags[1].text.strip()  # 提取最低价格
                high_price = td_tags[2].text.strip()  # 提取最高价格
                avg_price = td_tags[3].text.strip()  # 提取平均价格
                # 去除价格中的￥符号
                low_price = td_tags[1].text.strip().replace('￥', '')  
                high_price = td_tags[2].text.strip().replace('￥', '')  
                avg_price = td_tags[3].text.strip().replace('￥', '')  

                # 获取当前日期
                current_date = datetime.now().date()

                # 过滤掉表头标签
                if(date != '发布时间'):
                    # 将字符串转换为 datetime.date 类型
                    date_obj = datetime.strptime(date, '%Y-%m-%d').date()
                    # 计算给定日期的前一天日期
                    previous_date = current_date - timedelta(days=1)
                    
                    # 只要日期为昨天的数据
                    if date_obj == previous_date:
                        df = df.append({'market': content_between_hyphens, 'pz': word_between_year_and_price, 
                                        'date': date, 'highest': high_price, "lowest": low_price, "average": avg_price}, ignore_index=True)
                        # 将字典转换为 DataFrame，并使用 pd.concat() 方法来合并 DataFrame
                        #new_row = pd.DataFrame({'market': content_between_hyphens, 'pz': word_between_year_and_price, 
                        #                        'date': date, 'highest': high_price, 'lowest': low_price, 'average': avg_price}, index=[0])

                        #df = pd.concat([df, new_row], ignore_index=True)
                        # 定义输出 CSV 文件的路径
                        # output_csv_path = 'C:\\Users\\Bannie\\Desktop\\code\\summer-data\\prices.csv'   
                        output_csv_path = '/export/agrimarket/ods/prices.csv'                

                        if(i==1 and j==1):
                            df.to_csv(output_csv_path, index=False, mode='w', header=False)
                        else:
                            df.to_csv(output_csv_path, index=False, mode='a', header=False)








'''

                # 将数据添加到 DataFrame
                df = df.append({'date': date, 'l': low_price, 'h': high_price, 'a': avg_price}, ignore_index=True)
                
            # wait_time = random.uniform(1, 2)
            # time.sleep(wait_time)
            # 打开现有的 Excel 文件
            file_path = 'C:\\Users\\Bannie\\Desktop\\code\\summer-data\\' + content_between_hyphens + '.xlsx'

            # 检查文件是否存在
            file_exists = os.path.isfile(file_path)
            # 如果文件不存在，创建一个新的 Excel 文件
            if not file_exists:
                with pd.ExcelWriter(file_path, engine='openpyxl') as writer:
                    #print('新建')
                    df.to_excel(writer, sheet_name = word_between_year_and_price, index=False, header=False)
            else:
                # 如果文件已存在，使用追加模式 'a' 来写入数据
                with pd.ExcelWriter(file_path, mode='a', engine='openpyxl') as writer:
                    #print('加入')
                    df.to_excel(writer, sheet_name = word_between_year_and_price, index=False, header=False)


    # 找到包含价格信息的所有<tr>标签
    price_trs = soup.find_all('tr', bgcolor="#FFFFFF")

    for tr in price_trs:
        print(tr)
        # 提取日期、最低价格、最高价格和平均价格
        date = tr.find('td', align='center', width='20%').text
        lowest_price = tr.find('td', class_='L').text
        highest_price = tr.find('td', class_='H').text
        average_price = tr.find('td', class_='A').text

        # 输出每个<tr>标签中的信息
        print(f"日期: {date}")
        print(f"最低价格: {lowest_price}")
        print(f"最高价格: {highest_price}")
        print(f"平均价格: {average_price}")
        print("---------------------------")
'''
