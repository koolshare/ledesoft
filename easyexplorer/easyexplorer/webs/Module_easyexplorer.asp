<title>软件中心 - 易有云（easyexplorer）</title>
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
toggleVisibility('notes')
//console.log("111", document.location.hash)
var Apps;
var softcenter = 0;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/easyexplorer_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "easyexplorer_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("easyexplorer_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("easyexplorer_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_easyexplorer_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_easyexplorer_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
}

function toggleVisibility(whichone) {
	if(E('sesdiv' + whichone).style.display=='') {
		E('sesdiv' + whichone).style.display='none';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-up"></i>';
		cookie.set('adv_dhcpdns_' + whichone + '_vis', 0);
	} else {
		E('sesdiv' + whichone).style.display='';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-down"></i>';
		cookie.set('adv_dhcpdns_' + whichone + '_vis', 1);
	}
}

function save(){
	Apps.easyexplorer_enable = E('_easyexplorer_enable').checked ? '1':'0';
//	Apps.easyexplorer_dlna = E('_easyexplorer_dlna').checked ? '1':'0';
	Apps.easyexplorer_token = E('_easyexplorer_token').value;
	Apps.easyexplorer_folder = E('_easyexplorer_folder').value;
	if(Apps.easyexplorer_token == ""){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'easyexplorer_config.sh', "params":[], "fields": Apps};
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
}

function download_binary(){
	window.open("http://firmware.koolshare.cn/binary/Easy-Explorer/");
}
</script>
<div class="box">
<div class="heading">易有云（easyexplorer） <a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	易有云（easyexplorer）是koolshare小宝开发的，支持跨设备、点对点文件传输同步工具。<br />
	EasyExplorer支持PC、Mac、iOS、安卓、NAS和路由器平台，iOS易有云公测中：<a href="http://koolshare.cn/thread-159997-1-1.html" target="_blank">http://koolshare.cn/thread-159997-1-1.html</a><br />
	你需要先到<a href="https://www.ddnsto.com" target="_blank">https://www.ddnsto.com </a>扫码登录获取token(令牌)，然后在本插件内配置Token和本地同步文件夹。
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="easyexplorer-fields"></div>
<script type="text/javascript">
var option_mode = [['1', 'WAN1'], ['2', 'WAN2'], ['3', 'WAN3'], ['4', 'WAN4']];
$('#easyexplorer-fields').forms([
{ title: '开启EasyExplorer', name: 'easyexplorer_enable', type: 'checkbox', value: ((Apps.easyexplorer_enable == '1')? 1:0)},
{ title: 'EasyeEplorer运行状态', text: '<font id="easyexplorer_status" name=easyexplorer_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: 'Token', name: 'easyexplorer_token', type: 'text', maxlen: 38, size: 38, value: Apps.easyexplorer_token },
{ title: '本地同步文件夹', name: 'easyexplorer_folder', type: 'text', size: 38, value: Apps.easyexplorer_folder || "/mnt/sda3/share" },
//{ title: '开启DLNA解码器下载', name: 'easyexplorer_dlna', type: 'checkbox', value: ((Apps.easyexplorer_dlna == '1')? 1:0)},
{ title: 'WEB控制台',  name: 'easyexplorer_web',text: ' &nbsp;&nbsp;<a href=http://' + location.hostname + ":8899" + '/ target="_blank"><u>http://'  + location.hostname + ":8899" + '</u></a>'},
{ title: '相关链接', suffix: ' <button onclick="download_binary();" class="btn btn-danger">EasyExplorer全平台下载</button>' }
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">易有云（easyexplorer）穿透设置教程： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li> 查看设置教程<a id="gfw_number" href="http://koolshare.cn/thread-129199-1-1.html" target="_blank"><font color="#FF3300">http://koolshare.cn/thread-129199-1-1.html</font></a></li>
			<li> DLNA解码组件较大，如果你不使用DLNA服务则无需开启。</li>
			<li> 首次启用DLNA解码支持会需要较长时间来下载视频解码组件。</li>
			<li> 更新固件后需要重新下载视频解码组件。</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
