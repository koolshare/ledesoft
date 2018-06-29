<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>拨号助手</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbus;
		var softcenter = 0;
		var option_wan_list = [];
		get_local_data();
		var params = ["pppoeai_port", "pppoeai_count", "pppoeai_ip1", "pppoeai_ip2", "pppoeai_ip3"];
		var _responseLen;
		var noChange = 0;
		var reload = 0;
		tabSelect('app1');
		
		//============================================
		function init_pp(){
			get_wan_list();
			verifyFields();
			$("#_pppoeai_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/pppoeai_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}

		function get_wan_list(){
			var id = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id, "method": "pppoeai_getwan.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					if (response){
						var wans = response.result.split( '>' );
						for ( var i = 0; i < wans.length; ++i ) {
							$("#_pppoeai_wan").append("<option value='"  + wans[i] + "'>" + wans[i] + "</option>");
						}
					}
				}
			});
		}
			
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "pppoeai_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_pppoeai_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_pppoeai_status").innerHTML = "获取本地版本信息失败！";
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

		function verifyFields(r){
			var a = (E('_pppoeai_count').value == '1');
			var b = (E('_pppoeai_count').value == '2');
			var c = (E('_pppoeai_count').value == '3');
			elem.display(PR('_pppoeai_ip1'), a);
			elem.display(PR('_pppoeai_ip2'), b);
			elem.display(PR('_pppoeai_ip3'), c);
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
			dbus.pppoeai_enable = E('_pppoeai_enable').checked ? '1':'0';
			dbus.pppoeai_wan = E('_pppoeai_wan').value;
			dbus.pppoeai_count = E('_pppoeai_count').value;
			dbus.pppoeai_ip1 = E('_pppoeai_ip1').value;
			dbus.pppoeai_ip2 = E('_pppoeai_ip2').value;			
			dbus.pppoeai_ip3 = E('_pppoeai_ip3').value;			
			// post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "pppoeai_config.sh", "params":[""], "fields": dbus};
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
				url: '/_temp/pp_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_pppoeai_log");
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
					E("_pppoeai_log").value = "获取日志失败！";
					return false;
				}
			});
		}

	</script>

	<div class="box">
		<div class="heading">拨号助手<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				将你的宽带拨号到指定的号段，开启后会重复拨号，直到获取到指定的IP段停止。
			</span>
		</div>	
	</div>
	<ul class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 固件信息</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-server1-rz-tab"><i class="icon-info"></i> 更新日志</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启拨号助手', name:'pppoeai_enable',type:'checkbox',value: dbus.pppoeai_enable == 1 },
					{ title: '运行状态', text: '<font id="_pppoeai_status" name=_pppoeai_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '匹配的WAN口', name:'pppoeai_wan',type:'select',options:[],value: dbus.pppoeai_wan || "1" },
					{ title: 'IP头匹配位数', name:'pppoeai_count',type:'select',options:[['1','1'],['2','2'],['3','3']],value: dbus.pppoeai_count || "1" },
					{ title: '一位IP头设置', name:'pppoeai_ip1',type:'text', maxlen: 100, size: 100, value: dbus.pppoeai_ip1, suffix: '<lable id="_pppoeai_ip1_nu"></lable>' },
					{ title: '两位IP头设置', name:'pppoeai_ip2',type:'text', maxlen: 100, size: 100, value: dbus.pppoeai_ip2, suffix: '<lable id="_pppoeai_ip1_nu"></lable>' },
					{ title: '三位IP头设置', name:'pppoeai_ip3',type:'text', maxlen: 100, size: 100, value: dbus.pppoeai_ip3, suffix: '<lable id="_pppoeai_ip1_nu"></lable>' },
				]);
			</script>
		</div>
	<div class="box">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li> IP头必须严格匹配你设置的位数，如一位：<font color="#FF3300">114 </font>两位：<font color="#FF3300">114.114</font>  三位：<font color="#FF3300">114.114.114</font></li>
			<br />
			<li> 如需匹配多个IP头，用<font color="#FF3300">逗号</font>或者<font color="#FF3300">空格</font>分隔，如一位：<font color="#FF3300">224,225  两位：<font color="#FF3300">224.224     225.115</font>  三位：<font color="#FF3300">224.224.224,225.225.115</font></li>
	</div>
	</div>
</div>
	<div class="box boxr3">
		<div class="heading">拨号日志</div>
		<div class="content">
			<div class="section pp_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.pp_log').append('<textarea class="as-script" name="pppoeai_log" id="_pppoeai_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

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
