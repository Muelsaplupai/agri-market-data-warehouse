import requests
from bs4 import BeautifulSoup
import csv
import time

# 请求头
headers = {'User-Agent': 'Mozilla/5.0'}

# 省份列表，用于提取
provinces = ['北京', '上海', '天津', '重庆', '河北', '山西', '内蒙古', '辽宁', '吉林', '黑龙江',
             '江苏', '浙江', '安徽', '福建', '江西', '山东', '河南', '湖北', '湖南', '广东',
             '广西', '海南', '四川', '贵州', '云南', '西藏', '陕西', '甘肃', '青海', '宁夏',
             '新疆', '香港', '澳门', '台湾','全国']

def extract_province(title):
    for province in provinces:
        if province in title:
            return province
    return '未知'

# 用于存储所有页面的数据
all_data = []

# 遍历每一页
for page_num in range(1, 101):  # 从页面 1 到页面 100
    # 构造当前页面的 URL
    url = f'https://www.inong.net/news/list/68/{page_num}'

    try:
        # 发起请求
        response = requests.get(url, headers=headers)
        response.raise_for_status()  # 检查请求是否成功
        soup = BeautifulSoup(response.text, 'html.parser')

        # 查找所有文章
        articles = soup.find_all('dd', class_='noimg')

        # 提取数据
        for article in articles:
            title_tag = article.find('a', class_='a_btn')
            title = title_tag.text.strip()
            link = title_tag['href'].strip()
            pub_date = article.find('span', class_='time').text.replace('发布时间：', '').strip()
            
            province = extract_province(title)

            if province != '未知':  # 只有省份已知的数据才添加
                all_data.append({
                    'title': title,
                    'link': link,
                    'publication_date': pub_date,
                    'province': province
                })

        print(f"Page {page_num} data fetched.")

    except requests.RequestException as e:
        print(f"Error fetching page {page_num}: {e}")

    time.sleep(1)  # 添加延时，防止过于频繁的请求

# 输出为 CSV 文件
with open('agriculture_data.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['title', 'link', 'publication_date', 'province']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    
    writer.writeheader()
    for item in all_data:
        writer.writerow(item)

print("数据已保存到 ods_article.csv")
