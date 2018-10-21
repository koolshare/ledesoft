<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>软件中心 - anyconnect</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbus;
		var softcenter = 0;
		get_local_data();
		var _responseLen;
		var noChange = 0;
		var reload = 0;
		tabSelect('app1');
		//============================================
		var user = new TomatoGrid();
		user.populate = function(){
			for ( var i = 1; i <= dbus["anyconnect_user_nu"]; ++i ) {
				this.insertData( -1, [
				dbus["anyconnect_user_id_" + i] || "", 
				dbus["anyconnect_user_wip_" + i] || "", 
				dbus["anyconnect_user_vip_" + i] || "", 
				dbus["anyconnect_user_time_" + i] || "", 
				dbus["anyconnect_user_cipher_" + i] || "", 
				dbus["anyconnect_user_status_" + i] || ""
				] );
			}
		}
		user.setup = function() {
			this.init( 'user-grid', 'sort' );
			this.populate();
			this.headerSet( [ 'ID', '远程IP地址', '内部IP地址', '连接时间', '加密', '状态' ] );
			this.sort( 1 );
		}
		//============================================
		function init_anyconnect(){
			verifyFields();
			user.setup();
			setTimeout("get_run_status();", 1000);
			setInterval("refresh_table();", 5000);
			$("#_anyconnect_log").click(
				function() {
					x = -1;
			});
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/anyconnect_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 		dbus = data.result[0];
			  	}
			});
		}

		function refresh_table(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/anyconnect_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	dbus = data.result[0];
				var data = user.getAllData();
				if(data.length > 0){
					user.removeAllData();
				}
				user.populate();
				user.resort();
				get_run_status();
			  	}
			});
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "anyconnect_status.sh", "params":[], "fields": ""};
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
					document.getElementById("_anyconnect_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_anyconnect_status").innerHTML = "获取运行信息失败！";
					//setTimeout("get_run_status();", 2000);
				}
			});
		}

		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
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

		function verifyFields(){
			if (E("_anyconnect_enable").checked){
				$("#save-button").html("开始运行")
			}else{
				$("#save-button").html("停止运行")
			}
			var h1 = (E('_anyconnect_auth').value == '1');
			elem.display(PR('_anyconnect_user'), h1);
			elem.display(PR('_anyconnect_passwd'), h1);
			E('_download_cert').disabled = h1;			
			E('_restore_now').disabled = h1;			
			return true;
		}

		function tabSelect(obj){
			var tableX = ['app1-server1-jb-tab','app2-server1-an-tab','app3-server1-rz-tab'];
			var boxX = ['boxr1','boxr2','boxr3'];
			var appX = ['app1','app2','app3'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app3' ){
				setTimeout("get_log();", 400);
				elem.display('save-button', false);
				elem.display('cancel-button', false);
			}else{
				elem.display('save-button', true);
				elem.display('cancel-button', true);
			}
			if( obj=='app2' ){
				//setTimeout("get_run_status();", 400);
				//setTimeout("refresh_table();", 400);
				elem.display('save-button', false);
				elem.display('cancel-button', false);
			}
		}

		function save(){
			verifyFields();
			// disable update botton when in update progress
			E('save-button').disabled = true;
			// collect basic data
			var para_chk = ["anyconnect_enable"];
			var para_inp = ["anyconnect_port", "anyconnect_user", "anyconnect_passwd", "anyconnect_auth", "anyconnect_host"];
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
			// post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "anyconnect_config.sh", "params":[""], "fields": dbus};
			showMsg("msg_warring","正在提交数据！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				cache:false,
				type: "POST",
				dataType: "json",
				data: JSON.stringify(postData3),
				error: function(){
					showMsg("msg_error","失败","<b>当前系统存在异常查看系统日志！</b>");
				}
			});
			reload = 1;
			tabSelect("app3");
		}

		function download_cert(){
			var postData = {"id": parseInt(Math.random() * 100000000), "method": "dummy_script.sh", "params":[], "fields": "" };
			$.ajax({
				type: "POST",
				url: "/_api/",
				async: true,
				cache:false,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function(response){
					var a = document.createElement('A');
					a.href = "/files/anyconnect.p12";
					a.download = 'anyconnect.p12';
					document.body.appendChild(a);
					a.click();
					document.body.removeChild(a);
				}
			});
		}
		function get_log(){
			$.ajax({
				url: '/_temp/anyconnect_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_anyconnect_log");
					if (response.search("XU6J03M6") != -1) {
						retArea.value = response.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						if (reload == 1){
							setTimeout("window.location.reload()", 1200);
							return true;
						}else{
							return true;
						}
					}
					if (_responseLen == response.length) {
						noChange++;
					} else {
						noChange = 0;
					}
					if (noChange > 1000) {
						tabSelect("app1");
						return false;
					} else {
						setTimeout("get_log();", 200);
					}
					retArea.value = response.replace("XU6J03M6", " ");
					retArea.scrollTop = retArea.scrollHeight;
					_responseLen = response.length;
				},
				error: function() {
					E("_anyconnect_log").value = "获取日志失败！";
					return false;
				}
			});
		}

		function restore_now(o){
			verifyFields();
			// disable update botton when in update progress
			E('save-button').disabled = true;
			// collect basic data
			var para_chk = ["anyconnect_enable"];
			var para_inp = ["anyconnect_port", "anyconnect_user", "anyconnect_passwd", "anyconnect_auth", "anyconnect_host"];
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
			// post data
			var id2 = parseInt(Math.random() * 100000000);
			var postData2 = {"id": id2, "method": "anyconnect_config.sh", "params":[o], "fields": dbus};
			showMsg("msg_warring","正在提交数据！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				cache:false,
				type: "POST",
				dataType: "json",
				data: JSON.stringify(postData2),
				error: function(){
					showMsg("msg_error","失败","<b>当前系统存在异常查看系统日志！</b>");
				}
			});
			reload = 1;
			tabSelect("app3");
		}

	</script>

	<div class="box">
		<div class="heading">AnyConnect Server<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				AnyConnect为思科推出的企业VPN解决方案，目前已有Windows、Android、iOS、OS X、Ubuntu、WebOS等操作系统的客户端。
			</span>
		</div>	
	</div>
	<ul class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-server1-an-tab"><i class="icon-hammer"></i> 已连接用户</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-server1-rz-tab"><i class="icon-info"></i> 运行日志</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				var option_auth = [['1', '使用用户名和密码登陆'],['2', '使用证书登陆']];
				if(!dbus.anyconnect_host){dbus.anyconnect_host = "any.koolshare.cn";};
				if(!dbus.anyconnect_port){dbus.anyconnect_port = "4443";};				
				$('#identification').forms([
					{ title: '开启AnyConnect', name:'anyconnect_enable',type:'checkbox',value: dbus.anyconnect_enable == 1 },
					{ title: '运行状态', text: '<font id="_anyconnect_status" name=_anyconnect_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '外网连接使用的域名',name:'anyconnect_host',type:'text', maxlen: 30, size: 30,value: dbus.anyconnect_host || "any.koolshare.cn" },
					{ title: '端口',name:'anyconnect_port',type:'text', maxlen: 5, size: 5,value: dbus.anyconnect_port || "4443" },
					{ title: '客户端应该设置的服务器地址', name:'anyconnect_url' ,text: dbus.anyconnect_host + ":" + dbus.anyconnect_port },
					{ title: '登陆方式', name: 'anyconnect_auth', type: 'select', options: option_auth, value: dbus.anyconnect_auth },
					{ title: '用户名', name:'anyconnect_user',type:'text', maxlen: 20, size: 20, value: dbus.anyconnect_user || 'koolshare' },
					{ title: '密码', name:'anyconnect_passwd',type:'password', maxlen: 20, size: 20, value: dbus.anyconnect_passwd, peekaboo: 1 },
					{ title: '证书管理', multi: [ 
						{ name:'restore_cert',suffix: ' <button id="_restore_now" onclick="restore_now(1);" class="btn btn-primary">重新生成证书</button>' },
						{ name:'anyconnect_cert',suffix: ' <button id="_download_cert" onclick="download_cert();" class="btn btn-danger">证书下载（p12）<i class="icon-download"></i></button>' },
					] },
					]);
			</script>
		</div>
	</div>
	<div class="box boxr1"><br>
	<div class="heading"><font color="#FF3300">设置说明：</font> <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 手机可前往App Store下载客户端：<a href="https://itunes.apple.com/cn/app/cisco-anyconnect/id1135064690?mt=8" target="_blank">IOS</a>&nbsp;&nbsp;<a href="https://play.google.com/store/apps/details?id=com.cisco.anyconnect.vpn.android.avf&hl=zh_TW" target="_blank">Android</a></font></li>
			<li> PC用户可前往思科官网下载：<a href="https://software.cisco.com/download/release.html?mdfid=286281283&softwareid=282364313&os=&release=4.5.02033&relind=AVAILABLE&rellifecycle=&reltype=latest&i=!pp" target="_blank">MAC Windows Liunx</a></li>
			<li> 客户端初次连接时先在设置里关闭设置项--阻止不信任的服务器</li>
			<li> 使用用户名密码登陆时无需导入用户证书，证书导入密码<font color="#FF3300">koolshare</font></li>
			<li> 当前配置可以使用同一账号登入64个终端</li>
			<br />
	</div>
	</div>
	<div class="box boxr2">
		<div class="heading">已连接用户</div>
		<div class="content">
			<div class="section anyconnect_user content">
					<table class="line-table" id="user-grid"></table>
			</div>
		</div>
	</div>
	<div class="box boxr3">
		<div class="heading">运行日志</div>
		<div class="content">
			<div class="section anyconnect_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.anyconnect_log').append('<textarea class="as-script" name="anyconnect_log" id="_anyconnect_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

				</script>
			</div>
		</div>
	</div>
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">开始运行 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">刷新页面 <i class="icon-cancel"></i></button>
	<script type="text/javascript">init_anyconnect();</script>
</content>
