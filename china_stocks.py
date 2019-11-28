#!/usr/bin/env python
# -*- encoding: utf-8 -*-
import settings
import requests
import re
import logging
from lxml import etree
import pymysql

class China_Stocks(object):
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)
    logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    logger.addHandler(logging.StreamHandler())
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
    }
    table_kv = 'gp_kv'

    def __init__(self):
        super().__init__()
        self.init_mysql()

    def main(self):
        pass

    def get_proxy(self):
        resp = requests.get(settings.PROXY_URL)
        proxy = resp.text
        self.logger.info('current IP : {}'.format(proxy))
        proxies = {
            # 'http': 'http://' + proxy,
            'https': 'https://' + proxy,
        }
        return proxies

    def get_all_stocks(self):
        resp = requests.get(url=settings.ALL_LISTS_URL, proxies=self.get_proxy(), headers=self.headers, timeout=10)
        # resp = requests.get(url=settings.ALL_LISTS_URL, headers=self.headers, timeout=10)
        html_text = resp.text.encode('latin1').decode('gbk', 'ignore')
        # html_text = resp.text
        # print('所有股票列表界面:', html_text)
        html = etree.HTML(html_text)
        result_sh = html.xpath('//div[@class="quotebody"]/div/ul[1]/li/a[@target="_blank"]/text()')
        result_sz = html.xpath('//div[@class="quotebody"]/div/ul[2]/li/a[@target="_blank"]/text()')
        assert result_sh, print('获取上交所股票列表失败...')
        assert result_sz, print('获取深交所股票列表失败...')
        print('上交所：\n{}'.format(' | '.join(result_sh)))
        # dict_sh = list(map(lambda x: re.search('(.*)\((.*)\)', x), result_sh))
        dict_sh = self.process_stock_kv(result_sh)
        dict_sz = self.process_stock_kv(result_sz)
        self.close_coursor()

    def init_mysql(self):
        self.db = pymysql.connect(host='localhost', user=f'{your_name}', password=f'{your_psw}', port=3306, db='gp_db')
        self.cursor = self.db.cursor()
        sql = 'CREATE TABLE IF NOT EXISTS gp_kv (id VARCHAR (255) NOT NULL, name VARCHAR (255) NOT NULL, PRIMARY KEY (id))'
        self.cursor.execute(sql)
        # cursor.execute("CREATE DATABASE spiders DEFAULT CHARACTER SET utf8")

    def process_stock_kv(self, lists):
        for stock in lists:
            list_result = re.search('(.*)\((.*)\)', stock)
            stock_code = '\'' + list_result.group(2) + '\''
            stock_name = '\'' + list_result.group(1) + '\''
            # dict_kv[stock_code] = stock_name

            # sql = 'insert into %s (id, name) values(%s);' % (self.table_kv, stock_code + ' ,' + stock_name)
            sql = 'replace into %s (id, name) values(%s);' % (self.table_kv, stock_code + ' ,' + stock_name)
            self.cursor.execute(sql)
            self.db.commit()

    def close_cursor(self):
        self.cursor.close()

    def __del__(self):
        if self.__dict__.get('cursor'):
            self.cursor.close()


if __name__ == '__main__':
    china_stocks = China_Stocks()
    china_stocks.get_all_stocks()
