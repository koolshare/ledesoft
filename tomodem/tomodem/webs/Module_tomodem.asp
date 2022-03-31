<title>软件中心 - 光猫助手</title>
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
var dbus;
var softcenter = 0;
function init_tomodem(){
	getAppData();
	verifyFields(null, 1);
}

function getAppData(){
var dbusInfo;
	$.ajax({
	  type: "GET",
	 	url: "/_api/tomodem_",
	  dataType: "json",
	  async:false,
	 	success: function(data){
	 	dbus = data.result[0];
		}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "tomodem_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("tomodem_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("tomodem_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

function verifyFields(focused, quiet){
	var modemenable = E('_tomodem_enable').checked ? '1':'0';
	if(modemenable == 0){
		$('input').prop('disabled', true);
		$(E('_tomodem_enable')).prop('disabled', false);
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
	dbus.tomodem_enable = E('_tomodem_enable').checked ? '1':'0';
	dbus.tomodem_eth = E('_tomodem_eth').value;
	dbus.tomodem_ip = E('_tomodem_ip').value;
	if(dbus.tomodem_conn == "" || dbus.mode == "" ){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'tomodem_config.sh', "params":[], "fields": dbus};
	var success = function(data) {
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);
	};
	var error = function(data) {
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

</script>

<div class="box">
<div class="heading">光猫助手<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	在路由器PPPOE拨号后也能管理光猫。
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="tomodem-fields"></div>
<script type="text/javascript">
$('#tomodem-fields').forms([
{ title: '当前状态', text: '<font id="tomodem_status" name=tomodem_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '开启', name: 'tomodem_enable', type: 'checkbox', value: ((dbus.tomodem_enable == '1')? 1:0)},
{ title: '光猫IP地址', name: 'tomodem_ip', type: 'text', maxlen: 16, size: 16, value: dbus.tomodem_ip || '192.168.2.1'},
{ title: '连接光猫网口名称', name: 'tomodem_eth', type: 'text', maxlen: 10, size: 10, value: dbus.tomodem_eth || 'eth0'},
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">设置要注意的问题： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>光猫和路由不能在一个IP段</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_tomodem();</script>
</content>
