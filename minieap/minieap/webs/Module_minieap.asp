<title>软件中心 - 校园认证</title>
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
function init_minieap(){
	getAppData();
	verifyFields(null, 1);
}

function getAppData(){
var dbusInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/minieap_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	dbus = data.result[0];
		}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "minieap_status.sh", "params":[], "fields": ""};
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
			document.getElementById("minieap_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("minieap_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

function verifyFields(focused, quiet){
	var dnsenable = E('_minieap_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_minieap_enable')).prop('disabled', false);
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
	dbus.minieap_enable = E('_minieap_enable').checked ? '1':'0';
	dbus.minieap_user = E('_minieap_user').value;
	dbus.minieap_passwd = E('_minieap_passwd').value;
	dbus.minieap_auth = E('_minieap_auth').value;
	dbus.minieap_wan = E('_minieap_wan').value;
	if(dbus.minieap_user == "" || dbus.minieap_passwd == "" ){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'minieap_config.sh', "params":[], "fields": dbus};
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

function ps(){
	if (E('_minieap_passwd').type="password")
	E('_minieap_passwd').type="txt";
	psclick.innerHTML="<a href=\"javascript:txt()\">隐藏密码</a>"
}
		
function txt(){
	if (E('_minieap_passwd').type="text")
	E('_minieap_passwd').type="password";
	psclick.innerHTML="<a href=\"javascript:ps()\">显示密码</a>"
}


</script>
<div class="box">
<div class="heading">校园认证<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	这是一个实现了标准 EAP-MD5-Challenge 算法的 EAP 客户端，支持通过插件来修改标准数据包以通过特殊服务端的认证。目前带有一个实现锐捷 v3 (v4) 算法的插件。
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="minieap-fields"></div>
<script type="text/javascript">
var option_count = [['rjv3', '锐捷 v3 (v4)'], ['printer', '数据包打印']];
$('#minieap-fields').forms([
{ title: '开启', name: 'minieap_enable', type: 'checkbox', value: ((dbus.minieap_enable == '1')? 1:0)},
{ title: '运行状态', text: '<font id="minieap_status" name=minieap_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '用户名', name: 'minieap_user', type: 'text', maxlen: 30, size: 30, value: dbus.minieap_user },
{ title: '密码', name: 'minieap_passwd', type:'password', maxlen: 30, size: 30, value: dbus.minieap_passwd, suffix: '<SPAN id=psclick><A href="javascript:ps()">显示密码</A></SPAN>'},
{ title: 'Wan口设备名称', name: 'minieap_wan', type: 'text', maxlen: 8, size: 8, value: dbus.minieap_wan || 'eth0'},
{ title: '认证插件', name:'minieap_auth',type:'select', maxlen: 20, size: 20, options:option_count ,value: dbus.minieap_auth || 'rjv3' },
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">插件说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>目前锐捷的变种比较多，不保证所有环境下都能使用。</li>
			<li>更多帮助信息使用minieap -h获取。</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_minieap();</script>
</content>
