<title>软件中心 - UDPspeeder</title>
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
	 	url: "/_api/udpspeeder_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	dbus = data.result[0];
	  	}
	});
}

function get_run_status(){
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "udpspeeder_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("_udpspeeder_status").innerHTML = response.result;
			setTimeout("get_run_status();", 3000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("_udpspeeder_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}

function verifyFields(focused, quiet){
	if(E('_udpspeeder_enable').checked){
		$('input').prop('disabled', false);
		$('select').prop('disabled', false);
	}else{
		$('input').prop('disabled', true);
		$('select').prop('disabled', true);
		$(E('_udpspeeder_enable')).prop('disabled', false);
	}
	return true;
}

function toggleVisibility(whichone) {
	if(E('sesdiv' + whichone).style.display=='') {
		E('sesdiv' + whichone).style.display='none';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-up"></i>';
		cookie.set('ss_' + whichone + '_vis', 0);
	} else {
		E('sesdiv' + whichone).style.display='';
		E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-down"></i>';
		cookie.set('ss_' + whichone + '_vis', 1);
	}
}

function save(){
	var para_chk = ["udpspeeder_enable", "udpspeeder_disable_filter"];
	var para_inp = ["udpspeeder_local_server", "udpspeeder_local_port", "udpspeeder_remote_server", "udpspeeder_remote_port", "udpspeeder_password", "udpspeeder_mode", "udpspeeder_duplicate_nu", "udpspeeder_duplicate_time", "udpspeeder_jitter", "udpspeeder_report", "udpspeeder_drop", "udpspeeder_shell" ];
	// collect data from checkbox
	for (var i = 0; i < para_chk.length; i++) {
		dbus[para_chk[i]] = E('_' + para_chk[i] ).checked ? '1':'0';
	}
	// data from other element
	for (var i = 0; i < para_inp.length; i++) {
		console.log(E('_' + para_inp[i] ).value)
		if (!E('_' + para_inp[i] ).value){
			dbus[para_inp[i]] = "";
		}else{
			dbus[para_inp[i]] = E('_' + para_inp[i]).value;
		}
	}
	
	//-------------- post dbus to dbus ---------------
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method":'udpspeeder_config.sh', "params":["start"], "fields": dbus};
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
	<div class="heading">UDPspeeder 1.0.0<a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
	<div class="content">
		<span class="col" style="line-height:30px;width:700px">
		UDPspeeder是一个UDP双边加速工具，降低丢包率，配合vpn可以加速任何协议，尤其适用于加速游戏和网页打开速度；同时也是一个UDP连接的调试和统计工具。<br />
		本插件仅实现web配置UDPspeeder功能，开启操作仅配置好加速通道，要进一步成功加速udp协议，还需要手动配置通道的下游软件，比如：shadowsocks，openvpn等..<br />
		详细介绍和使用教程请查看：<a href="https://github.com/wangyu-/UDPspeeder/blob/master/README.md" target="_blank"><u> 官方说明文档</u></a>&nbsp;&nbsp;&nbsp;&nbsp;
		</span>
	</div>
</div>
<div class="box" style="margin-top: 0px;">
	<div class="heading">基本配置（*表示UDPspeeder程序参数）</div>
	<hr>
	<div class="content">
	<div id="udpspeeder-fields"></div>
	<script type="text/javascript">
		var mode = [['-c', '客户端模式'], ['-s', '服务器模式']];
		$('#udpspeeder-fields').forms([
		{ title: '开启udpspeeder', name: 'udpspeeder_enable', type: 'checkbox', value: dbus.udpspeeder_enable == 1},
		{ title: 'udpspeeder运行状态', text: '<font id="_udpspeeder_status" name=udpspeeder_status color="#1bbf35">正在获取运行状态...</font>' },
		{ title: '* 本地监听地址：端口 （-l）', multi: [
			{ name: 'udpspeeder_local_server',type:'text', size: 12, value: dbus.udpspeeder_local_server || "0.0.0.0", suffix: ' ：' },
			{ name: 'udpspeeder_local_port', type: 'text', maxlen: 5, size: 2, value: dbus.udpspeeder_local_port || "5566"}
		]},
		{ title: '* 服务器地址：端口 （-r）', multi: [
			{ name: 'udpspeeder_remote_server',type:'text', size: 12, value: dbus.udpspeeder_remote_server, suffix: ' ：' },
			{ name: 'udpspeeder_remote_port', type: 'text', maxlen: 5, size: 2, value: dbus.udpspeeder_remote_port||"8855" }
		]},
		{ title: '* 密码 （-k,--key）', name: 'udpspeeder_password', type: 'password', maxlen: 20, size: 5, value: dbus.udpspeeder_password,peekaboo: 1},
		{ title: '', suffix: '以下为包发送选项，两端设置可以不同。 只影响本地包发送。' },
		{ title: '* 运行模式 （-c/-s）', name: 'udpspeeder_mode', type: 'select', options:mode, value: dbus.udpspeeder_mode ||'-c' },
		{ title: '* 冗余包数量 （-d）', name: 'udpspeeder_duplicate_nu', type: 'text', maxlen: 5, size: 5, value: dbus.udpspeeder_duplicate_nu ||'0',suffix: ' 设置0表示不重复发包，设置1表示多发1个包，以此类推；必填。' },
		{ title: '* 冗余包发送延迟 （-t）', name: 'udpspeeder_duplicate_time', type: 'text', maxlen: 5, size: 5, value: dbus.udpspeeder_duplicate_time ||"",suffix: ' ① <number> 单位：0.1ms，默认20（2ms）；② tmin:tmax，允许设置最大值最小值，用随机延迟发送冗余包；留空则使用默认值。' },
		{ title: '* 原始数据抖动延迟 （-j）', name: 'udpspeeder_jitter', type: 'text', maxlen: 5, size: 5, value: dbus.udpspeeder_jitter ||"",suffix: ' ① <number> 范围:0 ~ 设置值*0.1 ms ； ② jmin:jmax，允许给jitter选项设置最大值最小值。在这个区间随机化jitter ；留空则不使用。' },
		{ title: '* 数据发送和接受报告 （--report）', name: 'udpspeeder_report', type: 'text', maxlen: 5, size: 5, value: dbus.udpspeeder_report ||"",suffix: ' 数据发送和接受报告，单位：秒。开启后可以根据此数据推测出包速和丢包率等特征；留空则不使用。' },
		{ title: '* 随机丢包 （--random-drop）', name: 'udpspeeder_drop', type: 'text', maxlen: 5, size: 5, value: dbus.udpspeeder_drop ||"",suffix: ' 单位：unit 0.01%，模拟恶劣的网络环境时使用。留空则不使用。' },
		{ title: '', suffix: '以下为包接收选项，两端设置可以不同。只影响本地包接受。' },
		{ title: '* 关闭重复包过滤器 （--disable-filter）', name: 'udpspeeder_disable_filter', type: 'checkbox', value: dbus.udpspeeder_disable_filter == 1,suffix: ' 配合-d 选项可以模拟有重复包的网络环境。' },
		{ title: '自定义触发脚本', name: 'udpspeeder_shell', type: 'text', size: 66, value: dbus.udpspeeder_shell ||"",suffix: ' 填写带绝对路径的shell脚本文件。UDPspeeder进程开启后会触发脚本启动，方便对ss，openvpn等进行操作，留空不使用该功能' }
		]);
		$('#_udpspeeder_enable').parent().parent().css("margin-left","-10px");
		$('#_udpspeeder_disable_filter').parent().parent().css("margin-left","-10px");
	</script>
	</div>
</div>
	<div class="box">
		<div class="heading">UDPspeeder加速SS游戏模式udp的简要操作手册： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('UDPspeeder');"><span id="sesdivUDPspeedershowhide"><i class="icon-chevron-up"></i></span></a></div>
		<div class="section content" id="sesdivUDPspeeder" style="display:none">
			<li>根据<a href="https://github.com/wangyu-/UDPspeeder/blob/master/README.md" target="_blank"><u> 官方说明文档</u></a>配置好服务器端程序；</li>
			<li>比如你正在使用SS游戏模式，此时用命令ps | grep ss-redir 可以查看到相关进程。</li>
			<li>例如查看进程找到【ss-redir -b 0.0.0.0 -c /koolshare/ss/ss.json -u -f /var/run/shadowsocks.pid】此条；</li>
			<li>该进程同时承载了ss的tcp和udp流量，需要将tcp和udp分开成两个进程，方便运行UDPspeeder单独加速udp，用命令killall ss-redir 将进程杀死，然后运行下面两个命令重新启动ss-redir；</li>
			<li>命令1（运行ss-redir转发tcp流量，去掉原命令 -u选项）：ss-redir -b 0.0.0.0 -c /koolshare/ss/ss.json -f /var/run/shadowsocks.pid</li>
			<li>命令2（运行ss-redir转发udp流量，去掉原命令 -u选项，加上 -U选项，并加上 -s 127.0.0.1）：ss-redir -b 0.0.0.0 -s 127.0.0.1 -c /koolshare/ss/ss.json -U -f /var/run/shadowsocks.pid</li>
			<li>假如你的ss服务器端口是2345，接下来可以在本插件里填写[本地监听地址：端口]为 0.0.0.0:2345；[填写服务器地址：端口]为 vps_ip:2345；</li>
			<li>选择客户端模式，并填写其它参数（除了密码外，其它参数服务器和客户端可以不一致）后点击保存，即可加速游戏模式的udp流量了。</li>
			<li>你可以自己配置触发脚本来实现以上功能；</li>
		</div>
		<script>
			var cc;
			if(!cookie.get('ss_UDPspeeder_vis')){
				cookie.set('ss_UDPspeeder_vis', 1);
			}
			if (((cc = cookie.get('ss_UDPspeeder_vis')) != null) && (cc == '1')) {
				toggleVisibility("UDPspeeder");
			}
		</script>
	</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
