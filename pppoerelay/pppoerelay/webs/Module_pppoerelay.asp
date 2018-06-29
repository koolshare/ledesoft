<title>软件中心 - PPPoE Relay</title>
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
	 	url: "/_api/pppoerelay_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "pppoerelay_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("pppoerelay_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("pppoerelay_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_pppoerelay_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_pppoerelay_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
}

function save(){
	Apps.pppoerelay_enable = E('_pppoerelay_enable').checked ? '1':'0';
	Apps.pppoerelay_dev = E('_pppoerelay_dev').value;
	Apps.pppoerelay_sesssions = E('_pppoerelay_sesssions').value;
	Apps.pppoerelay_time = E('_pppoerelay_time').value;
	if(Apps.pppoerelay_dev == ""){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'pppoerelay_config.sh', "params":[], "fields": Apps};
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
<div class="heading">PPPoE Relay <a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	PPPOE是2层技术，所以是不能跨路由使用的，用PPPoE穿透(pppoe-relay)使用网桥使PPPoE能够跨路由使用<br />
	对连接光猫的网卡进行穿透，方便路由下客户端需要自行拨号的用户，如：IPTV等。<br />
	你的宽带账号支持多拨才能正常使用。<br />
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="pppoerelay-fields"></div>
<script type="text/javascript">
$('#pppoerelay-fields').forms([
{ title: '开启PPPoE Relay', name: 'pppoerelay_enable', type: 'checkbox', value: ((Apps.pppoerelay_enable == '1')? 1:0)},
{ title: 'PPPoE Relay运行状态', text: '<font id="pppoerelay_status" name=pppoerelay_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '要穿透的连接光猫的网卡名称', name: 'pppoerelay_dev', type: 'text', maxlen: 15, size: 15, value: Apps.pppoerelay_dev || 'eth0', suffix: '如：eth0，每次只能穿透一个设备。' },
{ title: '最大连接数', name: 'pppoerelay_sesssions', type: 'text', maxlen: 5, size: 5, value: Apps.pppoerelay_sesssions || '64' },
{ title: '连接超时', name: 'pppoerelay_time', type: 'text', maxlen: 5, size: 5, value: Apps.pppoerelay_time || '60' }
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
