<title>软件中心 - 腾讯云存储</title>
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
var option_backup_hour = [];
for(var i = 0; i < 24; i++){
	option_backup_hour[i] = [i, i + "时"];
}
function init_cos(){
	getAppData();
	verifyFields(null, 1);
}

function getAppData(){
var dbusInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/cos_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	dbus = data.result[0];
	  	$("#_cos_restore").find('option').remove().end();
		for ( var i = 1; i <= dbus["cos_file_nu"]; ++i ) {
		$("#_cos_restore").append("<option value='" + dbus["cos_file_name" + i] + "'>" + dbus["cos_file_name" + i] + " (" + dbus["cos_file_size" + i] + " )" + "</option>");
		}
		(dbus["cos_restore"]) && $("#_cos_restore").val(dbus["cos_restore"]);
		}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "cos_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("cos_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("cos_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

function verifyFields(focused, quiet){
	var dnsenable = E('_cos_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_cos_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	var a = E('_cos_backup').checked;
	elem.display('_cos_hour', a);
	elem.display('cos_hour_suf', a);
	elem.display('cos_hour_pre', a);
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
	dbus.cos_enable = E('_cos_enable').checked ? '1':'0';
	dbus.cos_backup = E('_cos_backup').checked ? '1':'0';
	dbus.cos_reboot = E('_cos_reboot').checked ? '1':'0';
	dbus.cos_backupall = E('_cos_backupall').value;
	dbus.cos_secretid = E('_cos_secretid').value;
	dbus.cos_secretkey = E('_cos_secretkey').value;
	dbus.cos_appid = E('_cos_appid').value;
	dbus.cos_bucket = E('_cos_bucket').value;
	dbus.cos_local = E('_cos_local').value;
	dbus.cos_file = E('_cos_file').value;
	dbus.cos_hour = E('_cos_hour').value;
	if(dbus.cos_secretid == "" || dbus.cos_file == "" || dbus.cos_secretkey == "" || dbus.cos_appid == "" || dbus.cos_bucket == "" ){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'cos_config.sh', "params":["start"], "fields": dbus};
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

function restore_now(o){
	softcenter = 0;
	dbus.cos_restore = E('_cos_restore').value;
	dbus.cos_backupall = E('_cos_backupall').value;
	dbus.cos_reboot = E('_cos_reboot').checked ? '1':'0';
	var id2 = parseInt(Math.random() * 100000000);
	var postData2 = {"id": id2, "method": 'cos_config.sh', "params":[o], "fields": dbus};
	var success2 = function(data2) {
		$('#footer-msg').text(data2.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);
	};
	var error2 = function(data2) {
	};
	$('#footer-msg').text('运行中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData2),
	  success: success2,
	  error: error2,
	  dataType: "json"
	});
}

</script>
<div class="box">
<div class="heading">软件中心自动云备份和恢复<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	腾讯云平台提供的对象存储服务，最大50G的免费空间，访问接口提供全国范围内的动态加速<br />
	你需要先到<a id="cos_number" href="https://cloud.tencent.com/product/cos" target="_blank"> https://cloud.tencent.com/product/cos </a>注册，然后生成APPID、Secret<a id="cos_number" href="https://console.cloud.tencent.com/capi" target="_blank"> https://console.cloud.tencent.com/capi </a><br />
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="cos-fields"></div>
<script type="text/javascript">
var option_local = [['ap-shanghai', '上海（华东）'],['ap-guangzhou', '广州（华南）'],['ap-chengdu', '成都（西南）'], ['ap-beijing-1', '北京一区（华北）'], ['ap-beijing', '北京'], ['ap-singapore', '新加坡'], ['ap-hongkong', '香港'], ['na-toronto', '多伦多'], ['eu-frankfurt', '法兰克福']];
var option_backup_all = [['0', '仅备份软件中心数据'], ['1', '备份固件所有配置']];
if(!dbus.cos_restore){dbus.cos_restore = "没有备份文件或者同步还没有完成";};
$('#cos-fields').forms([
{ title: '开启', name: 'cos_enable', type: 'checkbox', value: ((dbus.cos_enable == '1')? 1:0)},
{ title: '云盘运行状态', text: '<font id="cos_status" name=cos_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '● 腾讯云账号设置' },
{ title: 'SecretId', name: 'cos_secretid', type: 'text', maxlen: 50, size: 50, value: dbus.cos_secretid },
{ title: 'SecretKey', name: 'cos_secretkey', type: 'text', maxlen: 38, size: 38, value: dbus.cos_secretkey },
{ title: 'APPID', name: 'cos_appid', type: 'text', maxlen: 38, size: 38, value: dbus.cos_appid },
{ title: 'Bucket名称', name: 'cos_bucket', type: 'text', maxlen: 38, size: 38, value: dbus.cos_bucket, suffix: ' 输入 - 前面的字符' },
{ title: '所属地域', name: 'cos_local', type: 'select', options: option_local, value: dbus.cos_local },
{ title: '● 本地设置' },
{ title: '本地同步目录', name:'cos_file', type: 'text', maxlen: 50, size: 50, value: dbus.cos_file || "/tmp/cosdir" },
{ title: '自动备份软件中心', multi: [ 
	{ name:'cos_backup',type: 'checkbox', value: ((dbus.cos_backup == '1')? 1:0), suffix: ' &nbsp;&nbsp;' },
	{ name: 'cos_hour', type: 'select', options: option_backup_hour, value: dbus.cos_hour, suffix: '<lable id="cos_hour_suf">自动备份</lable>', prefix: '<span id="cos_hour_pre" class="help-block"><lable>每天</lable></span>' },
	{ name: 'cos_backupall', type: 'select', options: option_backup_all, value: dbus.cos_backupall },
	{ suffix: ' <button id="backup_now" onclick="restore_now(1);" class="btn btn-primary">立即备份</button>' }
] },
{ title: '● 恢复备份' },
{ title: '要恢复的备份文件', multi: [ 
	{ name:'cos_restore', type:'select', options:[], value: dbus.cos_restore },
	{ name:'cos_reboot',type: 'checkbox', value: ((dbus.cos_reboot == '1')? 1:0), suffix: '恢复完成自动重启&nbsp;&nbsp;' },
	{ suffix: ' <button id="restore_now" onclick="restore_now(2);" class="btn btn-danger">立即恢复</button>' }
] },	
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">插件说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>自动备份会在每天你设置的时间备份软件中心所有插件和配置。</li>
			<li>自动备份的文件保存在同步目录下面的LEDE目录内，请不要删除。</li>
			<li>超过一周的自动备份文件会在最近一次备份时删除，如果备份的次数小于7次则保留。</li>
			<li>固件所有配置备份包前缀[lede]仅软件中心备份前缀[softcenter]。</li>
			<li>点击恢复备份后建议重启一次。</li>
			<li>将固件降级到2.30以下或者从低版本升级到2.30或以上需要重新安装。</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_cos();</script>
</content>
