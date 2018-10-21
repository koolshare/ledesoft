<title>软件中心 - 透明网桥</title>
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
	 	url: "/_api/bridge_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "bridge_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("bridge_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("bridge_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_bridge_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_bridge_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
}

function save(){
	Apps.bridge_enable = E('_bridge_enable').checked ? '1':'0';
	Apps.bridge_gateway = E('_bridge_gateway').value;
	Apps.bridge_dev = E('_bridge_dev').value;
	Apps.bridge_mask = E('_bridge_mask').value;
	Apps.bridge_ip = E('_bridge_ip').value;
	if(Apps.bridge_ip == ""){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'bridge_config.sh', "params":[], "fields": Apps};
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
<div class="heading">透明网桥<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	让Openwrt路由成为与上级路由通信，无感知，并具备防火墙功能的透明网桥设备。<br />
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="bridge-fields"></div>
<script type="text/javascript">
$('#bridge-fields').forms([
{ title: '开启透明网桥', name: 'bridge_enable', type: 'checkbox', value: ((Apps.bridge_enable == '1')? 1:0)},
{ title: '运行状态', text: '<font id="bridge_status" name=bridge_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '网关IP', name: 'bridge_gateway', type: 'text', maxlen: 16, size: 16, value: Apps.bridge_gateway || '192.168.1.1', suffix: '上级路由IP' },
{ title: '网桥IP', name: 'bridge_ip', type: 'text', maxlen: 16, size: 16, value: Apps.bridge_ip || '192.168.1.2', suffix: '需要和上级路由在同一个网段但不要和其它设备IP冲突' },
{ title: '子网掩码', name: 'bridge_mask', type: 'text', maxlen: 16, size: 16, value: Apps.bridge_mask || '255.255.255.0' },
{ title: '网口数', name: 'bridge_dev', type: 'text', maxlen: 2, size: 2, value: Apps.bridge_dev || '4' , suffix: '软路由物理网口数量'}
]);
</script>
</div>
</div>
	<div id="pbr_basic_readme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 适用于有上级路由，需要软路由的一些功能但又不想多级NAT的网络环境。</li>	
			<li> 交换机或客户端需要连接到软路由的网口下面。</li>	
			<li> 启用透明网桥后软路由的WEB控制台为网桥IP。</li>	
			<li> 启用透明网桥后软路由上的一些功能会失效，如：策略路由、多拨等。</li>	
			<li> 关闭后恢复插件安装时的网络设置，WEB控制台恢复为原始设置的IP。</li>	
	</div>
	</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
