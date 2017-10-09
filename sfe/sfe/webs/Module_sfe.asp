<title>软件中心 - SFE</title>
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
	 	url: "/_api/sfe_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "sfe_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("sfe_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("sfe_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_sfe_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_sfe_enable')).prop('disabled', false);
		$(E('_sfe_ipv4')).prop('disabled', false);
		$(E('_sfe_ipv6')).prop('disabled', false);
		$(E('_sfe_bridge')).prop('disabled', false);
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
	Apps.sfe_enable = E('_sfe_enable').checked ? '1':'0';
	Apps.sfe_ipv4 = E('_sfe_ipv4').checked ? '1':'0';
	Apps.sfe_ipv6 = E('_sfe_ipv6').checked ? '1':'0';
	Apps.sfe_bridge = E('_sfe_bridge').checked ? '1':'0';
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'sfe_config.sh', "params":[], "fields": Apps};
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
<div class="heading">SFE<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	SFE是高通开发的基于内核的IP包转发引擎，可以提供高速的IP包转发，显著增强低端硬件路由的NAT能力，但由于绕过Linux桥接层，不适合复杂环境的使用。<br />
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="sfe-fields"></div>
<script type="text/javascript">
var option_mode = [['1', 'WAN1'], ['2', 'WAN2'], ['3', 'WAN3'], ['4', 'WAN4']];
$('#sfe-fields').forms([
{ title: '开启SFE', name: 'sfe_enable', type: 'checkbox', value: ((Apps.sfe_enable == '1')? 1:0)},
{ title: '快速转发引擎运行状态', text: '<font id="sfe_status" name=sfe_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: 'SFE诊断相关设置（开发人员使用）'},
{ title: '关闭桥接口跟踪', name: 'sfe_bridge', type: 'checkbox', value: ((Apps.sfe_bridge == '1')? 1:0)},
{ title: '开启IPV4连接诊断', name: 'sfe_ipv4', type: 'checkbox', value: ((Apps.sfe_ipv4 == '1')? 1:0)},
{ title: '开启IPV6连接诊断', name: 'sfe_ipv6', type: 'checkbox', value: ((Apps.sfe_ipv6 == '1')? 1:0)}
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">SFE使用说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>SFE并不能加快网速，如果你的带宽没有超过路由的转发能力不建议开启快速转发引擎。</li>
			<li>SFE会导致防火墙一些功能失效，如fwmark。</li>
			<li>SFE会导致石像鬼QOS失效。</li>
			<li>SFE会导致多拨失效。</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
