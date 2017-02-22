<title>软件中心 - Aliddns</title>
<content>
<script type="text/javascript">
//数据 -  绘制界面用 - 直接 声明一个 nvram 然后 post 到 sh 然后 由 sh 执行 存到 dbus
nvram = {
	'aliddns_open':'1',
	'aliddns_last':'2016-02-27 22:22:22',
	'aliddns_key':'897hj6sd4f89e4thw5',
	'aliddns_secret':'dsf907sa6723502349846fdsf',
	'aliddns_check':'600',
	'aliddns_domain':'text.cctv.com',
	'aliddns_dns':'235.35.35.35',
	'aliddns_ip':'curl -s whatismyip.akamai.com',
	'aliddns_ttl':'600'
};

function verifyFields(focused, quiet){
	return 1;
}
function save(){
	nvram.aliddns_open = E('_aliddns_open').checked ? '1':'0';
	nvram.aliddns_key = E('_aliddns_key').value;
	nvram.aliddns_secret = E('_aliddns_secret').value;
	nvram.aliddns_check = E('_aliddns_check').value;
	nvram.aliddns_domain = E('_aliddns_domain').value;
	nvram.aliddns_dns = E('_aliddns_dns').value;
	nvram.aliddns_ip = E('_aliddns_ip').value;
	nvram.aliddns_ttl = E('_aliddns_ttl').value;
}
</script>
<div class="box">
<div class="heading">阿里云DDNS</div>
<div class="content">
<div id="aliddns-fields"></div><hr>
<script type="text/javascript">
$('#aliddns-fields').forms([
{ title: '开启Aliddns', name: 'aliddns_open', type: 'checkbox', value: nvram.aliddns_open },
{ title: '上次运行', name: 'aliddns_last', text: nvram.aliddns_last },
{ title: 'App Key', name: 'aliddns_key', type: 'text', maxlen: 63, size: 34, value: nvram.aliddns_key },
{ title: 'App Secret', name: 'aliddns_secret', type: 'password', maxlen: 32, size: 34, value: nvram.aliddns_secret },
{ title: '检查周期', name: 'aliddns_check', type: 'text', maxlen: 5, size: 5, value: nvram.aliddns_check || '600'},
{ title: '域名', name: 'aliddns_domain', type: 'text', maxlen: 32, size: 34, value: nvram.aliddns_domain || 'text.cctv.com'},
{ title: 'DNS服务器', name: 'aliddns_dns', type: 'text', maxlen: 15, size: 15, value: nvram.aliddns_dns ||'235.35.35.35'},
{ title: '获得IP命令', name: 'aliddns_ip', type: 'text', maxlen: 55, size: 55, value: nvram.aliddns_ip || 'curl -s whatismyip.akamai.com'},
{ title: 'TTL', name: 'aliddns_ttl', type: 'text', maxlen: 5, size: 5, value: nvram.aliddns_ttl || '600' ,suffix: ' <small> (范围: 1~86400; 默认: 600)</small>'},
]);
</script>
<h4>Notes</h4>
<ul>
<li>Not all models support these options</li>
</ul>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">Save <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">Cancel <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span>
</form>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
