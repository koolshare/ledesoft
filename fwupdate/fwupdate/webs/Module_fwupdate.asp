<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>fwupdate</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbss;
		var softcenter = 0;
		var params = ["fwupdate_fwlocal", "fwupdate_fwlast", "fwupdate_keep", "fwupdate_enforce"];
		var options_type = [];
		var options_list = [];
		var _responseLen;
		var noChange = 0;
		var reload = 0;
		tabSelect('app1');
		
		//============================================
		function init_fw(){
			get_local_data();
			$("#_fwupdate_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function conf2obj(dbus){
			for (var i = 0; i < params.length; i++) {
			if(typeof(dbus[params[i]]) != "undefined"){
					if (document.getElementById("_" + params[i]).getAttribute("type") == "checkbox"){
						if (dbus[params[i]] == 1){
							E("_" + params[i]).checked = true;
						}else{
							E("_" + params[i]).checked = false;
						}
					}else{
						E("_" + params[i]).value = dbus[params[i]];
					}
				}
			}
		}

		function get_local_data(){
			var dbus = {};
			$.getJSON("/_api/fwupdate_", function(res) {
				dbus=res.result[0];
				conf2obj(dbus);
			});
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "fwupdate_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_fwupdate_fwlocal").innerHTML = response.result.split("@@")[0];
					document.getElementById("_fwupdate_fwlast").innerHTML = response.result.split("@@")[1];
					setTimeout("get_run_status();", 10000);
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_fwupdate_fwlocal").innerHTML = "获取本地版本信息失败！";
					document.getElementById("_fwupdate_fwlast").innerHTML = "获取最新版本信息失败！";
					setTimeout("get_run_status();", 5000);
				}
			});
		}	

		function download_cert(){
			location.href = "http://110.110.110.110";
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

		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}

		function save(){
			// collect basic data
			var dbus2 = {};
			for (var i = 0; i < params.length; i++) {
				if (E("_" + params[i]).getAttribute("type") == "checkbox"){
		    		if(E("_" + params[i]).checked){
		    			dbus2[params[i]]="1";
		    		}else{
		    			dbus2[params[i]]="0";
		    		}
				}else{
		    		dbus2[params[i]] = E("_" + params[i]).value;
				}
			}
						
			// post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "fwupdate_config.sh", "params":["restart"], "fields": dbus2};
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
			//save_user_txt();
		}
		
		function get_log(){
			$.ajax({
				url: '/_temp/fw_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_fwupdate_log");
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
				}
			});
		}

	</script>

	<div class="box">
		<div class="heading">固件更新<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">在线更新或者重刷你的路由器固件。</span>
		</div>	
	</div>
	<ul class="nav nav-tabs">
		<li><a href="javascript:tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 固件信息</a></li>
		<li><a href="javascript:tabSelect('app3');" id="app3-server1-rz-tab"><i class="icon-info"></i> 更新日志</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading">固件信息</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">

				$('#identification').forms([
					{ title: '当前固件版本', text: '<font id="_fwupdate_fwlocal" name=_fwupdate_status color="#1bbf35">正在检查本地固件版本...</font>' },
					{ title: '最新固件版本', text: '<font id="_fwupdate_fwlast" name=_fwupdate_status color="#1bbf35">正在获取最新固件版本...</font>' },
					{ title: '保留配置', name:'fwupdate_keep',type:'checkbox',value: "0" == '1' },
					{ title: '强制重刷', name:'fwupdate_enforce',type:'checkbox',value: "0" == '1' },
				]);
			</script>
		</div>
	</div>
	<div class="box boxr3">
		<div class="heading">更新日志</div>
		<div class="content">
			<div class="section fw_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.fw_log').append('<textarea class="as-script" name="fwupdate_log" id="_fwupdate_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

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
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">开始更新 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">重新检测 <i class="icon-cancel"></i></button>
	<script type="text/javascript">init_fw();</script>
</content>
