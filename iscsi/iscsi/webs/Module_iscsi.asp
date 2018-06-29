<!--
lede GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/lede/

For use with lede Firmware only.
No part of this file may be used without permission.
-->
<title>软件中心 - iSCSI服务器</title>
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
		function init_iscsi(){
			verifyFields();
			$("#_iscsi_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function get_local_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/iscsi_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}

			
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "iscsi_status.sh", "params":[], "fields": ""};
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
					document.getElementById("_iscsi_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_iscsi_status").innerHTML = "获取运行信息失败！";
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
			var a = E('_iscsi_auth').checked;
			var h2 = (E('_iscsi_disk_count').value == '2');
			var h3 = (E('_iscsi_disk_count').value == '3');
			var h4 = (E('_iscsi_disk_count').value == '4');
			var h5 = (E('_iscsi_disk_count').value == '5');
			elem.display(PR('_iscsi_user'), a);
			elem.display(PR('_iscsi_passwd'), a);
			elem.display(PR('_iscsi_disk_file5'), h5);
			elem.display(PR('_iscsi_disk_size5'), h5);
			elem.display(PR('_iscsi_disk_file4'), h5 || h4);
			elem.display(PR('_iscsi_disk_size4'), h5 || h4);
			elem.display(PR('_iscsi_disk_file3'), h5 || h4 || h3);
			elem.display(PR('_iscsi_disk_size3'), h5 || h4 || h3);
			elem.display(PR('_iscsi_disk_file2'), h5 || h4 || h3 || h2);
			elem.display(PR('_iscsi_disk_size2'), h5 || h4 || h3 || h2);
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
			if (E('_iscsi_passwd').type="password")
				E('_iscsi_passwd').type="txt";
				psclick.innerHTML="<a href=\"javascript:txt()\">隐藏密码</a>"
		}
		
		function txt(){
			if (E('_iscsi_passwd').type="text")
			E('_iscsi_passwd').type="password";
			psclick.innerHTML="<a href=\"javascript:ps()\">显示密码</a>"
		}

		function save(){
			verifyFields();
			// disable update botton when in update progress
			E('save-button').disabled = true;
			// collect basic data
			var para_chk = ["iscsi_enable", "iscsi_auth"];
			var para_inp = ["iscsi_disk_file1", "iscsi_disk_size1", "iscsi_disk_file2", "iscsi_disk_size2","iscsi_disk_file3", "iscsi_disk_size3","iscsi_disk_file4", "iscsi_disk_size4","iscsi_disk_file5", "iscsi_disk_size5","iscsi_user", "iscsi_passwd", "iscsi_disk_count", "iscsi_iothreads"];
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
			var postData3 = {"id": id3, "method": "iscsi_config.sh", "params":[""], "fields": dbus};
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
				url: '/_temp/iscsi_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_iscsi_log");
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
					E("_iscsi_log").value = "获取日志失败！";
					return false;
				}
			});
		}

	</script>

	<div class="box">
		<div class="heading">iSCSI服务器<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				iSCSI服务器可以在你的路由器上搭建一个比samba更加稳定和高效的共享文件服务器。
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
				if(!dbus.iscsi_disk_count){dbus.iscsi_disk_count = "1";};
				var option_count = [['1', '1'], ['2', '2'], ['3', '3'], ['4', '4'], ['5', '5']];
				$('#identification').forms([
					{ title: '开启iscsi', name:'iscsi_enable',type:'checkbox',value: dbus.iscsi_enable == 1 },
					{ title: '运行状态', text: '<font id="_iscsi_status" name=_iscsi_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '执行块I/O线程（不能大于CPU线程数）', name:'iscsi_iothreads',type:'text', maxlen: 4, size: 4, value: dbus.iscsi_iothreads || '2' },
					{ title: '要挂载的磁盘个数',name:'iscsi_disk_count',type:'select',options:option_count,value: dbus.iscsi_disk_count || "1" },
					{ title: '磁盘1目录', name:'iscsi_disk_file1',type:'text', maxlen: 50, size: 50, value: dbus.iscsi_disk_file1 || '/mnt/sda1/iscsi' },
					{ title: '磁盘1大小（单位G）', name:'iscsi_disk_size1',type:'text', maxlen: 6, size: 6,value: dbus.iscsi_disk_size1 || '2000' },
					{ title: '磁盘2目录', name:'iscsi_disk_file2',type:'text', maxlen: 50, size: 50, value: dbus.iscsi_disk_file2 || '/mnt/sdb1/iscsi' },
					{ title: '磁盘2大小（单位G）', name:'iscsi_disk_size2',type:'text', maxlen: 6, size: 6,value: dbus.iscsi_disk_size2 || '2000' },
					{ title: '磁盘3目录', name:'iscsi_disk_file3',type:'text', maxlen: 50, size: 50, value: dbus.iscsi_disk_file3 || '/mnt/sdc1/iscsi' },
					{ title: '磁盘3大小（单位G）', name:'iscsi_disk_size3',type:'text', maxlen: 6, size: 6,value: dbus.iscsi_disk_size3 || '2000' },
					{ title: '磁盘4目录', name:'iscsi_disk_file4',type:'text', maxlen: 50, size: 50, value: dbus.iscsi_disk_file4 || '/mnt/sdd1/iscsi' },
					{ title: '磁盘4大小（单位G）', name:'iscsi_disk_size4',type:'text', maxlen: 6, size: 6,value: dbus.iscsi_disk_size4 || '2000' },
					{ title: '磁盘5目录', name:'iscsi_disk_file5',type:'text', maxlen: 50, size: 50, value: dbus.iscsi_disk_file5 || '/mnt/sde1/iscsi' },
					{ title: '磁盘5大小（单位G）', name:'iscsi_disk_size5',type:'text', maxlen: 6, size: 6,value: dbus.iscsi_disk_size5 || '2000' },
					{ title: '连接验证', name:'iscsi_auth',type:'checkbox',value: dbus.iscsi_auth == 1 },
					{ title: '用户名', name:'iscsi_user',type:'text', maxlen: 50, size: 50, value: dbus.iscsi_user },
					{ title: '密码', name:'iscsi_passwd',type:'password', maxlen: 50, size: 50, value: dbus.iscsi_passwd, suffix: '<SPAN id=psclick><A href="javascript:ps()">显示密码</A></SPAN>' },
					]);
			</script>
		</div>
	<div class="box"><br>
	<div class="heading"><font color="#FF3300">设置说明：</font> <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 设置的硬盘大小比实际大小稍小一点，超出可能会造成数据丢失。</font></li>
			<br />
	</div>
	</div>
</div>
	<div class="box boxr3">
		<div class="heading">运行日志</div>
		<div class="content">
			<div class="section iscsi_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.iscsi_log').append('<textarea class="as-script" name="iscsi_log" id="_iscsi_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');

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
	<script type="text/javascript">init_iscsi();</script>
</content>
