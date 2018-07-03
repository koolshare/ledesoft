<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>固件更新</title>
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
		var params = ["fwupdate_fwlocal", "fwupdate_fwlast", "fwupdate_keep", "fwupdate_uefi", "fwupdate_enforce"];
		var options_type = [];
		var options_list = [];
		var _responseLen;
		var noChange = 0;
		var reload = 0;
		tabSelect('app1');
		
		//============================================
		function init_fw(){
			E('save-button').disabled = true;
			get_local_data();
			$("#_fwupdate_log").click(
				function() {
					x = -1;
			});
			notice_show();
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/fwupdate_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
					dbus2obj(dbus);
					get_run_status();
			  	}
			});
		}

		function dbus2obj(dbus){
			// only fwupdate_keep send to skipd
			if(typeof(dbus["fwupdate_keep"]) != "undefined"){
				if (dbus["fwupdate_keep"] == 1){
					E("_fwupdate_keep").checked = true;
				}else{
					E("_fwupdate_keep").checked = false;
				}
			}
			if(typeof(dbus["fwupdate_uefi"]) != "undefined"){
				if (dbus["fwupdate_uefi"] == 1){
					E("_fwupdate_uefi").checked = true;
				}else{
					E("_fwupdate_uefi").checked = false;
				}
			}
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
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_fwupdate_fwlocal").innerHTML = "获取本地版本信息失败！";
					document.getElementById("_fwupdate_fwlast").innerHTML = "获取最新版本信息失败！";
					setTimeout("get_run_status();", 2000);
				}
			});
		}
		
		function versionCompare(v1, v2, options) {
			var lexicographical = options && options.lexicographical,
				zeroExtend = options && options.zeroExtend,
				v1parts = v1.split('.'),
				v2parts = v2.split('.');

			function isValidPart(x) {
				return (lexicographical ? /^\d+[A-Za-z]*$/ : /^\d+$/).test(x);
			}

			if (!v1parts.every(isValidPart) || !v2parts.every(isValidPart)) {
				return NaN;
			}

			if (zeroExtend) {
				while (v1parts.length < v2parts.length) v1parts.push("0");
				while (v2parts.length < v1parts.length) v2parts.push("0");
			}

			if (!lexicographical) {
				v1parts = v1parts.map(Number);
				v2parts = v2parts.map(Number);
			}

			for (var i = 0; i < v1parts.length; ++i) {
				if (v2parts.length == i) {
					return true;
				}

				if (v1parts[i] == v2parts[i]) {
					continue;
				} else if (v1parts[i] > v2parts[i]) {
					return true;
				} else {
					return false;
				}
			}

			if (v1parts.length != v2parts.length) {
				return false;
			}
			return false;
		}
		
		function verifyFields(r){
			var local_version = $.trim(E('_fwupdate_fwlocal').innerHTML);
			var online_version = $.trim(E('_fwupdate_fwlast').innerHTML);
			if(isNaN(local_version)){ //版本号不是数字
				showMsg("msg_warring","错误！","<b>获取本地版本号错误！</b>");
				return false;
			}

			if(isNaN(online_version)){ //版本号不是数字
				showMsg("msg_warring","错误！","<b>获取在线版本号错误！请检查你的网络！</b>");
				return false;
			}
			if (versionCompare(online_version, local_version)){
			//if (online_version > local_version){
				E('save-button').disabled = false;
			}else{
				var a = E('_fwupdate_enforce').checked;
				E('save-button').disabled = !a;
				if ( $(r).attr("id") == "_fwupdate_enforce" ) {
					E('save-button').innerHTML = '强制更新 <i class="icon-check"></i>';
				}else{
					E('save-button').innerHTML = '开始更新 <i class="icon-check"></i>';
				}
			}
			return true;
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
			// disable update botton when in update progress
			E('save-button').disabled = true;
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
			var postData3 = {"id": id3, "method": "fwupdate_config.sh", "params":["update"], "fields": dbus2};
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
				},
				error: function() {
					E("_fwupdate_log").value = "获取日志失败！";
					return false;
				}
			});
		}
		//推送信息
		function notice_show() {
			$.ajax({
				url: 'https://ledesoft.ngrok.wang/fwupdate//push_message.json.js',
				type: 'GET',
				dataType: "jsonp",
				success: function(res) {
					$("#push_titile").html(res.title);
					$("#push_content1").html(res.content1);
					$("#push_content2").html(res.content2);
				}
			});
		}
	</script>

	<div class="box">
		<div class="heading">固件更新<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				<li>在线更新或者重刷你的路由器固件，使用前请先更新本插件到最新版本。</li>
				<li>历史固件前往<a href='http://firmware.koolshare.cn/LEDE_X64_fw867/'  target='_blank'>Koolshare固件下载中心</a>查看。</li>
			</span>
		</div>	
	</div>
	<ul class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 固件信息</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-server1-rz-tab"><i class="icon-info"></i> 更新日志</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading">固件信息</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">

				$('#identification').forms([
					{ title: '当前固件版本', text: '<font id="_fwupdate_fwlocal" name=_fwupdate_status color="#1bbf35">正在检查本地固件版本...</font>' },
					{ title: '最新固件版本', text: '<font id="_fwupdate_fwlast" name=_fwupdate_status color="#1bbf35">正在获取最新固件版本...</font>' },
					{ title: '升级UEFI固件', name:'fwupdate_uefi',type:'checkbox',value: "0" == '1' },
					{ title: '保留配置', name:'fwupdate_keep',type:'checkbox',value: "0" == '1' },
					{ title: '强制重刷', name:'fwupdate_enforce',type:'checkbox',value: "0" == '1' },
				]);
			</script>
		</div>
	</div>

	<div class="box boxr1" style="margin-top: 10px;">
		<div class="heading">固件更新日志：</div>
		<div class="content">
			<fieldset>
				<div class="col-sm-10">
					<ul class="pullmsg" style="margin-left: 30px;">
						<span id="push_titile">获取更新日志失败！请检查网络！</span><br />
						<span id="push_content1"></span><br />
						<span id="push_content2"></span><br />
					</ul>
				</div>
			</fieldset>
		</div>
	</div>

	
	<div class="box boxr3">
		<div class="heading">运行日志</div>
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
