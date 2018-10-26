<title>软件中心 - 百度网盘</title>
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
	 	url: "/_api/baidupcs_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "baidupcs_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("baidupcs_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("baidupcs_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var dnsenable = E('_baidupcs_enable').checked ? '1':'0';
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_baidupcs_enable')).prop('disabled', false);
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
	Apps.baidupcs_enable = E('_baidupcs_enable').checked ? '1':'0';
	Apps.baidupcs_port = E('_baidupcs_port').value;
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'baidupcs_config.sh', "params":[], "fields": Apps};
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
}

function download_binary(){
	window.open("http://firmware.koolshare.cn/binary/Easy-Explorer/");
}
</script>
<div class="box">
<div class="heading">百度网盘 <a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	基于<a href="https://github.com/iikira/BaiduPCS-Go" target="_blank">BaiduPCS-Go </a>的<a href="https://github.com/liuzhuoling2011/baidupcs-web" target="_blank">web</a>版本，让你高效的使用百度云。<br />
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="baidupcs-fields"></div>
<script type="text/javascript">
if(!Apps.baidupcs_port){Apps.baidupcs_port = "5299";};
$('#baidupcs-fields').forms([
{ title: '开启', name: 'baidupcs_enable', type: 'checkbox', value: ((Apps.baidupcs_enable == '1')? 1:0)},
{ title: 'BaiduPCS运行状态', text: '<font id="baidupcs_status" name=baidupcs_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '控制台端口', name: 'baidupcs_port', type: 'text', size: 5, value: Apps.baidupcs_port || "5299" },
{ title: 'WEB控制台',  name: 'baidupcs_web',text: ' &nbsp;&nbsp;<a href=http://' + location.hostname + ":" + Apps.baidupcs_port + '><u>http://'  + location.hostname + ":" + Apps.baidupcs_port + '</u></a>'}
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">设置教程： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li> 首次使用打开web控制台后点击右上角选项配置本地同步文件夹。</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
