<title>软件中心 - 迅雷快鸟</title>
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
function init_fastdick(){
	getAppData();
	verifyFields(null, 1);
}

function getAppData(){
var dbusInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/fastdick_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	dbus = data.result[0];
		}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "fastdick_status.sh", "params":[], "fields": ""};
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
			document.getElementById("fastdick_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("fastdick_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

function verifyFields(focused, quiet){
	var dnsenable = E('_fastdick_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_fastdick_enable')).prop('disabled', false);
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
	dbus.fastdick_enable = E('_fastdick_enable').checked ? '1':'0';
	dbus.fastdick_user = E('_fastdick_user').value;
	dbus.fastdick_passwd = E('_fastdick_passwd').value;
	dbus.fastdick_sleep = E('_fastdick_sleep').value;
	if(dbus.fastdick_user == "" || dbus.fastdick_passwd == "" ){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'fastdick_config.sh', "params":[], "fields": dbus};
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
	if (E('_fastdick_passwd').type="password")
	E('_fastdick_passwd').type="txt";
	psclick.innerHTML="<a href=\"javascript:txt()\">隐藏密码</a>"
}
		
function txt(){
	if (E('_fastdick_passwd').type="text")
	E('_fastdick_passwd').type="password";
	psclick.innerHTML="<a href=\"javascript:ps()\">显示密码</a>"
}


</script>
<div class="box">
<div class="heading">迅雷快鸟<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	宽带上下行提速工具，需要迅雷超级会员或者迅雷快鸟会员。<br />
	你需要先到<a id="fastdick_number" href="http://k.xunlei.com/" target="_blank"> http://k.xunlei.com/ </a>确认你的宽带账号有提速资格<br />
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="fastdick-fields"></div>
<script type="text/javascript">
var option_count = [['5', '5'], ['15', '15'], ['30', '30'], ['60', '60'], ['90', '90']];
$('#fastdick-fields').forms([
{ title: '开启', name: 'fastdick_enable', type: 'checkbox', value: ((dbus.fastdick_enable == '1')? 1:0)},
{ title: '运行状态', text: '<font id="fastdick_status" name=fastdick_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '● 迅雷会员账号设置' },
{ title: '用户名', name: 'fastdick_user', type: 'text', maxlen: 30, size: 30, value: dbus.fastdick_user },
{ title: '密码', name: 'fastdick_passwd', type:'password', maxlen: 30, size: 30, value: dbus.fastdick_passwd, suffix: '<SPAN id=psclick><A href="javascript:ps()">显示密码</A></SPAN>'},
{ title: '● 启动设置' },
{ title: '开机延时启动', name:'fastdick_sleep',type:'select', maxlen: 3, size: 3, options:option_count ,value: dbus.fastdick_sleep || '5' },
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">插件说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>如果运行后不能提速，可以尝试运行官方桌面版绑定账号后再重试。</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_fastdick();</script>
</content>
