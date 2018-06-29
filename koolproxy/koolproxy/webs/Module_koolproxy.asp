<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/
For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<title>KoolProxy</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var softcenter = 0;
		var dbus;
		get_arp_list();
		get_dbus_data();
		var options_type = [];
		var options_list = [];
		var option_arp_list = [];
		var option_arp_local = [];
		var option_arp_web = [];
		var _responseLen;
		var noChange = 0;
		var reload = 0;
		var option_reboot_hour = [];
		var option_reboot_inter = [];
		for(var i = 0; i < 24; i++){
			option_reboot_hour[i] = [i, i + "时"];
		}
		for(var i = 0; i < 72; i++){
			option_reboot_inter[i] = [i + 1, i + 1 + "时"];
		}
		tabSelect('app1');
		if(typeof btoa == "Function") {
		   Base64 = {encode:function(e){ return btoa(e); }, decode:function(e){ return atob(e);}};
		} else {
		   Base64 ={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}}
		}
		
		//============================================
		var kpacl = new TomatoGrid();
		
		kpacl.exist = function( f, v ) {
			var data = this.getAllData();
			for ( var i = 0; i < data.length; ++i ) {
				if ( data[ i ][ f ] == v ) return true;
			}
			return false;
		}
		kpacl.dataToView = function( data ) {
			if (data[0]){
				return [ "【" + data[0] + "】", data[1], data[2], ['不过滤', 'http only', 'http + https', 'full port'][data[3]] ];
			}else{
				if (data[1]){
					return [ "【" + data[1] + "】", data[1], data[2], ['不过滤', 'http only', 'http + https', 'full port'][data[3]] ];
				}else{
					if (data[2]){
						return [ "【" + data[2] + "】", data[1], data[2], ['不过滤', 'http only', 'http + https', 'full port'][data[3]] ];
					}
				}
			}
		}
		kpacl.fieldValuesToData = function( row ) {
			var f = fields.getAll( row );
			if (f[0].value){
				return [ f[0].value, f[1].value, f[2].value, f[3].value ];
			}else{
				if (f[1].value){
					return [ f[1].value, f[1].value, f[2].value, f[3].value ];
				}else{
					if (f[1].value){
						return [ f[2].value, f[1].value, f[2].value, f[3].value ];
					}
				}
				
			}
		}
    	kpacl.onChange = function(which, cell) {
    	    return this.verifyFields((which == 'new') ? this.newEditor: this.editor, true, cell);
    	}
		kpacl.verifyFields = function( row, quiet, cell) {
			var f = fields.getAll( row );
			if ( $(cell).attr("id") == "_[object HTMLTableElement]_1" ) {
				if (f[0].value){
					f[1].value = option_arp_list[f[0].selectedIndex][2];
					f[2].value = option_arp_list[f[0].selectedIndex][3];
				}
			}
			
			if (f[1].value && !f[2].value){
				return v_ip( f[1], quiet );
			}
			if (!f[1].value && f[2].value){
				return v_mac( f[2], quiet );
			}
			if (f[1].value && f[2].value){
				return v_ip( f[1], quiet ) || v_mac( f[2], quiet );
			}
			if (f[0].value == "自定义"){
				console.log("sucess!");
				kpacl.updateUI;
			}
		}
		kpacl.onAdd = function() {
			var data;
			this.moving = null;
			this.rpHide();
			if (!this.verifyFields(this.newEditor, false)) return;
			data = this.fieldValuesToData(this.newEditor);
			this.insertData(1, data);
			this.disableNewEditor(false);
			this.resetNewEditor();
		}
		kpacl.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value = '';
			f[ 1 ].value   = '';
			f[ 2 ].value   = '';
			f[ 3 ].value   = '1';
		}
		kpacl.setup = function() {
			this.init( 'ctrl-grid', 'delete', 500, [
			{ type: 'select',maxlen:50,options:option_arp_list },
			{ type: 'text', maxlen: 50 },
			{ type: 'text', maxlen: 50 },
			{ type: 'select',maxlen:20,options:[['0', '不过滤'], ['1', 'http only'], ['2', 'http + https'],['3', 'full port']], value:'1'}
			] );
			
			this.headerSet( [ '主机别名', '主机IP地址', 'MAC地址', '访问控制' ] );
			this.footerSet( [ '<small><i>其它主机</small></i>', '<small><i>缺省规则</small></i>','',('<select id="_koolproxy_acl_default" name="koolproxy_acl_default"><option value="0">不过滤</option><option value="1" selected>http only</option><option value="2">http + https</option><option value="3">full port</option></select>')]);
			if(typeof(dbus["koolproxy_acl_list"]) != "undefined" ){
				var s = dbus["koolproxy_acl_list"].split( '>' );
			}else{
				var s =""
				return false;
			}
			if(typeof(dbus["koolproxy_acl_default"]) != "undefined" ){
				E("_koolproxy_acl_default").value = dbus["koolproxy_acl_default"];
			}
			for ( var i = 0; i < s.length; ++i ) {
				var t = s[ i ].split( '<' );
				if ( t.length == 4 ) this.insertData( -1, t );
			}
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		
		function init_kp(){
			verifyFields();
			//kpacl.setup(dbus);
			get_user_txt();
			$("#_koolproxy_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}
		function get_arp_list(){
			var id = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id, "method": "KoolProxy_getarp.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					if (response){
						get_dbus_data();
						//var s2 = response.result.split( '>' );
						var s2 = dbus["koolproxy_arp"].split( '>' );
						//console.log("s2", s2);
						for ( var i = 0; i < s2.length; ++i ) {
							option_arp_local[i] = [s2[ i ].split( '<' )[0],"【" + s2[ i ].split( '<' )[0] + "】",s2[ i ].split( '<' )[1],s2[ i ].split( '<' )[2]];
						}
						
						//console.log("option_arp_local", option_arp_local);
						var s3 = dbus["koolproxy_acl_list"].split( '>' );
						//console.log("s3", s3);
						for ( var i = 0; i < s3.length -1; ++i ) {
							option_arp_web[i] = [s3[ i ].split( '<' )[0],"【" + s3[ i ].split( '<' )[0] + "】",s3[ i ].split( '<' )[1],s3[ i ].split( '<' )[2]];
						}
						//option_arp_web[s3.length -1] = ["自定义", "【自定义】","",""];
						//console.log("option_arp_web", option_arp_web);
						//option_arp_list = $.extend([],option_arp_local, option_arp_web);
						option_arp_list = unique_array(option_arp_local.concat( option_arp_web ));
						//console.log("option_arp_list", option_arp_list);
						kpacl.setup();
					}
				},
				error:function(){
					kpacl.setup();
				},
				timeout:1000
			});
		}
		function unique_array(array){
			var r = [];
			for(var i = 0, l = array.length; i < l; i++) {
				for(var j = i + 1; j < l; j++)
				if (array[i][0] === array[j][0]) j = ++i;
					r.push(array[i]);
			}
			return r.sort();;
		}
		
		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/koolproxy_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}
		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "KoolProxy_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_koolproxy_status").innerHTML = response.result.split("@@")[0];
					document.getElementById("_koolproxy_rule_status").innerHTML = response.result.split("@@")[1];
					setTimeout("get_run_status();", 10000);
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_koolproxy_status").innerHTML = "获取运行状态失败！";
					document.getElementById("_koolproxy_rule_status").innerHTML = "获取规则状态失败！";
					setTimeout("get_run_status();", 5000);
				}
			});
		}	
		function download_cert(){
			location.href = "http://110.110.110.110";
		}
		function join_QQ(){
			window.open("//shang.qq.com/wpa/qunwpa?idkey=d6c8af54e6563126004324b5d8c58aa972e21e04ec6f007679458921587db9b0");
		}
		function join_KP(){
			window.open("https://koolproxy.io");
		}
		function verifyFields(){
			var a = E('_koolproxy_enable').checked;
			var f = (E('_koolproxy_reboot').value == '1');
			var g = (E('_koolproxy_reboot').value == '2');
			var h = (E('_koolproxy_mode').value == '2');
			var x = (E('_koolproxy_port').value == '1');
			var p = (E('_koolproxy_bp_port').value);
			E('_koolproxy_mode').disabled = !a;
			E('_koolproxy_port').disabled = !a			
//			E('_koolproxy_bp_port').disabled = !a;
			E('_koolproxy_reboot').disabled = !a;
			E('_download_cert').disabled = !a;
			elem.display('_koolproxy_reboot_hour', a && f);
			elem.display('koolproxy_reboot_hour_suf', a && f);
			elem.display('koolproxy_reboot_hour_pre', a && f);
			elem.display('_koolproxy_reboot_inter_hour', a && g);
			elem.display('koolproxy_reboot_inter_hour_suf', a && g);
			elem.display('koolproxy_reboot_inter_hour_pre', a && g);
			elem.display(PR('_koolproxy_host'), h);
			elem.display(PR('_koolproxy_bp_port'), x);
		}
		
		function tabSelect(obj){
			var tableX = ['app1-server1-jb-tab','app3-server1-kz-tab','app4-server1-zdy-tab','app5-server1-zsgl-tab','app6-server1-rz-tab'];
			var boxX = ['boxr1','boxr3','boxr4','boxr5','boxr6'];
			var appX = ['app1','app3','app4','app5','app6'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app6'){
				setTimeout("get_log();", 400);
				elem.display('save-button', false);
			}else{
				elem.display('save-button', true);
			}
		}
		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}
		function save(){
			verifyFields();
			// collect basic data
			dbus.koolproxy_enable = E('_koolproxy_enable').checked ? '1':'0';
			dbus.koolproxy_host = E('_koolproxy_host').checked ? '1':'0';
			dbus.koolproxy_mode = E('_koolproxy_mode').value;
			dbus.koolproxy_port = E('_koolproxy_port').value;
			dbus.koolproxy_bp_port = E('_koolproxy_bp_port').value;
			dbus.koolproxy_reboot = E('_koolproxy_reboot').value;
			dbus.koolproxy_reboot_hour = E('_koolproxy_reboot_hour').value;
			dbus.koolproxy_reboot_inter_hour = E('_koolproxy_reboot_inter_hour').value;
			dbus.koolproxy_acl_default = E('_koolproxy_acl_default').value;
			dbus["koolproxy_custom_rule"] = Base64.encode(document.getElementById("_koolproxy_custom_rule").value);
			// collect data from acl pannel
			var data2 = kpacl.getAllData();
			if(data2.length > 0){
				dbus["koolproxy_acl_node_max"] = data2.length;
			}else{
				dbus["koolproxy_acl_node_max"] = "";
			}
			var acllist = '';
			if(data2.length > 0){
				for ( var i = 0; i < data2.length; ++i ) {
					acllist += data2[ i ].join( '<' ) + '>';
				}
				dbus["koolproxy_acl_list"] = acllist;
			}else{
				dbus["koolproxy_acl_list"] = " ";
			}
			// post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "KoolProxy_config.sh", "params":["restart"], "fields": dbus};
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
			tabSelect("app6");
		}
		
		function get_log(){
			$.ajax({
				url: '/_temp/kp_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_koolproxy_log");
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
		function get_user_txt() {
			$.ajax({
				url: '/_temp/user.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(res) {
					$('#_koolproxy_custom_rule').val(res);
				}
			});
		}
		function kp_cert(script, arg){
			tabSelect("app6");
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[arg], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async: true,
				cache:false,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function(response){
					console.log("id", id);
					console.log("response", response);
					if (response.result == id){
						if (arg == 1){
							console.log("333");
							var a = document.createElement('A');
							a.href = "/files/koolproxyca.tar.gz";
							a.download = 'koolproxyCA.tar.gz';
							document.body.appendChild(a);
							a.click();
							document.body.removeChild(a);
						}else if (arg == 2){
							setTimeout("window.location.reload()", 1000);
						}
					}
				}
			});
		}
		function restore_cert(){
			var filename = $("#file").val();
			filename = filename.split('\\');
			filename = filename[filename.length-1];
			var filelast = filename.split('.');
			filelast = filelast[filelast.length-1];
			if(filelast !='gz'){
				alert('恢复文件格式不正确！');
				return false;
			}
			var formData = new FormData();
			formData.append('koolproxyCA.tar.gz', $('#file')[0].files[0]);
			$('.popover').html('正在恢复，请稍后……');
			//changeButton(true);
			$.ajax({
				url: '/_upload',
				type: 'POST',
				async: true,
				cache:false,
				data: formData,
				processData: false,
				contentType: false,
				complete:function(res){
					if(res.status==200){
						kp_cert('Koolproxy_cert.sh', 2);
					}
				}
			});
		}
	</script>

	<div class="box">
		<div class="heading">KoolProxy<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span id="msg" class="col-sm-9" style="margin-top:10px;width:700px">koolproxy是一款高效的修改和过滤流量包的代理软件，可以用于去除网页静广告和视频广告，并且支持https！</span>
		</div>	
	</div>
	<ul class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-server1-kz-tab"><i class="icon-tools"></i> 访问控制</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app4');" id="app4-server1-zdy-tab"><i class="icon-hammer"></i> 自定义规则</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app5');" id="app5-server1-zsgl-tab"><i class="icon-lock"></i> 证书管理</a></li>		
		<li><a href="javascript:void(0);" onclick="tabSelect('app6');" id="app6-server1-rz-tab"><i class="icon-info"></i> 日志信息</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启Koolproxy', name:'koolproxy_enable',type:'checkbox',value: dbus.koolproxy_enable == 1 },
					{ title: 'Koolproxy运行状态', text: '<font id="_koolproxy_status" name=_koolproxy_status color="#1bbf35">正在获取运行状态...</font>' },
					{ title: 'Koolproxy规则状态', text: '<font id="_koolproxy_rule_status" name=_koolproxy_status color="#1bbf35">正在获取规则状态...</font>' },
					{ title: '过滤模式', name:'koolproxy_mode',type:'select',options:[['1','全局模式'],['2','IPSET模式'],['3','视频模式']],value: dbus.koolproxy_mode || "1" },
					{ title: '端口控制', name:'koolproxy_port',type:'select',options:[['0','关闭'],['1','开启']],value: dbus.koolproxy_port || "0" },					
					{ title: '例外端口', name:'koolproxy_bp_port',type:'text',style:'input_style', maxlen:20, value:dbus.koolproxy_bp_port ,suffix: '<font color="#FF0000">例：</font>&nbsp;&nbsp;<font color="#FF0000">【单端口】：80【多端口】：80,443</font>'},
					{ title: '开启Adblock Plus Host', name:'koolproxy_host',type:'checkbox',value: dbus.koolproxy_host == 1, suffix: '<lable id="_koolproxy_host_nu"></lable>' },
					{ title: '插件自动重启', multi: [
						{ name:'koolproxy_reboot',type:'select',options:[['1','定时'],['2','间隔'],['0','关闭']],value: dbus.koolproxy_reboot || "0", suffix: ' &nbsp;&nbsp;' },
						{ name: 'koolproxy_reboot_hour', type: 'select', options: option_reboot_hour, value: dbus.koolproxy_reboot_hour || "", suffix: '<lable id="koolproxy_reboot_hour_suf">重启</lable>', prefix: '<span id="koolproxy_reboot_hour_pre" class="help-block"><lable>每天</lable></span>' },
						{ name: 'koolproxy_reboot_inter_hour', type: 'select', options: option_reboot_inter, value: dbus.koolproxy_reboot_inter_hour || "", suffix: '<lable id="koolproxy_reboot_inter_hour_suf">重启</lable>', prefix: '<span id="koolproxy_reboot_inter_hour_pre" class="help-block"><lable>每隔</lable></span>' }
					] },
					{ title: '证书下载', suffix: ' <button id="_download_cert" onclick="download_cert();" class="btn btn-danger">证书下载 <i class="icon-download"></i></button>&nbsp;&nbsp;<a class="kp_btn" href="https://koolproxy.io/docs/installation" target="_blank">【https过滤使用教程】<a>' },
					{ title: 'KoolProxy交流', suffix: ' <button id="_join_QQ" onclick="join_QQ();" class="btn">加入QQ群</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="join_KP();" class="btn">访问官网</button>' }
				]);
			</script>
		</div>
	</div>
	<div class="box boxr3">
		<div class="heading">访问控制</div>
		<div class="content">
			<div class="tabContent">	
				<table class="line-table" cellspacing=1 id="ctrl-grid"></table>
			</div>		
			<br><hr>
			<h4>使用手册</h4>
			<div class="section" id="sesdiv_notes2">
				<ul>
					<li>过滤https站点广告需要为相应设备安装证书，并启用http + https过滤！</li>
					<li><strong>full port</strong> 为全端口过滤，是包括443和80端口以内的全部端口，如果被过滤的设备开启这个，也需要安装证书！</li>
					<li>需要自定义列表内没有的主机时，把【主机别名】留空，填写其它的即可！</li>
					<li>访问控制面板中【ip地址】和【mac地址】至少一个不能为空！只有ip时匹配ip，只有mac时匹配mac，两个都有一起匹配！</li>
					<li>在路由器下的设备，不管是电脑，还是移动设备，都可以在浏览器中输入<i><b>110.110.110.110</b></i>来下载证书。</i></li>
					<li>如果想在多台装有koolroxy的路由设备上使用一个证书，请用winscp软件备份/koolshare/koolproxy/data文件夹，并上传到另一台路由。</li>
					<li><font color="red">注意！全端口过滤【full port】效果牛逼和覆盖的范围更广，但却对设备的性能有非常高的要求，请根据自己的设备的情况进行选择！</font></li>
					<li><font color="red">注意！如果使用全端口过滤【full port】导致一些端口出现问题，可以开启端口控制，进行例外端口排除！</font></li>					
				</ul>
			</div>
			<br><hr>
		</div>
	</div>
	<div class="box boxr4">
		<div class="heading">自定义规则</div>
		<div class="content">
			<div class="tabContent">
			<div class="section user_rule content"></div>
			<script type="text/javascript">
				y = Math.floor(docu.getViewSize().height * 0.75);
				s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
				$('.section.user_rule').append('<textarea class="as-script" name="koolproxy_custom_rule" id="_koolproxy_custom_rule" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
			</script>
		</div>
			</div>
		</div>
	</div>
	<div class="box boxr5">
		<div class="heading">证书管理</div>
		<div class="content">
			<div id="kp_certificate_management" class="section"></div>
			<script type="text/javascript">
				$('#kp_certificate_management').forms([
					{ title: '证书备份', suffix: '<button onclick="kp_cert(\'Koolproxy_cert.sh\', 1);" class="btn btn-success">证书备份 <i class="icon-download"></i></button>' },
					{ title: '证书恢复', suffix: '<input type="file" id="file" size="50">&nbsp;&nbsp;<button id="upload1" type="button"  onclick="restore_cert();" class="btn btn-danger">上传并恢复 <i class="icon-cloud"></i></button>' }
				]);
			</script>
		</div>
	</div>	
	<div class="box boxr6">
		<div class="heading">状态日志</div>
		<div class="content">
			<div class="section kp_log content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('.section.kp_log').append('<textarea class="as-script" name="koolproxy_log" id="_koolproxy_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
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
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
	<script type="text/javascript">init_kp();</script>
</content>
