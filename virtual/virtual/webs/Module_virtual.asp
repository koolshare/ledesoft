<title>软件中心 - 虚拟机助手</title>
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
function init_virtual(){
	getAppData();
	verifyFields(null, 1);
}

function getAppData(){
var dbusInfo;
	$.ajax({
	  type: "GET",
	 	url: "/_api/virtual_",
	  dataType: "json",
	  async:false,
	 	success: function(data){
	 	dbus = data.result[0];
		}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "virtual_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("virtual_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("virtual_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

function verifyFields(focused, quiet){
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
	dbus.virtual_enable = E('_virtual_enable').checked ? '1':'0';
	dbus.virtual_mode = E('_virtual_mode').value;
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'virtual_config.sh', "params":[], "fields": dbus};
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
<div class="heading">虚拟机助手<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	如果你的Openwrt软路由是安装在虚拟机里，开启助手可增强虚拟机的系统性能并改进虚拟机管理。
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="virtual-fields"></div>
<script type="text/javascript">
var option_mode = [['1', 'Proxmox VE'],['2', 'VMware EXSI']];
$('#virtual-fields').forms([
{ title: '当前状态', text: '<font id="virtual_status" name=virtual_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '开启', name: 'virtual_enable', type: 'checkbox', value: dbus.virtual_enable == 1},
{ title: '宿主机操作系统', name: 'virtual_mode', type: 'select', options: option_mode, value: dbus.virtual_mode},
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">关于虚拟机助手： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>PVE需要在先在控制台-虚拟机-选项中开启Qemu代理</li>
			<li>固件需要2.28以上才能支持ESXI系统</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_virtual();</script>
</content>
