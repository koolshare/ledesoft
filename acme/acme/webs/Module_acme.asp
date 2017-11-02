<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>Let's Encrypt</title>
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
		function init_acme(){
			verifyFields();
			get_local_data();
			$("#_acme_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/acme_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	dbus = data.result[0];
				}
			});
		}

			
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "acme_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_acme_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_acme_status").innerHTML = "获取本地版本信息失败！";
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
			var a = (E('_acme_ddns').value == '1');
			var b = (E('_acme_ddns').value == '2');
			var d = (E('_acme_ddns').value == '3');
			elem.display(PR('_acme_ddns_dnspodid'), b);
			elem.display(PR('_acme_ddns_dnspodkey'), b);
			elem.display(PR('_acme_ddns_aliid'), a);
			elem.display(PR('_acme_ddns_alikey'), a);
			elem.display(PR('_acme_ddns_cid'), d);
			elem.display(PR('_acme_ddns_ckey'), d);
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
			dbus.acme_enable = E('_acme_enable').checked ? '1':'0';
			dbus.acme_auto = E('_acme_auto').checked ? '1':'0';
			dbus.acme_host = E('_acme_host').value;
			dbus.acme_port = E('_acme_port').value;
			dbus.acme_ddns = E('_acme_ddns').value;
			dbus.acme_ddns_dnspodid = E('_acme_ddns_dnspodid').value;
			dbus.acme_ddns_dnspodkey = E('_acme_ddns_dnspodkey').value;
			dbus.acme_ddns_aliid = E('_acme_ddns_aliid').value;
			dbus.acme_ddns_alikey = E('_acme_ddns_alikey').value;
			dbus.acme_ddns_cid = E('_acme_ddns_cid').value;
			dbus.acme_ddns_ckey = E('_acme_ddns_ckey').value;
			// post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "acme_config.sh", "params":[""], "fields": dbus};
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
				url: '/_temp/acme_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_acme_log");
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
					E("_acme_log").value = "获取日志失败！";
					return false;
				}
			});
		}

	</script>

	<div class="box">
		<div class="heading">Let's Encrypt<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				Let's Encrypt是一个于2015年三季度成立的数字证书认证机构，旨在推广互联网无所不在的加密连接，为安全网站提供免费的SSL/TLS证书。
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
				if(!dbus.acme_host){dbus.acme_host = "lede.fw867.com";};
				if(!dbus.acme_port){dbus.acme_port = "3443";};
				var option_ddns = [['1', '阿里DDNS'], ['2', 'Dnspod'], ['3', 'CloudXNS']];
				$('#identification').forms([
					{ title: '开启', name:'acme_enable',type:'checkbox',value: dbus.acme_enable == 1 },
					{ title: '运行状态', text: '<font id="_acme_status" name=_acme_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '域名', name:'acme_host',type:'text', maxlen: 60, size: 60, value: dbus.acme_host },
					{ title: '端口转发', name:'acme_port',type:'text', maxlen: 5, size: 5,  value: dbus.acme_port },
					{ title: 'DDNS服务商', name:'acme_ddns',type:'select', options:option_ddns, value: dbus.acme_ddns },
					{ title: 'Dnspod ID', name:'acme_ddns_dnspodid',type:'text', maxlen: 60, size: 60,  value: dbus.acme_ddns_dnspodid },
					{ title: 'Dnspod Key', name:'acme_ddns_dnspodkey',type:'text', maxlen: 60, size: 60,  value: dbus.acme_ddns_dnspodkey },
					{ title: 'Ali Access Key ID', name:'acme_ddns_aliid',type:'text', maxlen: 60, size: 60,  value: dbus.acme_ddns_aliid },
					{ title: 'Ali Access Key Secret', name:'acme_ddns_alikey',type:'text', maxlen: 60, size: 60,  value: dbus.acme_ddns_alikey },
					{ title: 'CloudXNS Access Key ID', name:'acme_ddns_cid',type:'text', maxlen: 60, size: 60,  value: dbus.acme_ddns_cid },
					{ title: 'CloudXNS Access Key Secret', name:'acme_ddns_ckey',type:'text', maxlen: 60, size: 60,  value: dbus.acme_ddns_ckey },
					{ title: '自动更新证书', name:'acme_auto',type:'checkbox',value: dbus.acme_auto == 1 },
					{ title: '路由器管理', name:'acme_url' ,text: '<a href=https://' + dbus.acme_host + ":" + dbus.acme_port + '/ target="_blank"><u>https://'  + dbus.acme_host + ":" + dbus.acme_port + '</u></a>' },
				]);
			</script>
		</div>
	<div class="box"><br>
	<div class="heading"><font color="#FF3300">插件说明：</font> <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> Let's Encrypt的免费证书在2018年1月后才能支持泛域名*解析。</font></li>
			<li> Let's Encrypt的免费证书只有90天有效期，到期可以续期。</font></li>
			<li> 目前大部分的运营商已经关闭家用宽带80，443端口，如果需要在外网访问请设置端口转发。</font></li>
	</div>
	</div>
</div>
	<div class="box boxr3">
		<div class="heading">启动日志</div>
		<div class="content">
			<div class="section acme_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.acme_log').append('<textarea class="as-script" name="acme_log" id="_acme_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

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
	<script type="text/javascript">init_acme();</script>
</content>
