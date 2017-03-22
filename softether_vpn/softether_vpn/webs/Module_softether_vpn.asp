<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<title>SoftetherVPN</title>
<content>
	<script type="text/javascript">
		var dbus = [];
		function get_local_data(){
			$.getJSON("/_api/softether", function(res) {
				dbus=res.result[0];
				E('_softether_enable').checked = (dbus["softether_enable"] == 1);
				E('_softether_l2tp').checked = (dbus["softether_l2tp"] == 1);
				E('_softether_sstp').checked = (dbus["softether_sstp"] == 1);
				E('_softether_openvpn').checked = (dbus["softether_openvpn"] == 1);

				setTimeout("get_log();", 500);
			});
		}

		function verifyFields(){
			return true;
		}
		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}
		function save(){
			setTimeout("get_log();", 500);
			dbus["softether_enable"] = E('_softether_enable').checked ? '1':'0';
			dbus["softether_l2tp"] = E('_softether_l2tp').checked ? '1':'0';
			dbus["softether_sstp"] = E('_softether_sstp').checked ? '1':'0';
			dbus["softether_openvpn"] = E('_softether_openvpn').checked ? '1':'0';
			// post data
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "softether_config.sh", "params":[1], "fields": dbus};
			showMsg("msg_warring","正在提交数据！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				type: "POST",
				dataType: "json",
				data: JSON.stringify(postData),
				success: function(response){
					if(response.result == id){
						showMsg("msg_success","提交成功","<b>成功提交数据。</b>");
						$('#msg_warring').hide();
						setTimeout("$('#msg_success').hide()", 5000);
					}
				}
			});
		}
		var _responseLen;
		var noChange = 0;
		var Scorll = 1;
		function get_log(){
			$.ajax({
				url: '/_temp/softether_log.txt',
				type: 'GET',
				dataType: 'text',
				success: function(response) {
					var retArea = E("_log");
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
					if (noChange > 10000) {
						return false;
					} else {
						setTimeout("get_log();", 500); //100 is radical but smooth!
					}
					retArea.value = response;
					if (Scorll == '1'){
						retArea.scrollTop = retArea.scrollHeight;
						_responseLen = response.length;
					}
				},
				error: function() {
					E("_log").value = "获取日志失败！";
				}
			});
		}
		function Scroll(s){
			Scorll = s;
		}
		
	</script>
	<div class="box">
		<div class="heading">SoftetherVPN 1.0.0<a href="/#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span id="msg" class="col-sm-9" style="margin-top:10px;width:800px">SoftEther VPN是由筑波大学研究生Daiyuu Nobori因硕士论文开发的开源，跨平台，多重协定的虚拟私人网路方案。<br/>使用控制台可以轻松在路由器上搭建OpenVPN, IPsec, L2TP, MS-SSTP, L2TPv3 和 EtherIP服务器。</span>
		</div>	
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启SoftetherVPN', name:'softether_enable',type:'checkbox', value: dbus.softether_enable == '1' },
					{ title: '防火墙设置', multi: [
						{ name:'softether_l2tp',type:'checkbox',value: dbus.softether_l2tp == '1', suffix: '<lable id="_ss_basic_gfwlist_update_txt">开启L2TP/IPSEC防火墙</lable>&nbsp;&nbsp;&nbsp;&nbsp;' },
						{ name:'softether_sstp',type:'checkbox',value: dbus.softether_sstp == '1', suffix: '<lable id="_ss_basic_chnroute_update_txt">开启MS-SSTP防火墙</lable>&nbsp;&nbsp;&nbsp;&nbsp;' },
						{ name:'softether_openvpn',type:'checkbox',value: dbus.softether_openvpn == '1', suffix: '<lable id="_ss_basic_cdn_update_txt">开启OPENVPN防火墙</lable>&nbsp;&nbsp;&nbsp;&nbsp;' }
					]},
					{ title: '设置教程', text:'<a class="btn" href="http://koolshare.cn/thread-67572-1-1.html" target="_blank">设置教程</a>'},
					{ title: '控制台下载', text:'<a class="btn" href="http://www.softether-download.com/files/softether/v4.22-9634-beta-2016.11.27-tree/Windows/SoftEther_VPN_Server_and_VPN_Bridge/softether-vpnserver_vpnbridge-v4.22-9634-beta-2016.11.27-windows-x86_x64-intel.exe">Windows-x86_x64-intel.exe</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class="btn" href="http://www.softether-download.com/files/softether/v4.21-9613-beta-2016.04.24-tree/Mac_OS_X/Admin_Tools/VPN_Server_Manager_Package/softether-vpnserver_manager-v4.21-9613-beta-2016.04.24-macos-x86-32bit.pkg">macos-x86-32bit.pkg</a>'},
					{ title: '软件版本', text:'软件版本：SoftEther_VPN_Server_version_4.2.2_build_9634'}
				]);
			</script>
			<div id="log_pannel" class="content">
				<div class="section content">
					<script type="text/javascript">
						y = Math.floor(docu.getViewSize().height * 0.18);
						s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
						$('#log_pannel').append('<textarea class="as-script" name="_log" id="_log" onmouseover="Scroll(0);" onmouseout="Scroll(1);" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
					</script>
				</div>
			</div>
		</div>
		
	</div>

	<div id="msg_warring" class="alert alert-warning icon" style="display:none;">
	</div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;">
	</div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;">
	</div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
	<script type="text/javascript">get_local_data();</script>
</content>
