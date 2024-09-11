from bs4 import BeautifulSoup
import requests
import pandas as pd

# 设置要爬取的接口
base_url = 'http://price.cnveg.com/shucaiqiye/cla-1t-1cta-1ctb-1ctc-1by-1p{}.html'
# 设置请求头
headers = {
    'User-Agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1'
}

# 创建一个空的 DataFrame 来存储所有数据
all_data = pd.DataFrame()

for i in range (1,1740): #1,300 
    url = base_url.format(i)
    print(url)

    # 创建一个空的 DataFrame 来存储数据
    df = pd.DataFrame(columns=['name', 'demand_type', 'manager', 'email', 'phone', 'fixed_phone', 'qq', 'addr'])
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        soup = BeautifulSoup(response.content, 'html.parser', from_encoding='utf-8')
        # 找到<title>标签
        title_tag = soup.title
        companies = soup.find_all('table', {'align': 'left', 'bgcolor': '#ffffff'})
        
        for info in companies:
            company_name = ""
            responsible_person = ""
            category = ""
            email = ""
            mobile = ""
            fixed = ""
            qq = ""
            address = ""

            #print("info:")
            #print(info.text)
            #print()
            lines = info.text.splitlines()
            #print("lines:")
            #print(lines)

            for line in lines:
                #print("line:", line)
                if "手机" in line:
                    mobile = line[line.find("：") + 1:]
                elif "地址" in line:
                    address = line[line.find("：") + 1:]
                elif "供应" in line or "求购" in line:
                    category = line[:line.find("：")]
                    responsible_person = line[line.find("：") + 1:]
                elif "邮箱" in line:
                    email = line[line.find("：") + 1:]
                elif "Q Q" in line:
                    qq = line[line.find("：") + 1:]
                elif "电话" in line:
                    fixed = line[line.find("：") + 1:]
                elif not line.strip():
                    continue
                else:
                    company_name = line

            df = df.append({'name': company_name, 'demand_type': category, 'manager': responsible_person, 'email': email, 'phone': mobile, 'fixed_phone': fixed, 'qq': qq, 'address': address}, ignore_index=True)
        all_data = pd.concat([all_data, df], ignore_index=True)


# 定义输出 CSV 文件的路径
output_csv_path = 'C:\\Users\\Bannie\\Desktop\\code\\summer-data\\enterprise.csv'   
                
# 将所有数据保存到指定路径的 CSV 文件，覆盖已存在的文件
all_data.to_csv(output_csv_path, index=False, mode='w', header=False)


'''
            print()
            print(f"名称: {company_name}")
            print(f"供求类别: {category}")
            print(f"负责人: {responsible_person}")
            print(f"邮箱: {email}")
            print(f"手机: {mobile}")
            print(f"QQ: {qq}")
            print(f"地址: {address}")
            print()
'''
    
