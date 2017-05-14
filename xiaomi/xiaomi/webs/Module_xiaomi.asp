<title>软件中心 - xiaomi</title>
<content>
<style type="text/css">
input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript">
get_temp_status();
getAppData();
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/xiaomi_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}


function get_temp_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "xiaomi_status.sh", "params":[2], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData1),
		dataType: "json",
		success: function(response){
			document.getElementById("_xiaomi_cpu_tmp").innerHTML = response.result.split("@@")[0] + "°C";
			document.getElementById("_xiaomi_fan_speed").innerHTML = response.result.split("@@")[1] || "未检测到！";
			setTimeout("get_temp_status();", 2000);
		},
		error: function(){
			document.getElementById("_koolproxy_status").innerHTML = "获取温度失败！";
			document.getElementById("_xiaomi_fan_speed").innerHTML = "未检测到！";
			setTimeout("get_temp_status();", 1000);
		}
	});
}	


//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_xiaomi_auto_enable').checked ? '1':'0';
	var l  = E('_xiaomi_sleep').value == '1';
	elem.display('_xiaomi_sleep_start_time', l);
	elem.display('_xiaomi_sleep_end_time', l);	
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_xiaomi_auto_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}	
	return 1;
}
function save(){
	Apps.xiaomi_auto_enable = E('_xiaomi_auto_enable').checked ? '1':'0';
	Apps.xiaomi_sleep = E('_xiaomi_sleep').value;
	Apps.xiaomi_sleep_start_time = E('_xiaomi_sleep_start_time').value;
	Apps.xiaomi_sleep_end_time = E('_xiaomi_sleep_end_time').value;
	Apps.xiaomi_interval = E('_xiaomi_interval').value;
	Apps.xiaomi_custom_enable = E('_xiaomi_custom_enable').checked ? '1':'0';
	Apps.xiaomi_speed = E('_xiaomi_speed').value;
	if(Apps.xiaomi_interval == ""){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}	
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'xiaomi_config.sh', "params":[], "fields": Apps};
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
<div class="heading">小米风扇 <a href="/#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<br><hr>
<div class="content">
<div id="xiaomi-fields"></div>
<script type="text/javascript">
var option_mode = [['1', '转速1'], ['2', '转速2'], ['3', '转速3'], ['4', '转速4'], ['5', '转速5']];
var option_hour_time = [];
for(var i = 0; i < 24; i++){
	option_hour_time[i] = [i, i + "时"];
}
$('#xiaomi-fields').forms([
{ title: '当前CPU温度', text: '<font id="_xiaomi_cpu_tmp" name=xiaomi_cpu_tmp color="#1bbf35">--°C</font>' },
{ title: '当前风扇转速', text: '<font id="_xiaomi_fan_speed" name=xiaomi_fan_speed color="#1bbf35">未检测到！</font>' },
{ title: '自动巡航', name: 'xiaomi_auto_enable', type: 'checkbox', value: ((Apps.xiaomi_auto_enable == '1')? 1:0)},
{ title: '休眠模式', multi: [
{ name: 'xiaomi_sleep',type: 'select', options:[['0', '禁用'], ['1', '开启']], value: Apps.xiaomi_sleep || "0", suffix: ' &nbsp;&nbsp;' },
{ name: 'xiaomi_sleep_start_time', type: 'select', options:option_hour_time, value: Apps.xiaomi_sleep_start_time || "0",suffix: ' &nbsp;&nbsp;' },
{ name: 'xiaomi_sleep_end_time', type: 'select', options:option_hour_time, value: Apps.xiaomi_sleep_end_time || "8"}
]},
{ title: '温度检查周期', name: 'xiaomi_interval', type: 'text', maxlen: 5, size: 5, value: Apps.xiaomi_interval || '5',suffix:'分钟'},
{ title: '手动变速', name: 'xiaomi_custom_enable', type: 'checkbox', value: ((Apps.xiaomi_custom_enable == '1')? 1:0)},
{ title: '风扇转速', name: 'xiaomi_speed', type: 'select', options:option_mode,value: Apps.xiaomi_speed || '1',suffix:'<small>需要开启手动变速才会生效，默认自动调节转速</small>'},
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
