<title>软件中心 - Godaddy DDNS</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript">
AdvancedTomato();
getAppData();
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/gdddns_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

function init_gdddns(){
	get_wan_list();
	verifyFields(null, 1);
}

function get_wan_list(){
	var id = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id, "method": "gdddns_uigetwan.sh", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		url: "/_api/",
		async:true,
		cache:false,
		data: JSON.stringify(postData1),
		dataType: "json",
		success: function(response){
		if (response){
			var wans = response.result.split( '>' );
			for ( var i = 0; i < wans.length; ++i ) {
				$("#_gdddns_curl").append("<option value='"  + wans[i] + "'>" + wans[i] + "</option>");
			}
		}
		}
	});
}
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_gdddns_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_gdddns_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
}
function save(){
	Apps.gdddns_enable = E('_gdddns_enable').checked ? '1':'0';
	Apps.gdddns_key = E('_gdddns_key').value;
	Apps.gdddns_secret = E('_gdddns_secret').value;
	Apps.gdddns_interval = E('_gdddns_interval').value;
	Apps.gdddns_domain = E('_gdddns_domain').value;
	Apps.gdddns_dns = E('_gdddns_dns').value;
	Apps.gdddns_curl = E('_gdddns_curl').value;
	Apps.gdddns_ttl = E('_gdddns_ttl').value;
	if(Apps.gdddns_key == "" || Apps.gdddns_secret == "" || Apps.gdddns_domain == "home.example.com"){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'gdddns_config.sh', "params":[], "fields": Apps};
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
<div class="heading">Godaddy DDNS <a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<br><hr>
<div class="content">
<div id="gdddns-fields"></div>
<script type="text/javascript">
$('#gdddns-fields').forms([
{ title: '开启 Godaddy DDNS', name: 'gdddns_enable', type: 'checkbox', value: ((Apps.gdddns_enable == '1')? 1:0)},
{ title: '上次运行', name: 'gdddns_last_act', text: Apps.gdddns_last_act ||'--' },
{ title: 'Godaddy Key', name: 'gdddns_key', type: 'text', maxlen: 50, size: 34, value: Apps.gdddns_key },
{ title: 'Godaddy Secret', name: 'gdddns_secret', type: 'password', maxlen: 50, size: 34, value: Apps.gdddns_secret },
{ title: '检查周期', name: 'gdddns_interval', type: 'text', maxlen: 5, size: 5, value: Apps.gdddns_interval || '5',suffix:'分钟'},
{ title: '域名', name: 'gdddns_domain', type: 'text', maxlen: 32, size: 34, value: Apps.gdddns_domain || 'home.example.com'},
{ title: 'DNS服务器', name: 'gdddns_dns', type: 'text', maxlen: 15, size: 15, value: Apps.gdddns_dns ||'114.114.114.114',suffix:'<small>查询域名当前IP时使用的DNS解析服务器，默认为 114 DNS</small>'},
{ title: '接口', name: 'gdddns_curl', type: 'select', options:[], value:Apps.gdddns_curl || 'url', suffix:'<small>URL适用于未使用PPPOE拨号的二级路由</small>'},
{ title: 'TTL', name: 'gdddns_ttl', type: 'text', maxlen: 5, size: 5, value: Apps.gdddns_ttl || '600' ,suffix: ' <small> (范围: 1~86400; 默认: 600)</small>'},
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_gdddns();</script>
</content>
