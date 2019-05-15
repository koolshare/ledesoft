<title>软件中心 - TCP BBR拥塞控制算法</title>
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
function init_bbr(){
	getAppData();
	verifyFields(null, 1);
}

function getAppData(){
var dbusInfo;
	$.ajax({
	  type: "GET",
	 	url: "/_api/bbr_",
	  dataType: "json",
	  async:false,
	 	success: function(data){
	 	dbus = data.result[0];
		}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "bbr_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("bbr_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("bbr_status").innerHTML = "获取运行状态失败！";
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
	dbus.bbr_conn = E('_bbr_conn').value;
	dbus.bbr_mode = E('_bbr_mode').value;
	if(dbus.bbr_conn == "" || dbus.mode == "" ){
		alert("填写的信息不全，请检查后再提交！");
		return false;
	}
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'bbr_config.sh', "params":[], "fields": dbus};
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
<div class="heading">TCP 拥塞控制算法管理器<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	TCP BBR 由谷歌开发，即 TCP 拥塞控制算法，其目的在于最大化利用网络链路。
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="bbr-fields"></div>
<script type="text/javascript">
var option_mode = [['cubic', '默认Cubic'],['olia', 'olia'],['hybla', 'hybla'],['bbr', '原版BBR'],['bbrplus', 'BBR Plus'],['tcp_bbr_mod', '魔改BBR'],['tcp_bbr_tsunami', '魔改BBR→Yankee版'],['tcp_bbr_nql', '魔改BBR→南琴浪版']];
$('#bbr-fields').forms([
{ title: '当前状态', text: '<font id="bbr_status" name=bbr_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: 'TCP 拥塞控制算法', name: 'bbr_mode', type: 'select', options: option_mode, value: dbus.bbr_mode},
{ title: 'TCP 最大连接数', name: 'bbr_conn', type: 'text', maxlen: 10, size: 10, value: dbus.bbr_conn || '100000'},
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">TCP BBR要解决的问题： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>充分利用存在一定丢包率的网络链路</li>
			<li>降低网络延迟；</li>
			<li>某些TCP拥塞控制算法需要升级到最新固件才能开启；</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_bbr();</script>
</content>
