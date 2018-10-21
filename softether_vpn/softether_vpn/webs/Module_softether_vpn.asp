<title>SoftetherVPN</title>
<content>
<style type="text/css">
	.c-checkbox {
		margin-left:-10px;
	}
</style>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbus = [];
		var softcenter = 0;
		var _responseLen;
		var noChange = 0;
		var Scorll = 1;

		function init(){
			get_dbus_data();
			get_run_status();
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/softether_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
					E('_softether_enable').checked = (dbus["softether_enable"] == 1);
					E('_softether_l2tp').checked = (dbus["softether_l2tp"] == 1);
					E('_softether_sstp').checked = (dbus["softether_sstp"] == 1);
					E('_softether_openvpn').checked = (dbus["softether_openvpn"] == 1);
					setTimeout("get_log();", 500);
			  	}
			});
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "softether_status.sh", "params":[2], "fields": ""};
			$.ajax({
				type: "POST",
				cache:false,
				url: "/_api/",
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					console.log(response)
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_softether_status").innerHTML = response.result;
					setTimeout("get_run_status();", 10000);
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_softether_status").innerHTML = "获取运行状态失败！";
					setTimeout("get_run_status();", 5000);
				}
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
					E("_log").value = "当前没有日志可以获取。";
				}
			});
		}
		
		function Scroll(s){
			Scorll = s;
		}
	
	</script>
	<div class="box">
		<div class="heading">
			<a style="margin-left:-4px" href="https://github.com/koolshare/ledesoft/blob/master/softether_vpn/Changelog.txt" target="_blank"><font color="#0099FF">SoftetherVPN 1.0.6</font></a>
			<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
		</div>
		<div class="content">
			<span id="msg" class="col-sm-9" style="margin-top:10px;width:800px">SoftEther VPN是由筑波大学研究生Daiyuu Nobori因硕士论文开发的开源，跨平台，多重协定的虚拟私人网路方案。
			<br/>使用控制台可以轻松在路由器上搭建OpenVPN, IPsec, L2TP, MS-SSTP, L2TPv3 和 EtherIP服务器。</span>
		</div>	
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启SoftetherVPN', name:'softether_enable',type:'checkbox', value: dbus.softether_enable == '1' },
					{ title: 'SoftetherVPN运行状态', text: '<font id="_softether_status" name=softether_status color="#1bbf35">正在获取运行状态...</font>' },
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
	<script type="text/javascript">init();</script>
</content>
