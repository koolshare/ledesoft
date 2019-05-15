#!/usr/bin/env python
from __future__ import print_function
import os
import re
import sys
import json
import time
import binascii
import tarfile
import atexit
import logging 
logger = logging.getLogger('knlog')
logger.setLevel(logging.INFO)
hdr = logging.FileHandler('/tmp/upload/fastdick.log', encoding='utf-8')
formatter = logging.Formatter('[%(asctime)s] %(message)s')
hdr.setFormatter(formatter)
logger.addHandler(hdr)

def print(fmt, **args):
	if not args:
		logger.info(fmt)
	else:
		logger.info(fmt, args)

try:
    import ssl
    import hashlib
except ImportError as ex:
    print("Error: cannot import module ssl or hashlib (%s)." % str(ex))
    print("If you are using openwrt, run \"opkg install python-openssl\"")
    os._exit(0)
try:
    import zlib
except ImportError as ex:
    print("Warning: cannot import module zlib (%s)." % str(ex))
    # TODO: if there's a python dist that is not bundled with zlib ever exists, disable gzip Accept-Encoding

#xunlei use self-signed certificate; on py2.7.9+
if hasattr(ssl, '_create_unverified_context') and hasattr(ssl, '_create_default_https_context'):
    ssl._create_default_https_context = ssl._create_unverified_context

#rsa_mod = 0xAC69F5CCC8BDE47CD3D371603748378C9CFAD2938A6B021E0E191013975AD683F5CBF9ADE8BD7D46B4D2EC2D78AF146F1DD2D50DC51446BB8880B8CE88D476694DFC60594393BEEFAA16F5DBCEBE22F89D640F5336E42F587DC4AFEDEFEAC36CF007009CCCE5C1ACB4FF06FBA69802A8085C2C54BADD0597FC83E6870F1E36FD
#rsa_pubexp = 0x010001

APP_VERSION = "2.4.1.3"
PROTOCOL_VERSION = 200
VASID_DOWN = 14 # vasid for downstream accel
VASID_UP = 33 # vasid for upstream accel
FALLBACK_MAC = '000000000000'
FALLBACK_PORTAL = "119.147.41.210:12180"
FALLBACK_UPPORTAL = "153.37.208.185:81"

UNICODE_WARNING_SHOWN = False

PY3K = sys.version_info[0] == 3
if not PY3K:
    import urllib2
    from urllib2 import URLError
    from urllib import quote as url_quote
    from cStringIO import StringIO as sio
    #rsa_pubexp = long(rsa_pubexp)
else:
    import urllib.request as urllib2
    from urllib.error import URLError
    from urllib.parse import quote as url_quote
    from io import BytesIO as sio

account_session = '.swjsq.session'
account_file_plain = 'swjsq.account.txt'
shell_file = 'swjsq_wget.sh'
ipk_file = 'swjsq_0.0.1_all.ipk'
log_file = 'swjsq.log'

login_xunlei_intv = 600 # do not login twice in 10min

DEVICE = "SmallRice R1"
DEVICE_MODEL = "R1"
OS_VERSION = "5.0.1"
OS_API_LEVEL = "24"
OS_BUILD = "LRX22C"

header_xl = {
    'Content-Type':'',
    'Connection': 'Keep-Alive',
    'Accept-Encoding': 'gzip',
    'User-Agent': 'android-async-http/xl-acc-sdk/version-2.1.1.177662'
}
header_api = {
    'Content-Type':'',
    'Connection': 'Keep-Alive',
    'Accept-Encoding': 'gzip',
    'User-Agent': 'Dalvik/2.1.0 (Linux; U; Android %s; %s Build/%s)' % (OS_VERSION, DEVICE_MODEL, OS_BUILD)
}


def get_mac(nic = '', to_splt = ':'):
    if os.name == 'nt':
        cmd = 'ipconfig /all'
        splt = '-'
    elif os.name == "posix":
        if os.path.exists('/usr/bin/ip') or os.path.exists('/bin/ip'):
            if nic:
                cmd = 'ip link show dev %s' % nic
            else:
                # Unfortunately, loopback interface always comes first
                # So we have to grep it out
                cmd = 'ip link show up | grep -v loopback'
        else:
            cmd = 'ifconfig %s' % (nic or '-a')
        splt = ':'
    else:
        return FALLBACK_MAC
    try:
        r = os.popen(cmd).read()
        if r:
            _ = re.findall('((?:[0-9A-Fa-f]{2}%s){5}[0-9A-Fa-f]{2})' % splt, r)
            if not _:
                return FALLBACK_MAC
            else:
                return _[0].replace(splt, to_splt)
    except:
        pass
    return FALLBACK_MAC

    
def api_url(up = False):
    portal = None
    if up:
        portals = (("", "up", 80), )
    else:
        portals = (("", "", 81), ("2", "", 81), ("", "", 82))
    for cmb in portals:
        portal = json.loads(http_req("http://api%s.%sportal.swjsq.vip.xunlei.com:%d/v2/queryportal" % cmb))
        try:
            portal = json.loads(http_req("http://api%s.%sportal.swjsq.vip.xunlei.com:%d/v2/queryportal" % cmb))
        except:
            pass
        else:
            break
    if not portal or portal['errno']:
        print('Warning: get interface_ip failed, use fallback address')
        if up:
            return FALLBACK_UPPORTAL
        else:
            return FALLBACK_PORTAL
    return '%s:%s' % (portal['interface_ip'], portal['interface_port'])

def long2hex(l):
    return hex(l)[2:].upper().rstrip('L')

_real_print = print
logfd = open(log_file, 'ab')

def print(s, **kwargs):
    line = "%s %s" % (time.strftime('%X', time.localtime(time.time())), s)
    if PY3K:
        logfd.write(line.encode('utf-8'))
    else:
        try:
            logfd.write(line)
        except UnicodeEncodeError:
            logfd.write(line.encode('utf-8'))
    if PY3K:
        logfd.write(b'\n')
    else:
        logfd.write("\n")
    _real_print(line, **kwargs)
    
def uprint(s, fallback = None, end = None):
    global UNICODE_WARNING_SHOWN
    while True:
        try:
            print(s, end = end)
        except UnicodeEncodeError:
            if UNICODE_WARNING_SHOWN:
                print('Warning: locale of your system may not be utf8 compatible, output will be truncated')
                UNICODE_WARNING_SHOWN = True
        else:
            break
        try:
            print(s.encode('utf-8'), end = end)
        except UnicodeEncodeError:
            if fallback:
                print(fallback, end = end)
        break

def http_req(url, headers = {}, body = None, encoding = 'utf-8'):
    req = urllib2.Request(url)
    for k in headers:
        req.add_header(k, headers[k])
    if sys.version.startswith('3') and isinstance(body, str):
        body = bytes(body, encoding = 'ascii')
    resp = urllib2.urlopen(req, data = body, timeout = 60)
    buf = resp.read()
    # check if response is gzip encoded
    if buf.startswith(b'\037\213'):
        try:
            buf = zlib.decompress(buf, 16 + zlib.MAX_WBITS) # skip gzip headers
        except Exception as ex:
            print('Warning: malformed gzip response (%s).' % str(ex))
            # buf is unchanged
    ret = buf.decode(encoding)
    if sys.version.startswith('3') and isinstance(ret, bytes):
        ret = str(ret)
    return ret


class fast_d1ck(object):
    def __init__(self):
        self.api_url = api_url(up = False)
        self.api_up_url = api_url(up = True)
        self.mac = get_mac(to_splt = '').upper() + '004V'
        self.xl_uid = None
        self.xl_session = None
        self.xl_loginkey = None
        self.xl_login_payload = None
        self.last_login_xunlei = 0
        self.do_down_accel = False
        self.do_up_accel = False
        
        self.state = 0

    def load_xl(self, dt):
        if 'sessionID' in dt:
            self.xl_session = dt['sessionID']
        if 'userID' in dt:
            self.xl_uid = dt['userID']
        if 'loginKey' in dt:
            self.xl_loginkey = dt['loginKey']

    def login_xunlei(self, uname, pwd):       
        _ = int(login_xunlei_intv - time.time() + self.last_login_xunlei)
        if _ > 0: 
            print("sleep %ds to prevent login flood" % _)
            time.sleep(_)
        self.last_login_xunlei = time.time()

        # pwd = rsa_encode(pwd_md5)
        fake_device_id = hashlib.md5(("msfdc%s23333" % pwd).encode('utf-8')).hexdigest() # just generate a 32bit string
        # sign = div.10?.device_id + md5(sha1(packageName + businessType + md5(a protocolVersion specific GUID)))
        device_sign = "div101.%s%s" % (fake_device_id, hashlib.md5(
            hashlib.sha1(("%scom.xunlei.vip.swjsq68c7f21687eed3cdb400ca11fc2263c998" % fake_device_id).encode('utf-8'))
                .hexdigest().encode('utf-8')
         ).hexdigest())
        _payload = {
                "protocolVersion": str(PROTOCOL_VERSION),
                "sequenceNo": "1000001",
                "platformVersion": "2",
                "sdkVersion": "177662",
                "peerID": self.mac,
                "businessType": "68",
                "clientVersion": APP_VERSION,
                "devicesign":device_sign,
                "isCompressed": "0",
                #"cmdID": 1,
                "userName": uname,
                "passWord": pwd,
                #"loginType": 0, # normal account
                "sessionID": "",
                "verifyKey": "",
                "verifyCode": "",
                "appName": "ANDROID-com.xunlei.vip.swjsq",
                #"rsaKey": {
                #    "e": "%06X" % rsa_pubexp,
                #    "n": long2hex(rsa_mod)
                #},
                #"extensionList": "",
                "deviceModel": DEVICE_MODEL,
                "deviceName": DEVICE,
                "OSVersion": OS_VERSION
        }
        ct = http_req('https://mobile-login.xunlei.com:443/login', body=json.dumps(_payload), headers=header_xl, encoding='utf-8')
        self.xl_login_payload = _payload
        dt = json.loads(ct)
        
        self.load_xl(dt)
        return dt


    def check_xunlei_vas(self, vasid):
        # copy original payload to new dict
        _payload = dict(self.xl_login_payload)
        _payload.update({
            "sequenceNo": "1000002",
            "vasid": str(vasid),
            "userID": str(self.xl_uid),
            "sessionID": self.xl_session,
            #"extensionList": [
            #    "payId", "isVip", "mobile", "birthday", "isSubAccount", "isAutoDeduct", "isYear", "imgURL",
            #    "vipDayGrow", "role", "province", "rank", "expireDate", "personalSign", "jumpKey", "allowScore",
            #    "nickName", "vipGrow", "isSpecialNum", "vipLevel", "order", "payName", "isRemind", "account",
            #    "sex", "vasType", "register", "todayScore", "city", "country"
            #]
        })
        # delete unwanted kv pairs
        for k in ('userName', 'passWord', 'verifyKey', 'verifyCode'):
            del _payload[k]
        ct = http_req('https://mobile-login.xunlei.com:443/getuserinfo', body=json.dumps(_payload), headers=header_xl, encoding='utf-8')
        return json.loads(ct)

    def renew_xunlei(self):
        _ = int(login_xunlei_intv - time.time() + self.last_login_xunlei)
        if _ > 0: 
            print("sleep %ds to prevent login flood" % _)
            time.sleep(_)
        self.last_login_xunlei = time.time()

        _payload = dict(self.xl_login_payload)
        _payload.update({
            "sequenceNo": "1000001",
            "userName": str(self.xl_uid), #wtf
            "loginKey": self.xl_loginkey,
        })
        for k in ('passWord', 'verifyKey', 'verifyCode', "sessionID"):
            del _payload[k]
        ct = http_req('https://mobile-login.xunlei.com:443/loginkey ', body=json.dumps(_payload), headers=header_xl, encoding='utf-8')
        dt = json.loads(ct)
        
        self.load_xl(dt)
        return dt


    def api(self, cmd, extras = '', no_session = False):
        ret = {}
        for _k1, api_url_k, _clienttype, _v in (('down', 'api_url', 'swjsq', 'do_down_accel'), ('up', 'api_up_url', 'uplink', 'do_up_accel')):
            if not getattr(self, _v):
                continue
            while True:
                # missing dial_account, (userid), os
                api_url = getattr(self, api_url_k)
                # TODO: phasing out time_and
                url = 'http://%s/v2/%s?%sclient_type=android-%s-%s&peerid=%s&time_and=%d&client_version=android%s-%s&userid=%s&os=android-%s%s' % (
                        api_url,
                        cmd,
                        ('sessionid=%s&' % self.xl_session) if not no_session else '',
                        _clienttype, APP_VERSION,
                        self.mac,
                        time.time() * 1000,
                        _clienttype, APP_VERSION,
                        self.xl_uid,
                        url_quote("%s.%s%s" % (OS_VERSION, OS_API_LEVEL, DEVICE_MODEL)),
                        ('&%s' % extras) if extras else '',
                )
                try:
                    ret[_k1] = {}
                    ret[_k1] = json.loads(http_req(url, headers = header_api))
                    break
                except URLError as ex:
                    uprint("Warning: error during %sapi connection: %s, use portal: %s" % (_k1, str(ex), api_url))
                    if (_k1 == 'down' and api_url == FALLBACK_PORTAL) or (_k1 == 'up' and api_url == FALLBACK_UPPORTAL):
                        print("Error: can't connect to %s api" % _k1)
                        os._exit(5)
                    if _k1 == 'down':
                        setattr(self, api_url_k, FALLBACK_PORTAL)
                    elif _k1 == 'up':
                        setattr(self, api_url_k, FALLBACK_UPPORTAL)
        return ret


    def run(self, uname, pwd, save=True):
        if uname[-2] == ':':
            print('Error: sub account can not upgrade')
            os._exit(3)

        login_methods = [lambda : self.login_xunlei(uname, pwd)]
        if self.xl_session:
            login_methods.insert(0, self.renew_xunlei)

        failed = True
        for _lm in login_methods:
            dt = _lm()
            if dt['errorCode'] != "0" or not self.xl_session or not self.xl_loginkey:
                uprint('Error: login xunlei failed, %s' % dt['errorDesc'], 'Error: login failed')
                print(dt)
            else:
                failed = False
                break
        if failed:
            os._exit(1)
        print('Login xunlei succeeded')
        
        yyyymmdd = time.strftime("%Y%m%d", time.localtime(time.time()))
        
        if 'vipList' not in dt:
            vipList = []
        else:
            vipList = dt['vipList']
        # chaoji member
        if vipList and vipList[0]['isVip'] == "1" and vipList[0]['vasType'] == "5" and vipList[0]['expireDate'] > yyyymmdd: # choaji membership
            self.do_down_accel = True
            # self.do_up_accel = True
            print('Expire date for chaoji member: %s' % vipList[0]['expireDate'])
        # kuainiao down/up member
        _vas_debug = []
        for _vas, _name, _v in ((VASID_DOWN, 'fastdick', 'do_down_accel'), (VASID_UP, 'upstream acceleration', 'do_up_accel')):
            if getattr(self, _v): # don't check again if vas is activated in other membership
                continue
            _dt = self.check_xunlei_vas(_vas)
            if 'vipList' not in _dt or not _dt['vipList']:
                continue
            for vip in _dt['vipList']:
                if vip['vasid'] == str(_vas):
                    _vas_debug.append(vip)
                    if vip['isVip'] == "1":
                        if vip['expireDate'] < yyyymmdd:
                            print('Warning: Your %s membership expires on %s' % (_name, vip['expireDate']))
                        else:
                            print('Expire date for %s: %s' % (_name, vip['expireDate']))
                            setattr(self, _v, True)
                
            if not self.do_down_accel and not self.do_up_accel:
                print('Error: You are neither xunlei fastdick member nor upstream acceleration member, buy buy buy!\nDebug: %s' % _vas_debug)
                os._exit(2)

        if save:
            try:
                os.remove(account_file_plain)
            except:
                pass
            with open(account_session, 'w') as f:
                f.write('%s\n%s' % (json.dumps(dt), json.dumps(self.xl_login_payload)))
        
        api_ret = self.api('bandwidth', no_session = True)
        
        _to_upgrade = []
        for _k1, _k2, _name, _v in (
                ('down', 'downstream', 'fastdick', 'do_down_accel'),
                ('up', 'upstream', 'upstream acceleration', 'do_up_accel')):
            if not getattr(self, _v):
                continue

            _ = api_ret[_k1]
            if 'can_upgrade' not in _ or not _['can_upgrade']:
                uprint('Warning: %s can not upgrade, so sad TAT: %s' % (_name, _['message']), 'Error: %s can not upgrade, so sad TAT' % _name)
                setattr(self, _v, False)
            else:
                _to_upgrade.append('%s %dM -> %dM' % (
                        _k1, 
                        _['bandwidth'][_k2]/1024,
                        _['max_bandwidth'][_k2]/1024,
                    ))
        
        if not self.do_down_accel and not self.do_up_accel:
            print("Error: neither downstream nor upstream can be upgraded")
            os._exit(3)
        
        _avail = api_ret[list(api_ret.keys())[0]]
        
        uprint('To Upgrade: %s%s %s' % ( _avail['province_name'], _avail['sp_name'], ", ".join(_to_upgrade)),
                'To Upgrade: %s %s %s' % ( _avail['province'], _avail['sp'], ", ".join(_to_upgrade))
              )
              
        _dial_account = _avail['dial_account']

       # _script_mtime = os.stat(os.path.realpath(__file__)).st_mtime
       # if not os.path.exists(shell_file) or os.stat(shell_file).st_mtime < _script_mtime:
       #     self.make_wget_script(pwd, _dial_account)
       # if not os.path.exists(ipk_file) or os.stat(ipk_file).st_mtime < _script_mtime:
        #    update_ipk()

        #print(_)
        def _atexit_func():
            print("Sending recover request")
            try:
                self.api('recover', extras = "dial_account=%s" % _dial_account)
            except KeyboardInterrupt:
                print('Secondary ctrl+c pressed, exiting')
            try:
                logfd.close()
            except:
                pass
        atexit.register(_atexit_func)
        self.state = 0
        while True:
            has_error = False
            try:
                # self.state=1~17 keepalive,  self.state++
                # self.state=18 (3h) re-upgrade all, self.state-=18
                # self.state=100 login, self.state:=18
                if self.state == 100:
                    _dt_t = self.renew_xunlei()
                    if int(_dt_t['errorCode']):
                        time.sleep(60)
                        dt = self.login_xunlei(uname, pwd)
                        if int(dt['errorCode']):
                            self.state = 100
                            continue
                    else:
                        _dt_t = dt
                    self.state = 18
                if self.state % 18 == 0:#3h
                    print('Initializing upgrade')
                    if self.state:# not first time
                        self.api('recover', extras = "dial_account=%s" % _dial_account)
                        time.sleep(5)
                    api_ret = self.api('upgrade', extras = "user_type=1&dial_account=%s" % _dial_account)
                    #print(_)
                    _upgrade_done = []
                    for _k1, _k2 in ('down', 'downstream'), ('up', 'upstream'):
                        if _k1 not in api_ret:
                            continue
                        if not api_ret[_k1]['errno']:
                            _upgrade_done.append("%s %dM" % (_k1, api_ret[_k1]['bandwidth'][_k2]/1024))
                    if _upgrade_done:
                        print("Upgrade done: %s" % ", ".join(_upgrade_done))
                else:
                    # _dt_t = self.renew_xunlei()
                    # if _dt_t['errorCode']:
                    #     self.state = 100
                    #     continue
                    try:
                        api_ret = self.api('keepalive')
                    except Exception as ex:
                        print("keepalive exception: %s" % str(ex))
                        time.sleep(60)
                        self.state = 18
                        continue
                for _k1, _k2, _name, _v in ('down', 'Downstream', 'fastdick', 'do_down_accel'), ('up', 'Upstream', 'upstream acceleration', 'do_up_accel'):
                    if _k1 in api_ret and api_ret[_k1]['errno']:
                        _ = api_ret[_k1]
                        print('%s error %s: %s' % (_k2, _['errno'], _['message']))
                        if _['errno'] in (513, 824):# TEST: re-upgrade when get 513 or 824 speedup closed
                            self.state = 100
                        elif _['errno'] == 812:
                            print('%s already upgraded, continuing' % _k2)
                        elif _['errno'] == 717 or _['errno'] == 718:# re-upgrade when get 'account auth session failed'
                            self.state = 100
                        elif _['errno'] == 518: # disable down/up when get qurey vip response user not has business property
                            print("Warning: membership expired? Disabling %s" % _name)
                            setattr(self, _v, False)
                        else:
                            has_error = True
                if self.state == 100:
                    continue
            except Exception as ex:
                import traceback
                _ = traceback.format_exc()
                print(_)
                has_error = True
            if has_error:
                # sleep 5 min and repeat the same state
                time.sleep(290)#5 min
            else:
                self.state += 1
                time.sleep(590)#10 min


    def make_wget_script(self, pwd, dial_account):
        # i=1~17 keepalive, renew session, i++
        # i=18 (3h) re-upgrade, i:=0
        # i=100 login, i:=18
        xl_renew_payload = dict(self.xl_login_payload)
        xl_renew_payload.update({
            "sequenceNo": "1000001",
            "userName": str(self.xl_uid), #wtf
            "loginKey": "$loginkey",
        })
        for k in ('passWord', 'verifyKey', 'verifyCode', "sessionID"):
            del xl_renew_payload[k]
        with open(shell_file, 'wb') as f:
            _ = '''#!/bin/ash
TEST_URL="https://baidu.com"
UA_XL="User-Agent: swjsq/0.0.1"

if [ ! -z "`wget --no-check-certificate -O - $TEST_URL 2>&1|grep "100%"`" ]; then
   HTTP_REQ="wget -q --no-check-certificate -O - "
   POST_ARG="--post-data="
else
   command -v curl >/dev/null 2>&1 && curl -kI $TEST_URL >/dev/null 2>&1 || { echo >&2 "Xunlei-FastD1ck cannot find wget or curl installed with https(ssl) enabled in this system."; exit 1; }
   HTTP_REQ="curl -ks"
   POST_ARG="--data "
fi

uid='''+str(self.xl_uid)+'''
pwd='''+pwd+'''
nic=eth0
peerid='''+self.mac+'''
uid_orig=$uid

last_login_xunlei=0
login_xunlei_intv='''+str(login_xunlei_intv)+'''

day_of_month_orig=`date +%d`
orig_day_of_month=`echo $day_of_month_orig|grep -oE "[1-9]{1,2}"`

#portal=`$HTTP_REQ http://api.portal.swjsq.vip.xunlei.com:82/v2/queryportal`
#portal_ip=`echo $portal|grep -oE '([0-9]{1,3}[\.]){3}[0-9]{1,3}'`
#portal_port_temp=`echo $portal|grep -oE "port...[0-9]{1,5}"`
#portal_port=`echo $portal_port_temp|grep -oE '[0-9]{1,5}'`
portal_ip='''+self.api_url.split(":")[0]+'''
portal_port='''+self.api_url.split(":")[1]+'''
portal_up_ip='''+self.api_up_url.split(":")[0]+'''
portal_up_port='''+self.api_up_url.split(":")[1]+'''

if [ -z "$portal_ip" ]; then
    sleep 30
    portal=`$HTTP_REQ http://api.portal.swjsq.vip.xunlei.com:81/v2/queryportal`
    portal_ip=`echo $portal|grep -oE '([0-9]{1,3}[\.]){3}[0-9]{1,3}'`
    portal_port_temp=`echo $portal|grep -oE "port...[0-9]{1,5}"`
    portal_port=`echo $portal_port_temp|grep -oE '[0-9]{1,5}'`
    if [ -z "$portal_ip" ]; then
        portal_ip="'''+FALLBACK_PORTAL.split(":")[0]+'''"
        portal_port='''+FALLBACK_PORTAL.split(":")[1]+'''
    fi
fi

log () {
    echo `date +%X 2>/dev/null` $@
}

api_url="http://$portal_ip:$portal_port/v2"
api_up_url="http://$portal_up_ip:$portal_up_port/v2"

do_down_accel='''+str(int(self.do_down_accel))+'''
do_up_accel='''+str(int(self.do_up_accel))+'''

i=100
while true; do
    if test $i -ge 100; then
        tmstmp=`date "+%s"`
        let slp=login_xunlei_intv-tmstmp+last_login_xunlei
        if test $slp -ge 0; then
            sleep $slp
        fi
        last_login_xunlei=$tmstmp

        if [ ! -z "$loginkey" ]; then
            log "renew xunlei"
            ret=`$HTTP_REQ https://mobile-login.xunlei.com:443/loginkey $POST_ARG"'''+json.dumps(xl_renew_payload).replace('"','\\"')+'''" --header "$UA_XL"`
            error_code=`echo $ret|grep -oE "errorCode...[0-9]+"|grep -oE "[0-9]+"`
            if [[ -z $error_code || $error_code -ne 0 ]]; then
                log "renew error code $error_code"
            fi
            session_temp=`echo $ret|grep -oE "sessionID...[A-F,0-9]{32}"`
            session=`echo $session_temp|grep -oE "[A-F,0-9]{32}"`
            if [ -z "$session" ]; then
                log "renew session is empty"
                sleep 60
            else
                log "session is $session"
            fi
        fi

        if [ -z "$session" ]; then
            log "login xunlei"
            ret=`$HTTP_REQ https://mobile-login.xunlei.com:443/login $POST_ARG"'''+json.dumps(self.xl_login_payload).replace('"','\\"')+'''" --header "$UA_XL"`
            session_temp=`echo $ret|grep -oE "sessionID...[A-F,0-9]{32}"`
            session=`echo $session_temp|grep -oE "[A-F,0-9]{32}"`
            uid_temp=`echo $ret|grep -oE "userID...[0-9]+"`
            uid=`echo $uid_temp|grep -oE "[0-9]+"`
            if [ -z "$session" ]; then
                log "login session is empty"
                uid=$uid_orig
            else
                log "session is $session"
            fi

            if [ -z "$uid" ]; then
                #echo "uid is empty"
                uid=$uid_orig
            else
                log "uid is $uid"
            fi
        fi

        if [ -z "$session" ]; then
            sleep 600
            continue
        fi

        loginkey=`echo $ret|grep -oE "lk...[a-f,0-9,\.]{96}"`
        i=18
    fi

    if test $i -eq 18; then
        log "upgrade"
        _ts=`date +%s`0000
        if test $do_down_accel -eq 1; then
            $HTTP_REQ "$api_url/upgrade?peerid=$peerid&userid=$uid&sessionid=$session&user_type=1&client_type=android-swjsq-'''+APP_VERSION+'''&time_and=$_ts&client_version=androidswjsq-'''+APP_VERSION+'''&os=android-'''+OS_VERSION+'.'+OS_API_LEVEL+DEVICE_MODEL+'''&dial_account='''+dial_account+'''"
        fi
        if test $do_up_accel -eq 1; then
            $HTTP_REQ "$api_up_url/upgrade?peerid=$peerid&userid=$uid&sessionid=$session&user_type=1&client_type=android-uplink-'''+APP_VERSION+'''&time_and=$_ts&client_version=androiduplink-'''+APP_VERSION+'''&os=android-'''+OS_VERSION+'.'+OS_API_LEVEL+DEVICE_MODEL+'''&dial_account='''+dial_account+'''"
        fi
        i=1
        sleep 590
        continue
    fi

    sleep 1
    day_of_month_orig=`date +%d`
    day_of_month=`echo $day_of_month_orig|grep -oE "[1-9]{1,2}"`
    if [[ -z $orig_day_of_month || $day_of_month -ne $orig_day_of_month ]]; then
        log "recover"
        orig_day_of_month=$day_of_month
        _ts=`date +%s`0000
        if test $do_down_accel -eq 1; then
            $HTTP_REQ "$api_url/recover?peerid=$peerid&userid=$uid&sessionid=$session&client_type=android-swjsq-'''+APP_VERSION+'''&time_and=$_ts&client_version=androidswjsq-'''+APP_VERSION+'''&os=android-'''+OS_VERSION+'.'+OS_API_LEVEL+DEVICE_MODEL+'''&dial_account='''+dial_account+'''"
        fi
        if test $do_up_accel -eq 1; then
            $HTTP_REQ "$api_up_url/recover?peerid=$peerid&userid=$uid&sessionid=$session&client_type=android-uplink-'''+APP_VERSION+'''&time_and=$_ts&client_version=androiduplink-'''+APP_VERSION+'''&os=android-'''+OS_VERSION+'.'+OS_API_LEVEL+DEVICE_MODEL+'''&dial_account='''+dial_account+'''"
        fi
        sleep 5
        i=100
        continue
    fi


    log "keepalive"
    _ts=`date +%s`0000
    if test $do_down_accel -eq 1; then
        ret=`$HTTP_REQ "$api_url/keepalive?peerid=$peerid&userid=$uid&sessionid=$session&client_type=android-swjsq-'''+APP_VERSION+'''&time_and=$_ts&client_version=androidswjsq-'''+APP_VERSION+'''&os=android-'''+OS_VERSION+'.'+OS_API_LEVEL+DEVICE_MODEL+'''&dial_account='''+dial_account+'''"`
        if [[ -z $ret ]]; then
            sleep 60
            i=18
            continue
        fi
        if [ ! -z "`echo $ret|grep "not exist channel"`" ]; then
            i=100
        fi
        if  [ ! -z "`echo $ret|grep "user not has business property"`" ]; then
            log "membership expired? disabling fastdick"
            do_down_accel=0
        fi
    fi
    if test $do_up_accel -eq 1; then
        ret=`$HTTP_REQ "$api_up_url/keepalive?peerid=$peerid&userid=$uid&sessionid=$session&client_type=android-uplink-'''+APP_VERSION+'''&time_and=$_ts&client_version=androiduplink-'''+APP_VERSION+'''&os=android-'''+OS_VERSION+'.'+OS_API_LEVEL+DEVICE_MODEL+'''&dial_account='''+dial_account+'''"`
        if [[ -z $ret ]]; then
            sleep 60
            i=18
            continue
        fi
        if [ ! -z "`echo $ret|grep "not exist channel"`" ]; then
            i=100
        fi
        if  [ ! -z "`echo $ret|grep "user not has business property"`" ]; then
            log "membership expired? disabling upstream acceleration"
            do_up_accel=0
        fi
    fi
    
    if test $i -ne 100; then
        let i=i+1
        sleep 590
    fi
done
'''.replace("\r", "")
            if PY3K:
                _ = _.encode("utf-8")
            f.write(_)


def update_ipk():
    def _sio(s = None):
        if not s:
            return sio()
        if PY3K:
            return sio(bytes(s, "ascii"))
        else:
            return sio(s)

    def flen(fobj):
        pos = fobj.tell()
        fobj.seek(0)
        _ = len(fobj.read())
        fobj.seek(pos)
        return _

    def add_to_tar(tar, name, sio_obj, perm = 420):
        info = tarfile.TarInfo(name = name)
        info.size = flen(sio_obj)
        info.mode = perm
        sio_obj.seek(0)
        tar.addfile(info, sio_obj)

    if os.path.exists(ipk_file):
        os.remove(ipk_file)
    ipk_fobj = tarfile.open(name = ipk_file, mode = 'w:gz')

    data_stream = sio()
    data_fobj = tarfile.open(fileobj = data_stream, mode = 'w:gz')
    # /usr/bin/swjsq
    data_content = open(shell_file, 'rb')
    add_to_tar(data_fobj, './bin/swjsq', data_content, perm = 511)
    # /etc/init.d/swjsq
    data_content = _sio('''#!/bin/sh /etc/rc.common
START=90
STOP=15
USE_PROCD=1

start_service()
{
	procd_open_instance
	procd_set_param respawn ${respawn_threshold:-3600} ${respawn_timeout:-5} ${respawn_retry:-5}
	procd_set_param command /bin/swjsq
	procd_set_param stdout 1
	procd_set_param stderr 1
	procd_close_instance
}
''')
    add_to_tar(data_fobj, './etc/init.d/swjsq', data_content, perm = 511)
    # wrap up
    data_fobj.close()
    add_to_tar(ipk_fobj, './data.tar.gz', data_stream)
    data_stream.close()

    control_stream = sio()
    control_fobj = tarfile.open(fileobj = control_stream, mode = 'w:gz')
    control_content = _sio('''Package: swjsq
Version: 0.0.1
Depends: libc
Source: none
Section: net
Maintainer: fffonion
Architecture: all
Installed-Size: %d
Description:  Xunlei Fast Dick
''' % flen(data_content))
    add_to_tar(control_fobj, './control', control_content)
    control_fobj.close()
    add_to_tar(ipk_fobj, './control.tar.gz', control_stream)
    control_stream.close()

    data_content.close()
    control_content.close()

    debian_binary_stream = _sio('2.0\n')
    add_to_tar(ipk_fobj, './debian-binary', debian_binary_stream)
    debian_binary_stream.close()

    ipk_fobj.close()


if __name__ == '__main__':
    # change to script directory
    if getattr(sys, 'frozen', False):
        _wd = os.path.dirname(os.path.realpath(sys.executable))
    else:
        _wd = sys.path[0]
    os.chdir(_wd)
    
    ins = fast_d1ck()
    
    try:
        if os.path.exists(account_file_plain):
            uid, pwd = open(account_file_plain).read().strip().split(',')
            ins.run(uid, pwd)
        elif os.path.exists(account_session):
            with open(account_session) as f:
                session = json.loads(f.readline())
                ins.xl_login_payload = json.loads(f.readline())
            ins.load_xl(session)
            ins.run(ins.xl_login_payload['userName'], ins.xl_login_payload['passWord'])
        elif 'XUNLEI_UID' in os.environ and 'XUNLEI_PASSWD' in os.environ:
            uid = os.environ['XUNLEI_UID']
            pwd = os.environ['XUNLEI_PASSWD']
            ins.run(uid, pwd)
        else:
            _real_print('Please use XUNLEI_UID=<uid>/XUNLEI_PASSWD=<pass> envrionment varibles or create config file "%s", input account splitting with comma(,). Eg:\nyonghuming,mima' % account_file_plain)
    except KeyboardInterrupt:
        pass