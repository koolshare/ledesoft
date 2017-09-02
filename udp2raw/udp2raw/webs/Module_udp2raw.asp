<title>软件中心 - udp2raw</title>
<content>
<style type="text/css">
input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<script type="text/javascript">
getAppData();
setTimeout("get_run_status();", 1000);
//console.log("111", document.location.hash)
var Apps;
var softcenter = 0;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/udp2raw_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "udp2raw_status.sh", "params":[2], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData1),
		dataType: "json",
		success: function(response){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("udp2raw_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("udp2raw_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_udp2raw_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_udp2raw_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
}


function save(){
	Apps.udp2raw_enable = E('_udp2raw_enable').checked ? '1':'0';
	Apps.udp2raw_iptables = E('_udp2raw_iptables').checked ? '1':'0';
	Apps.udp2raw_keep = E('_udp2raw_keep').checked ? '1':'0';
	Apps.udp2raw_lower = E('_udp2raw_lower').checked ? '1':'0';
	Apps.udp2raw_auth = E('_udp2raw_auth').value;
	Apps.udp2raw_port = E('_udp2raw_port').value;
	Apps.udp2raw_local = E('_udp2raw_local').value;
	Apps.udp2raw_passwd = E('_udp2raw_passwd').value;
	Apps.udp2raw_cipher = E('_udp2raw_cipher').value;
	Apps.udp2raw_mode = E('_udp2raw_mode').value;
	Apps.udp2raw_server = E('_udp2raw_server').value;
	if(Apps.udp2raw_server == ""){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'udp2raw_config.sh', "params":[], "fields": Apps};
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
<div class="heading">udp2raw <a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	<li>udp2raw是通过raw socket给UDP包加上TCP或ICMP header，进而绕过UDP屏蔽或QoS</li>
	<li>在UDP不稳定的环境下提升稳定性。可以有效防止在使用kcptun或者finalspeed的情况下udp端口被运营商限速。</li>
	<li>详细介绍你可以查看<a href="https://github.com/wangyu-/udp2raw-tunnel/blob/master/doc/README.zh-cn.md" target="_blank">README.zh-cn.md</a></li>
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="udp2raw-fields"></div>
<script type="text/javascript">
var option_mode = [['1', 'WAN1'], ['2', 'WAN2'], ['3', 'WAN3'], ['4', 'WAN4']];
$('#udp2raw-fields').forms([
{ title: '开启udp2raw', name: 'udp2raw_enable', type: 'checkbox', value: ((Apps.udp2raw_enable == '1')? 1:0)},
{ title: 'udp2raw运行状态', text: '<font id="udp2raw_status" name=udp2raw_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '服务器地址', name: 'udp2raw_server', type: 'text', maxlen: 38, size: 38, value: Apps.udp2raw_server },
{ title: '服务器端口', name: 'udp2raw_port', type: 'text', maxlen: 10, size: 10, value: Apps.udp2raw_port },
{ title: '本地端口', name: 'udp2raw_local', type: 'text', maxlen: 10, size: 10, value: Apps.udp2raw_local || "7777"},
{ title: '密码', name: 'udp2raw_passwd', type: 'text', maxlen: 50, size: 50, value: Apps.udp2raw_passwd },
{ title: '模式', name:'udp2raw_mode',type:'select',options:[['faketcp','faketcp'],['udp','udp'],['icmp','icmp']],value: Apps.udp2raw_mode || "faketcp", suffix: 'raw-mode 默认:faketcp' },
{ title: '加密模式', name:'udp2raw_cipher',type:'select',options:[['aes128cbc','aes128cbc'],['xor','xor'],['none','无']],value: Apps.udp2raw_cipher || "aes128cbc", suffix: 'cipher-mode 默认:aes128cbc' },
{ title: '校验模式', name:'udp2raw_auth',type:'select',options:[['md5','md5'],['crc32','crc32'],['icmp','icmp'],['simple','simple'],['none','无']],value: Apps.udp2raw_auth || "md5" , suffix: 'auth-mode 默认:md5' },
{ title: '程序退出保留防火墙规则', name: 'udp2raw_iptables', type: 'checkbox', value: ((Apps.udp2raw_iptables == '1')? 1:0), suffix: '开启后防火墙规则需要自己手动添加，规则不会在udp2raw退出时被删掉，可以避免停掉udp2raw后内核向对端回复RST。'},
{ title: '定期检查iptables防火墙规则', name: 'udp2raw_keep', type: 'checkbox', value: ((Apps.udp2raw_keep == '1')? 1:0), suffix: '开启后定期主动检查iptables，如果udp2raw添加的iptables规则丢了，就重新添加。'},
{ title: '绕过本地iptables', name: 'udp2raw_lower', type: 'checkbox', value: ((Apps.udp2raw_lower == '1')? 1:0), suffix: '允许绕过本地iptables，在一些iptables不好改动的情况下尤其有效'},
{ title: '其它配置项', name: 'udp2raw_custom', type: 'text', maxlen: 250, size: 250, value: Apps.udp2raw_custom }
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
