<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>ShadowsocksR服务器</title>
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
		function init_ssrserver(){
			verifyFields();
			get_local_data();
			$("#_ssrserver_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/ssrserver_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}

			
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "ssrserver_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_ssrserver_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_ssrserver_status").innerHTML = "获取本地版本信息失败！";
					setTimeout("get_run_status();", 2000);
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
			//var a = E('_ssrserver_debian').checked == 0;
			//E('_ssrserver_url').disabled = !a;
		}

		function tabSelect(obj){
			var tableX = ['app1-server1-jb-tab','app3-server1-rz-tab'];
			var boxX = ['boxr1','boxr3'];
			var appX = ['app1','app3'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app3'){
				setTimeout("get_log();", 400);
				elem.display('save-button', false);
				elem.display('cancel-button', false);
			}else{
				elem.display('save-button', true);
				elem.display('cancel-button', true);
			}
		}

		function save(){
			verifyFields();
			// disable update botton when in update progress
			E('save-button').disabled = true;
			// collect basic data
			var para_chk = ["ssrserver_enable", "ssrserver_tcp", "ssrserver_ss"];
			var para_inp = ["ssrserver_port", "ssrserver_timeout", "ssrserver_passwd", "ssrserver_encrypt", "ssrserver_protocol", "ssrserver_protocol_param", "ssrserver_obfs", "ssrserver_obfs_param", "ssrserver_redirect"];
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
			var postData3 = {"id": id3, "method": "ssrserver_config.sh", "params":[""], "fields": dbus};
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
		
		function get_log(){
			$.ajax({
				url: '/_temp/ssrserver_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_ssrserver_log");
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
					E("_ssrserver_log").value = "获取日志失败！";
					return false;
				}
			});
		}

	</script>

	<div class="box">
		<div class="heading">ShadowsocksR服务器<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				在你的路由器上搭建一个ShadowsocksR服务器。
			</span>
		</div>	
	</div>
	<ul class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-server1-rz-tab"><i class="icon-info"></i> 启动日志</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				var option_encrypt = [['none', 'none'], ['rc4-md5', 'rc4-md5'], ['aes-128-cfb', 'aes-128-cfb'], ['aes-192-cfb', 'aes-192-cfb'], ['aes-256-cfb', 'aes-256-cfb'], ['salsa20', 'salsa20'], ['chacha20', 'chacha20'], ['chacha20-ietf', 'chacha20-ietf'], ['chacha20-ietf-poly1305', 'chacha20-ietf-poly1305'], ['chacha20-poly1305', 'chacha20-poly1305']];
				var option_protocol = [['origin', 'origin'], ['auth_simple', 'auth_simple'], ['auth_sha1_v4', 'auth_sha1_v4'], ['auth_aes128_md5', 'auth_aes128_md5'], ['auth_aes128_sha1', 'auth_aes128_sha1'], ['auth_chain_a', 'auth_chain_a'], ['auth_chain_b', 'auth_chain_b'], ['auth_chain_c', 'auth_chain_c'], ['auth_chain_d', 'auth_chain_d'], ['auth_chain_e', 'auth_chain_e'], ['auth_chain_f', 'auth_chain_f']];
				var option_obfs = [['plain', 'plain'], ['http_simple', 'http_simple'], ['http_post', 'http_post'], ['tls_simple', 'tls_simple'], ['tls1.2_ticket_auth', 'tls1.2_ticket_auth']];
				$('#identification').forms([
					{ title: '开启', name:'ssrserver_enable',type:'checkbox',value: dbus.ssrserver_enable == 1 },
					{ title: '运行状态', text: '<font id="_ssrserver_status" name=_ssrserver_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '服务器端口', name:'ssrserver_port',type:'text', maxlen: 5, size: 5,value: dbus.ssrserver_port || '6688' },
					{ title: '连接超时', name:'ssrserver_timeout',type:'text', maxlen: 5, size: 5,value: dbus.ssrserver_timeout || '300' },
					{ title: '密码', name:'ssrserver_passwd',type:'password', maxlen: 50, size: 50,value: dbus.ssrserver_passwd , peekaboo: 1 },
					{ title: '加密', name:'ssrserver_encrypt' ,type:'select',options:option_encrypt,value: dbus.ssrserver_encrypt || "aes-256-cfb" },
					{ title: '协议', name:'ssrserver_protocol' ,type:'select',options:option_protocol,value: dbus.ssrserver_protocol || "auth_aes128_sha1" },
					{ title: '协议参数', name:'ssrserver_protocol_param',type:'text', maxlen: 50, size: 50,value: dbus.ssrserver_protocol_param },
					{ title: '混淆', name:'ssrserver_obfs' ,type:'select',options:option_obfs,value: dbus.ssrserver_obfs || "tls1.2_ticket_auth" },
					{ title: '混淆参数', name:'ssrserver_obfs_param',type:'text', maxlen: 50, size: 50,value: dbus.ssrserver_obfs_param },
					{ title: '重定向', name:'ssrserver_redirect',type:'text', maxlen: 50, size: 50,value: dbus.ssrserver_redirect },
					{ title: 'TCP快速打开', name:'ssrserver_tcp',type:'checkbox',value: dbus.ssrserver_tcp == 1 },
					{ title: '允许客户端科学上网', name:'ssrserver_ss',type:'checkbox',value: dbus.ssrserver_ss == 1 },
				]);
			</script>
		</div>
	</div>
	<div class="box boxr3">
		<div class="heading">启动日志</div>
		<div class="content">
			<div class="section ssrserver_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.ssrserver_log').append('<textarea class="as-script" name="ssrserver_log" id="_ssrserver_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

				</script>
			</div>
		</div>
	</div>
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;">
	</div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;">
	</div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;">
	</div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">开始运行 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">刷新页面 <i class="icon-cancel"></i></button>
	<script type="text/javascript">init_ssrserver();</script>
</content>
