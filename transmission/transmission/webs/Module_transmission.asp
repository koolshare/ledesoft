<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>软件中心 - Transmission</title>
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
		function init_transmission(){
			verifyFields();
			$("#_transmission_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/transmission_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}

			
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "transmission_status.sh", "params":[], "fields": ""};
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
					document.getElementById("_transmission_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_transmission_status").innerHTML = "获取运行信息失败！";
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
			var a = E('_transmission_rpc_enable').checked;
			var b = E('_transmission_queue_enabled').checked;
			var d = E('_transmission_watch_enable').checked;
			elem.display(PR('_transmission_rpc_user'), a);
			elem.display(PR('_transmission_rpc_passwd'), a);
			elem.display(PR('_transmission_watch_dir'), d);
			elem.display(PR('_transmission_queue_size'), b);
			if (dbus.transmission_enable == 1){
				//elem.display(PR('kdisk_now1'), false);
			}
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

		function ps(){
			if (E('_transmission_rpc_passwd').type="password")
				E('_transmission_rpc_passwd').type="txt";
				psclick.innerHTML="<a href=\"javascript:txt()\">隐藏密码</a>"
		}
		
		function txt(){
			if (E('_transmission_rpc_passwd').type="text")
			E('_transmission_rpc_passwd').type="password";
			psclick.innerHTML="<a href=\"javascript:ps()\">显示密码</a>"
		}

		function save(){
			verifyFields();
			// disable update botton when in update progress
			E('save-button').disabled = true;
			// collect basic data
			var para_chk = ["transmission_enable", "transmission_subtitle_enable", "transmission_rpc_enable", "transmission_watch_enable", "transmission_dht_enable", "transmission_ldp_enable", "transmission_queue_enabled"];
			var para_inp = ["transmission_dir", "transmission_rpc_port", "transmission_rpc_user", "transmission_rpc_passwd","transmission_cache", "transmission_limit_global" ,"transmission_limit_per", "transmission_watch_dir", "transmission_queue_size"];
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
			var postData3 = {"id": id3, "method": "transmission_config.sh", "params":[""], "fields": dbus};
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
				url: '/_temp/transmission_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_transmission_log");
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
					E("_transmission_log").value = "获取日志失败！";
					return false;
				}
			});
		}

	</script>

	<div class="box">
		<div class="heading">Transmission<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				Transmission是一个强大的BitTorrent开源客户端。
			</span>
		</div>	
	</div>
	<ul class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-server1-rz-tab"><i class="icon-info"></i> 运行日志</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启transmission', name:'transmission_enable',type:'checkbox',value: dbus.transmission_enable == 1 },
					{ title: '运行状态', text: '<font id="_transmission_status" name=_transmission_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '下载存储目录', name:'transmission_dir',type:'text', maxlen: 40, size: 40, value: dbus.transmission_dir || '/mnt/sdb1/Downloads' },
					{ title: 'RPC监听(Web)端口',name:'transmission_rpc_port',type:'text', maxlen: 5, size: 5,value: dbus.transmission_rpc_port || "9091", suffix: ' &nbsp;&nbsp;<a href=http://' + location.hostname + ":" + dbus.transmission_rpc_port + '/ target="_blank"><u>http://'  + location.hostname + ":" + dbus.transmission_rpc_port + '</u></a>' },
					{ title: '开启RPC验证', name:'transmission_rpc_enable',type:'checkbox',value: dbus.transmission_rpc_enable == 1 },
					{ title: '用户名', name:'transmission_rpc_user',type:'text', maxlen: 20, size: 20, value: dbus.transmission_rpc_user || 'koolshare' },
					{ title: '密码', name:'transmission_rpc_passwd',type:'password', maxlen: 20, size: 20, value: dbus.transmission_rpc_passwd, suffix: '<SPAN id=psclick><A href="javascript:ps()">显示密码</A></SPAN>' },
					{ title: '开启DHT', name: 'transmission_dht_enable', type: 'checkbox', value: dbus.transmission_dht_enable == 1 },
					{ title: '开启LDP', name: 'transmission_ldp_enable', type: 'checkbox', value: dbus.transmission_ldp_enable == 1 },
					{ title: '缓存大小(MB)', name:'transmission_cache',type:'text', maxlen: 5, size: 5, value: dbus.transmission_cache || '300' , suffix: '建议设置为内存的1/6'},
					{ title: '开启排队下载', name: 'transmission_queue_enabled', type: 'checkbox', value: dbus.transmission_queue_enabled == 1 },
					{ title: '同时最大下载数', name:'transmission_queue_size',type:'text', maxlen: 3, size: 3,value: dbus.transmission_queue_size || '4' },
					{ title: '全局连接数', name:'transmission_limit_global',type:'text', maxlen: 5, size: 5, value: dbus.transmission_limit_global || '240' },
					{ title: '每个种子连接数', name:'transmission_limit_per',type:'text', maxlen: 6, size: 6,value: dbus.transmission_limit_per || '80' },
					{ title: '开启自动监控下载', name: 'transmission_watch_enable', type: 'checkbox', value: dbus.transmission_watch_enable == 1 },
					{ title: '本地种子监控目录', name:'transmission_watch_dir',type:'text', maxlen: 40, size: 40,value: dbus.transmission_watch_dir || '/mnt/sdb1/Downloads/watch' , suffix: '放到此目录的种子会自动添加下载'},
					{ title: '下载完成自动下载字幕', name: 'transmission_subtitle_enable', type: 'checkbox', value: dbus.transmission_subtitle_enable == 1 },
					]);
			</script>
		</div>
	<div class="box"><br>
	<div class="heading"><font color="#FF3300">设置说明：</font> <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> DHT和LDP进行PT下载时请关闭开启可能会被封号，BT下载开启可以加快速度。</font></li>
			<br />
	</div>
	</div>
</div>
	<div class="box boxr3">
		<div class="heading">运行日志</div>
		<div class="content">
			<div class="section transmission_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.transmission_log').append('<textarea class="as-script" name="transmission_log" id="_transmission_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

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
	<script type="text/javascript">init_transmission();</script>
</content>
