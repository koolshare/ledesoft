<title>sgame</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
.box {
	min-width:540px;
}
</style>
	<script type="text/javascript">
		var dbus;
		get_dbus_data();
		var _responseLen;
		var noChange = 0;
		var x = 4;
		var wans_value =[];
		var status_time = 1;
		var ssbasic = ["server", "port", "password", "mtu", "token" ];
		var option_mode = [['1', '全局模式'], ['2', '大陆白名单'], ['3', '自定义黑名单']];
		var option_dns_china = [['1', '运营商DNS【自动获取】'],  ['2', '阿里DNS1【223.5.5.5】'],  ['3', '阿里DNS2【223.6.6.6】'],  ['4', '114DNS1【114.114.114.114】'],  
								['5', '114DNS1【114.114.115.115】'],  ['6', 'cnnic DNS【1.2.4.8】'],  ['7', 'cnnic DNS【210.2.4.8】'],  ['8', 'oneDNS1【112.124.47.27】'],  
								['9', 'oneDNS2【114.215.126.16】'],  ['10', '百度DNS【180.76.76.76】'],  ['11', 'DNSpod DNS【119.29.29.29】'],  ['12', '自定义']];
		var option_sgame_dns_foreign = [['2', 'google dns\[8.8.8.8\]'], ['3', 'google dns\[8.8.4.4\]'], ['1', 'OpenDNS\[208.67.220.220\]'], ['4', '自定义']];
		var softcenter = 0;

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
		//============================================
		function init_sgame(){
			tabSelect('app1');
			verifyFields();
			$("#_sgame_basic_log").click(
				function() {
					x = 10000000;
			});
			show_hide_panel();
			set_version();
			get_wans_list();
			setTimeout("get_run_status();", 2000);
		}

		function set_version(){
			$('#_sgame_version').html( '<font color="#1bbf35">ShadowVPN for LEDE - 游戏加速器 ' + (dbus["sgame_version"]  || "") + '</font></a>' );
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/sgame",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}
		
		function get_run_status(){
			if (status_time > 99999){
				return false;
			}
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "sgame_status.sh", "params":[3], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					if(softcenter == 1){
						return false;
					}
					++status_time;
					if (response.result == '-2'){
						E("_sgame_basic_status_bin").innerHTML = "获取运行状态失败！";
						E("_sgame_basic_status_foreign").innerHTML = "获取运行状态失败！";
						E("_sgame_basic_status_china").innerHTML = "获取运行状态失败！";
						setTimeout("get_run_status();", 5000);
					}else{
						if(dbus["sgame_basic_enable"] != "1"){
							E("_sgame_basic_status_bin").innerHTML = "ShadowVPN - 尚未提交，暂停获取状态！";
							E("_sgame_basic_status_foreign").innerHTML = "国外链接 - 尚未提交，暂停获取状态！";
							E("_sgame_basic_status_china").innerHTML = "国内链接 - 尚未提交，暂停获取状态！";
						}else{
							E("_sgame_basic_status_bin").innerHTML = response.result.split("@@")[0];
							E("_sgame_basic_status_foreign").innerHTML = response.result.split("@@")[1];
							E("_sgame_basic_status_china").innerHTML = response.result.split("@@")[2];
						}
						setTimeout("get_run_status();", 5000);
					}
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					E("_sgame_basic_status_bin").innerHTML = "获取运行状态失败！";
					E("_sgame_basic_status_foreign").innerHTML = "获取运行状态失败！";
					E("_sgame_basic_status_china").innerHTML = "获取运行状态失败！";
					setTimeout("get_run_status();", 5000);
				}
			});
		}

		function mwan_set(){
			for ( var i = 0; i < wans.length; ++i ) {
				$("#_sgame_wan_china").append("<option value='"  + wans[i][0] + "'>" + wans[i][0] + "</option>");
				$("#_sgame_wan_foreign").append("<option value='"  + wans[i][0] + "'>" + wans[i][0] + "</option>");
			}
			// fill the 3 input
			if(wans.length > 1){
				E("_sgame_wan_china").value = dbus["sgame_wan_china"] || "0";
				E("_sgame_wan_foreign").value = dbus["sgame_wan_foreign"] || "0";
			}else if (wans.length == 0){
				E("_sgame_wan_china").value = "0";
				E("_sgame_wan_foreign").value = "0";
			}else{
				E("_sgame_wan_china").value = wans[0][0];
				E("_sgame_wan_foreign").value = wans[0][0];
			}
			for ( var i = 0; i < wans.length; ++i ) {
				wans_value[i] = wans[i][0];
			}
		}

		function get_wans_list(){
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "sgame_getwans.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData3),
				dataType: "json",
				success: function(response){
					if (response.result != "-1"){
						wans = eval(Base64.decode(response.result));
						wans  = wans.sort();
						if(wans.length > 1){
							wans.unshift(["0","不指定"]);
						}else if (wans.length == 0){
							wans = [["0","不指定"]];
						}
						console.log("当前接口信息(主用)：", wans);
						mwan_set();
					}
				},
				error:function(){
					get_wans_list2();
				},
				timeout:1000
			});
		}
		
		function get_wans_list2(){
			XHR.get('/cgi-bin/luci/admin/network/mwan/overview/interface_status', null,
				function(x, mArray){
					if (mArray.wans){
						for ( var i = 0; i < mArray.wans.length; i++ ){
							if(mArray.wans[i].status == "online"){
								var wans2_temp = [];
								wans2_temp[0] = mArray.wans[i].ifname
								wans2_temp[1] = mArray.wans[i].name
								wans2.push(wans2_temp);
							}
						}
						wans2 = wans2.sort();
                        if(wans2.length > 1){
                            wans2.unshift(["0","不指定"]);
                        }else if (wans2.length == 0){
                            wans2 = [["0","不指定"]];
                        }
                        console.log("当前接口信息(备用)：", wans2);
                        wans = wans2;
                        mwan_set();
					}else{
						statusDiv.innerHTML = '<strong>没有找到 MWAN 接口</strong>';
						alert("没有找到任何可用的wan接口！\n 请检查你的网络接口设置！")
					}
				}
			);
		}

		function show_hide_panel(){
			var a  = E('_sgame_basic_enable').checked;
			var b  = E('_sgame_udp_enable').checked;
			elem.display('sgame_status_pannel', a);
			elem.display('sgame_tabs', a);
			elem.display('sgame_basic_tab', a);
			elem.display('sgame_basic_udppannel', a&&b);
			elem.display('sgame_basic_tab2', a&&b);
		}

		function verifyFields(r){
			if (E("_sgame_dns_plan").value == "1"){
				$('#_sgame_dns_plan_txt').html("国外dns解析gfwlist名单内的国外域名，剩下的域名用国内dns解析。 ")
			}else if (E("_sgame_dns_plan").value == "2"){
				$('#_sgame_dns_plan_txt').html("国内dns解析cdn名单内的国内域名用，剩下的域名用国外dns解析。<font color='#FF3300'>推荐！</font> ")
			}
			// when check/uncheck sgame_switch
			var a  = E('_sgame_basic_enable').checked;
			if ( $(r).attr("id") == "_sgame_basic_enable" ) {
				if(a){
					elem.display('sgame_status_pannel', a);
					elem.display('sgame_tabs', a);
					tabSelect('app1')
				}else{
					tabSelect('fuckapp')
				}
			}
			
			var b  = E('_sgame_dns_china').value == '12';
			elem.display('_sgame_dns_china_user', b);
			
			var c  = E('_sgame_dns_foreign').value == '4';
			elem.display('_sgame_dns_foreign_user', c);
			
			var d  = E('_sgame_udp_enable').checked;
			elem.display('sgame_basic_tab2', d);
			elem.display('sgame_basic_udppannel', d);

			return true;
		}
		function tabSelect(obj){
			var tableX = ['app1-tab', 'app2-tab','app3-tab','app4-tab','app5-tab','app6-tab'];
			var boxX = ['boxr1','boxr2','boxr3','boxr4','boxr5','boxr6'];
			var appX = ['app1','app2','app3','app4','app5','app6'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app6'){
				elem.display('save-button', false);
				elem.display('cancel-button', false);
				noChange=0;
				setTimeout("get_log();", 200);
			}else if(obj=='app1'){
				var d  = E('_sgame_udp_enable').checked;
				elem.display('sgame_basic_tab2', d);
				elem.display('sgame_basic_udppannel', d);
			}else{
				elem.display('save-button', true);
				elem.display('cancel-button', true);
				noChange=2001;
			}
			if(obj=='fuckapp'){
				elem.display('sgame_status_pannel', false);
				elem.display('sgame_tabs', false);
				elem.display('sgame_basic_tab', false);
				elem.display('sgame_basic_tab2', false);
				elem.display('sgame_wblist_tab', false);
				elem.display('sgame_dns_tab', false);
				elem.display('sgame_log_tab', false);
				E('save-button').style.display = "";
			}
		}
		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}

		function save(){
			setTimeout("tabSelect('app6')", 500);
			status_time = 999999990;
			get_run_status();
			E("_sgame_basic_status_bin").innerHTML = "ShadowVPN - 提交中...暂停获取状态！";
			E("_sgame_basic_status_foreign").innerHTML = "国外链接 - 提交中...暂停获取状态！";
			E("_sgame_basic_status_china").innerHTML = "国内链接 - 提交中...暂停获取状态！";
			var paras_chk = ["sgame_basic_enable", "sgame_udp_enable", "sgame_udp_disableobscure"];
			var paras_inp = ["sgame_basic_server", "sgame_basic_port", "sgame_basic_password", "sgame_basic_mode", "sgame_basic_subnet", "sgame_basic_mtu", "sgame_basic_token", "sgame_dns_plan", "sgame_dns_china", "sgame_dns_china_user", "sgame_dns_foreign", "sgame_dns_foreign_user", "sgame_wan_china", "sgame_wan_foreign", "sgame_udp_server", "sgame_udp_port", "sgame_udp_password", "sgame_udp_fec", "sgame_udp_timeout", "sgame_udp_mode", "sgame_udp_report", "sgame_udp_mtu", "sgame_udp_jitter", "sgame_udp_interval", "sgame_udp_drop", "sgame_udp_other" ];
			// collect data from checkbox
			for (var i = 0; i < paras_chk.length; i++) {
				dbus[paras_chk[i]] = E('_' + paras_chk[i] ).checked ? '1':'0';
			}
			// data from other element
			for (var i = 0; i < paras_inp.length; i++) {
				if (!E('_' + paras_inp[i] ).value){
					dbus[paras_inp[i]] = "";
				}else{
					dbus[paras_inp[i]] = E('_' + paras_inp[i]).value;
				}
			}
			// data need base64 encode
			var paras_base64 = [ "sgame_wan_black_ip", "sgame_dnsmasq"];
			for (var i = 0; i < paras_base64.length; i++) {
				if (typeof(E('_' + paras_base64[i] ).value) == "undefined"){
					dbus[paras_base64[i]] = "";
				}else{
					dbus[paras_base64[i]] = Base64.encode(E('_' + paras_base64[i]).value);
				}
			}
			// now post data
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "sgame_config.sh", "params":[1], "fields": dbus};
			showMsg("msg_warring","正在提交数据！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				type: "POST",
				async:true,
				cache:false,
				dataType: "json",
				data: JSON.stringify(postData),
				success: function(response){
					if (response.result == id){
						if(E('_sgame_basic_enable').checked){
							showMsg("msg_success","提交成功","<b>成功提交数据</b>");
							$('#msg_warring').hide();
							setTimeout("$('#msg_success').hide()", 500);
							x = 4;
							count_down_switch();
						}else{
							// when shut down ss finished, close the log tab
							$('#msg_warring').hide();
							showMsg("msg_success","提交成功","<b>sgame成功关闭！</b>");
							setTimeout("$('#msg_success').hide()", 4000);
							setTimeout("tabSelect('fuckapp')", 4000);
						}
					}else{
						$('#msg_warring').hide();
						showMsg("msg_error","提交失败","<b>提交数据失败！错误代码：" + response.result + "</b>");
						setTimeout("window.location.reload()", 500);
					}
				},
				error: function(){
					showMsg("msg_error","失败","<b>当前系统存在异常查看系统日志！</b>");
					status_time = 1;
				}
			});
		}

		function get_log(){
			$.ajax({
				url: '/_temp/sgame_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(response) {
					var retArea = E("_sgame_basic_log");
					if (response.search("XU6J03M6") != -1) {
						retArea.value = response.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						return true;
					}
					if (_responseLen == response.length) {
						noChange++;
					} else {
						noChange = 0;
					}
					if (noChange > 2000) {
						//tabSelect("app1");
						return false;
					} else {
						setTimeout("get_log();", 100); //100 is radical but smooth!
					}
					retArea.value = response;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLen = response.length;
				},
				error: function() {
					E("_sgame_basic_log").value = "获取日志失败！";
				}
			});
		}
		function count_down_switch() {
			if (x == "0") {
				setTimeout("window.location.reload()", 500);
			}
			if (x < 0) {
				return false;
			}
				--x;
			setTimeout("count_down_switch();", 500);
		}
		function manipulate_conf(script, arg){
			var dbus3 = {};
			if(arg == 2 || arg == 4 || arg == 5){
				tabSelect("app6");
			}
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[arg], "fields": [] };
			$.ajax({
				type: "POST",
				url: "/_api/",
				async: true,
				cache:false,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function(response){
					if (script == "sgame_config.sh"){
						if(arg == 2 || arg == 4){
							setTimeout("window.location.reload()", 800);
						}else if (arg == 3){
							var a = document.createElement('A');
							a.href = "/files/sgame_conf_backup.sh";
							a.download = 'sgame_conf_backup.sh';
							document.body.appendChild(a);
							a.click();
							document.body.removeChild(a);
						}else if (arg == 5){
							var b = document.createElement('A')
							b.href = "/files/sgame.tar.gz"
							b.download = 'sgame.tar.gz'
							document.body.appendChild(b);
							b.click();
							document.body.removeChild(b);
							x=10;
							count_down_switch();
						}
					}
				}
			});
		}
		function restore_conf(){
			var filename = $("#file").val();
			filename = filename.split('\\');
			filename = filename[filename.length-1];
			var filelast = filename.split('.');
			filelast = filelast[filelast.length-1];
			if(filelast !='sh'){
				alert('配置文件格式不正确！');
				return false;
			}
			var formData = new FormData();
			formData.append('sgame_conf_backup.sh', $('#file')[0].files[0]);
			$('.popover').html('正在恢复，请稍后……');
			//changeButton(true);
			$.ajax({
				url: '/_upload',
				type: 'POST',
				async: true,
				cache:false,
				data: formData,
				processData: false,
				contentType: false,
				complete:function(res){
					if(res.status==200){
						manipulate_conf('sgame_config.sh', 4);
					}
				}
			});
		}
	</script>
	<div class="box">
		<div class="heading">
			<span id="_sgame_version"></span>
			<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
		</div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
			ShadowVPN是针对UDP发包和nat类型优化的游戏加速软件。<br />
			你需要安装ShadowVPN服务端程序。
			<a href="http://firmware.koolshare.cn/binary/tools/" target="_blank"> 【nat测试工具下载】 </a>
		</div>
	</div>
	<div class="box" style="margin-top: 0px;min-width:540px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="sgame_switch_pannel" class="section"></div>
			<script type="text/javascript">
				$('#sgame_switch_pannel').forms([
					{ title: '游戏加速开关', name:'sgame_basic_enable',type:'checkbox',  value: dbus.sgame_basic_enable == 1 }  // ==1 means default close; !=0 means default open
				]);
			</script>
			<hr />
			<fieldset id="sgame_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">游戏加速运行状态</label>
				<div class="col-sm-9">
					<font id="_sgame_basic_status_bin" name="sgame_basic_status_bin" color="#1bbf35">ShadowVPN: waiting...</font>
				</div>
				<div class="col-sm-9" style="margin-top:2px">
					<font id="_sgame_basic_status_china" name="sgame_basic_status_china" color="#1bbf35">国内链接: waiting...</font><br><font id="_sgame_basic_status_foreign" name="sgame_basic_status_foreign" color="#1bbf35">国外链接: waiting...</font>
				</div>
			</fieldset>
		</div>
	</div>
	<ul id="sgame_tabs" class="nav nav-tabs" style="min-width:540px;">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active"><i class="icon-system"></i> 帐号设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab"><i class="icon-tools"></i> DNS设定</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab"><i class="icon-warning"></i> 黑白名单</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app5');" id="app5-tab"><i class="icon-wake"></i> 附加设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app6');" id="app6-tab"><i class="icon-hourglass"></i> 查看日志</a></li>	
	</ul>
	<div class="box boxr1" id="sgame_basic_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="sgame_basic_pannel" class="section"></div>
			<script type="text/javascript">
				$('#sgame_basic_pannel').forms([
					{ title: '加速模式', name:'sgame_basic_mode',type:'select',options:option_mode,value: dbus.sgame_basic_mode || "2" },
					{ title: 'ShadowVPN 服务器地址', multi: [
						{ name:'sgame_basic_server',type:'text',size: 20,value: dbus.sgame_basic_server || "2", suffix: ' &nbsp;&nbsp;端口：'},
						{ name: 'sgame_basic_port',type:'text',size: 6,value:dbus.sgame_basic_port || "4031"},
					],help: '尽管支持域名格式，但是仍然建议首先使用IP地址。'},
					{ title: 'ShadowVPN 连接密码', name:'sgame_basic_password',type:'password',size: 20,maxLength:30,value:dbus.sgame_basic_password,help: '如果你的密码内有特殊字符，可能会导致密码参数不能正确的传给配置文件，导致启动后不能使用加速器。',peekaboo: 1  },
					{ title: '本地子网', name:'sgame_basic_subnet',type:'text',size: 18,value:dbus.sgame_basic_subnet|| "10.7.0.2/24" },
					{ title: 'MTU', name:'sgame_basic_mtu',type:'text',size: 4,value: dbus.sgame_basic_mtu || "1432",help: '和服务器上设置一致。' },
					{ title: 'Token', name:'sgame_basic_token',type:'text',size: 20,value: dbus.sgame_basic_token ,help: '单用户留空不要填写。' },
					{ title: '国内出口', name:'sgame_wan_china',type:'select',options:[],value: dbus.sgame_wan_china },
					{ title: 'VPN出口', name:'sgame_wan_foreign',type:'select',options:[],value: dbus.sgame_wan_foreign },
					{ title: '开启UDPspeederV2加速', name:'sgame_udp_enable',type:'checkbox',  value: dbus.sgame_udp_enable == 1 },
				]);
			</script>
		</div>
	</div>
	<div class="box boxr1" id="sgame_basic_tab2" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="sgame_basic_udppannel" class="section"></div>
			<script type="text/javascript">
				$('#sgame_basic_udppannel').forms([
					{ title: 'UDPspeederV2 服务器地址', multi: [
						{ name:'sgame_udp_server',type:'text',size: 20,value: dbus.sgame_udp_server || "2", suffix: ' &nbsp;&nbsp;端口：'},
						{ name: 'sgame_udp_port',type:'text',size: 6,value:dbus.sgame_udp_port || "4031"},
					],help: '尽管支持域名格式，但是仍然建议首先使用IP地址。'},
					{ title: 'UDPspeederV2 连接密码', name:'sgame_udp_password',type:'password',size: 20,maxLength:30,value:dbus.sgame_udp_password,help: '如果你的密码内有特殊字符，可能会导致密码参数不能正确的传给配置文件，导致启动后不能使用加速器。',peekaboo: 1  },
					{ title: '',name:'sgame_udp_status1', suffix: ' =======以下服务器和客户端设置必须一致！======='},
					{ title: '* 关闭数据包随机填充（--disable-obscure）', name:'sgame_udp_disableobscure',type:'checkbox',value: dbus.sgame_udp_disableobscure == 1, suffix: ' 关闭可节省一点带宽和cpu' },
					{ title: '',name:'sgame_udp_status2', suffix: ' =======以下为包发送选项，两端设置可以不同, 只影响本地包发送======='},
					{ title: '* fec参数 （-f）', name:'sgame_udp_fec',type:'text',size: 18,value:dbus.sgame_udp_fec, suffix: ' 必填，x:y，每x个包额外发送y个包。<a target="_blank" href="https://github.com/wangyu-/UDPspeeder/wiki/%E4%BD%BF%E7%94%A8%E7%BB%8F%E9%AA%8C">fec使用经验</a>' },
					{ title: '* timeout参数 （--timeout）', name:'sgame_udp_timeout',type:'text',size: 4,value: dbus.sgame_udp_timeout ,suffix: ' 单位：ms，默认8，留空则使用默认值，仅在--mode 0下起作用'  },
					{ title: '* mode参数 （--mode）', name:'sgame_udp_mode',type:'text',size: 20,value: dbus.sgame_udp_mode ,suffix: ' 默认1，留空则使用默认值' },
					{ title: '* 数据发送和接受报告 （--report）', name:'sgame_udp_report',type:'text',size: 20,value: dbus.sgame_udp_report ,suffix: ' 单位：s，留空则不使用' },
					{ title: '* mtu参数 （--mtu）', name:'sgame_udp_mtu',type:'text',size: 20,value: dbus.sgame_udp_mtu ,suffix: ' 默认1250，留空则使用默认值' },
					{ title: '* 原始数据抖动延迟 （-j,--jitter）', name:'sgame_udp_jitter',type:'text',size: 20,value: dbus.sgame_udp_jitter ,suffix: ' 单位：ms，默认0，留空则使用默认值' },
					{ title: '* 时间窗口 （-i,--interval）', name:'sgame_udp_interval',type:'text',size: 20,value: dbus.sgame_udp_interval ,suffix: ' 单位：ms，默认0，留空则使用默认值。' },
					{ title: '* 随机丢包 （--random-drop）', name:'sgame_udp_drop',type:'text',size: 20,value: dbus.sgame_udp_drop ,suffix: ' 单位：0.01%，默认0，留空则使用默认值' },
					{ title: '* 其它参数 ', name:'sgame_udp_other',type:'text',size: 100,value: dbus.sgame_udp_other ,suffix: ' 其它高级参数，请手动输入，如 -q1 等' },
				]);
			</script>
		</div>
	</div>
	<div class="box boxr2" id="sgame_dns_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="sgame_dns_pannel" class="section"></div>
			<script type="text/javascript">
				$('#sgame_dns_pannel').forms([
					{ title: 'DNS解析偏好', name:'sgame_dns_plan',type:'select',options:[['1', '国内优先'], ['2', '国外优先']], value: dbus.sgame_dns_plan || "2", suffix: '<lable id="_sgame_dns_plan_txt"></lable>'},
					{ title: '选择国内DNS', multi: [
						{ name: 'sgame_dns_china',type:'select', options:option_dns_china, value: dbus.sgame_dns_china || "1", suffix: ' &nbsp;&nbsp;' },
						{ name: 'sgame_dns_china_user', type: 'text', value: dbus.sgame_dns_china_user }
					]},
					// dns foreign pcap
					{ title: '选择国外DNS', multi: [
						{ name: 'sgame_dns_foreign',type: 'select', options:option_sgame_dns_foreign, value: dbus.sgame_dns_foreign || "2", suffix: ' &nbsp;&nbsp;' },
						{ name: 'sgame_dns_foreign_user', type: 'text', value: dbus.sgame_dns_foreign_user || "8.8.8.8" },
						{ suffix: '<lable>默认使用 sgame 内置的DNS功能解析国外域名。</lable>' }
					]},
					{ title: '<b>自定义dnsmasq</b></br></br><font color="#B2B2B2">一行一个，错误的格式会导致dnsmasq不能启动，格式：</br>address=/koolshare.cn/2.2.2.2</br>bogus-nxdomain=220.250.64.18</br>conf-file=/koolshare/mydnsmasq.conf</font>', name: 'sgame_dnsmasq', type: 'textarea', value: Base64.decode(dbus.sgame_dnsmasq)||"", style: 'width: 100%; height:150px;' }
				]);
			</script>
		</div>
	</div>
	<div class="box boxr3" id="sgame_wblist_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="sgame_wblist_pannel" class="section"></div>
			<script type="text/javascript">
				$('#sgame_wblist_pannel').forms([
					{ title: '<b>IP/CIDR黑名单</b></br></br><font color="#B2B2B2">需要加速的外网ip/cidr地址，一行一个，例如：</br>4.4.4.4</br>5.0.0.0/8</font>', name: 'sgame_wan_black_ip', type: 'textarea', value: Base64.decode(dbus.sgame_wan_black_ip)||"", style: 'width: 100%; height:600px;' },
				]);
			</script>
		</div>
	</div>	
	<div class="box boxr5" id="sgame_addon_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="sgame_addon_pannel" class="section"></div>
			<script type="text/javascript">
				$('#sgame_addon_pannel').forms([
					{ title: 'SGame 数据操作', suffix: '<button onclick="manipulate_conf(\'sgame_config.sh\', 2);" class="btn btn-success">清除所有 SGame 数据</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="manipulate_conf(\'sgame_config.sh\', 3);" class="btn btn-download">备份所有 SGame 数据</button>' },
					{ title: 'SGame 数据恢复', suffix: '<input type="file" id="file" size="50">&nbsp;&nbsp;<button id="upload1" type="button"  onclick="restore_conf();" class="btn btn-danger">上传并恢复 <i class="icon-cloud"></i></button>' }
				]);
			</script>
		</div>
	</div>
	<div class="box boxr6" id="sgame_log_tab" style="margin-top: 0px;">
		<div id="sgame_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.45);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#sgame_log_pannel').append('<textarea class="as-script" name="_sgame_basic_log" id="_sgame_basic_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
		</div>
	</div>
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">提交 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
	<script type="text/javascript">init_sgame();</script>
</content>
