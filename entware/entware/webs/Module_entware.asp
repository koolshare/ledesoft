<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>Entware环境</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbus;
		var softcenter = 0;
		var option_wan_list = [];
		get_local_data();
		var _responseLen;
		var noChange = 0;
		var reload = 0;
		var option_install = [['1', 'phpMyAdmin（数据库管理工具）'], ['2', 'WordPress（使用最广泛的CMS）'], ['3', 'Owncloud（经典的私有云）'], ['4', 'Nextcloud（Owncloud团队的新作，美观强大的个人云盘）'], ['5', 'h5ai（优秀的文件目录）'], ['6', 'Lychee（一个很好看，易于使用的Web相册）'], ['7', 'Kodexplorer（可道云aka芒果云在线文档管理器）'], ['8', 'Typecho (流畅的轻量级开源博客程序)'], ['9', 'Z-Blog (体积小，速度快的PHP博客程序)'], ['10', 'DzzOffice (开源办公平台)']];
		tabSelect('app1');
		
		//============================================
		function init_entware(){
			verifyFields();
			get_local_data();
			$("#_entware_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/entware_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	dbus = data.result[0];
			  	$("#_entware_on_disk").find('option').remove().end();
				for ( var i = 1; i <= dbus["entware_disk_nu"]; ++i ) {
					//if (dbus["entware_disk_type_" + i] == "ext2" || dbus["entware_disk_type_" + i] == "ext3" || dbus["entware_disk_type_" + i] == "ext4" ){
						$("#_entware_on_disk").append("<option value='" + dbus["entware_disk_mount_" + i] + "/entware" + "'>" + dbus["entware_disk_mount_" + i] + "/entware   空闲空间：" + dbus["entware_disk_free_" + i] + "</option>");
					//}
				}
				(dbus["entware_on_disk"]) && $("#_entware_on_disk").val(dbus["entware_on_disk"]);
				}
			});
		}

			
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "entware_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_entware_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_entware_status").innerHTML = "获取本地版本信息失败！";
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
			//var a = (dbus.entware_onmp == '1');
			//elem.display('_stop_onmp', a);
			//elem.display('_start_onmp', a);
			//elem.display('_rest_onmp', a);
			//elem.display('_uninstall_onmp', a);
			//elem.display('_install_onmp', !a);
			//elem.display(PR('_entware_url'), a);
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
			dbus.entware_enable = E('_entware_enable').checked ? '1':'0';
			dbus.entware_on_disk = E('_entware_on_disk').value;
			dbus.entware_password = E('_entware_password').value;
			// post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "entware_config.sh", "params":["start"], "fields": dbus};
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
				url: '/_temp/entware_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_entware_log");
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
					E("_entware_log").value = "获取日志失败！";
					return false;
				}
			});
		}
		function install_now(o){
			verifyFields();
			// disable update botton when in update progress
			E('save-button').disabled = true;
			// collect basic data
			var para_chk = ["entware_enable"];
			var para_inp = ["entware_install", "entware_on_disk", "entware_password"];
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
			var postData2 = {"id": id2, "method": "entware_config.sh", "params":[o], "fields": dbus};
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
		<div class="heading">Entware环境及一键扩展<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				在你的路由器布署Entware环境及扩展一键安装。安装应用部分代码使用了<a href=https://github.com/xzhih/ONMP target="_blank">ONMP</a>。
			</span>
		</div>	
	</div>
	<ul class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-server1-rz-tab"><i class="icon-info"></i> 启动日志</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading"><font color="#FF3300">基本设置</font></div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启', name:'entware_enable',type:'checkbox',value: dbus.entware_enable == 1 },
					{ title: '运行状态', text: '<font id="_entware_status" name=_entware_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '安装目录', name:'entware_on_disk',type:'select', options:[], value: dbus.entware_on_disk ,suffix: '选择空闲空间大于5G的硬盘' },
					{ title: '数据库密码管理', multi: [
						{ name:'entware_password', type: 'password', size: 20, value: dbus.entware_password  || 'koolshare' ,peekaboo: 1 },
						{ name:'change_mysql',suffix: ' <button id="_change_mysql" onclick="install_now(8);" class="btn btn-primary">修改</button>' },
						{ name:'reset_mysql',suffix: ' <button id="_reset_mysql" onclick="install_now(9);" class="btn">重置数据库</button>' },
					]},
					{ title: 'ONMP管理', multi: [
						{ name:'install_onmp',suffix: ' <button id="_install_onmp" onclick="install_now(3);" class="btn btn-danger">安装</button>' },
						{ name:'uninstall_onmp',suffix: ' <button id="_uninstall_onmp" onclick="install_now(4);" class="btn btn-danger">卸载</button>' },
						{ name:'start_onmp',suffix: ' <button id="_start_onmp" onclick="install_now(5);" class="btn btn-primary">启动</button>' },
						{ name:'stop_onmp',suffix: ' <button id="_stop_onmp" onclick="install_now(6);" class="btn">停止</button>' },
						{ name:'rest_onmp',suffix: ' <button id="_rest_onmp" onclick="install_now(7);" class="btn btn-primary">重启</button>' },
					]},
					{ title: '安装应用', multi: [
						{ name:'entware_install' ,type:'select',options:option_install, value: dbus.entware_install },
						{ name:'install_now',suffix: ' <button id="_install_now" onclick="install_now(1);" class="btn btn-primary">一建安装</button>' },
						{ name:'uninstall_now',suffix: ' <button id="_uninstall_now" onclick="install_now(2);" class="btn btn-danger">全部删除</button>' },
					]},
					{ title: '已安装应用列表', name:'all_soft' ,suffix: ' <button id="_all_soft" onclick="install_now(0);" class="btn btn-primary">查看已安装应用列表</button>' },
				]);
			</script>
		</div>
	</div>
	<div class="box boxr1"><br>
	<div class="heading"><font color="#FF3300">快捷链接：</font> <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
		<div id="identification1" class="section"></div>
			<script type="text/javascript">
				$('#identification1').forms([
					{ title: '探针查看', name:'entware_url' ,text: '<a href=http://' + location.hostname + ":81" + '/ target="_blank"><u>http://'  + location.hostname + ":81" + '</u></a>' },
					{ title: 'phpmyadmin', name:'phpmyadmin_url' ,text: '<a href=http://' + location.hostname + ":82" + '/ target="_blank"><u>http://'  + location.hostname + ":82" + '</u></a>' },
					{ title: 'nextcloud', name:'nextcloud_url' ,text: '<a href=http://' + location.hostname + ":99" + '/ target="_blank"><u>http://'  + location.hostname + ":99" + '</u></a>' },
					{ title: 'owncloud', name:'owncloud_url' ,text: '<a href=http://' + location.hostname + ":98" + '/ target="_blank"><u>http://'  + location.hostname + ":98" + '</u></a>' },
					{ title: 'lychee', name:'lychee_url' ,text: '<a href=http://' + location.hostname + ":86" + '/ target="_blank"><u>http://'  + location.hostname + ":86" + '</u></a>' },
					{ title: 'h5ai', name:'h5ai_url' ,text: '<a href=http://' + location.hostname + ":85" + '/ target="_blank"><u>http://'  + location.hostname + ":85" + '</u></a>' },
					{ title: 'wordpress', name:'wordpress_url' ,text: '<a href=http://' + location.hostname + ":83" + '/ target="_blank"><u>http://'  + location.hostname + ":83" + '</u></a>' },
					{ title: '可道云', name:'kodexplorer_url' ,text: '<a href=http://' + location.hostname + ":88" + '/ target="_blank"><u>http://'  + location.hostname + ":88" + '</u></a>' },
					{ title: 'Typecho', name:'typecho_url' ,text: '<a href=http://' + location.hostname + ":90" + '/ target="_blank"><u>http://'  + location.hostname + ":90" + '</u></a>' },
					{ title: 'Z-Blog', name:'zbolg_url' ,text: '<a href=http://' + location.hostname + ":91" + '/ target="_blank"><u>http://'  + location.hostname + ":91" + '</u></a>' },
					{ title: 'DzzOffice', name:'dzzoffice_url' ,text: '<a href=http://' + location.hostname + ":92" + '/ target="_blank"><u>http://'  + location.hostname + ":92" + '</u></a>' },
				]);
			</script>
	</div>
	</div>
</div>
	<div class="box boxr1"><br>
	<div class="heading"><font color="#FF3300">插件说明：</font> </div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> ONMP指Opkg + Nginx + MySQL + PHP</font></li>
			<li> 安装其它应用前必须先安装ONMP且正常运行</font></li>
			<li> ONMP的安装包在国外，第一次安装将会需要非常长的时候，请耐心等候</font></li>
			<li> 如如果不成功可以再次点击安装按钮再次安装</font></li>
	</div>
	</div>
</div>
	<div class="box boxr3">
		<div class="heading">启动日志</div>
		<div class="content">
			<div class="section entware_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.entware_log').append('<textarea class="as-script" name="entware_log" id="_entware_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

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
	<script type="text/javascript">init_entware();</script>
</content>
