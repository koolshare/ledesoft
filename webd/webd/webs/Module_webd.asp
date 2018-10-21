<title>软件中心 - 个人网盘</title>
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
	 	url: "/_api/webd_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	dbus = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "webd_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("_webd_status").innerHTML = response.result;
			setTimeout("get_run_status();", 3000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_webd_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}

function verifyFields(focused, quiet){
	if(E('_webd_enable').checked){
		$('input').prop('disabled', false);
		$('select').prop('disabled', false);
	}else{
		$('input').prop('disabled', true);
		$('select').prop('disabled', true);
		$(E('_webd_enable')).prop('disabled', false);
	}
	return true;
}

function save(){
	var para_chk = ["webd_enable","webd_open"];
	var para_inp = ["webd_dir", "webd_port"];
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
	var id = parseInt(Math.random() * 6);
	var postData = {"id": id, "method":'webd_config.sh', "params":["start"], "fields": dbus};
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
	<div class="heading">个人网盘<a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
	<div class="content">
		<span class="col" style="line-height:30px;width:700px">
		Webd是由论坛网友<a href="http://koolshare.cn/thread-148435-1-1.html" target="_blank"><u> @c351529</u></a>开发的小巧网盘客户端。<br />
		</span>
	</div>
</div>
<div class="box" style="margin-top: 0px;">
	<div class="content">
	<div id="webd-fields"></div>
	<script type="text/javascript">
		if(!dbus.webd_port){dbus.webd_port = "9192";};
		if(!dbus.webd_dir){dbus.webd_dir = "/mnt/sda3/www";};
		$('#webd-fields').forms([
		{ title: '开启webd', name: 'webd_enable', type: 'checkbox', value: dbus.webd_enable == 1},
		{ title: 'webd运行状态', text: '<font id="_webd_status" name=webd_status color="#1bbf35">正在获取运行状态...</font>' },
		{ title: 'web目录',  name: 'webd_dir',type:'text', size: 65, value: dbus.webd_dir || "/mnt/sda3/www" },
		{ title: 'web端口',  name: 'webd_port',type:'text', size: 12, value: dbus.webd_port || "9212", suffix: ' &nbsp;&nbsp;<a href=http://' + location.hostname + ":" + dbus.webd_port + '/ target="_blank"><u>http://'  + location.hostname + ":" + dbus.webd_port + '</u></a>'},
	//	{ title: 'web登录帐号：密码 ', multi: [
	//		{ name: 'webd_usr',type:'text', size: 12, value: dbus.webd_usr || "admin", suffix: ' ：' },
	//		{ name: 'webd_passwd', type: 'password', maxlen: 10, size: 12, value: dbus.webd_passwd||"koolshare" ,peekaboo:"1" }
	//	]},
		{ title: '允许外网访问',  name: 'webd_open',type:'checkbox', value: dbus.webd_open == 1 }
		]);
		
	</script>
	</div>
</div>
	<div id="pbr_basic_readme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">高级应用： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 当一个目录下的文件需要隐藏的时候, 可以在这个目录下新建一个0字节的 index.html 文件即可，之后可以通过类似 http://xxx:port/#/隐藏目录名/ 方式进行访问</li>	
			<li> 在文件列表中隐藏某个文件或文件夹，只要命令行下把某个文件重名名成点 . 开头的即可隐藏</li>	
			<li> 软件本身不支持虚拟目录, 但可以用操作系统的目录链接功能变相实现</li>	
			<li> 软件暂时没有权限管理，重要文件请谨慎开放公网访问</li>	
	</div>
	</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
