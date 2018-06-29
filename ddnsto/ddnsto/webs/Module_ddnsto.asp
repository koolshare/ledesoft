<title>软件中心 - ddnsto</title>
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
	 	url: "/_api/ddnsto_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "ddnsto_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("ddnsto_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("ddnsto_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_ddnsto_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_ddnsto_enable')).prop('disabled', false);
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
	Apps.ddnsto_enable = E('_ddnsto_enable').checked ? '1':'0';
	Apps.ddnsto_token = E('_ddnsto_token').value;
	if(Apps.ddnsto_token == ""){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'ddnsto_config.sh', "params":[], "fields": Apps};
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
<div class="heading">ddnsto 远程穿透<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	ddnsto是koolshare小宝开发的，支持http2的快速穿透。<br />
	你需要到<a id="gfw_number" href="https://www.ddnsto.com" target="_blank"> https://www.ddnsto.com </a>扫码登录，以获取token。<br />
	<font color="#FF3300">注意：</font>因验证方式改变，原有Token和设置失效，最新插件需要您重新登录控制台获取Token并重新设置。
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="ddnsto-fields"></div>
<script type="text/javascript">
var option_mode = [['1', 'WAN1'], ['2', 'WAN2'], ['3', 'WAN3'], ['4', 'WAN4']];
$('#ddnsto-fields').forms([
{ title: '开启ddnsto', name: 'ddnsto_enable', type: 'checkbox', value: ((Apps.ddnsto_enable == '1')? 1:0)},
{ title: 'ddnsto运行状态', text: '<font id="ddnsto_status" name=ddnsto_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: 'token', name: 'ddnsto_token', type: 'text', maxlen: 38, size: 38, value: Apps.ddnsto_token }
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">ddnsto穿透设置教程： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li> 比如我路由器局域网ip是192.168.2.1，需要用 <font color="#FF3300">https://xiaobao.ddns.to/</font> 作为我的ddns域名，则设置域名前缀为 <font color="#FF3300">xiaobao</font>，目标主机地址为 <font color="#FF3300">http://192.168.2.1</font>；</li>
			<br />
			<li> 如果需要使用远程命令，建议安装并使用<a id="gfw_number" href="/#Module_shellinabox.asp" target="_blank"> shellinabox </a>插件，并设置<font color="#FF3300"> xiaobao-cmd </font>为二级域名，并添加 <font color="#FF3300">http://192.168.2.1:4200</font> 目标主机地址。</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
