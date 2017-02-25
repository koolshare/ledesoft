<title>软件中心 - ShadowSocks</title>
<content>
<script type="text/javascript">
getAppData();
var nvram ;
function getAppData(){
	$.ajax({ 
		type:"get", 
		url:"/_api/ss_",  
		async : false,//设置为同步操作就可以给全局变量赋值成功 
		success:function(data){ 
			nvram = data.result[0];//usersname为前面声明的全局变量 
		} 
	}); 	
}
console.log('nvram',nvram);
//数据 -  绘制界面用 - 直接 声明一个 nvram 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var a = E('_ss_basic_use_rss').checked ? '1':'0';
	if(a=='1'){
		PR('_ss_basic_rss_protocol').style.display='';
		PR('_ss_basic_rss_obfs').style.display='';
		PR('_ss_basic_onetime_auth').style.display='none';
		E('_ss_basic_onetime_auth').checked=false;
	}else{
		PR('_ss_basic_rss_protocol').style.display='none';
		PR('_ss_basic_rss_obfs').style.display='none';
		PR('_ss_basic_onetime_auth').style.display='';
	}
	var b = E('_ss_dns_sel').value;
	if(b=='0'){
		nvram.ss_ipset_foreign_dns='2';
		nvram.ss_redchn_dns_foreign='4';
		nvram.ss_redchn_dns2socks_user='208.67.222.222:53';
		nvram.ss_ipset_dns2socks_user='208.67.222.222:53';
	}else if(b=='1'){
		alert(1);
		nvram.ss_ipset_foreign_dns='1';
		nvram.ss_redchn_dns_foreign='2';
		nvram.ss_redchn_sstunnel='1';
		nvram.ss_ipset_tunnel='1';
	}else{
		alert(-1);
		nvram.ss_ipset_foreign_dns='3';
		nvram.ss_redchn_dns_foreign='5';
	}
	return 1;
}
function save(){
	nvram.ss_basic_open = E('_ss_basic_open').checked ? '1':'0';
	nvram.ss_basic_mode = E('_ss_basic_mode').value;
	nvram.ss_basic_server = E('_ss_basic_server').value;
	nvram.ss_basic_port = E('_ss_basic_port').value;
	nvram.ss_basic_password = E('_ss_basic_password').value;
	nvram.ss_basic_method = E('_ss_basic_method').value;
	nvram.ss_basic_onetime_auth = E('_ss_basic_onetime_auth').checked ? '1':'0';
	nvram.ss_basic_rss_protocol = E('_ss_basic_rss_protocol').value;
	nvram.ss_basic_rss_obfs = E('_ss_basic_rss_obfs').value;
	nvram.ss_basic_use_rss = E('_ss_basic_use_rss').checked ? '1':'0';
	nvram.ss_dns_sel = E('_ss_dns_sel').value;

	//-------------- post nvram to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'ss_config.sh', "params":[], "fields": nvram};
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
	  beforeSend:function(){
	  	changeButton(true);
	  	showMsg("msg_warring","系统提示","<b>工作中请稍后……！</b>");
	  	setTimeout("document.location.reload()", 10000);
	  },
	  success: success,
	  error: error,
	  dataType: "json"
	});
	//-------------- post nvram to dbus ---------------
}
function changeButton(obj){
	if(obj){
		$('button').addClass('disabled');
		$('button').prop('disabled', true);
	}else{
		$('button').removeClass('disabled');
		$('button').prop('disabled', false);
	}
}
function showMsg(Outtype,title,msg){
	$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
	$('#'+Outtype).show();
}
</script>
<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
<div class="box">
<div class="heading">ShadowSocks</div>
<div class="content">
<div id="aliddns-fields"></div><hr>
<script type="text/javascript">
$('#aliddns-fields').forms([
{ title: '开启ShadowSocks', name: 'ss_basic_open', type: 'checkbox', value: ((nvram.ss_basic_open =='1')? 1 : 0)},
{ title: '模式选择', name: 'ss_basic_mode', type:'select',options:[['1','GFW模式'],['2','大陆白名单模式'],['3','游戏模式'],['6','KcpTun模式']], value:nvram.ss_basic_mode || '1'},
{ title: '服务器地址', name: 'ss_basic_server', type: 'text', maxlen: 34, size: 34, value: nvram.ss_basic_server },
{ title: '服务器端口', name: 'ss_basic_port', type: 'text', maxlen: 5, size: 5, value: nvram.ss_basic_port },
{ title: '密码', name: 'ss_basic_password', type: 'password', maxlen: 20, size: 20, value: nvram.ss_basic_password },
{ title: '加密方式', name: 'ss_basic_method', type: 'select', options:[['table','table'],['rc4','rc4'],['rc4-md5','rc4-md5'],['aes-128-cfb','aes-128-cfb'],['aes-192-cfb','aes-192-cfb'],['aes-256-cfb','aes-256-cfb'],['bf-cfb','bf-cfb'],['camellia-128-cfb','camellia-128-cfb'],['camellia-192-cfb','camellia-192-cfb'],['camellia-256-cfb','camellia-256-cfb'],['cast5-cfb','cast5-cfb'],['des-cfb','des-cfb'],['idea-cfb','idea-cfb'],['rc2-cfb','rc2-cfb'],['seed-cfb','seed-cfb'],['salsa20','salsa20'],['chacha20','chacha20'],['chacha20-ietf','chacha20-ietf']], value: nvram.ss_basic_method || 'aes-256-cfb'},
{ title: 'DNS服务器', name: 'ss_dns_sel', type: 'select',options:[['0','dns2socks(默认)'],['1','ss-tunnel'],['2','Pcap_DNSProxy']], value: nvram.ss_dns_sel ||'0' ,suffix: '注意：Pcap_DNSProxy 模式不推荐 PPPOE 用户使用，SS-TUNNEL 模式SS服务器必须支持UDP。'},

{ title: '启用SSR', name: 'ss_basic_use_rss', type: 'checkbox' , value: ((nvram.ss_basic_use_rss =='1')? 1 : 0)},
{ title: 'OTA支持', name: 'ss_basic_onetime_auth', type: 'checkbox', value: ((nvram.ss_basic_onetime_auth=='1')? 1 : 0)},
{ title: '协议(protocol)', name: 'ss_basic_rss_protocol', type: 'select', options:[['origin','origin'],['verify_simple','verify_simple'],['verify_deflate','verify_deflate'],['verify_sha1','verify_sha1'],['auth_simple','auth_simple'],['auth_sha1','auth_sha1'],['auth_sha1_v2','auth_sha1_v2']], value: nvram.ss_basic_rss_protocol || 'origin',hidden:1},
{ title: '混淆插件 (obfs)', name: 'ss_basic_rss_obfs', type: 'select', options:[['plain','plain'],['http_simple','http_simple'],['tls_simple','tls_simple'],['random_head','random_head'],['tls1.0_session_auth','tls1.0_session_auth'],['tls1.2_ticket_auth','tls1.2_ticket_auth']], value: nvram.ss_basic_rss_obfs || 'origin',hidden:1}
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
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
