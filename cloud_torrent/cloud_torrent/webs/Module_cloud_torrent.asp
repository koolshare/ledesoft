<title>软件中心 - cloud torrent</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
	input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript">
var dbus;
var softcenter = 0;
get_dbus_data();
setTimeout("get_run_status();", 1000);

function get_dbus_data(){
	$.ajax({
	  	type: "GET",
	 	url: "/_api/cloud_torrent_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	dbus = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "cloud_torrent_status.sh", "params":[2], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_cloud_torrent_status").innerHTML = response.result;
			setTimeout("get_run_status();", 3000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_cloud_torrent_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}

function verifyFields(focused, quiet){
	if(E('_cloud_torrent_enable').checked){
		$('input').prop('disabled', false);
		$('select').prop('disabled', false);
	}else{
		$('input').prop('disabled', true);
		$('select').prop('disabled', true);
		$(E('_cloud_torrent_enable')).prop('disabled', false);
	}
	return true;
}

function save(){
	var para_chk = ["cloud_torrent_enable"];
	var para_inp = ["cloud_torrent_title1", "cloud_torrent_port", "cloud_torrent_usr", "cloud_torrent_passwd", "cloud_torrent_path" ];
	// collect data from checkbox
	for (var i = 0; i < para_chk.length; i++) {
		dbus[para_chk[i]] = E('_' + para_chk[i] ).checked ? '1':'0';
	}
	// data from other element
	for (var i = 0; i < para_inp.length; i++) {
		if (!E('_' + para_inp[i] ).value){
			dbus[para_inp[i]] = "";
		}else{
			dbus[para_inp[i]] = E('_' + para_inp[i]).value;
		}
	}
	
	//-------------- post dbus to dbus ---------------
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method":'cloud_torrent_config.sh', "params":["start"], "fields": dbus};
	var success = function(data) {
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 1000);
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
	  dataType: "json"
	});
}

</script>
<div class="box">
	<div class="heading">cloud torrent 1.0.0<a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
	<div class="content">
		<span class="col" style="line-height:30px;width:700px">
		Cloud torrent是一个由Go（golang）撰写的自带web端的torrent客户端。<br />
		您可以远程启动它来下载文件，然后通过自带的HTTP下载传输到你的电脑。<a href="https://github.com/jpillora/cloud-torrent" target="_blank"><u> cloud torrent github 项目地址</u></a>
		</span>
	</div>
</div>
<div class="box" style="margin-top: 0px;">
	<div class="content">
	<div id="cloud_torrent-fields"></div>
	<script type="text/javascript">
		var mode = [['-c', '客户端模式'], ['-s', '服务器模式']];
		if(!dbus.cloud_torrent_port){dbus.cloud_torrent_port = "23333";};
		if(!dbus.cloud_torrent_path){dbus.cloud_torrent_path = "/mnt/downloads";};
		$('#cloud_torrent-fields').forms([
		{ title: '开启cloud_torrent', name: 'cloud_torrent_enable', type: 'checkbox', value: dbus.cloud_torrent_enable == 1},
		{ title: 'cloud_torrent运行状态', text: '<font id="_cloud_torrent_status" name=cloud_torrent_status color="#1bbf35">正在获取运行状态...</font>' },
		{ title: 'web标题',  name: 'cloud_torrent_title1',type:'text', size: 12, value: dbus.cloud_torrent_title1 || "LEDE-X64", suffix:' &nbsp;&nbsp;不能有空格' },
		{ title: 'web端口',  name: 'cloud_torrent_port',type:'text', size: 12, value: dbus.cloud_torrent_port , suffix: ' &nbsp;&nbsp;<a href=http://' + location.hostname + ":" + dbus.cloud_torrent_port + '/ target="_blank"><u>http://'  + location.hostname + ":" + dbus.cloud_torrent_port + '</u></a>'},
		{ title: 'web登录帐号：密码 ', multi: [
			{ name: 'cloud_torrent_usr',type:'text', size: 12, value: dbus.cloud_torrent_usr || "admin", suffix: ' ：' },
			{ name: 'cloud_torrent_passwd', type: 'password', maxlen: 10, size: 12, value: dbus.cloud_torrent_passwd||"koolshare" ,peekaboo:"1" }
		]},
		{ title: '文件下载路径',  name: 'cloud_torrent_path',type:'text', size: 65, value: dbus.cloud_torrent_path || "/mnt/downloads" }
		]);
		
	</script>
	</div>
</div>

<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
