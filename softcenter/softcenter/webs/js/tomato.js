/*
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

For use with Tomato Firmware only.
No part of this file may be used without permission.
*/
Array.prototype.find = function(v) {
for (var i = 0; i < this.length; ++i) if (this[i] == v) return i;
return - 1;
}
Array.prototype.remove = function(v) {
for (var i = 0; i < this.length; ++i) {
if (this[i] == v) {
this.splice(i, 1);
return true;
}
}
return false;
}
String.prototype.trim = function() {
return this.replace(/^\s+/, '').replace(/\s+$/, '');
}
Number.prototype.pad = function(min) {
var s = this.toString();
while (s.length < min) s = '0' + s;
return s;
}
Number.prototype.hex = function(min) {
var h = '0123456789ABCDEF';
var n = this;
var s = '';
do {
s = h.charAt(n & 15) + s;
n = n >>> 4;
} while ((-- min > 0 ) || (n > 0));
return s;
}
var elem = {
getOffset: function(e) {
var r = {
x: 0,
y: 0
};
e = E(e);
while (e.offsetParent) {
r.x += e.offsetLeft;
r.y += e.offsetTop;
e = e.offsetParent;
}
return r;
},
addClass: function(e, name) {
if ((e = E(e)) == null) return;
var a = e.className.split(/\s+/);
var k = 0;
for (var i = 1; i < arguments.length; ++i) {
if (a.find(arguments[i]) == -1) {
a.push(arguments[i]);
k = 1;
}
}
if (k) e.className = a.join(' ');
},
removeClass: function(e, name) {
if ((e = E(e)) == null) return;
var a = e.className.split(/\s+/);
var k = 0;
for (var i = 1; i < arguments.length; ++i) k |= a.remove(arguments[i]);
if (k) e.className = a.join(' ');
},
remove: function(e) {
if ((e = E(e)) != null) e.parentNode.removeChild(e);
},
parentElem: function(e, tagName) {
e = E(e);
tagName = tagName.toUpperCase();
while (e.parentNode) {
e = e.parentNode;
if (e.tagName == tagName) return e;
}
return null;
},
display: function() {
var enable = arguments[arguments.length - 1];
for (var i = 0; i < arguments.length - 1; ++i) {
E(arguments[i]).style.display = enable ? '': 'none';
}
},
isVisible: function(e) {
e = E(e);
while (e) {
if ((e.style.visibility != 'visible') || (e.style.display == 'none')) return false;
e = e.parentNode;
}
return true;
},
setInnerHTML: function(e, html) {
e = E(e);
if (e.innerHTML != html) e.innerHTML = html; // reduce flickering
}
};
var docu = {
getViewSize: function() {
if (window.innerHeight) {
return {
width: window.innerWidth,
height: window.innerHeight
};
} else if (document.documentElement && document.documentElement.clientHeight) {
return {
width: document.documentElement.clientWidth,
height: document.documentElement.clientHeight
};
}
return {
width: document.body.clientWidth,
height: document.body.clientHeight
};
},
getPageOffset: function() {
if (typeof(window.pageYOffset) != 'undefined') {
return {
x: window.pageXOffset,
y: window.pageYOffset
};
} else if ((document.documentElement) && (typeof(document.documentElement.scrollTop) != 'undefined')) {
return {
x: document.documentElement.scrollLeft,
y: document.documentElement.scrollTop
};
}
return {
x: document.body.scrollLeft,
y: document.body.scrollTop
};
}
};
var fields = {
getAll: function(e) {
var a = [];
switch (e.tagName) {
case 'INPUT':
case 'SELECT':
a.push(e);
break;
default:
if (e.childNodes) {
for (var i = 0; i < e.childNodes.length; ++i) {
a = a.concat(fields.getAll(e.childNodes[i]));
}
}
}
return a;
},
disableAll: function(e, d) {
var i;
if (e == null) {
return false;
}
if ((typeof(e.tagName) == 'undefined') && (typeof(e) != 'string')) {
for (i = e.length - 1; i >= 0; --i) {
e[i].disabled = d;
}
} else {
var a = this.getAll(E(e));
for (var i = a.length - 1; i >= 0; --i) {
a[i].disabled = d;
}
}
},
radio: {
selected: function(e) {
for (var i = 0; i < e.length; ++i) {
if (e[i].checked) return e[i];
}
return null;
},
find: function(e, value) {
for (var i = 0; i < e.length; ++i) {
if (e[i].value == value) return e[i];
}
return null;
}
}
};
var form = {
submitHidden: function(url, fields) {
var fom, body;
fom = document.createElement('FORM');
fom.action = url;
fom.method = 'post';
for (var f in fields) {
var e = document.createElement('INPUT');
e.type = 'hidden';
e.name = f;
e.value = fields[f];
fom.appendChild(e);
}
body = document.getElementsByTagName('body')[0];
fom = body.appendChild(fom);
this.submit(fom);
body.removeChild(fom);
},
submit: function(fom, async, url) {
var e, v, f, i, wait, msg, sb, cb;
fom = E(fom);
if (isLocal()) {
this.dump(fom, async, url);
return;
}
if (this.xhttp) return;
if ((sb = E('save-button')) != null) sb.disabled = 1;
if ((cb = E('cancel-button')) != null) cb.disabled = 1;
if ((!async) || (!useAjax())) {
this.addId(fom);
if (url) fom.action = url;
fom.submit();
return;
}
v = ['_ajax=1'];
wait = 5;
for (var i = 0; i < fom.elements.length; ++i) {
f = fom.elements[i];
/* IE Bugfix */
if (typeof(f) == 'undefined' || (typeof(f.name) == 'undefined')) {
continue;
}
if ((f.disabled) || (f.name == '') || (f.name.substr(0, 2) == 'f_')) continue;
if ((f.tagName == 'INPUT') && ((f.type == 'CHECKBOX') || (f.type == 'RADIO')) && (!f.checked)) continue;
if (f.name == '_nextwait') {
wait = f.value * 1;
if (isNaN(wait)) wait = 5;
else wait = Math.abs(wait);
}
v.push(escapeCGI(f.name) + '=' + escapeCGI(f.value));
}
if ((msg = E('footer-msg')) != null) {
msg.innerHTML = '保存中...';
msg.style.visibility = 'visible';
}
this.xhttp = new XmlHttp();
this.xhttp.onCompleted = function(text, xml) {
if (msg) {
if (text.match(/@msg:(.+)/)) msg.innerHTML = escapeHTML(RegExp.$1);
else msg.innerHTML = '已保存';
}
setTimeout(function() {
if (sb) sb.disabled = 0;
if (cb) cb.disabled = 0;
if (msg) msg.style.visibility = 'hidden';
if (typeof(submit_complete) != 'undefined') submit_complete();
},
wait * 1100);
form.xhttp = null;
}
this.xhttp.onError = function(x) {
if (url) fom.action = url;
fom.submit();
}
this.xhttp.post(url ? url: fom.action, v.join('&'));
},
addId: function(fom) {
var e;
if (typeof(fom._http_id) == 'undefined') {
e = document.createElement('INPUT');
e.type = 'hidden';
e.name = '_http_id';
e.value = nvram.http_id;
fom.appendChild(e);
} else {
fom._http_id.value = nvram.http_id;
}
},
addIdAction: function(fom) {
if (fom.action.indexOf('?') != -1) fom.action += '&_http_id=' + nvram.http_id;
else fom.action += '?_http_id=' + nvram.http_id;
},
dump: function(fom, async, url) {}
};
var ferror = {
set: function(e, message, quiet) {
if ((e = E(e)) == null) return;
e._error_msg = message;
e._error_org = e.title;
e.title = message;
elem.addClass(e, 'error');
if (!quiet) this.show(e);
},
clear: function(e) {
if ((e = E(e)) == null) return;
e.title = e._error_org || '';
elem.removeClass(e, 'error');
e._error_msg = null;
e._error_org = null;
},
clearAll: function(e) {
for (var i = 0; i < e.length; ++i) this.clear(e[i]);
},
show: function(e) {
if ((e = E(e)) == null) return;
if (!e._error_msg) return;
elem.addClass(e, 'error-focused');
e.focus();
alert(e._error_msg);
elem.removeClass(e, 'error-focused');
},
ok: function(e) {
if ((e = E(e)) == null) return 0;
return ! e._error_msg;
}
};
function fixFile(name) {
var i;
if (((i = name.lastIndexOf('/')) > 0) || ((i = name.lastIndexOf('\\')) > 0)) name = name.substring(i + 1, name.length);
return name;
}
function _v_range(e, quiet, min, max, name) {
if ((e = E(e)) == null) return 0;
var v = e.value;
if ((!v.match(/^ *[-\+]?\d+ *$/)) || (v < min) || (v > max)) {
ferror.set(e, '无效的 ' + name + '. 有效范围: ' + min + '-' + max, quiet);
return 0;
}
e.value = v * 1;
ferror.clear(e);
return 1;
}
function v_range(e, quiet, min, max) {
return _v_range(e, quiet, min, max, 'number');
}
function v_port(e, quiet) {
return _v_range(e, quiet, 1, 0xFFFF, 'port');
}
function v_octet(e, quiet) {
return _v_range(e, quiet, 1, 254, 'address');
}
function v_mins(e, quiet, min, max) {
var v, m;
if ((e = E(e)) == null) return 0;
if (e.value.match(/^\s*(.+?)([mhd])?\s*$/)) {
m = 1;
if (RegExp.$2 == 'h') m = 60;
else if (RegExp.$2 == 'd') m = 60 * 24;
v = Math.round(RegExp.$1 * m);
if (!isNaN(v)) {
e.value = v;
return _v_range(e, quiet, min, max, 'minutes');
}
}
ferror.set(e, '无效的分钟数。', quiet);
return 0;
}
function v_macip(e, quiet, bok, lan_ipaddr, lan_netmask) {
var s, a, b, c, d, i;
var ipp, temp;
temp = lan_ipaddr.split('.');
ipp = temp[0] + '.' + temp[1] + '.' + temp[2] + '.';
if ((e = E(e)) == null) return 0;
s = e.value.replace(/\s+/g, '');
if ((a = fixMAC(s)) != null) {
if (isMAC0(a)) {
if (bok) {
e.value = '';
} else {
ferror.set(e, '无效的MAC或IP地址。');
return false;
}
} else e.value = a;
ferror.clear(e);
return true;
}
a = s.split('-');
if (a.length > 2) {
ferror.set(e, '无效的IP地址范围。', quiet);
return false;
}
if (a[0].match(/^\d+$/)) {
a[0] = ipp + a[0];
if ((a.length == 2) && (a[1].match(/^\d+$/))) a[1] = ipp + a[1];
} else {
if ((a.length == 2) && (a[1].match(/^\d+$/))) {
temp = a[0].split('.');
a[1] = temp[0] + '.' + temp[1] + '.' + temp[2] + '.' + a[1];
}
}
for (i = 0; i < a.length; ++i) {
b = a[i];
b = fixIP(b);
if (!b) {
ferror.set(e, '无效的IP地址。', quiet);
return false;
}
if ((aton(b) & aton(lan_netmask)) != (aton(lan_ipaddr) & aton(lan_netmask))) {
ferror.set(e, '必须是LAN外的IP地址。', quiet);
return false;
}
d = (b.split('.'))[3];
if (parseInt(d) <= parseInt(c)) {
ferror.set(e, '无效的IP地址范围。', quiet);
return false;
}
a[i] = c = d;
}
e.value = b.split('.')[0] + '.' + b.split('.')[1] + '.' + b.split('.')[2] + '.' + a.join('-');
return true;
}
function fixIP(ip, x) {
var a, n, i;
a = ip;
i = a.indexOf("<br>");
if (i > 0) a = a.slice(0, i);
a = a.split('.');
if (a.length != 4) return null;
for (i = 0; i < 4; ++i) {
n = a[i] * 1;
if ((isNaN(n)) || (n < 0) || (n > 255)) return null;
a[i] = n;
}
if ((x) && ((a[3] == 0) || (a[3] == 255))) return null;
return a.join('.');
}
function v_ip(e, quiet, x) {
var ip;
if ((e = E(e)) == null) return 0;
ip = fixIP(e.value, x);
if (!ip) {
ferror.set(e, '无效的IP地址。', quiet);
return false;
}
e.value = ip;
ferror.clear(e);
return true;
}
function v_ipz(e, quiet) {
if ((e = E(e)) == null) return 0;
if (e.value == '') e.value = '0.0.0.0';
return v_ip(e, quiet);
}
function v_dns(e, quiet) {
if ((e = E(e)) == null) return 0;
if (e.value == '') {
e.value = '0.0.0.0';
} else {
var s = e.value.split(':');
if (s.length == 1) {
s.push(53);
} else if (s.length != 2) {
ferror.set(e, '无效的IP地址或端口。', quiet);
return false;
}
if ((s[0] = fixIP(s[0])) == null) {
ferror.set(e, '无效的IP地址。', quiet);
return false;
}
if ((s[1] = fixPort(s[1], -1)) == -1) {
ferror.set(e, '无效的端口。', quiet);
return false;
}
if (s[1] == 53) {
e.value = s[0];
} else {
e.value = s.join(':');
}
}
ferror.clear(e);
return true;
}
function aton(ip) {
var o, x, i;
o = ip.split('.');
x = '';
for (i = 0; i < 4; ++i) x += (o[i] * 1).hex(2);
return parseInt(x, 16);
}
function ntoa(ip) {
return ((ip >> 24) & 255) + '.' + ((ip >> 16) & 255) + '.' + ((ip >> 8) & 255) + '.' + (ip & 255);
}
function _v_iptip(e, ip, quiet) {
var ma, x, y, z, oip;
var a, b;
oip = ip;
// x.x.x.x - y.y.y.y
if (ip.match(/^(.*)-(.*)$/)) {
a = fixIP(RegExp.$1);
b = fixIP(RegExp.$2);
if ((a == null) || (b == null)) {
ferror.set(e, oip + ' - 无效的IP地址范围。', quiet);
return null;
}
ferror.clear(e);
if (aton(a) > aton(b)) return b + '-' + a;
return a + '-' + b;
}
ma = '';
// x.x.x.x/nn
// x.x.x.x/y.y.y.y
if (ip.match(/^(.*)\/(.*)$/)) {
ip = RegExp.$1;
b = RegExp.$2;
ma = b * 1;
if (isNaN(ma)) {
ma = fixIP(b);
if ((ma == null) || (!_v_netmask(ma))) {
ferror.set(e, oip + ' - 无效的网络掩码。', quiet);
return null;
}
} else {
if ((ma < 0) || (ma > 32)) {
ferror.set(e, oip + ' - 无效的网络掩码。', quiet);
return null;
}
}
}
ip = fixIP(ip);
if (!ip) {
ferror.set(e, oip + ' - 无效的IP地址。', quiet);
return null;
}
ferror.clear(e);
return ip + ((ma != '') ? ('/' + ma) : '');
}
function v_iptip(e, quiet, multi) {
var v, i;
if ((e = E(e)) == null) return 0;
v = e.value.split(',');
if (multi) {
if (v.length > multi) {
ferror.set(e, 'IP地址过多。', quiet);
return 0;
}
} else {
if (v.length > 1) {
ferror.set(e, '无效的IP地址。', quiet);
return 0;
}
}
for (i = 0; i < v.length; ++i) {
if ((v[i] = _v_iptip(e, v[i], quiet)) == null) return 0;
}
e.value = v.join(', ');
return 1;
}
function _v_subnet(e, ip, quiet) {
var ma, oip;
oip = ip;
// x.x.x.x/nn
if (ip.match(/^(.*)\/(.*)$/)) {
ip = RegExp.$1;
ma = RegExp.$2;
if ((ma < 0) || (ma > 32)) {
ferror.set(e, oip + ' - 无效的子网。', quiet);
return null;
}
} else {
ferror.set(e, oip + ' - 无效的子网。', quiet);
return null;
}
ferror.clear(e);
return ip + ((ma != '') ? ('/' + ma) : '');
}
function v_subnet(e, quiet) {
if ((_v_subnet(e, e.value, quiet)) == null) return 0;
return 1;
}
function _v_domain(e, dom, quiet) {
var s;
s = dom.replace(/\s+/g, ' ').trim();
if (s.length > 0) {
s = _v_hostname(e, s, 1, 1, 7, '.', true);
if (s == null) {
ferror.set(e, "名称无效。 只允许使用字符 \"A-Z 0-9 . -\" 。", quiet);
return null;
}
}
ferror.clear(e);
return s;
}
function v_domain(e, quiet) {
var v;
if ((e = E(e)) == null) return 0;
if ((v = _v_domain(e, e.value, quiet)) == null) return 0;
e.value = v;
return 1;
}
function ExpandIPv6Address(ip) {
var a, pre, n, i, fill, post;
ip = ip.toLowerCase();
if (!ip.match(/^(::)?([a-f0-9]{1,4}::?){0,7}([a-f0-9]{1,4})(::)?$/)) return null;
a = ip.split('::');
switch (a.length) {
case 1:
if (a[0] == '') return null;
pre = a[0].split(':');
if (pre.length != 8) return null;
ip = pre.join(':');
break;
case 2:
pre = a[0].split(':');
post = a[1].split(':');
n = 8 - pre.length - post.length;
for (i = 0; i < 2; i++) {
if (a[i] == '') n++;
}
if (n < 0) return null;
fill = '';
while (n-->0) fill += ':0';
ip = pre.join(':') + fill + ':' + post.join(':');
ip = ip.replace(/^:/, '').replace(/:$/, '');
break;
default:
return null;
}
ip = ip.replace(/([a-f0-9]{1,4})/ig, '000$1');
ip = ip.replace(/0{0,3}([a-f0-9]{4})/ig, '$1');
return ip;
}
function CompressIPv6Address(ip) {
var a, segments;
ip = ExpandIPv6Address(ip);
if (!ip) return null;
// if (ip.match(/(?:^00)|(?:^fe[8-9a-b])|(?:^ff)/)) return null; // not valid routable unicast address
ip = ip.replace(/(^|:)0{1,3}/g, '$1');
ip = ip.replace(/(:0)+$/, '::');
ip = ip.replace(/(?:(?:^|:)0){2,}(?!.*(?:::|(?::0){3,}))/, ':');
return ip;
}
function ZeroIPv6PrefixBits(ip, prefix_length) {
var b, c, m, n;
ip = ExpandIPv6Address(ip);
ip = ip.replace(/:/g, '');
n = Math.floor(prefix_length / 4);
m = 32 - Math.ceil(prefix_length / 4);
b = prefix_length % 4;
if (b != 0) c = (parseInt(ip.charAt(n), 16) & (0xf << 4 - b)).toString(16);
else c = '';
ip = ip.substring(0, n) + c + Array((m % 4) + 1).join('0') + (m >= 4 ? '::': '');
ip = ip.replace(/([a-f0-9]{4})(?=[a-f0-9])/g, '$1:');
ip = ip.replace(/(^|:)0{1,3}/g, '$1');
return ip;
}
function ipv6ton(ip) {
var o, x, i;
ip = ExpandIPv6Address(ip);
if (!ip) return 0;
o = ip.split(':');
x = '';
for (i = 0; i < 8; ++i) x += (('0x' + o[i]) * 1).hex(4);
return parseInt(x, 16);
}
function _v_ipv6_addr(e, ip, ipt, quiet) {
var oip;
var a, b;
oip = ip;
// ip range
if ((ipt) && ip.match(/^(.*)-(.*)$/)) {
a = RegExp.$1;
b = RegExp.$2;
a = CompressIPv6Address(a);
b = CompressIPv6Address(b);
if ((a == null) || (b == null)) {
ferror.set(e, oip + ' - 无效的IPv6地址范围。', quiet);
return null;
}
ferror.clear(e);
if (ipv6ton(a) > ipv6ton(b)) return b + '-' + a;
return a + '-' + b;
}
if ((ipt) && ip.match(/^([A-Fa-f0-9:]+)\/(\d+)$/)) {
a = RegExp.$1;
b = parseInt(RegExp.$2, 10);
a = ExpandIPv6Address(a);
if ((a == null) || (b == null)) {
ferror.set(e, oip + ' - 无效的IPv6地址。', quiet);
return null;
}
if (b < 0 || b > 128) {
ferror.set(e, oip + ' - IPv6地址上的无效CIDR符号。', quiet);
return null;
}
ferror.clear(e);
ip = ZeroIPv6PrefixBits(a, b);
return ip + '/' + b.toString(10);
}
ip = CompressIPv6Address(oip);
if (!ip) {
ferror.set(e, oip + ' - 无效的IPv6地址。', quiet);
return null;
}
ferror.clear(e);
return ip;
}
function v_ipv6_addr(e, quiet) {
if ((e = E(e)) == null) return 0;
ip = _v_ipv6_addr(e, e.value, false, quiet);
if (ip) e.value = ip;
return (ip != null);
}
function fixPort(p, def) {
if (def == null) def = -1;
if (p == null) return def;
p *= 1;
if ((isNaN(p) || (p < 1) || (p > 65535) || (('' + p).indexOf('.') != -1))) return def;
return p;
}
function _v_portrange(e, quiet, v) {
if (v.match(/^(.*)[-:](.*)$/)) {
var x = RegExp.$1;
var y = RegExp.$2;
x = fixPort(x, -1);
y = fixPort(y, -1);
if ((x == -1) || (y == -1)) {
ferror.set(e, '无效的端口范围: ' + v, quiet);
return null;
}
if (x > y) {
v = x;
x = y;
y = v;
}
ferror.clear(e);
if (x == y) return x;
return x + '-' + y;
}
v = fixPort(v, -1);
if (v == -1) {
ferror.set(e, '无效的端口', quiet);
return null;
}
ferror.clear(e);
return v;
}
function v_portrange(e, quiet) {
var v;
if ((e = E(e)) == null) return 0;
v = _v_portrange(e, quiet, e.value);
if (v == null) return 0;
e.value = v;
return 1;
}
function v_iptport(e, quiet) {
var a, i, v, q;
if ((e = E(e)) == null) return 0;
a = e.value.split(/[,\.]/);
if (a.length == 0) {
ferror.set(e, '期望的端口或端口的范围。', quiet);
return 0;
}
if (a.length > 10) {
ferror.set(e, '只允许10个端口或端口范围。', quiet);
return 0;
}
q = [];
for (i = 0; i < a.length; ++i) {
v = _v_portrange(e, quiet, a[i]);
if (v == null) return 0;
q.push(v);
}
e.value = q.join(',');
ferror.clear(e);
return 1;
}
function _v_netmask(mask) {
var v = aton(mask) ^ 0xFFFFFFFF;
return (((v + 1) & v) == 0);
}
function v_netmask(e, quiet) {
var n, b;
if ((e = E(e)) == null) return 0;
n = fixIP(e.value);
if (n) {
if (_v_netmask(n)) {
e.value = n;
ferror.clear(e);
return 1;
}
} else if (e.value.match(/^\s*\/\s*(\d+)\s*$/)) {
b = RegExp.$1 * 1;
if ((b >= 1) && (b <= 32)) {
if (b == 32) n = 0xFFFFFFFF; // js quirk
else n = (0xFFFFFFFF >>> b) ^ 0xFFFFFFFF;
e.value = (n >>> 24) + '.' + ((n >>> 16) & 0xFF) + '.' + ((n >>> 8) & 0xFF) + '.' + (n & 0xFF);
ferror.clear(e);
return 1;
}
}
ferror.set(e, '网络掩码无效。', quiet);
return 0;
}
function fixMAC(mac) {
var t, i;
mac = mac.replace(/\s+/g, '').toUpperCase();
if (mac.length == 0) {
mac = [0, 0, 0, 0, 0, 0];
} else if (mac.length == 12) {
mac = mac.match(/../g);
} else {
mac = mac.split(/[:\-]/);
if (mac.length != 6) return null;
}
for (i = 0; i < 6; ++i) {
t = '' + mac[i];
if (t.search(/^[0-9A-F]+$/) == -1) return null;
if ((t = parseInt(t, 16)) > 255) return null;
mac[i] = t.hex(2);
}
return mac.join(':');
}
function v_mac(e, quiet) {
var mac;
if ((e = E(e)) == null) return 0;
mac = fixMAC(e.value);
if ((!mac) || (isMAC0(mac))) {
ferror.set(e, '无效的MAC地址。', quiet);
return 0;
}
e.value = mac;
ferror.clear(e);
return 1;
}
function v_macz(e, quiet) {
var mac;
if ((e = E(e)) == null) return 0;
mac = fixMAC(e.value);
if (!mac) {
ferror.set(e, '无效的MAC地址。', quiet);
return false;
}
e.value = mac;
ferror.clear(e);
return true;
}
function v_length(e, quiet, min, max) {
var s, n;
if ((e = E(e)) == null) return 0;
s = e.value.trim();
n = s.length;
if (min == undefined) min = 1;
if (n < min) {
ferror.set(e, '长度无效. 请至少输入 ' + min + ' 个字符。', quiet);
return 0;
}
max = max || e.maxlength;
if (n > max) {
ferror.set(e, '长度无效。 请将长度减小到 ' + max + ' 个字符或更少。', quiet);
return 0;
}
e.value = s;
ferror.clear(e);
return 1;
}
function _v_iptaddr(e, quiet, multi, ipv4, ipv6) {
var v, t, i;
if ((e = E(e)) == null) return 0;
v = e.value.split(',');
if (multi) {
if (v.length > multi) {
ferror.set(e, '地址过多。', quiet);
return 0;
}
} else {
if (v.length > 1) {
ferror.set(e, '无效的域名或IP地址。', quiet);
return 0;
}
}
for (i = 0; i < v.length; ++i) {
if ((t = _v_domain(e, v[i], 1)) == null) {
if ((!ipv6) && (!ipv4)) {
if (!quiet) ferror.show(e);
return 0;
}
if ((!ipv6) || ((t = _v_ipv6_addr(e, v[i], 1, 1)) == null)) {
if (!ipv4) {
if (!quiet) ferror.show(e);
return 0;
}
if ((t = _v_iptip(e, v[i], 1)) == null) {
ferror.set(e, e._error_msg + ', 或无效的域名。', quiet);
return 0;
}
}
}
v[i] = t;
}
e.value = v.join(', ');
ferror.clear(e);
return 1;
}
function v_iptaddr(e, quiet, multi) {
return _v_iptaddr(e, quiet, multi, 1, 0);
}
function _v_hostname(e, h, quiet, required, multi, delim, cidr) {
var s;
var v, i;
var re;
v = (typeof(delim) == 'undefined') ? h.split(/\s+/) : h.split(delim);
if (multi) {
if (v.length > multi) {
ferror.set(e, '主机名过长。', quiet);
return null;
}
} else {
if (v.length > 1) {
ferror.set(e, '无效的主机名。', quiet);
return null;
}
}
re = /^[a-zA-Z0-9](([a-zA-Z0-9\-]{0,61})[a-zA-Z0-9]){0,1}$/;
for (i = 0; i < v.length; ++i) {
s = v[i].replace(/_+/g, '-').replace(/\s+/g, '-');
if (s.length > 0) {
if (cidr && i == v.length - 1) re = /^[a-zA-Z0-9](([a-zA-Z0-9\-]{0,61})[a-zA-Z0-9]){0,1}(\/\d{1,3})?$/;
if (s.search(re) == -1 || s.search(/^\d+$/) != -1) {
ferror.set(e, '无效的主机名。只能 "A-Z 0-9" 并且 "-" 只能在2个字符中间 (最多63个字符)。', quiet);
return null;
}
} else if (required) {
ferror.set(e, '无效的主机名。', quiet);
return null;
}
v[i] = s;
}
ferror.clear(e);
return v.join((typeof(delim) == 'undefined') ? ' ': delim);
}
function v_hostname(e, quiet, multi, delim) {
var v;
if ((e = E(e)) == null) return 0;
v = _v_hostname(e, e.value, quiet, 0, multi, delim, false);
if (v == null) return 0;
e.value = v;
return 1;
}
function v_nodelim(e, quiet, name, checklist) {
if ((e = E(e)) == null) return 0;
e.value = e.value.trim();
if (e.value.indexOf('<') != -1 || (checklist && e.value.indexOf('>') != -1)) {
ferror.set(e, '无效的 ' + name + ': \"<\" ' + (checklist ? '或 \">\" 是': '是') + ' 不允许的。', quiet);
return 0;
}
ferror.clear(e);
return 1;
}
function v_path(e, quiet, required) {
if ((e = E(e)) == null) return 0;
if (required && !v_length(e, quiet, 1)) return 0;
if (!required && e.value.trim().length == 0) {
ferror.clear(e);
return 1;
}
if (e.value.substr(0, 1) != '/') {
ferror.set(e, '请从 /root 目录开始。', quiet);
return 0;
}
ferror.clear(e);
return 1;
}
function isMAC0(mac) {
return (mac == '00:00:00:00:00:00');
}
function cmpIP(a, b) {
if ((a = fixIP(a)) == null) a = '255.255.255.255';
if ((b = fixIP(b)) == null) b = '255.255.255.255';
return aton(a) - aton(b);
}
/**
*
* @param a		Text1
* @param b		Text2
* @returns		-1 if a < b
* 				 0 if a = b
* 				 1 if a > b
*
*/
function cmpText(a, b) {
if (a == '') a = '\xff';
if (b == '') b = '\xff';
return (a < b) ? -1 : ((a > b) ? 1 : 0);
}
function cmpInt(a, b) {
a = parseInt(a, 10);
b = parseInt(b, 10);
return ((isNaN(a)) ? -0x7FFFFFFF: a) - ((isNaN(b)) ? -0x7FFFFFFF: b);
}
function cmpFloat(a, b) {
a = parseFloat(a);
b = parseFloat(b);
return ((isNaN(a)) ? -Number.MAX_VALUE: a) - ((isNaN(b)) ? -Number.MAX_VALUE: b);
}
function cmpDate(a, b) {
return b.getTime() - a.getTime();
}
function TGO(e) {
return elem.parentElem(e, 'TABLE').gridObj;
}
function tgHideIcons() {
var e;
while ((e = document.getElementById('table-row-panel')) != null) e.parentNode.removeChild(e);
}
function TomatoGrid(tb, options, maxAdd, editorFields) {
this.init(tb, options, maxAdd, editorFields);
return this;
}
TomatoGrid.prototype = {
init: function(tb, options, maxAdd, editorFields) {
if (tb) {
this.tb = E(tb);
this.tb.gridObj = this;
} else {
this.tb = null;
}
if (!options) options = '';
this.header = null;
this.footer = null;
this.editor = null;
this.canSort = options.indexOf('sort') != -1;
this.canMove = options.indexOf('move') != -1;
this.maxAdd = maxAdd || 500;
this.canEdit = (editorFields != null);
this.canDelete = this.canEdit || (options.indexOf('delete') != -1);
this.editorFields = editorFields;
this.sortColumn = -1;
this.sortAscending = true;
},
_insert: function(at, cells, escCells, header) {
var tr, td, c;
var i, t;
tr = this.tb.insertRow(at);
for (i = 0; i < cells.length; ++i) {
c = cells[i];
if (typeof(c) == 'string') {
td = tr.insertCell(i);
td.className = ((header === true) ? 'header ': '') + 'co' + (i + 1);
if (escCells) td.appendChild(document.createTextNode(c));
else td.innerHTML = c;
} else {
tr.appendChild(c);
}
}
return tr;
},
headerClick: function(cell) {
if (this.canSort) {
this.sort(cell.cellN);
}
},
headerSet: function(cells, escCells) {
var e, i;
elem.remove(this.header);
this.header = e = this._insert(0, cells, escCells, true);
for (i = 0; i < e.cells.length; ++i) {
e.cells[i].cellN = i; // cellIndex broken in Safari
e.cells[i].onclick = function() {
return TGO(this).headerClick(this);
};
}
return e;
},
footerClick: function(cell) {},
footerSet: function(cells, escCells) {
var e, i;
elem.remove(this.footer);
this.footer = e = this._insert( - 1, cells, escCells);
e.className = 'bold controls';
for (i = 0; i < e.cells.length; ++i) {
e.cells[i].cellN = i;
e.cells[i].onclick = function() {
TGO(this).footerClick(this)
};
}
return e;
},
rpUp: function(e) {
var i;
e = PR(e);
TGO(e).moving = null;
i = e.previousSibling;
if (i == this.header) return;
e.parentNode.removeChild(e);
i.parentNode.insertBefore(e, i);
this.recolor();
this.rpHide();
},
rpDn: function(e) {
var i;
e = PR(e);
TGO(e).moving = null;
i = e.nextSibling;
if (i == this.footer) return;
e.parentNode.removeChild(e);
i.parentNode.insertBefore(e, i.nextSibling);
this.recolor();
this.rpHide();
},
rpMo: function(img, e) {
var me;
e = PR(e);
me = TGO(e);
if (me.moving == e) {
me.moving = null;
this.rpHide();
return;
}
me.moving = e;
img.style.border = "1px dotted red";
},
rpDel: function(e) {
e = PR(e);
TGO(e).moving = null;
e.parentNode.removeChild(e);
this.recolor();
this.rpHide();
},
rpMouIn: function(evt) {
var e, x, ofs, me, s, n;
if ((evt = checkEvent(evt)) == null || evt.target.nodeName == 'A' || evt.target.nodeName == 'I') return;
me = TGO(evt.target);
if (me.isEditing()) return;
if (me.moving) return;
if (evt.target.id != 'table-row-panel') {
me.rpHide();
}
e = document.createElement('div');
e.tgo = me;
e.ref = evt.target;
e.setAttribute('id', 'table-row-panel');
n = 0;
s = '';
if (me.canMove) {
s = '<a class="move-up-row" href="#" onclick="this.parentNode.tgo.rpUp(this.parentNode.ref); return false;" title="上移"><i class="icon-chevron-up"></i></a> \
<a class="move-down-row" href="#" onclick="this.parentNode.tgo.rpDn(this.parentNode.ref); return false;" title="下移"><i class="icon-chevron-down"></i></a> \
<a class="move-row" href="#" onclick="this.parentNode.tgo.rpMo(this,this.parentNode.ref); return false;" title="移动"><i class="icon-move"></i></a> ';
n += 3;
}
if (me.canDelete) {
s += '<a class="delete-row" href="#" onclick="this.parentNode.tgo.rpDel(this.parentNode.ref); return false;" title="删除"><i class="icon-cancel"></i></a>'; ++n;
}
x = PR(evt.target);
x = x.cells[x.cells.length - 1];
ofs = elem.getOffset(x);
n *= 18;
e.innerHTML = s;
this.appendChild(e);
},
rpHide: tgHideIcons,
onClick: function(cell) {
if (this.canEdit) {
if (this.moving) {
var p = this.moving.parentNode;
var q = PR(cell);
if (this.moving != q) {
var v = this.moving.rowIndex > q.rowIndex;
p.removeChild(this.moving);
if (v) p.insertBefore(this.moving, q);
else p.insertBefore(this.moving, q.nextSibling);
this.recolor();
}
this.moving = null;
this.rpHide();
return;
}
this.edit(cell);
}
},
insert: function(at, data, cells, escCells) {
var e, i;
if ((this.footer) && (at == -1)) at = this.footer.rowIndex;
e = this._insert(at, cells, escCells);
e.className = (e.rowIndex & 1) ? 'even': 'odd';
for (i = 0; i < e.cells.length; ++i) {
e.cells[i].onclick = function() {
return TGO(this).onClick(this);
};
}
e._data = data;
e.getRowData = function() {
return this._data;
}
e.setRowData = function(data) {
this._data = data;
}
if ((this.canMove) || (this.canEdit) || (this.canDelete)) {
e.onmouseover = this.rpMouIn;
e.onmouseout = this.rpMouOut;
if (this.canEdit) e.title = '点击编辑';
$(e).css('cursor', 'text');
}
return e;
},
insertData: function(at, data) {
return this.insert(at, data, this.dataToView(data), false);
},
dataToView: function(data) {
var v = [];
for (var i = 0; i < data.length; ++i) {
var s = escapeHTML('' + data[i]);
if (this.editorFields && this.editorFields.length > i) {
var ef = this.editorFields[i].multi;
if (!ef) ef = [this.editorFields[i]];
var f = (ef && ef.length > 0 ? ef[0] : null);
if (f && f.type == 'password') {
if (!f.peekaboo || get_config('web_pb', '1') != '0') s = s.replace(/./g, '&#x25CF;');
}
}
v.push(s);
}
return v;
},
dataToFieldValues: function(data) {
return data;
},
fieldValuesToData: function(row) {
var e, i, data;
data = [];
e = fields.getAll(row);
for (i = 0; i < e.length; ++i) data.push(e[i].value);
return data;
},
edit: function(cell) {
var sr, er, e, c;
if (this.isEditing()) return;
sr = PR(cell);
sr.style.display = 'none';
elem.removeClass(sr, 'hover');
this.source = sr;
er = this.createEditor('edit', sr.rowIndex, sr);
er.className = 'editor';
this.editor = er;
c = er.cells[cell.cellIndex || 0];
e = c.getElementsByTagName('input');
if ((e) && (e.length > 0)) {
try { // IE quirk
e[0].focus();
} catch(ex) {}
}
this.controls = this.createControls('edit', sr.rowIndex);
this.disableNewEditor(true);
this.rpHide();
this.verifyFields(this.editor, true);
},
createEditor: function(which, rowIndex, source) {
var values;
if (which == 'edit') values = this.dataToFieldValues(source.getRowData());
var row = this.tb.insertRow(rowIndex);
row.className = 'editor';
var common = ' onkeypress="return TGO(this).onKey(\'' + which + '\', event)" onchange="TGO(this).onChange(\'' + which + '\', this)"';
var vi = 0;
for (var i = 0; i < this.editorFields.length; ++i) {
var s = '';
var ef = this.editorFields[i].multi;
if (!ef) ef = [this.editorFields[i]];
for (var j = 0; j < ef.length; ++j) {
var f = ef[j];
if (f.prefix) s += f.prefix;
var attrib = ' class="fi' + (vi + 1) + ' ' + (f['class'] ? f['class'] : '') + '" ' + (f.attrib || '');
var id = (this.tb ? ('_' + this.tb + '_' + (vi + 1)) : null);
if (id) attrib += ' id="' + id + '"';
switch (f.type) {
case 'password':
if (f.peekaboo) {
switch (get_config('web_pb', '1')) {
case '0':
f.type = 'text';
case '2':
f.peekaboo = 0;
break;
}
}
attrib += ' autocomplete="off"';
if (f.peekaboo && id) attrib += ' onfocus=\'peekaboo("' + id + '",1)\'';
// drop
case 'text':
s += '<input type="' + f.type + '" maxlength=' + f.maxlen + common + attrib;
if (which == 'edit') s += ' value="' + escapeHTML('' + values[vi]) + '">';
else s += '>';
break;
case 'select':
s += '<select' + common + attrib + '>';
for (var k = 0; k < f.options.length; ++k) {
a = f.options[k];
if (which == 'edit') {
s += '<option value="' + a[0] + '"' + ((a[0] == values[vi]) ? ' selected>': '>') + a[1] + '</option>';
} else {
s += '<option value="' + a[0] + '">' + a[1] + '</option>';
}
}
s += '</select>';
break;
case 'checkbox':
s += '<div class="checkbox c-checkbox"><label><input type="checkbox"' + common + attrib;
if ((which == 'edit') && (values[vi])) s += ' checked';
s += '><span></span> </label></div>';
break;
case 'textarea':
if (which == 'edit') {
document.getElementById(f.proxy).value = values[vi];
}
break;
default:
s += f.custom.replace(/\$which\$/g, which);
}
if (f.suffix) s += f.suffix;
++vi;
}
var c = row.insertCell(i);
c.innerHTML = s;
// Added verticalAlignment, this fixes the incorrect vertical positioning of inputs in the editorRow
if (this.editorFields[i].vtop) {
c.vAlign = 'top';
c.style.verticalAlign = "top";
}
}
return row;
},
createControls: function(which, rowIndex) {
var r, c;
r = this.tb.insertRow(rowIndex);
r.className = 'controls';
c = r.insertCell(0);
c.colSpan = this.header.cells.length;
if (which == 'edit') {
c.innerHTML = '<button type="button" class="btn btn-danger" value="Delete" onclick="TGO(this).onDelete()">删除 <i class="icon-cancel"></i></button> ' + '<button type="button" class="btn" value="Cancel" onclick="TGO(this).onCancel()">取消 <i class="icon-disable"></i></button> ' + '<button type="button" class="btn btn-primary" value="OK" onclick="TGO(this).onOK()">确定 <i class="icon-check"></i></button>';
} else {
c.innerHTML = '<button type="button" class="btn btn-danger" value="Add" onclick="TGO(this).onAdd()">添加 <i class="icon-plus"></i></button>';
}
return r;
},
removeEditor: function() {
if (this.editor) {
elem.remove(this.editor);
this.editor = null;
}
if (this.controls) {
elem.remove(this.controls);
this.controls = null;
}
},
showSource: function() {
if (this.source) {
this.source.style.display = '';
this.source = null;
}
},
onChange: function(which, cell) {
return this.verifyFields((which == 'new') ? this.newEditor: this.editor, true);
},
onKey: function(which, ev) {
switch (ev.keyCode) {
case 27:
if (which == 'edit') this.onCancel();
return false;
case 13:
if (((ev.srcElement) && (ev.srcElement.tagName == 'SELECT')) || ((ev.target) && (ev.target.tagName == 'SELECT'))) return true;
if (which == 'edit') this.onOK();
else this.onAdd();
return false;
}
return true;
},
onDelete: function() {
this.removeEditor();
elem.remove(this.source);
this.source = null;
this.disableNewEditor(false);
},
onCancel: function() {
this.removeEditor();
this.showSource();
this.disableNewEditor(false);
},
onOK: function() {
var i, data, view;
if (!this.verifyFields(this.editor, false)) return;
data = this.fieldValuesToData(this.editor);
view = this.dataToView(data);
this.source.setRowData(data);
for (i = 0; i < this.source.cells.length; ++i) {
this.source.cells[i].innerHTML = view[i];
}
this.removeEditor();
this.showSource();
this.disableNewEditor(false);
},
onAdd: function() {
var data;
this.moving = null;
this.rpHide();
if (!this.verifyFields(this.newEditor, false)) return;
data = this.fieldValuesToData(this.newEditor);
this.insertData( - 1, data);
this.disableNewEditor(false);
this.resetNewEditor();
},
verifyFields: function(row, quiet) {
return true;
},
showNewEditor: function() {
var r;
r = this.createEditor('new', -1, null);
this.footer = this.newEditor = r;
r = this.createControls('new', -1);
this.newControls = r;
this.disableNewEditor(false);
},
disableNewEditor: function(disable) {
if (this.getDataCount() >= this.maxAdd) disable = true;
if (this.newEditor) fields.disableAll(this.newEditor, disable);
if (this.newControls) fields.disableAll(this.newControls, disable);
},
resetNewEditor: function() {
var i, e;
e = fields.getAll(this.newEditor);
ferror.clearAll(e);
for (i = 0; i < e.length; ++i) {
var f = e[i];
if (f.selectedIndex) f.selectedIndex = 0;
else f.value = '';
}
try {
if (e.length) e[0].focus();
} catch(er) {}
},
getDataCount: function() {
var n;
n = this.tb.rows.length;
if (this.footer) n = this.footer.rowIndex;
if (this.header) n -= this.header.rowIndex + 1;
return n;
},
/**
* @brief	Sortcompare function for rows of a datagrid
* @details	Because rows can't be compared, the function gets the
* 			columnindex of the column that has to be sorted.
* 			Than the columndata is compared. According to the sorting
* 			(Ascending, Descending) the resultvalue is negated.
*
* 			This function is often overiden for a specific grid.
*/
sortCompare: function(a, b) {
// Get the gridobject for the row that is being compared.
var obj = TGO(a);
// Get the columnindex for the column that will be sorted
var col = obj.sortColumn;
// Compute the compareValue for this column (in ascending mode)
var r = cmpText(a.cells[col].innerHTML, b.cells[col].innerHTML);
// Negate the return value if sorting is not Ascending
return obj.sortAscending ? r: -r;
},
/**
* @brief	Sort the table.
* @details	Sort function sets the table header accordingly and calls
* 			member function 'resort' on the gird.
*/
sort: function(column) {
if (this.editor) return;
if (this.sortColumn >= 0) {
$(this.header.cells[this.sortColumn]).find('i').remove();;
}
if (column == this.sortColumn) {
this.sortAscending = !this.sortAscending;
} else {
this.sortAscending = true;
this.sortColumn = column;
}
$(this.header.cells[column]).append(this.sortAscending ? '<i class="icon-chevron-up icon-sort"></i>': '<i class="icon-chevron-down icon-sort"></i>');
this.resort();
},
/**
* 	@brief: 	Do the actual sorting on the table.
*/
resort: function() {
// Return if there is no column set for sorting, if the grid is empty, or if the grid is being edited
if ((this.sortColumn < 0) || (this.getDataCount() == 0) || (this.editor)) return;
// Initialize variables
var p = this.header.parentNode;
var a = [];
var i, j, max, e, p;
var top;
// ?Stop the row moving state
this.moving = null;
// Set top to the index of the first data row
top = this.header ? this.header.rowIndex + 1 : 0;
// Set max to the index of the last data row
max = this.footer ? this.footer.rowIndex: this.tb.rows.length;
// create a copy of the datarows of the gird in the array a
for (i = top; i < max; ++i) a.push(p.rows[i]);
// Sort the newly created copy with a compare function.
// The compare function is the compare function defined for the grid being sorted.
a.sort(THIS(this, this.sortCompare));
// Empty the grid and fill it with the sorted rows
this.removeAllData();
j = top;
for (i = 0; i < a.length; ++i) {
e = p.insertBefore(a[i], this.footer);
e.className = (j & 1) ? 'even': 'odd'; ++j;
}
},
recolor: function() {
var i, e, o;
i = this.header ? this.header.rowIndex + 1 : 0;
e = this.footer ? this.footer.rowIndex: this.tb.rows.length;
for (; i < e; ++i) {
o = this.tb.rows[i];
o.className = (o.rowIndex & 1) ? 'even': 'odd';
}
},
removeAllData: function() {
var i, count;
i = this.header ? this.header.rowIndex + 1 : 0;
count = (this.footer ? this.footer.rowIndex: this.tb.rows.length) - i;
while (count-->0) elem.remove(this.tb.rows[i]);
},
getAllData: function() {
var i, max, data, r;
data = [];
max = this.footer ? this.footer.rowIndex: this.tb.rows.length;
for (i = this.header ? this.header.rowIndex + 1 : 0; i < max; ++i) {
r = this.tb.rows[i];
if ((r.style.display != 'none') && (r._data)) data.push(r._data);
}
return data;
},
isEditing: function() {
return (this.editor != null);
}
}
function xmlHttpObj() {
var ob;
try {
ob = new XMLHttpRequest();
if (ob) return ob;
} catch(ex) {}
try {
ob = new ActiveXObject('Microsoft.XMLHTTP');
if (ob) return ob;
} catch(ex) {}
return null;
}
var _useAjax = -1;
var _holdAjax = null;
function useAjax() {
if (_useAjax == -1) _useAjax = ((_holdAjax = xmlHttpObj()) != null);
return _useAjax;
}
function XmlHttp() {
if ((!useAjax()) || ((this.xob = xmlHttpObj()) == null)) return null;
return this;
}
XmlHttp.prototype = {
addId: function(vars) {
if (vars) vars += '&';
else vars = '';
vars += '_http_id=' + escapeCGI(nvram.http_id);
return vars;
},
get: function(url, vars) {
try {
vars = this.addId(vars);
url += '?' + vars;
this.xob.onreadystatechange = THIS(this, this.onReadyStateChange);
this.xob.open('GET', url, true);
this.xob.send(null);
} catch(ex) {
this.onError(ex);
}
},
post: function(url, vars) {
try {
vars = this.addId(vars);
this.xob.onreadystatechange = THIS(this, this.onReadyStateChange);
this.xob.open('POST', url, true);
this.xob.send(vars);
} catch(ex) {
this.onError(ex);
}
},
abort: function() {
try {
this.xob.onreadystatechange = function() {}
this.xob.abort();
} catch(ex) {}
},
onReadyStateChange: function() {
try {
if (typeof(E) == 'undefined') return; // oddly late? testing for bug...
if (this.xob.readyState == 4) {
if (this.xob.status == 200) {
this.onCompleted(this.xob.responseText, this.xob.responseXML);
} else {
this.onError('' + (this.xob.status || 'unknown'));
}
}
} catch(ex) {
this.onError(ex);
}
},
onCompleted: function(text, xml) {},
onError: function(ex) {}
}
function TomatoTimer(func, ms) {
this.tid = null;
this.onTimer = func;
if (ms) this.start(ms);
return this;
}
TomatoTimer.prototype = {
start: function(ms) {
this.stop();
this.tid = setTimeout(THIS(this, this._onTimer), ms);
},
stop: function() {
if (this.tid) {
clearTimeout(this.tid);
this.tid = null;
}
},
isRunning: function() {
return (this.tid != null);
},
_onTimer: function() {
this.tid = null;
this.onTimer();
},
onTimer: function() {}
}
function TomatoRefresh(actionURL, postData, refreshTime, cookieTag) {
this.setup(actionURL, postData, refreshTime, cookieTag);
this.timer = new TomatoTimer(THIS(this, this.start));
}
TomatoRefresh.prototype = {
running: 0,
setup: function(actionURL, postData, refreshTime, cookieTag) {
var e, v;
this.actionURL = actionURL;
this.postData = postData;
this.refreshTime = refreshTime * 1000;
this.cookieTag = cookieTag;
},
start: function() {
var e;
if ((e = E('refresh-time')) != null) {
if (this.cookieTag) cookie.set(this.cookieTag, e.value);
this.refreshTime = e.value * 1000;
}
e = undefined;
this.updateUI('start');
this.running = 1;
if ((this.http = new XmlHttp()) == null) {
reloadPage();
return;
}
this.http.parent = this;
this.http.onCompleted = function(text, xml) {
var p = this.parent;
if (p.cookieTag) cookie.unset(p.cookieTag + '-error');
if (!p.running) {
p.stop();
return;
}
p.refresh(text);
if ((p.refreshTime > 0) && (!p.once)) {
p.updateUI('wait');
p.timer.start(Math.round(p.refreshTime));
} else {
p.stop();
}
p.errors = 0;
}
this.http.onError = function(ex) {
var p = this.parent;
if ((!p) || (!p.running)) return;
p.timer.stop();
if (++p.errors <= 3) {
p.updateUI('wait');
p.timer.start(3000);
return;
}
if (p.cookieTag) {
var e = cookie.get(p.cookieTag + '-error') * 1;
if (isNaN(e)) e = 0;
else++e;
cookie.unset(p.cookieTag);
cookie.set(p.cookieTag + '-error', e, 1);
if (e >= 3) {
alert('XMLHTTP: ' + ex);
return;
}
}
setTimeout(reloadPage, 2000);
}
this.errors = 0;
this.http.post(this.actionURL, this.postData);
},
stop: function() {
if (this.cookieTag) cookie.set(this.cookieTag, '0');
this.running = 0;
this.updateUI('stop');
this.timer.stop();
this.http = null;
this.once = undefined;
},
toggle: function(delay) {
if (this.running) this.stop();
else this.start(delay);
},
updateUI: function(mode) {
var e, b;
if (typeof(E) == 'undefined') return; // for a bizzare bug...
b = (mode != 'stop') && (this.refreshTime > 0);
if ((e = E('refresh-button')) != null) {
e.innerHTML = b ? '停止 <i class="icon-cancel"></i>': '刷新 <i class="icon-refresh"></i>';
e.disabled = ((mode == 'start') && (!b));
}
if ((e = E('refresh-time')) != null) e.disabled = b;
if ((e = E('refresh-spinner')) != null) e.style.visibility = b ? 'visible': 'hidden';
},
initPage: function(delay, def) {
var e, v;
e = E('refresh-time');
if (((this.cookieTag) && (e != null)) && ((v = cookie.get(this.cookieTag)) != null) && (!isNaN(v *= 1))) {
e.value = Math.abs(v);
if (v > 0) v = (v * 1000) + (delay || 0);
} else if (def) {
v = def;
if (e) e.value = def;
} else v = 0;
if (delay < 0) {
v = -delay;
this.once = 1;
}
if (v > 0) {
this.running = 1;
this.refreshTime = v;
this.timer.start(v);
this.updateUI('wait');
}
},
destroy: function() {
this.running = 0;
this.updateUI('wait');
this.timer.stop();
this.http = null;
this.once = undefined;
this.refresh = null;
}
}
function genStdTimeList(id, zero, min) {
var b = [];
var t = [0.5, 1, 2, 3, 4, 5, 10, 15, 30, 60, 120, 180, 240, 300, 10 * 60, 15 * 60, 20 * 60, 30 * 60];
var i, v;
if (min >= 0) {
b.push('<select id="' + id + '"><option value=0>' + zero);
for (i = 0; i < t.length; ++i) {
v = t[i];
if (v < min) continue;
b.push('<option value=' + v + '>');
if (v == 60) b.push('1 分钟');
else if (v > 60) b.push((v / 60) + ' 分钟');
else if (v == 1) b.push('1 秒');
else b.push(v + ' 秒');
}
b.push('</select> ');
}
return b.join('');
}
function genStdRefresh(spin, min, exec) {
var html = '<div class="tomato-refresh form-inline input-append">';
if (spin) html += '<div class="spinner spinner-small"></div>';
html += genStdTimeList('refresh-time', '自动刷新', min);
html += '<button value="Refresh" onclick="' + (exec ? exec: 'refreshClick()') + '; return false;" id="refresh-button" class="btn">刷新 <i class="icon-refresh"></i></button></div>';
return html;
}
function _tabCreate(tabs) {
var buf = [];
buf.push('<div id="tabs" class="btn-group">');
for (var i = 0; i < arguments.length; ++i) buf.push('<a class="btn btn-tab" style="border-radius: 0;" href="javascript:tabSelect(\'' + arguments[i][0] + '\')" id="' + arguments[i][0] + '">' + arguments[i][1] + '</a>');
buf.push('</div>');
return buf.join('');
}
function tabCreate(tabs) {
return (_tabCreate.apply(this, arguments));
}
function tabHigh(id) {
var a = E('tabs').getElementsByTagName('A');
for (var i = 0; i < a.length; ++i) {
if (id != a[i].id) elem.removeClass(a[i], 'active');
}
elem.addClass(id, 'active');
}
var cookie = {
// The value 2147483647000 is ((2^31)-1)*1000, which is the number of
// milliseconds (minus 1 second) which correlates with the year 2038 counter
// rollover. This effectively makes the cookie never expire.
set: function(key, value, days) {
document.cookie = 'tomato_' + encodeURIComponent(key) + '=' + encodeURIComponent(value) + '; expires=' + new Date(2147483647000).toUTCString() + '; path=/';
},
get: function(key) {
var r = ('; ' + document.cookie + ';').match('; tomato_' + encodeURIComponent(key) + '=(.*?);');
return r ? decodeURIComponent(r[1]) : null;
},
unset: function(key) {
document.cookie = 'tomato_' + encodeURIComponent(key) + '=; expires=' + (new Date(1)).toUTCString() + '; path=/';
}
};
function checkEvent(evt) {
if (typeof(evt) == 'undefined') {
evt = event;
evt.target = evt.srcElement;
evt.relatedTarget = evt.toElement;
}
return evt;
}
function W(s) {
// $('.content .ajaxwrap').append(s);
}
function E(e) {
return (typeof(e) == 'string') ? document.getElementById(e) : e;
}
function PR(e) {
return elem.parentElem(e, 'TR') || elem.parentElem(e, 'FIELDSET');
}
function THIS(obj, func) {
return function() {
return func.apply(obj, arguments);
}
}
function UT(v) {
return (typeof(v) == 'undefined') ? '': '' + v;
}
function escapeHTML(s) {
function esc(c) {
return '&#' + c.charCodeAt(0) + ';';
}
return s.replace(/[&"'<>\r\n]/g, esc);
}
function escapeCGI(s) {
return escape(s).replace(/\+/g, '%2B'); // escape() doesn't handle +
}
function escapeD(s) {
function esc(c) {
return '%' + c.charCodeAt(0).hex(2);
}
return s.replace(/[<>|%]/g, esc);
}
function ellipsis(s, max) {
return (s.length <= max) ? s: s.substr(0, max - 3) + '...';
}
function MIN(a, b) {
return a < b ? a: b;
}
function MAX(a, b) {
return a > b ? a: b;
}
function fixInt(n, min, max, def) {
if (n === null) return def;
n *= 1;
if (isNaN(n)) return def;
if (n < min) return min;
if (n > max) return max;
return n;
}
function comma(n) {
n = '' + n;
var p = n;
while ((n = n.replace(/(\d+)(\d{3})/g, '$1,$2')) != p) p = n;
return n;
}
function doScaleSize(n, sm) {
if (isNaN(n *= 1)) return '-';
if (n <= 9999) return '' + n;
var s = -1;
do {
n /= 1024; ++s;
} while (( n > 9999 ) && (s < 2));
return comma(n.toFixed(2)) + (sm ? '<small> ': ' ') + (['KB', 'MB', 'GB'])[s] + (sm ? '</small>': '');
}
function scaleSize(n) {
return doScaleSize(n, 1);
}
function timeString(mins) {
var h = Math.floor(mins / 60);
if ((new Date(2000, 0, 1, 23, 0, 0, 0)).toLocaleString().indexOf('23') != -1) return h + ':' + (mins % 60).pad(2);
return ((h == 0) ? 12 : ((h > 12) ? h - 12 : h)) + ':' + (mins % 60).pad(2) + ((h >= 12) ? ' PM': ' AM');
}
function features(s) {
var features = ['ses', 'brau', 'aoss', 'wham', 'hpamp', '!nve', '11n', '1000et', '11ac'];
var i;
for (i = features.length - 1; i >= 0; --i) {
if (features[i] == s) return (parseInt(nvram.t_features) & (1 << i)) != 0;
}
return 0;
}
function get_config(name, def) {
return ((typeof(nvram) != 'undefined') && (typeof(nvram[name]) != 'undefined')) ? nvram[name] : def;
}
function nothing() {}
function show_notice1(s, type) {
if (s.length) $('#ajaxwrap').prepend('<div class="alert ' + ((type == null) ? 'alert-warning': type) + '"><a href="#" class="close"><i class="icon-cancel"></i></a>' + s.replace(/\n/g, '<br>') + '</div>');
}
function myName() {
var name, i;
name = window.location.hash.replace('#', '');
name = name.replace(/\\/g, '/'); // IE local testing
if ((i = name.lastIndexOf('/')) != -1) name = name.substring(i + 1, name.length);
if (name == '') name = 'status-overview.asp';
return '/#' + name;
}
function createFieldTable(flags, desc, writeTo, extraClass) {
var common;
var i, n;
var name;
var id;
var fields;
var f;
var a;
var buf = [];
var buf2;
var id1;
var tr;
if ((flags.indexOf('noopen') == -1)) buf.push('<table class="' + ((typeof extraClass != 'undefined') ? extraClass: 'data-table') + '">');
for (desci = 0; desci < desc.length; ++desci) {
var v = desc[desci];
if (!v) {
buf.push('<tr><td colspan=2>&nbsp;</td></tr>');
continue;
}
if (v.ignore) continue;
buf.push('<tr');
if (v.rid) buf.push(' id="' + v.rid + '"');
if (v.hidden) buf.push(' style="display:none"');
buf.push('>');
if (v.help) {
v.title += ' (<i class="icon-info icon-normal tooltip" data-info="' + v.help + '"></i>)';
}
if (v.text) {
if (v.title) {
buf.push('<td>' + v.title + '</td><td>' + v.text + '</td></tr>');
} else {
buf.push('<td colspan=2>' + v.text + '</td></tr>');
}
continue;
}
id1 = '';
buf2 = [];
buf2.push('<td>');
if (v.multi) fields = v.multi;
else fields = [v];
for (n = 0; n < fields.length; ++n) {
f = fields[n];
if (f.prefix) buf2.push(f.prefix);
if ((f.type == 'radio') && (!f.id)) id = '_' + f.name + '_' + i;
else id = (f.id ? f.id: ('_' + f.name));
if (id1 == '') id1 = id;
common = ' onchange="verifyFields(this, 1)" id="' + id + '"';
if (f.attrib) common += ' ' + f.attrib;
name = f.name ? (' name="' + f.name + '"') : '';
switch (f.type) {
case 'checkbox':
buf2.push('<input class="custom" type="checkbox"' + name + (f.value ? ' checked': '') + ' onclick="verifyFields(this, 1)"' + common + '>');
break;
case 'radio':
buf2.push('<input class="custom" type="radio"' + name + (f.value ? ' checked': '') + ' onclick="verifyFields(this, 1)"' + common + '>');
break;
case 'password':
if (f.peekaboo) {
switch (get_config('web_pb', '1')) {
case '0':
f.type = 'text';
case '2':
f.peekaboo = 0;
break;
}
}
if (f.type == 'password') {
common += ' autocomplete="off"';
if (f.peekaboo) common += ' onfocus=\'peekaboo("' + id + '",1)\'';
}
// drop
case 'text':
buf2.push('<input type="' + f.type + '"' + name + ' value="' + escapeHTML(UT(f.value)) + '" maxlength=' + f.maxlen + (f.size ? (' size=' + f.size) : '') + common + '>');
break;
case 'select':
buf2.push('<select' + name + common + '>');
for (i = 0; i < f.options.length; ++i) {
a = f.options[i];
if (a.length == 1) a.push(a[0]);
buf2.push('<option value="' + a[0] + '"' + ((a[0] == f.value) ? ' selected': '') + '>' + a[1] + '</option>');
}
buf2.push('</select>');
break;
case 'textarea':
buf2.push('<textarea ' + (f.style ? (' style="' + f.style + '" ') : '') + name + common + (f.wrap ? (' wrap=' + f.wrap) : '') + '>' + escapeHTML(UT(f.value)) + '</textarea>');
break;
default:
if (f.custom) buf2.push(f.custom);
break;
}
if (f.suffix) buf2.push(f.suffix);
}
buf2.push('</td>');
buf.push('<td>');
if (id1 != '') buf.push('<label for="' + id + '">' + v.title + '</label></td>');
else buf.push( + v.title + '</td>');
buf.push(buf2.join(''));
buf.push('</tr>');
}
if ((!flags) || (flags.indexOf('noclose') == -1)) buf.push('</table>');
if (writeTo != null) {
$(writeTo).append(buf.join(''));
} else {
return buf.join('');
}
}
function peekaboo(id, show) {
try {
var o = document.createElement('INPUT');
var e = E(id);
var name = e.name;
o.type = show ? 'text': 'password';
o.value = e.value;
o.size = e.size;
o.autocomplete = e.autocomplete;
o.title = e.title;
o.disabled = e.disabled;
o.onchange = e.onchange;
e.parentNode.replaceChild(o, e);
e = null;
o.id = id;
o.name = name;
if (show) {
o.onblur = function(ev) {
setTimeout('peekaboo("' + this.id + '", 0)', 0)
};
setTimeout('try { E("' + id + '").focus() } catch (ex) { }', 0)
} else {
o.onfocus = function(ev) {
peekaboo(this.id, 1);
};
}
} catch(ex) {
//		alert(ex);
}
/* REMOVE-BEGIN
notes:
- e.type= doesn't work in IE, ok in FF
- may mess keyboard tabing (bad: IE; ok: FF, Opera)... setTimeout() delay seems to help a little.
REMOVE-END */
}
function reloadPage() {
if (document.location.hash.match(/#/)) {
loadPage(document.location.hash);
} else {
loadPage('#soft-center.asp');
}
}
function reboot() {
if (confirm("重启?")) {
form.submitHidden('tomato.cgi', {
_reboot: 1,
_commit: 0,
_nvset: 0
});
} else {
return false;
}
}
function shutdown() {
if (confirm("关机?")) {
form.submitHidden('shutdown.cgi', {});
} else {
return false;
}
}
function logout() {
form.submitHidden('logout.asp', {});
}
// jQuery function to create forms on the fly
(function($) {
$.fn.forms = function(data, settings) {
$(this).append(createFormFields(data, settings));
}
})(jQuery);
function createFormFields(data, settings) {
var id, id1, common, output, form = '';
var s = $.extend({
// Defaults
'align': 'left',
'grid': ['col-sm-3', 'col-sm-9']
},
settings);
// Loop through array
$.each(data,
function(key, v) {
if (!v) {
form += '<br />';
return;
}
if (v.ignore) return;
form += '<fieldset' + ((v.rid) ? ' id="' + v.rid + '"': '') + ((v.hidden) ? ' style="display: none;"': '') + '>';
if (v.help) {
v.title += ' (<i data-toggle="tooltip" class="icon-info icon-normal" title="' + v.help + '"></i>)';
}
if (v.text) {
if (v.title) {
form += '<label class="' + s.grid[0] + ' ' + ((s.align == 'center') ? 'control-label': 'control-left-label') + '">' + v.title + '</label><div class="' + s.grid[1] + ' text-block">' + v.text + '</div></fieldset>';
} else {
form += '<label class="' + s.grid[0] + ' ' + ((s.align == 'center') ? 'control-label': 'control-left-label') + '">' + v.text + '</label></fieldset>';
}
return;
}
if (v.multi) multiornot = v.multi;
else multiornot = [v];
output = '';
$.each(multiornot,
function(key, f) {
if ((f.type == 'radio') && (!f.id)) id = '_' + f.name + '_' + i;
else id = (f.id ? f.id: ('_' + f.name));
if (id1 == '') id1 = id;
common = ' onchange="verifyFields(this, 1)" id="' + id + '"';
if (f.size > 65) common += ' style="width: 100%; display: block;"';
if (f.attrib) common += ' ' + f.attrib;
name = f.name ? (' name="' + f.name + '"') : '';
// Prefix
if (f.prefix) output += f.prefix;
switch (f.type) {
case 'checkbox':
output += '<div class="checkbox c-checkbox"><label><input class="custom" type="checkbox"' + name + (f.value ? ' checked': '') + ' onclick="verifyFields(this, 1)"' + common + '>\
<span></span> ' + (f.suffix ? f.suffix: '') + '</label></div>';
break;
case 'radio':
output += '<div class="radio c-radio"><label><input class="custom" type="radio"' + name + (f.value ? ' checked': '') + ' onclick="verifyFields(this, 1)"' + common + '>\
<span></span> ' + (f.suffix ? f.suffix: '') + '</label></div>';
break;
case 'password':
if (f.peekaboo) {
switch (get_config('web_pb', '1')) {
case '0':
f.type = 'text';
case '2':
f.peekaboo = 0;
break;
}
}
if (f.type == 'password') {
common += ' autocomplete="off"';
if (f.peekaboo) common += ' onfocus=\'peekaboo("' + id + '",1)\'';
}
// drop
case 'text':
output += '<input type="' + f.type + '"' + name + ' value="' + escapeHTML(UT(f.value)) + '" maxlength=' + f.maxlen + (f.size ? (' size=' + f.size) : '') + common + '>';
break;
case 'select':
output += '<select' + name + common + '>';
for (optsCount = 0; optsCount < f.options.length; ++optsCount) {
a = f.options[optsCount];
if (a.length == 1) a.push(a[0]);
output += '<option value="' + a[0] + '"' + ((a[0] == f.value) ? ' selected': '') + '>' + a[1] + '</option>';
}
output += '</select>';
break;
case 'textarea':
output += '<textarea ' + (f.style ? (' style="' + f.style + '" ') : '') + name + common + (f.wrap ? (' wrap=' + f.wrap) : '') + '>' + escapeHTML(UT(f.value)) + '</textarea>';
break;
default:
if (f.custom) output += f.custom;
break;
}
if (f.suffix && (f.type != 'checkbox' && f.type != 'radio')) output += '<span class="help-block">' + f.suffix + '</span>';
});
if (id1 != '') form += '<label class="' + s.grid[0] + ' ' + ((s.align == 'center') ? 'control-label': 'control-left-label') + '" for="' + id + '">' + v.title + '</label><div class="' + s.grid[1] + '">' + output;
else form += '<label>' + v.title + '</label>';
form += '</div></fieldset>';
});
return form;
}
function isLocal() {
return location.href.search('file://') == 0;
}
