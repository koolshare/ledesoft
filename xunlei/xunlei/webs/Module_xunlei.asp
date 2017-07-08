<title>软件中心 - 迅雷远程</title>
<content>
<script type="text/javascript">
getAppData();
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/xunlei_",
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
	return 1;
}
function save(){
	Apps.xunlei_enable = E('_xunlei_enable').checked ? '1':'0';
	//Apps.xunlei_ack = E('_xunlei_ack').value;
	//Apps.xunlei_user = E('_xunlei_user').value;
	//Apps.xunlei_disk = E('_xunlei_disk').value;
	//Apps.xunlei_domain = E('_xunlei_domain').value;
	//Apps.xunlei_dns = E('_xunlei_dns').value;
	//Apps.xunlei_curl = E('_xunlei_curl').value;
	//Apps.xunlei_ttl = E('_xunlei_ttl').value;

	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'xunlei_config.sh', "params":[], "fields": Apps};
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
	$('#footer-msg').text('正在启动服务，请耐心等待……');
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
<div class="heading">迅雷远程 <a href="javascript:history.back()" class="btn" style="float:right;border-radius:3px;">返回</a></div>
<br><hr>
<div class="content">
<div id="xunlei-fields"></div>
<script type="text/javascript">

$('#xunlei-fields').forms([
{ title: '开启迅雷远程', name: 'xunlei_enable', type: 'checkbox', value: ((Apps.xunlei_enable == '1')? 1:0)},
{ title: '迅雷版本', name: 'xunlei_version', text: Apps.xunlei_version ||'--' },
{ title: '运行状态', name: 'xunlei_last_act', text: Apps.xunlei_last_act ||'--' },
{ title: '激活码', name: 'xunlei_ackey', text: Apps.xunlei_ackey ||'--' },
{ title: '绑定账号', name: 'xunlei_user', text: Apps.xunlei_user ||'--' },
{ title: '磁盘状态', name: 'xunlei_disk', text: Apps.xunlei_disk ||'--' },
{ title: '控制台', name: 'xunlei_webui', text: '<a href="http://yuancheng.xunlei.com/" target="_blank">迅雷远程控制台</a>' },
//{ title: '域名', name: 'xunlei_domain', type: 'text', maxlen: 32, size: 34, value: Apps.xunlei_domain || 'ex.example.com'},
//{ title: 'DNS服务器', name: 'xunlei_dns', type: 'text', maxlen: 15, size: 15, value: Apps.xunlei_dns ||'223.5.5.5',suffix:'<small>查询域名当前IP时使用的DNS解析服务器，默认为阿里云DNS</small>'},
//{ title: '获取IP接口', name: 'xunlei_curl', type: 'select', options:option_mode,value:Apps.xunlei_curl || '1'},
//{ title: 'TTL', name: 'xunlei_ttl', type: 'text', maxlen: 5, size: 5, value: Apps.xunlei_ttl || '600' ,suffix: ' <small> (范围: 1~86400; 默认: 600)</small>'},
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
