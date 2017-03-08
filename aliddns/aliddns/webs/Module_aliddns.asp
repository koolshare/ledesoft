<title>软件中心 - Aliddns</title>
<content>
<script type="text/javascript">
getAppData();
var nvram = {};
function getAppData(){
var appsInfo;
	$.getJSON("/_api/aliddns_", function(resp) {
		appsInfo=resp.result[0];
		nvram = appsInfo;
	});
}
//数据 -  绘制界面用 - 直接 声明一个 nvram 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	return 1;
}
function save(){
	nvram.aliddns_open = E('_aliddns_enable').checked ? '1':'0';
	nvram.aliddns_ak = E('_aliddns_ak').value;
	nvram.aliddns_sk = E('_aliddns_sk').value;
	nvram.aliddns_interval = E('_aliddns_interval').value;
	nvram.aliddns_domain = E('_aliddns_domain').value;
	nvram.aliddns_dns = E('_aliddns_dns').value;
	nvram.aliddns_curl = E('_aliddns_curl').value;
	nvram.aliddns_ttl = E('_aliddns_ttl').value;
	//-------------- post nvram to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'aliddns_config.sh', "params":[], "fields": nvram};
	var success = function(data) {
		//
		//  do someting here.
		//
	};
	var error = function(data) {
		//
		//  do someting here.
		//
	};
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  error: error,
	  dataType: "json"
	});
	console.log('nvram',nvram);
	//-------------- post nvram to dbus ---------------
}
</script>
<div class="box">
<div class="heading">阿里云DDNS</div>
<div class="content">
<div id="aliddns-fields"></div><hr>
<script type="text/javascript">
$('#aliddns-fields').forms([
{ title: '开启Aliddns', name: 'aliddns_enable', type: 'checkbox', value: nvram.aliddns_enable != '0'},
{ title: '上次运行', name: 'aliddns_last_act', text: nvram.aliddns_last_act ||'--' },
{ title: 'App Key', name: 'aliddns_ak', type: 'text', maxlen: 63, size: 34, value: nvram.aliddns_ak },
{ title: 'App Secret', name: 'aliddns_sk', type: 'password', maxlen: 32, size: 34, value: nvram.aliddns_sk },
{ title: '检查周期', name: 'aliddns_interval', type: 'text', maxlen: 5, size: 5, value: nvram.aliddns_interval || '120'},
{ title: '域名', name: 'aliddns_domain', type: 'text', maxlen: 32, size: 34, value: nvram.aliddns_domain || 'home.example.com'},
{ title: 'DNS服务器', name: 'aliddns_dns', type: 'text', maxlen: 15, size: 15, value: nvram.aliddns_dns ||'223.5.5.5',suffix:'<small>查询域名当前IP时使用的DNS解析服务器，默认为阿里云DNS</small>'},
{ title: '获得IP命令', name: 'aliddns_curl', type: 'text', maxlen: 55, size: 55, value: nvram.aliddns_curl || 'curl -s whatismyip.akamai.com',suffix:' <small>如添加 "--interface vlan2" 以指定多播情况下的端口支持</small>'},
{ title: 'TTL', name: 'aliddns_ttl', type: 'text', maxlen: 5, size: 5, value: nvram.aliddns_ttl || '600' ,suffix: ' <small> (范围: 1~86400; 默认: 600)</small>'},
]);
</script>
<h4>Notes</h4>
<ul>
<li>This is your place , just do it. —— @JsMonkey</li>
</ul>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
