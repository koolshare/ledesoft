<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>Unifi控制器</title>
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
		tabSelect('app1');
		
		//============================================
		function init_unifi(){
			verifyFields();
			get_local_data();
			$("#_unifi_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/unifi_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	dbus = data.result[0];
			  	$("#_unifi_on_disk").find('option').remove().end();
				for ( var i = 1; i <= dbus["unifi_disk_nu"]; ++i ) {
					//if (dbus["unifi_disk_type_" + i] == "ext2" || dbus["unifi_disk_type_" + i] == "ext3" || dbus["unifi_disk_type_" + i] == "ext4" ){
						$("#_unifi_on_disk").append("<option value='" + dbus["unifi_disk_mount_" + i] + "/debian" + "'>" + dbus["unifi_disk_mount_" + i] + "/debian   空闲空间：" + dbus["unifi_disk_free_" + i] + "</option>");
					//}
				}
				(dbus["unifi_on_disk"]) && $("#_unifi_on_disk").val(dbus["unifi_on_disk"]);
				}
			});
		}

			
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "unifi_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_unifi_status").innerHTML = response.result.split("@@")[0];
					setTimeout("get_run_status();", 3000);
					verifyFields();					
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_unifi_status").innerHTML = "获取本地版本信息失败！";
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
			//var a = E('_unifi_debian').checked == 0;
			//E('_unifi_url').disabled = !a;
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
			dbus.unifi_enable = E('_unifi_enable').checked ? '1':'0';
			dbus.unifi_debian = E('_unifi_debian').checked ? '1':'0';
			dbus.unifi_on_disk = E('_unifi_on_disk').value;
			// post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "unifi_config.sh", "params":[""], "fields": dbus};
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
				url: '/_temp/unifi_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_unifi_log");
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
					E("_unifi_log").value = "获取日志失败！";
					return false;
				}
			});
		}

		function update_unifi(o){
			verifyFields();
			// disable update botton when in update progress
			E('save-button').disabled = true;
			// collect basic data
			var para_chk = ["unifi_enable","unifi_debian"];
			var para_inp = ["unifi_on_disk","unifi_mode"];
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
			var postData2 = {"id": id2, "method": "unifi_config.sh", "params":[o], "fields": dbus};
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
		<div class="heading">Unifi控制器和Debian系统<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				在你的路由器上运行一个Debian系统和Unifi控制器。
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
				var option_auth = [['1', '稳定版'],['2', '开发版'],['3', '快速预览版']];
				$('#identification').forms([
					{ title: '开启', name:'unifi_enable',type:'checkbox',value: dbus.unifi_enable == 1 },
					{ title: '运行状态', text: '<font id="_unifi_status" name=_unifi_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '只安装Debian系统', name:'unifi_debian',type:'checkbox',value: dbus.unifi_debian == 1 },
					{ title: '安装目录', name:'unifi_on_disk',type:'select', options:[], value: dbus.unifi_on_disk ,suffix: '选择空闲空间大于5G的硬盘' },
					{ title: 'Unifi控制器版本', name: 'unifi_mode', type: 'select', options: option_auth, value: dbus.unifi_mode },
					{ title: 'Unifi控制器', multi: [ 
						{ name:'update_unifi',suffix: ' <button id="_update_now" onclick="update_unifi(1);" class="btn btn-primary">检查升级</button>' },
						{ name:'change_unifi',suffix: ' <button id="_change_now" onclick="update_unifi(2);" class="btn btn-primary">切换版本</button>' },
					] },
					{ title: '控制器管理', name:'unifi_url' ,text: '<a href=https://' + location.hostname + ":8443" + '/ target="_blank"><u>https://'  + location.hostname + ":8443" + '</u></a>' },
				]);
			</script>
		</div>
	<div class="box"><br>
	<div class="heading"><font color="#FF3300">插件说明：</font> <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 必须有2G左右的闲置硬盘空间才能布署Debian系统和Unifi控制器。</font></li>
			<li> 必须有6G左右的闲置硬盘空间才能成功启动Unifi控制器。</font></li>
			<li> 设置只安装Debian系统将不会安装和启动Unifi控制器。</font></li>
			<li> 只需要开启插件后在ssh下输入debian即可切换到Debian系统。</li>
			<li> 输入exit回到LEDE系统。</li>
	</div>
	</div>
</div>
	<div class="box boxr3">
		<div class="heading">启动日志</div>
		<div class="content">
			<div class="section unifi_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.unifi_log').append('<textarea class="as-script" name="unifi_log" id="_unifi_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

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
	<script type="text/javascript">init_unifi();</script>
</content>
