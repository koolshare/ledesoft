<title>软件中心 - Frpc</title>
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
	 	url: "/_api/frpc_",
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
var frpc = new TomatoGrid();
frpc.exist = function( f, v ) {
var data = this.getAllData();
for ( var i = 0; i < data.length; ++i ) {
if ( data[ i ][ f ] == v ) return true;
}
return false;
}
frpc.dataToView = function( data ) {
	for(var i=0;i < data.length; i++){
		//alert(data[i]);
		//if(data[i]==''){
		//	alert('参数不能为空');
		//	return false;
		//}
	}
return [ data[ 0 ] , data[ 1 ], data[ 2 ],data[3] ,data[4],data[5],data[6],data[7],data[8]];
}
frpc.fieldValuesToData = function( row ) {
var f = fields.getAll( row );
return [ f[ 0 ].value, f[ 1 ].value, f[ 2 ].value ,f[3].value,f[4].value,f[5].value,f[6].value,f[7].value,f[8].value];
}

frpc.resetNewEditor = function() {
var f;
f = fields.getAll( this.newEditor );
ferror.clearAll( f );
f[ 0 ].value   = '';
f[ 1 ].value   = 'http';
f[ 2 ].value   = '';
f[ 3 ].value   = '';
f[ 4 ].value   = '';
f[ 5 ].value   = '';
f[ 6 ].value   = '关闭';
f[ 7 ].value   = '关闭';
f[ 8 ].value   = '开启';
}
frpc.setup = function() {
this.init( 'frpc-grid', '', 50, [
{ type: 'text', maxlen: 20 },
{ type: 'select' ,options:[['http','http'],['https','https'],['tcp','tcp'],['udp','udp']]},
{ type: 'text', maxlen: 90 },
{ type: 'text', maxlen: 40 },
{ type: 'text', maxlen: 5 },
{ type: 'text', maxlen: 5 },
{ type: 'select' ,options:[['关闭','关闭'],['开启','开启']]},
{ type: 'select' ,options:[['关闭','关闭'],['开启','开启']]},
{ type: 'select' ,options:[['开启','开启'],['关闭','关闭']]},
] );
this.headerSet( [ '服务名称', '协议类型', '域名', '内网地址' ,'内网端口','远程端口','压缩','加密','特权模式'] );
if (Apps.frpc_srlist == undefined||Apps.frpc_srlist == null){
		Apps.frpc_srlist = '';
	}
var s = Apps.frpc_srlist.split( '>' );
for ( var i = 0; i < s.length; ++i ) {
	var t = s[ i ].split( '<' );
	if ( t.length == 9 ) this.insertData( -1, t );
}
this.showNewEditor();
this.resetNewEditor();
}
function save(){
	var data      = frpc.getAllData();
	var frpc_srlist = '';
	for ( var i = 0; i < data.length; ++i ) {
		frpc_srlist += data[ i ].join( '<' ) + '>';
	}
	Apps.frpc_enable = E('_frpc_enable').checked ? '1':'0';
	Apps.frpc_common_server_addr = E('_frpc_common_server_addr').value;
	Apps.frpc_common_server_port = E('_frpc_common_server_port').value;
	Apps.frpc_common_log_file = E('_frpc_common_log_file').value;
	Apps.frpc_common_log_level = E('_frpc_common_log_level').value;
	Apps.frpc_common_log_max_days = E('_frpc_common_log_max_days').value;
	//Apps.frpc_common_auth_token = E('_frpc_common_auth_token').value;
	Apps.frpc_common_privilege_token = E('_frpc_common_privilege_token').value;
	Apps.frpc_srlist = frpc_srlist;
	
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'frpc_config.sh', "params":[], "fields": Apps};
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
<div class="heading">frpc内网穿透 <a href="javascript:history.back()" class="btn" style="float:right;border-radius:3px;">返回</a></div>
<br><hr>
<div class="content">
<div id="frpc-fields"></div>
<script type="text/javascript">
var time_mode = [['1', '1天'], ['2', '2天'], ['3', '3天']];
var log_mode = [['debug', 'debug'], ['info', 'info'], ['warn', 'warn'], ['error', 'error']];
//var option_mode = [['1', 'whatismyip.akamai.com'], ['2', 'WAN'], ['3', 'WAN2'], ['4', 'WAN3'], ['5', 'WAN4'], ['6', 'ip.chinaz.com']];
$('#frpc-fields').forms([
{ title: '开启frpc', name: 'frpc_enable', type: 'checkbox', value: ((Apps.frpc_enable == '1')? 1:0)},
{ title: '运行状态', name: 'frpc_last_act', text: Apps.frpc_last_act+" Frpc版本:"+Apps.frpc_version ||'--' },
{ title: '服务器地址', name: 'frpc_common_server_addr', type: 'text', maxlen: 25, size: 25, value: Apps.frpc_common_server_addr ||'0.0.0.0' },
{ title: '服务器端口', name: 'frpc_common_server_port', type: 'text', maxlen: 5, size: 5, value: Apps.frpc_common_server_port ||'7000' },
{ title: '日志记录文件', name: 'frpc_common_log_file', type: 'text', maxlen: 25, size: 25, value: Apps.frpc_common_log_file ||'/tmp/frpc.log' },
{ title: '日志记录等级', name: 'frpc_common_log_level', type: 'select', options:log_mode,value:Apps.frpc_common_log_level || 'info'},
{ title: '日志记录时间', name: 'frpc_common_log_max_days', type: 'select', options:time_mode,value:Apps.frpc_common_log_max_days || '1' ,suffix:'日志保存最长时间'},
//{ title: '认证密码', name: 'frpc_common_auth_token', type: 'text', maxlen: 20, size: 20, value: Apps.frpc_common_auth_token ,suffix:'如果没有请留空'},
{ title: '特权连接密码(privilege_token)', name: 'frpc_common_privilege_token', type: 'text', maxlen: 20, size: 20, value: Apps.frpc_common_privilege_token ,suffix:'如果没有请留空'},
//{ title: '域名', name: 'frpc_domain', type: 'text', maxlen: 32, size: 34, value: Apps.frpc_domain || 'ex.example.com'},
//{ title: 'DNS服务器', name: 'frpc_dns', type: 'text', maxlen: 15, size: 15, value: Apps.frpc_dns ||'223.5.5.5',suffix:'<small>查询域名当前IP时使用的DNS解析服务器，默认为阿里云DNS</small>'},
//{ title: '获取IP接口', name: 'frpc_curl', type: 'select', options:option_mode,value:Apps.frpc_curl || '1'},
//{ title: 'TTL', name: 'frpc_ttl', type: 'text', maxlen: 5, size: 5, value: Apps.frpc_ttl || '600' ,suffix: ' <small> (范围: 1~86400; 默认: 600)</small>'},
]);
</script>
</div>
</div>
<div class="box">
<div class="heading">配置服务</div>
<hr>
<div class="content">
<table class="line-table" cellspacing=1 id="frpc-grid"></table>	
<script type="text/javascript">frpc.setup();</script>
<br><hr>
<h4>配置说明：</h4>
<div class="section" id="sesdiv_notes2">
				<ul>
					<li>当协议类型为HTTP/HTTPS时，远程端口的设置无效，不需要填写，访问端口为服务端设置的vhost_http_port或vhost_https_port</li>
					<li>当协议类型为TCP/UDP时，域名设置无效，不需要填写</li>
					<li>除以上两项外，其他项都需要正确填写</li>
					<li>特权模式（privilege_mode）开启后，添加服务时不用在服务器端添加相应的服务即可生效。需要正确填写 特权连接密码(privilege_token)，如果没有请在服务端设置</li>
				</ul>
			</div>
<br>
<hr>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
