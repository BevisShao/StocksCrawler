#!/usr/bin/env python
# -*- encoding: utf-8 -*-
from urllib.parse import urljoin, urlencode
import logging
import requests
import settings
import pymysql
import asyncio
import aiohttp
from threading import Thread
import json
import redis
import random
from settings import REDIS_HOST, REDIS_PASSWORD, REDIS_PORT, MAX_SCORE, REDIS_KEY
import time


class DailyDetail(object):
    db_redis = redis.StrictRedis(host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PASSWORD, decode_responses=True)
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)
    logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    logger.addHandler(logging.StreamHandler())
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
    }
    headers_connect = {
        'CONNECT': 'www.web-tinker.com:80 HTTP / 1.1',
        'Host': 'www.web-tinker.com:80',
        'Proxy-Connection': 'Keep-Alive',
        'Proxy-Authorization': 'Basic *',
        'Content-Length': 0,
    }

    def __init__(self):
        super().__init__()
        self.init_db()

    def close_cursor(self):
        self.cursor.close()

    def __del__(self):
        if self.__dict__.get('cursor'):
            self.cursor.close()

    def get_proxy(self):
        # 获取库存里可用的代理
        lists_ip = self.db_redis.zrangebyscore(REDIS_KEY, MAX_SCORE, MAX_SCORE + 1)
        if lists_ip:
            proxy = random.choice(lists_ip)
            self.logger.info('current IP : {}'.format(proxy))
            return 'http://' + proxy
        else:
            self.logger.error('当前无可用代理，请等待...')
            return 'http://' + '255.255.255.255:8888'

    # def get_proxy(self):
    #     resp = requests.get(settings.PROXY_URL)
    #     proxy = resp.text
    #     self.logger.info('current IP : {}'.format(proxy))
    #     # proxies = {
    #     #     # 'http': 'http://' + proxy,
    #     #     'https': 'https://' + proxy,
    #     # }
    #     proxies = 'http://' + proxy
    #     self.proxies = proxies
    #     return proxies

    def init_db(self):
        self.db_mysql = pymysql.connect(host='localhost', user='your_name', password='your_psw', port=3306, db='gp_db')
        self.cursor = self.db_mysql.cursor()

    def get_dicts(self, mk):
        sql_600 = "select * from gp_kv where id>'60000' and id<'610000';"
        self.cursor.execute(sql_600)
        dict_600 = dict(self.cursor.fetchall())
        assert dict_600, self.logger.error('获取600开头的股票列表失败...')
        # print(lists_600)
        sql_000 = "select * from gp_kv where id>'00000' and id<'010000';"
        self.cursor.execute(sql_000)
        dict_000 = dict(self.cursor.fetchall())
        assert dict_000, self.logger.error('获取000开头的股票列表失败...')
        # print(dict_000)
        sql_300 = "select * from gp_kv where id>'30000' and id<'310000';"
        self.cursor.execute(sql_300)
        dict_300 = dict(self.cursor.fetchall())
        assert dict_300, self.logger.error('获取300开头的股票列表失败...')
        sql_688 = "SELECT * FROM gp_kv WHERE id LIKE '688%';"
        self.cursor.execute(sql_688)
        dict_688 = dict(self.cursor.fetchall())
        assert dict_688, self.logger.error('获取688开头的股票列表失败...')
        # print(dict_300)
        # print(type(dict_300))
        if mk == '000':
            return dict_000
        elif mk == '300':
            return dict_300
        elif mk == '600':
            return dict_600
        elif mk == '688':
            return dict_688

    def get_urls(self, mk):
        lists = self.get_dicts(mk).keys()
        params = settings.PARAMS_DETAILS
        urls = []
        for li in lists:
            if mk == '000' or '300':
                params.update(id=li + '2')
                url = settings.DAILY_BASE_URL + urlencode(params)
                # print(url)
                urls.append(url)
            elif mk == '600' or '688':
                params.update(id=li + '1')
                url = settings.DAILY_BASE_URL + urlencode(params)
                # print(url)
                urls.append(url)
        return urls

    def start_coroutine(self, urls=None, loop=None):
        asyncio.set_event_loop(loop)
        tasks = [asyncio.ensure_future(self.get_daily_datas(url=url)) for url in urls]
        loop.run_until_complete(asyncio.wait(tasks))

    def start_thread(self, urls):
        loop = asyncio.new_event_loop()
        work_thread = Thread(target=self.start_coroutine, args=(urls, loop))
        work_thread.start()

    async def get_daily_datas(self, url):
        async with aiohttp.ClientSession() as session:
            print('当前url：{}'.format(url))
            async with session.get(url=url, proxy=self.get_proxy(), headers=self.headers, ) as resp:
                # resp = await session.get(url=url, headers=self.headers)
                status = resp.status
                print('status:{}'.format(status))
                if status == 200:
                    html = await resp.text()
                    # dict_text = json.loads(html)
                    # print('单个股票信息详情页：{}'.format(html))
                    # 'sssssadf'.rstrip(')').lstrip('(')
                    json_text = html.rstrip(')').lstrip('(')
                    json2dict = json.loads(json_text)
                    # print(json2dict)
                    self.insert_to_mysql(json2dict)
                elif status == 403:
                    self.logger.warning('当前访问已被服务器屏蔽，url:{}'.format(url))
                else:
                    self.logger.warning('当前访问异常，异常代码：{}，当前url：{}'.format(status, url))

    def insert_to_mysql(self, json2dict):
        '''
        date\start_price\stop_price\max_price\min_price\deal_quantom\deal_money\amplitude
        :return:
        '''
        name, code, datas = json2dict.get('name'), json2dict.get('code'), json2dict.get('data')
        # print(name, code, datas)
        # for data in datas:
        for data in datas:
            # data = datas[0]
            print(data)
            # 2009-10-30,100.10,102.90,147.80,86.00,226207,2373081072,-
            list_single = list(data.split(','))
            data2 = list(map(lambda x: '\'' + x + '\'', list_single))
            data3 = list(map(lambda x: str(x), list_single))
            print('data:', data2)
            data_join = ','.join(data2)
            print('处理后的data_join：', data_join)
            sql1 = 'CREATE TABLE if not exists %s (date_deal date NOT NULL primary key , start_price double NOT NULL, ' \
                   'stop_price double NOT NULL, max_price double  NOT NULL, min_price double  NOT NULL, ' \
                   'deal_quantom int  NOT NULL, deal_money bigint NOT NULL, amplitude varchar(6) NOT NULL ' \
                   ') ENGINE=InnoDB DEFAULT CHARSET=UTF8MB4;' % (code+name)
            sql2 = 'INSERT INTO {} values({});'.format(code+name, data_join)
            try:
                var_exsits = self.db_mysql.cursor().execute(sql1)
                print('var_exsits: ', var_exsits)
                self.db_mysql.commit()
                self.db_mysql.cursor().execute(sql2)
                self.db_mysql.commit()
                self.db_mysql.cursor().close()
            except pymysql.err.IntegrityError:
                self.logger.error('数据库插入错误...')


if __name__ == '__main__':
    now = lambda: time.time()
    start_time = now()
    print('start_time:{}'.format(start_time))
    DailyDetails = DailyDetail()
    urls_300 = DailyDetails.get_urls('300')
    # urls_300_slit = urls_300[:5]
    urls_300_slit = urls_300
    DailyDetails.start_thread(urls_300_slit)
    end_time = now()
    print('end_time:{}'.format(end_time))
    print('all_time:{}'.format(end_time - start_time))
    # print(' | '.join(urls_300))
    # urls_600 = DailyDetails.get_urls('600')
    # print(' | '.join(urls_600))

