<title>软件中心 - xldoc</title>
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
	 	url: "/_api/xldoc_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "xldoc_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("xldoc_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("xldoc_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_xldoc_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_xldoc_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
}


function save(){
	Apps.xldoc_enable = E('_xldoc_enable').checked ? '1':'0';
	if(Apps.xldoc_token == ""){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'xldoc_config.sh', "params":[], "fields": Apps};
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
<div class="heading">救救迅雷<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	尝试修复一个下载软件却无法下载的BUG。。。<br />
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="xldoc-fields"></div>
<script type="text/javascript">
var option_mode = [['1', 'WAN1'], ['2', 'WAN2'], ['3', 'WAN3'], ['4', 'WAN4']];
$('#xldoc-fields').forms([
{ title: '开启迅雷医生', name: 'xldoc_enable', type: 'checkbox', value: ((Apps.xldoc_enable == '1')? 1:0)},
{ title: '迅雷医生运行状态', text: '<font id="xldoc_status" name=xldoc_status color="#1bbf35">正在获取运行状态...</font>' },
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
