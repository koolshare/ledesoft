<title>软件中心 - Aliddns</title>
<content>
<style type="text/css">
input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript">
getAppData();
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/aliddns_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}
//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_aliddns_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_aliddns_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
}
function save(){
	Apps.aliddns_enable = E('_aliddns_enable').checked ? '1':'0';
	Apps.aliddns_ak = E('_aliddns_ak').value;
	Apps.aliddns_sk = E('_aliddns_sk').value;
	Apps.aliddns_interval = E('_aliddns_interval').value;
	Apps.aliddns_domain = E('_aliddns_domain').value;
	Apps.aliddns_dns = E('_aliddns_dns').value;
	Apps.aliddns_curl = E('_aliddns_curl').value;
	Apps.aliddns_ttl = E('_aliddns_ttl').value;
	if(Apps.aliddns_ak == "" || Apps.aliddns_sk == "" || Apps.aliddns_domain == "home.example.com"){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'aliddns_config.sh', "params":[], "fields": Apps};
	var success = function(data) {
		//
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);

		//  do someting here.
		//
	};
	var error = function(data) {
		//
		//  do someting here.
		//
	};
	$('#footer-msg').text('保存中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  error: error,
	  dataType: "json"
	});
	
	//-------------- post Apps to dbus ---------------
}
</script>
<div class="box">
<div class="heading">阿里云DDNS <a href="/#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<br><hr>
<div class="content">
<div id="aliddns-fields"></div>
<script type="text/javascript">
var option_mode = [['1', 'WAN1'], ['2', 'WAN2'], ['3', 'WAN3'], ['4', 'WAN4']];
$('#aliddns-fields').forms([
{ title: '开启Aliddns', name: 'aliddns_enable', type: 'checkbox', value: ((Apps.aliddns_enable == '1')? 1:0)},
{ title: '上次运行', name: 'aliddns_last_act', text: Apps.aliddns_last_act ||'--' },
{ title: 'App Key', name: 'aliddns_ak', type: 'text', maxlen: 34, size: 34, value: Apps.aliddns_ak },
{ title: 'App Secret', name: 'aliddns_sk', type: 'password', maxlen: 34, size: 34, value: Apps.aliddns_sk },
{ title: '检查周期', name: 'aliddns_interval', type: 'text', maxlen: 5, size: 5, value: Apps.aliddns_interval || '5',suffix:'分钟'},
{ title: '域名', name: 'aliddns_domain', type: 'text', maxlen: 32, size: 34, value: Apps.aliddns_domain || 'home.example.com'},
{ title: 'DNS服务器', name: 'aliddns_dns', type: 'text', maxlen: 15, size: 15, value: Apps.aliddns_dns ||'223.5.5.5',suffix:'<small>查询域名当前IP时使用的DNS解析服务器，默认为阿里云DNS</small>'},
{ title: '接口', name: 'aliddns_curl', type: 'select', options:option_mode,value:Apps.aliddns_curl || '1'},
{ title: 'TTL', name: 'aliddns_ttl', type: 'text', maxlen: 5, size: 5, value: Apps.aliddns_ttl || '600' ,suffix: ' <small> (范围: 1~86400; 默认: 600)</small>'},
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
