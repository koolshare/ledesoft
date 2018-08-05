# coding: utf-8

import urllib
import urllib2
import re
import pdb
import os
import cookielib
import StringIO
import ConfigParser

class Smzdm:

    def __init__(self):
        self.cookies = cookielib.CookieJar()
        self.opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(self.cookies))
        self.headers = {
            'User-Agent' : 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.124 Safari/537.36',
            'Referer' : 'http://www.smzdm.com/',
            'Origin' : 'http://www.smzdm.com/'
        }

    # 登录
    def login(self, account):
        url = "https://zhiyou.smzdm.com/user/login/ajax_check"
        data = urllib.urlencode({
            'username' : account['username'],
            'password' : account['password'],
            'rememberme' : 'on',
            'redirect_url' : 'http://www.smzdm.com'
        })
        request = urllib2.Request(url, headers = self.headers, data = data)
        content = self.opener.open(request)
        return content

    # 退出
    def logout(self):
        url = "http://zhiyou.smzdm.com/user/logout"
        request = urllib2.Request(url, headers = self.headers)
        self.opener.open(request)

    # 签到
    def checkin(self):
        url = "http://zhiyou.smzdm.com/user/checkin/jsonp_checkin"
        request = urllib2.Request(url, headers = self.headers)
        self.opener.open(request)

    # 查看是否签到
    def is_checkin(self):
        url = "http://zhiyou.smzdm.com/user/info/jsonp_get_current?"
        request = urllib2.Request(url, headers = self.headers)
        response = self.opener.open(request)
        content = response.read()
        pattern = re.compile('\"has_checkin\"\:(.*?),')
        item = re.search(pattern, content)
        if item and item.group(1).strip() == 'true':
            os.system(' var=`date "+%Y-%m-%d %H:%M:%S"`;echo "${var} 自动签到成功" > /koolshare/smzdm/log')
        else:
            os.system(' var=`date "+%Y-%m-%d %H:%M:%S"`;echo "${var} 自动签到出错" > /koolshare/smzdm/log')

    def start_checkin(self):
        parser = ConfigParser.RawConfigParser()
        parser.read("/koolshare/smzdm/account.ini")
        for user in parser.sections():
            account = {}
            account['username'] = parser.get(user, 'username')
            account['password'] = parser.get(user, 'password')
            self.login(account)
            self.checkin()
            self.is_checkin()
            self.logout()

smzdm = Smzdm()
smzdm.start_checkin()
