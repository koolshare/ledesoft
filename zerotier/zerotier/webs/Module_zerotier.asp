<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>软件中心 - ZeroTier</title>
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
		function init_zerotier(){
			verifyFields();
			$("#_zerotier_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/zerotier_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}

			
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "zerotier_status.sh", "params":[], "fields": ""};
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
					document.getElementById("_zerotier_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_zerotier_status").innerHTML = "获取运行信息失败！";
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
			var zerotierenable = E('_zerotier_enable').checked ? '1':'0';
			if(zerotierenable == 0){
				$('input').prop('disabled', true);
				$(E('_zerotier_enable')).prop('disabled', false);
			}else{
				$('input').prop('disabled', false);
			}
			return 1;
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
			if (E('_zerotier_id').type="password")
				E('_zerotier_id').type="txt";
				psclick.innerHTML="<a href=\"javascript:txt()\">隐藏ID</a>"
		}
		
		function txt(){
			if (E('_zerotier_id').type="text")
			E('_zerotier_id').type="password";
			psclick.innerHTML="<a href=\"javascript:ps()\">显示ID</a>"
		}

		function save(){
			verifyFields();
			// disable update botton when in update progress
			E('save-button').disabled = true;
			// collect basic data
			var para_chk = ["zerotier_enable"];
			var para_inp = ["zerotier_id"];
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
			var postData3 = {"id": id3, "method": "zerotier_config.sh", "params":[""], "fields": dbus};
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
				url: '/_temp/zerotier_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_zerotier_log");
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
					E("_zerotier_log").value = "获取日志失败！";
					return false;
				}
			});
		}

	</script>

	<div class="box">
		<div class="heading">ZeroTier<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				ZeroTier通过单个系统提供VPN、SDN和SD-WAN功，将任何设备连接到一个局域网。
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
				var option_count = [['5', '5'], ['15', '15'], ['30', '30'], ['60', '60'], ['90', '90']];
				$('#identification').forms([
					{ title: '开启ZeroTier', name:'zerotier_enable',type:'checkbox',value: dbus.zerotier_enable == 1 },
					{ title: '运行状态', text: '<font id="_zerotier_status" name=_zerotier_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: 'Network ID', name:'zerotier_id',type:'password', maxlen: 50, size: 50, value: dbus.zerotier_id, suffix: '<SPAN id=psclick><A href="javascript:ps()">显示ID</A></SPAN>' },
					{ title: '开机延时启动', name:'zerotier_sleep',type:'select', maxlen: 3, size: 3, options:option_count ,value: dbus.zerotier_sleep || '30' },
					]);
			</script>
		</div>
	<div class="box"><br>
	<div class="heading"><font color="#FF3300">设置说明：</font> <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 1.首先到<a href="https://my.zerotier.com" target="_blank"> ZeroTier官网</a>注册账号。</li>
			<li> 2.点击顶部<a href="https://my.zerotier.com/network" target="_blank"> Networks</a>菜单，在页面点击Create创建Network。</li>
			<li> 3.点击创建好My Networks下的名称获取页面上的Network ID填入插件设置并开启运行。</li>
			<li> 4.返回刚才的Network ID官网页面，在右侧IPv4 Auto-Assign附近勾选 Auto-Assign from Range，然后选择一个ip段，如：192.168.192.X</li>
			<li> 5.网页往下拉，在 Members里会看到你的路由器的MAC信息，信息前面打上对号给予授权。过个两分钟左右在Managed IPs会出现网页分配的给你的ip信息，复制待用。</li>
			<li> 6.网页拉到最顶部在 Managed Routes 项里添加IP信息，如果你的路由器ip地址是192.168.2.1，在第一个框框里就添加192.168.2.0/24，第二个框框里写你刚刚复制的IP信息。</li>
			<li> 7.下载其它设备app,运行后只需要在Members里授权即可。</li>
			<br />
	</div>
	</div>
</div>
	<div class="box boxr3">
		<div class="heading">运行日志</div>
		<div class="content">
			<div class="section zerotier_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.zerotier_log').append('<textarea class="as-script" name="zerotier_log" id="_zerotier_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

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
	<script type="text/javascript">init_zerotier();</script>
</content>
