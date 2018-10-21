<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>智能家庭网关</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbus;
		var softcenter = 0;
		var option_wan_list = [];
		get_local_data();
		var params = ["homebridge_passwd,homebridge_mi_mac,homebridge_mi_passwd"];
		var _responseLen;
		var noChange = 0;
		var reload = 0;
		tabSelect('app1');
		
		//============================================
		function init_pp(){
			verifyFields();
			$("#_homebridge_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/homebridge_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}

			
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "homebridge_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_homebridge_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_homebridge_status").innerHTML = "获取本地版本信息失败！";
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
			var a = E('_homebridge_mi').checked;
			elem.display(PR('_homebridge_mi_mac'), a);
			elem.display(PR('_homebridge_mi_passwd'), a);
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
			dbus.homebridge_enable = E('_homebridge_enable').checked ? '1':'0';
			dbus.homebridge_autoconfig = E('_homebridge_autoconfig').checked ? '1':'0';
			dbus.homebridge_mi = E('_homebridge_mi').checked ? '1':'0';
			dbus.homebridge_passwd = E('_homebridge_passwd').value;
			dbus.homebridge_mi_mac = E('_homebridge_mi_mac').value;
			dbus.homebridge_mi_passwd = E('_homebridge_mi_passwd').value;
			// post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "homebridge_config.sh", "params":[""], "fields": dbus};
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
				url: '/_temp/hb_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_homebridge_log");
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
					E("_homebridge_log").value = "获取日志失败！";
					return false;
				}
			});
		}

	</script>

	<div class="box">
		<div class="heading">HomeBridge<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				Homebridge可以模拟成一个HomeKit网关。使用前请仔细阅读设置说明，<a id="hk_url" href="http://koolshare.cn/thread-123706-1-1.html" target="_blank">论坛详细配置教程</a>。
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
				$('#identification').forms([
					{ title: '开启Homebridge', name:'homebridge_enable',type:'checkbox',value: dbus.homebridge_enable == 1 },
					{ title: '运行状态', text: '<font id="_homebridge_status" name=_homebridge_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '网关配对密码配置', name:'homebridge_passwd',type:'text', maxlen: 10, size: 10, value: dbus.homebridge_passwd || '123-78-456', suffix: '输入8位匹配密码，格式：123-78-456' },
					{ title: '自动生成配置文件', name:'homebridge_autoconfig',type:'checkbox',value: dbus.homebridge_autoconfig == 1, suffix: '如果取消选择，请手动配置文件/koolshare/homebridge/config.json'},
					{ title: '开启小米智能硬件支持', name:'homebridge_mi',type:'checkbox',value: dbus.homebridge_mi == 1 },
					{ title: '小米智能网关MAC', name:'homebridge_mi_mac',type:'text', maxlen: 80, size: 60, value: dbus.homebridge_mi_mac || '286c0885b30f', suffix: '<lable id="_homebridge_mi_mac_nu"></lable>' },
					{ title: '小米智能网关密码', name:'homebridge_mi_passwd',type:'text', maxlen: 80, size: 60, value: dbus.homebridge_mi_passwd || ' cb30a01c1bcc4b3c' , suffix: '<lable id="_homebridge_mi_passwd_nu"></lable>' },
				]);
			</script>
		</div>
	<div class="box"><br>
	<div class="heading"><font color="#FF3300">设置说明：</font> <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 你必须购买支持homekit协议的硬件才能配置此网关使用。默认只能在局域网内使用，如果要在外网访问的话，需要家里有第四代的Apple TV或者任意iPad做中转。</font></li>
			<li> 小米第二代智能网关才能支持homekit，且需要开启开发者模式，进入局域网通信协议菜单，打开开关。</li>
			<li> 小米智能网关MAC为在米家APP中点击网关信息中显示mac=引号内的内容，设置时去掉：号且小写。</li>
			<li> 小米智能网关密码为在米家APP中点击局域网通信协议显示的密码，严格按照大小写。</li>
	</div>
	</div>
</div>
	<div class="box boxr3">
		<div class="heading">启动日志</div>
		<div class="content">
			<div class="section hb_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.hb_log').append('<textarea class="as-script" name="homebridge_log" id="_homebridge_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

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
	<script type="text/javascript">init_pp();</script>
</content>
