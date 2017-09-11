<title>软件中心 - Server酱</title>
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
		if (typeof btoa == "Function") {
			Base64 = {
				encode: function(e) {
					return btoa(e);
				},
				decode: function(e) {
					return atob(e);
				}
			};
		} else {
			Base64 = {
				_keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
				encode: function(e) {
					var t = "";
					var n, r, i, s, o, u, a;
					var f = 0;
					e = Base64._utf8_encode(e);
					while (f < e.length) {
						n = e.charCodeAt(f++);
						r = e.charCodeAt(f++);
						i = e.charCodeAt(f++);
						s = n >> 2;
						o = (n & 3) << 4 | r >> 4;
						u = (r & 15) << 2 | i >> 6;
						a = i & 63;
						if (isNaN(r)) {
							u = a = 64
						} else if (isNaN(i)) {
							a = 64
						}
						t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a)
					}
					return t
				},
				decode: function(e) {
					var t = "";
					var n, r, i;
					var s, o, u, a;
					var f = 0;
					if (typeof(e) == "undefined"){
						return t = "";
					}
					e = e.replace(/[^A-Za-z0-9\+\/\=]/g, "");
					while (f < e.length) {
						s = this._keyStr.indexOf(e.charAt(f++));
						o = this._keyStr.indexOf(e.charAt(f++));
						u = this._keyStr.indexOf(e.charAt(f++));
						a = this._keyStr.indexOf(e.charAt(f++));
						n = s << 2 | o >> 4;
						r = (o & 15) << 4 | u >> 2;
						i = (u & 3) << 6 | a;
						t = t + String.fromCharCode(n);
						if (u != 64) {
							t = t + String.fromCharCode(r)
						}
						if (a != 64) {
							t = t + String.fromCharCode(i)
						}
					}
					t = Base64._utf8_decode(t);
					return t
				},
				_utf8_encode: function(e) {
					e = e.replace(/\r\n/g, "\n");
					var t = "";
					for (var n = 0; n < e.length; n++) {
						var r = e.charCodeAt(n);
						if (r < 128) {
							t += String.fromCharCode(r)
						} else if (r > 127 && r < 2048) {
							t += String.fromCharCode(r >> 6 | 192);
							t += String.fromCharCode(r & 63 | 128)
						} else {
							t += String.fromCharCode(r >> 12 | 224);
							t += String.fromCharCode(r >> 6 & 63 | 128);
							t += String.fromCharCode(r & 63 | 128)
						}
					}
					return t
				},
				_utf8_decode: function(e) {
					var t = "";
					var n = 0;
					var r = c1 = c2 = 0;
					while (n < e.length) {
						r = e.charCodeAt(n);
						if (r < 128) {
							t += String.fromCharCode(r);
							n++
						} else if (r > 191 && r < 224) {
							c2 = e.charCodeAt(n + 1);
							t += String.fromCharCode((r & 31) << 6 | c2 & 63);
							n += 2
						} else {
							c2 = e.charCodeAt(n + 1);
							c3 = e.charCodeAt(n + 2);
							t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63);
							n += 3
						}
					}
					return t
				}
			}
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/serverchan_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
					$('#_serverchan_version').html( '<a style="margin-left:-4px" href="https://github.com/koolshare/ledesoft/blob/master/serverchan/Changelog.txt" target="_blank"><font color="#0099FF">Server酱  ' + (dbus["serverchan_version"]  || "") + '</font></a>' );
			  	}
			});
		}
		
		function verifyFields(focused, quiet){
			if(E('_serverchan_enable').checked){
				$('input').prop('disabled', false);
			}else{
				$('input').prop('disabled', true);
				$(E('_serverchan_enable')).prop('disabled', false);
			}
			var a = E('_serverchan_enable').checked;
			E('_serverchan_status_check').disabled = !a;
			
			var f = (E('_serverchan_status_check').value == '1');
			var g = (E('_serverchan_status_check').value == '2');
			
			elem.display('_serverchan_check_time_pre', a && f);
			elem.display('_serverchan_check_time_hour', a && f);
			elem.display('_serverchan_check_time_min', a && f);
			elem.display('_serverchan_check_time_suf', a && f);
			
			elem.display('_serverchan_check_inter_pre', a && g);
			elem.display('_serverchan_check_inter_hour', a && g);
			elem.display('_serverchan_check_inter_min', a && g);
			elem.display('_serverchan_check_inter_suf', a && g);

			
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
		
		function save(s){
			//collect data from checkbox
			var para_chk = ["serverchan_enable", "serverchan_info_system", "serverchan_info_temp", "serverchan_info_wan", "serverchan_info_lan", "serverchan_info_lan_macoff",
							"serverchan_info_ss", "serverchan_info_softcenter", "serverchan_trigger_ifup", "serverchan_trigger_dhcp", "serverchan_trigger_dhcp_macoff"];
			for (var i = 0; i < para_chk.length; i++) {
				dbus[para_chk[i]] = E('_' + para_chk[i] ).checked ? '1':'0';
			}
			//data from other element
			var para_inp = ["serverchan_sckey", "serverchan_info_title", "serverchan_status_check", "serverchan_check_time_hour", "serverchan_check_time_min", "serverchan_check_inter_hour", "serverchan_check_inter_min"];
			for (var i = 0; i < para_inp.length; i++) {
				if (!E('_' + para_inp[i] ).value){
					dbus[para_inp[i]] = "";
				}else{
					dbus[para_inp[i]] = E('_' + para_inp[i]).value;
				}
			}
			if(s == 1){
				arg="manual"
			}else{
				arg="start"
			}
			//-------------- post dbus to dbus ---------------
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method":'serverchan_config', "params":[arg], "fields": dbus};
			var success = function(data) {
				if (s == 1){
					$('#send-msg').text(data.result);
					$('#send-msg').show();
					setTimeout("$('#send-msg').hide()", 2000);
				}else{
					$('#footer-msg').text(data.result);
					$('#footer-msg').show();
					setTimeout("window.location.reload()", 1000);
				}
			};
			if (s == 1){
				$('#send-msg').text('发送中……');
				$('#send-msg').show();
			}else{
				$('#footer-msg').text('保存中……');
				$('#footer-msg').show();
				$('button').addClass('disabled');
				$('button').prop('disabled', true);
			}
			$.ajax({
			  type: "POST",
			  url: "/_api/",
			  data: JSON.stringify(postData),
			  success: success,
			  dataType: "json"
			});
		}
		/*
		function send_message(){
			// var para_inp = [""];
			// for (var i = 0; i < para_inp.length; i++) {
			// 	if (!E('_' + para_inp[i] ).value){
			// 		dbus[para_inp[i]] = "";
			// 	}else{
			// 		dbus[para_inp[i]] = E('_' + para_inp[i]).value;
			// 	}
			// }
			// data need base64 encode
			var paras_base64 = ["serverchan_send_title", "serverchan_send_content"];
			for (var i = 0; i < paras_base64.length; i++) {
				if (typeof(E('_' + paras_base64[i] ).value) == "undefined"){
					dbus[paras_base64[i]] = "";
				}else{
					dbus[paras_base64[i]] = Base64.encode(E('_' + paras_base64[i]).value);
				}
			}
			//-------------- post dbus to dbus ---------------
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method":'serverchan_config', "params":["send"], "fields": dbus};
			var success = function(data) {
				$('#send-msg').text(data.result);
				$('#send-msg').show();
				setTimeout("window.location.reload()", 1000);
			};
			$('#send-msg').text('发送中……');
			$('#send-msg').addClass('height:35px');
			$('#send-msg').show();
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

		XHR.poll(10, '/cgi-bin/luci/admin/network/iface_status/lan,wan', null,
			function(x, ifcs)
			{
				if (ifcs)
				{
					for (var idx = 0; idx < ifcs.length; idx++)
					{
						var ifc = ifcs[idx];
						console.log(ifc)
					}
				}
			}
		);
	*/
		
	</script>
<div class="box">
	<div class="heading">
		<span id="_serverchan_version"><font color="#1bbf35"></font></span>
		<a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
	</div>
	<div class="content">
		<span class="col" style="line-height:30px;width:700px">
		「Server酱」，英文名「ServerChan」，是一款「程序员」和「服务器」之间的通信软件。说人话？就是从服务器推报警和日志到手机的工具。&nbsp;&nbsp;<a href="http://sc.ftqq.com/3.version" target="_blank">「Server酱官方网站」</a><br />
		&nbsp;&nbsp;开通并使用上它，只需要一分钟：<br />
		<li>登入：用GitHub账号<a href="http://sc.ftqq.com/?c=github&a=login" target="_blank">登入网站</a>，就能获得一个<a href="http://sc.ftqq.com/?c=code" target="_blank"><u> SCKEY</u></a>；</li>
		<li>绑定：点击「<a href="http://sc.ftqq.com/?c=wechat&a=bind" target="_blank">微信推送</a>」，扫码关注同时即可完成绑定；</li>
		<li>发消息：通过本插件的消息发送窗口，或者定制消息定时发送任务；</li>
		</span>
	</div>
</div>

<div class="box" style="margin-top: 0px;">
	<div class="heading">Server酱配置</div>
	<hr>
	<div class="content">
	<div id="serverchan1-fields"></div>
	<script type="text/javascript">
		$('#serverchan1-fields').forms([
		{ title: '开启serverchan', name: 'serverchan_enable', type: 'checkbox', value: dbus.serverchan_enable == 1},
		{ title: 'SCKEY', name: 'serverchan_sckey', type: 'password', maxlen: 20, size: 65, value: dbus.serverchan_sckey,peekaboo: 1}
		]);
		$('#_serverchan_enable').parent().parent().css("margin-left","-10px");
	</script>
	</div>
</div>

<div class="box" style="margin-top: 0px;">
	<div class="heading">定时发送状态消息 (长消息)</div>
	<hr>
	<div class="content">
	<div id="serverchan2-fields"></div>
	<script type="text/javascript">
		var option_check_time_hour = [];
		var option_check_time_min = [];
		var option_check_inter_hour = [];
		var option_check_inter_min = [];
		for(var i = 0; i < 24; i++){
			option_check_time_hour[i] = [i, i + "时"];
		}
		for(var i = 0; i < 60; i++){
			option_check_time_min[i] = [i, i + "分"];
		}
		for(var i = 0; i <= 72; i++){
			option_check_inter_hour[i] = [i, i + "时"];
		}
		for(var i = 0; i < 60; i++){
			option_check_inter_min[i] = [i, i + "分"];
		}
		$('#serverchan2-fields').forms([
		{ title: '微信推送标题', name: 'serverchan_info_title', type: 'text', size: 55, value: dbus.serverchan_info_title ||"Lede X64 V2.2 路由状态消息：" },
		{ title: '定时任务设定', multi: [
			{ name:'serverchan_status_check',type:'select',options:[['1','定时'],['2','间隔'],['0','关闭']],value: dbus.serverchan_status_check || "2", suffix: ' &nbsp;&nbsp;' },
			{ name: 'serverchan_check_time_hour', type: 'select', options: option_check_time_hour, value: dbus.serverchan_check_time_hour || "11", prefix: '<span id="_serverchan_check_time_pre" class="help-block"><lable>每天</lable></span>', suffix: ' &nbsp;&nbsp;' },
			{ name: 'serverchan_check_time_min', type: 'select', options: option_check_time_min, value: dbus.serverchan_check_time_min || "30", suffix: '<lable id="_serverchan_check_time_suf">发送</lable>' },
			{ name: 'serverchan_check_inter_hour', type: 'select', options: option_check_inter_hour, value: dbus.serverchan_check_inter_hour || "6", prefix: '<span id="_serverchan_check_inter_pre" class="help-block"><lable>每隔</lable></span>', suffix: ' &nbsp;&nbsp;' },
			{ name: 'serverchan_check_inter_min', type: 'select', options: option_check_inter_min, value: dbus.serverchan_check_inter_min || "0", suffix: '<lable id="_serverchan_check_inter_suf">发送</lable>' }
		]},
		{ title: '系统运行情况', name: 'serverchan_info_system', type: 'checkbox', value: dbus.serverchan_info_system == 1 },
		{ title: '设备温度', name: 'serverchan_info_temp', type: 'checkbox', value: dbus.serverchan_info_temp == 1 },
		{ title: 'wan信息', name: 'serverchan_info_wan', type: 'checkbox', value: dbus.serverchan_info_wan == 1 },
		{ title: '客户端列表', multi: [
			{ name: 'serverchan_info_lan', type: 'checkbox', value: dbus.serverchan_info_lan == 1 },
			{ suffix: ' &nbsp;&nbsp;关闭mac地址显示' },
			{ name: 'serverchan_info_lan_macoff', type: 'checkbox', value: dbus.serverchan_info_lan_macoff == 1 }
		]},
		{ title: '$$状态', name: 'serverchan_info_ss', type: 'checkbox', value: dbus.serverchan_info_ss == 1 },
		{ title: '软件中心插件信息', name: 'serverchan_info_softcenter', type: 'checkbox', value: dbus.serverchan_info_softcenter == 1 }
		]);
		$('#_serverchan_info_system').parent().parent().css("margin-left","-10px");
		$('#_serverchan_info_temp').parent().parent().css("margin-left","-10px");
		$('#_serverchan_info_wan').parent().parent().css("margin-left","-10px");
		$('#_serverchan_info_lan').parent().parent().css("margin-left","-10px");
		$('#_serverchan_info_ss').parent().parent().css("margin-left","-10px");
		$('#_serverchan_info_softcenter').parent().parent().css("margin-left","-10px");
	</script>
	<button type="button" value="Save" id="send-button" onclick="save('1')" class="btn btn-primary" style="float:right;">手动推送 <i class="icon-check"></i></button>
	<span id="send-msg" style="display: block;height:35px;background:transparent;border: 0px solid #FFFFFF;float:right; margin-right:30px;margin-top:8px;"></span>
	</div>
</div>

<div class="box" style="margin-top: 0px;">
	<div class="heading">触发发送通知消息 (短消息)</div>
	<hr>
	<div class="content">
	<div id="serverchan3-fields"></div>
	<script type="text/javascript">
		$('#serverchan3-fields').forms([
		{ title: '网络重拨时', name: 'serverchan_trigger_ifup', type: 'checkbox', value: dbus.serverchan_trigger_ifup == 1 },
		{ title: '设备上线时', multi: [
			{ name: 'serverchan_trigger_dhcp', type: 'checkbox', value: dbus.serverchan_trigger_dhcp == 1 },
			{ suffix: ' &nbsp;&nbsp;关闭mac地址显示' },
			{ name: 'serverchan_trigger_dhcp_macoff', type: 'checkbox', value: dbus.serverchan_trigger_dhcp_macoff == 1 },
		]},
		]);
		$('#_serverchan_trigger_ifup').parent().parent().css("margin-left","-10px");
		$('#_serverchan_trigger_dhcp').parent().parent().css("margin-left","-10px");
	</script>
	</div>
</div>
<!--
<div class="box" style="margin-top: 0px;">
	<div class="heading">消息发送测试工具</div>
	<hr>
	<div class="content">
	<div id="serverchan4-fields"></div>
	<script type="text/javascript">
		var date = new Date();
		var year = date.getFullYear();
		var month = date.getMonth()+1;
		var day = date.getDate();
		var hour = date.getHours();
		var minute = date.getMinutes();
		var second = date.getSeconds();
		if(hour <=9){
			hour = "0" + hour;
		}
		if(minute <=9){
			minute = "0" + minute;
		}
		if(second <=9){
			second = "0" + second;
		}
		var my_date = year + '年' + month + '月' + day + '日 ' + hour + ':'  + minute + ':' + second;
		$('#serverchan4-fields').forms([
		{ title: '消息标题', name: 'serverchan_send_title', type: 'text', maxlen: 5, size: 65, value:my_date },
		{ title: '消息内容', name: 'serverchan_send_content', type: 'textarea', value: Base64.decode(dbus.serverchan_send_content)||"" ||"" , style: 'width: 440px; height:150px;' }
		]);
	</script>
	<button type="button" value="Save" id="send-button" onclick="send_message()" class="btn btn-primary">发送消息 <i class="icon-check"></i></button>
	<span id="send-msg" class="alert alert-warning" style="display: none;height:35px;"></span>
	</div>
</div>-->

<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
