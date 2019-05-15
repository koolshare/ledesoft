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
				return [ "【" + data[0] + "】", data[1], data[2], ['不过滤', '全局模式', '带HTTPS的全局模式', '黑名单模式', '带HTTPS的黑名单模式', '全端口模式'][data[3]] ];
			}else{
				if (data[1]){
					return [ "【" + data[1] + "】", data[1], data[2], ['不过滤', '全局模式', '带HTTPS的全局模式', '黑名单模式', '带HTTPS的黑名单模式', '全端口模式'][data[3]] ];
				}else{
					if (data[2]){
						return [ "【" + data[2] + "】", data[1], data[2], ['不过滤', '全局模式', '带HTTPS的全局模式', '黑名单模式', '带HTTPS的黑名单模式', '全端口模式'][data[3]] ];
					}
				}
			}
		}
		kpacl.fieldValuesToData = function( row ) {
			var f = fields.getAll( row );
			//alert(dbus["koolproxy_portctrl_mode"]);
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
			{ type: 'select',maxlen:20,options:[['0', '不过滤'], ['1', '全局模式'], ['2', '带HTTPS的全局模式'], ['3', '黑名单模式'], ['4', '带HTTPS的黑名单模式'], ['5', '全端口模式']], value: '1' }
			] );

			this.headerSet( [ '主机别名', '主机IP地址', 'MAC地址', '过滤模式控制' ] );
//			this.footerSet( [ '', '', '', ('')]);
			if(typeof(dbus["koolproxy_acl_list"]) != "undefined" ){
				var s = dbus["koolproxy_acl_list"].split( '>' );
			}else{
				var s =""
				return false;
			}
//			dbus.koolproxy_acl_mode = E('_koolproxy_acl_mode').value;
//			if(typeof(dbus["koolproxy_acl_mode"]) != "undefined" ){
//			E("_koolproxy_acl_mode").value = dbus["koolproxy_acl_mode"];
//			}
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
			set_version();
			get_user_txt();
			$("#_koolproxy_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
			setTimeout("get_rules_status();", 1000);			
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
						option_arp_web[s3.length -1] = ["自定义", "【自定义设备】","",""];
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
					setTimeout("get_log();", 500);	
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
					setTimeout("get_run_status();", 1000);
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_koolproxy_status").innerHTML = "获取运行状态失败！";
					document.getElementById("_koolproxy_rule_status").innerHTML = "获取规则状态失败！";
					setTimeout("get_run_status();", 500);
				}
			});
		}
		
		function get_rules_status(){
			var id2 = parseInt(Math.random() * 100000000);
			var postData2 = {"id": id2, "method": "KoolProxy_rules_status.sh", "params":[2], "fields": ""};
			$.ajax({
				type: "POST",
				cache:false,
				url: "/_api/",
				data: JSON.stringify(postData2),
				dataType: "json",
				success: function(response){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_koolproxy_third_rule_status").innerHTML = response.result.split("@@");
					setTimeout("get_rules_status();", 20000);
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_koolproxy_third_rule_status").innerHTML = "获取规则状态失败！";
					setTimeout("get_rules_status();", 10000);
				}
			});
		}		
		
		function download_cert(){
			location.href = "http://110.110.110.110";
		}
		function https_KP(){
			window.open("https://koolproxy.io/docs/videos");			
		}	
		function join_QQ(){
			window.open("//shang.qq.com/wpa/qunwpa?idkey=d6c8af54e6563126004324b5d8c58aa972e21e04ec6f007679458921587db9b0");
		}
		function join_KP(){
			window.open("https://koolproxy.io");
		}
		function issues_KP(){
			window.open("https://uyzeda.fanqier.cn/f/v5mhk3");
		}
		function query_KP(){
			window.open("https://uyzeda.fanqier.cn/f/v5mhk3/query");
		}		
		function verifyFields(){
			var a = E('_koolproxy_enable').checked;
//			var f = (E('_koolproxy_reboot').value == '1');
//			var g = (E('_koolproxy_reboot').value == '2');
//			var h = (E('_koolproxy_mode').value == '2');
			var h = (E('_koolproxy_mode_enable').value == '0');
			var s = (E('_koolproxy_mode_enable').value == '1');
			var x = (E('_koolproxy_port').value == '1');
//			var o = (E('_koolproxy_mode').value == '5');
			var p = (E('_koolproxy_bp_port').value);
			E('_koolproxy_mode_enable').disabled = !a;
			E('_koolproxy_port').disabled = !a;			
			E('_koolproxy_mode').disabled = !a;
			E('_koolproxy_base_mode').disabled = !a;		
//			E('_koolproxy_bp_port').disabled = !a;
//			E('_koolproxy_reboot').disabled = !a;
			E('_download_cert').disabled = !a;
			elem.display(PR('_koolproxy_mode'), s);
			elem.display(PR('_koolproxy_base_mode'), h);
//			elem.display('_koolproxy_reboot_hour', a && f);
//			elem.display('koolproxy_reboot_hour_suf', a && f);
//			elem.display('koolproxy_reboot_hour_pre', a && f);
//			elem.display('_koolproxy_reboot_inter_hour', a && g);
//			elem.display('koolproxy_reboot_inter_hour_suf', a && g);
//			elem.display('koolproxy_reboot_inter_hour_pre', a && g);
			elem.display('readme_port', x);
//			elem.display(PR('_koolproxy_host'), h);
			if (dbus["koolproxy_portctrl_mode"]=="1"){
				var z = true;
			}else{
				var z = false;
				x = false;
			}
			elem.display(PR('_koolproxy_port'), z);
			elem.display(PR('_koolproxy_bp_port'), x);
		}

		function tabSelect(obj){
			var tableX = ['app1-server1-jb-tab','app3-server1-kz-tab','app4-server1-zdy-tab','app5-server1-zsgl-tab','app6-server1-gzgl-tab','app7-server1-rz-tab'];
			var boxX = ['boxr1','boxr3','boxr4','boxr5','boxr6','boxr7'];
			var appX = ['app1','app3','app4','app5','app6','app7'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app7'){
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
		
		function toggleVisibility(whichone) {
			if (E('sesdiv' + whichone).style.display == '') {
				E('sesdiv' + whichone).style.display = 'none';
				E('sesdiv' + whichone + 'showhide').innerHTML = '<i class="icon-chevron-up"></i>';
				cookie.set('adv_dhcpdns_' + whichone + '_vis', 0);
			} else {
				E('sesdiv' + whichone).style.display = '';
				E('sesdiv' + whichone + 'showhide').innerHTML = '<i class="icon-chevron-down"></i>';
				cookie.set('adv_dhcpdns_' + whichone + '_vis', 1);
			}
		}

		function save(){
			var KP = document.getElementById('_koolproxy_enable').checked==false;			
			var R1 = document.getElementById('_koolproxy_oline_rules').checked==false;
//			var R2 = document.getElementById('_koolproxy_easylist_rules').checked==false;
//			var R3 = document.getElementById('_koolproxy_abx_rules').checked==false;
//			var R4 = document.getElementById('_koolproxy_fanboy_rules').checked==false;
			var R5 = document.getElementById('_koolproxy_encryption_rules').checked==false;

			if (KP){
				
//			}else if(R1 && R2 && R3 && R4 && R5){
			}else if(R1 && R5){				
				alert("请到【规则管理】勾选规则！");
				return false;
			}
			verifyFields();
			// collect basic data
			dbus.koolproxy_enable = E('_koolproxy_enable').checked ? '1':'0';
			dbus.koolproxy_mode_enable = E('_koolproxy_mode_enable').value;			
//			dbus.koolproxy_host = E('_koolproxy_host').checked ? '1':'0';
			dbus.koolproxy_base_mode = E('_koolproxy_base_mode').value;			
			dbus.koolproxy_mode = E('_koolproxy_mode').value;
			dbus.koolproxy_port = E('_koolproxy_port').value;
			dbus.koolproxy_bp_port = E('_koolproxy_bp_port').value;
//			dbus.koolproxy_reboot = E('_koolproxy_reboot').value;
//			dbus.koolproxy_reboot_hour = E('_koolproxy_reboot_hour').value;
//			dbus.koolproxy_reboot_inter_hour = E('_koolproxy_reboot_inter_hour').value;
			dbus.koolproxy_oline_rules = E("_koolproxy_oline_rules").checked ? "1" : "0";
			dbus.koolproxy_encryption_rules = E("_koolproxy_encryption_rules").checked ? "1" : "0";
//			dbus.koolproxy_easylist_rules = E("_koolproxy_easylist_rules").checked ? "1" : "0";
//			dbus.koolproxy_abx_rules = E("_koolproxy_abx_rules").checked ? "1" : "0";
//			dbus.koolproxy_fanboy_rules = E("_koolproxy_fanboy_rules").checked ? "1" : "0";
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
			if(dbus["koolproxy_acl_list"].indexOf('<5')!=-1){
				dbus.koolproxy_portctrl_mode = '1';
			}else{
				dbus.koolproxy_portctrl_mode = '0';
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
			tabSelect("app7");
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
			tabSelect("app7");
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
		
		function set_version() {
			$('#_koolproxy_version').html('<font color="#0099FF">KoolProxy</font>');
		}

	</script>

	<div class="box">
		<div class="heading">
		<span id="_koolproxy_version"></span>
		<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
		</div>
		<div class="content">
			<span id="msg" class="col" style="line-height:30px;width:700px">koolproxy是一款高效的修改和过滤流量包的软件，用于保护未成年人健康上网，并且支持https和IPV6！</span>
		</div>	
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="koolproxy_switch_pannel" class="section" style="margin-top: -20px;"></div>
			<script type="text/javascript">
				$('#koolproxy_switch_pannel').forms([
					{ title: '开启KoolProxy', name:'koolproxy_enable',type:'checkbox',value: dbus.koolproxy_enable == 1 }
				]);
			</script>
			<hr />
			<fieldset id="koolproxy_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">KoolProxy运行状态</label>
				<div class="col-sm-9" style="margin-top:2px">
					<font id="_koolproxy_status" name="_koolproxy_status" color="#1bbf35">正在检查运行状态...</font>
				</div>
			</fieldset>
		</div>
	</div>	
	<!-- ------------------ 标签页 --------------------- -->	
	<ul class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-server1-kz-tab"><i class="icon-tools"></i> 访问控制</a></li>		
		<li><a href="javascript:void(0);" onclick="tabSelect('app4');" id="app4-server1-zdy-tab"><i class="icon-hammer"></i> 自定义规则</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app5');" id="app5-server1-zsgl-tab"><i class="icon-lock"></i> 证书管理</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app6');" id="app6-server1-gzgl-tab"><i class="icon-cmd"></i> 规则管理</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app7');" id="app7-server1-rz-tab"><i class="icon-info"></i> 日志信息</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
//					{ title: '开启Koolproxy', name:'koolproxy_enable',type:'checkbox',value: dbus.koolproxy_enable == 1 },
//					{ title: 'Koolproxy运行状态', text: '<font id="_koolproxy_status" name=_koolproxy_status color="#1bbf35">正在获取运行状态...</font>' },
//					{ title: 'Koolproxy规则状态', text: '<font id="_koolproxy_rule_status" name=_koolproxy_status color="#1bbf35">正在获取规则状态...</font>' },
					{ title: '开启进阶模式', name:'koolproxy_mode_enable',type:'select',options:[['0','关闭'],['1','开启']],value: dbus.koolproxy_mode_enable || "0" },
					{ title: '过滤模式', name:'koolproxy_base_mode',type:'select',options:[['0','不过滤'],['1','全局模式'],['2','黑名单模式']],value: dbus.koolproxy_base_mode || "1" },
					{ title: '过滤模式', name:'koolproxy_mode',type:'select',options:[['0','不过滤'],['1','全局模式'],['2','带HTTPS的全局模式'],['3','黑名单模式'],['4','带HTTPS的黑名单模式']],value: dbus.koolproxy_mode || "1" },
					{ title: '端口控制', name:'koolproxy_port',type:'select',options:[['0','关闭'],['1','开启']],value: dbus.koolproxy_port || "0",
					suffix: '<lable id="readme_port"><font color="#FF0000">【端口控制】&nbsp;&nbsp;只有全端口模式下才生效</font></lable>'},
					{ title: '例外端口', name:'koolproxy_bp_port',type:'text',style:'input_style', maxlen:50, value:dbus.koolproxy_bp_port ,suffix: '<font color="#FF0000">例：</font><font color="#FF0000">【单端口】：80【多端口】：80,443</font>'},
//					{ title: '开启Adblock Plus Host', name:'koolproxy_host',type:'checkbox',value: dbus.koolproxy_host == 1, suffix: '<lable id="_koolproxy_host_nu"></lable>' },
//					{ title: '插件自动重启', multi: [
//						{ name:'koolproxy_reboot',type:'select',options:[['1','定时'],['2','间隔'],['0','关闭']],value: dbus.koolproxy_reboot || "0", suffix: ' &nbsp;&nbsp;' },
//						{ name: 'koolproxy_reboot_hour', type: 'select', options: option_reboot_hour, value: dbus.koolproxy_reboot_hour || "", suffix: '<lable id="koolproxy_reboot_hour_suf">重启</lable>', prefix: '<span id="koolproxy_reboot_hour_pre" class="help-block"><lable>每天</lable></span>' },
//						{ name: 'koolproxy_reboot_inter_hour', type: 'select', options: option_reboot_inter, value: dbus.koolproxy_reboot_inter_hour || "", suffix: '<lable id="koolproxy_reboot_inter_hour_suf">重启</lable>', prefix: '<span id="koolproxy_reboot_inter_hour_pre" class="help-block"><lable>每隔</lable></span>' }
//					] },
					{ title: '证书下载', suffix: ' <button id="_download_cert" onclick="download_cert();" class="btn btn-danger">证书下载 <i class="icon-download"></i></button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="https_KP();" class="btn btn-success">HTTPS过滤教程 <i class="icon-hammer"></i></button>' },
					{ title: '反馈查询', suffix: ' <button id="_issues_KP" onclick="issues_KP();" class="btn btn-primary">问题反馈 <i class="icon-tools"></i></button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="query_KP();" class="btn btn-success">结果查询 <i class="icon-search"></i></button>' },
					{ title: 'KoolProxy交流', suffix: ' <button id="_join_QQ" onclick="join_QQ();" class="btn">加入QQ群 <i class="icon-plus"></i></button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="join_KP();" class="btn btn-hello">访问官网 <i class="icon-globe"></i></button>' }
//					{ title: '广告赞助', suffix: ' <button onclick="Ad_Contribution();" class="btn btn-primary">养我啊 <i class="icon-check"></i></button>' }
				]);
			</script>
		</div>
	</div>
	<div id="kp_mode_readme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">过滤模式说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li>【进阶模式】不推荐新手或者第一次使用KoolProxy的用户使用。</li>		
			<li>【不过滤】不过滤任何设备，除非你在访问控制里另外设置过滤模式。</li>
			<li>【全局模式】只过滤80端口的流量并且是所有网站的流量都过滤。</li>
			<li>【带HTTPS的全局模式】只过滤80和443端口的流量并且是所有网站的流量都过滤。</li>
			<li>【黑名单模式】只过滤80端口流量并且是在黑名单内的网站流量。</li>
			<li>【带HTTPS的黑名单模式】只过滤80和443端口流量并且是在黑名单内的网站流量。</li>
			<li>【全端口模式】过滤包含80和443端口以外的所有端口流量并且是所有网站的流量都过滤。</li>
			<li>【全端口模式】需要更强大的性能作为过滤的保障。</li>
	</div>
	</div>	
	<div class="box boxr3">
		<div class="heading"></div>
		<div class="content">
			<div class="tabContent">	
				<table class="line-table" cellspacing=1 id="ctrl-grid"></table>
			</div>		
			<br><hr>
			<h4>使用手册</h4>
			<div class="section" id="sesdiv_notes2">
				<li>过滤https站点需要为相应设备安装证书，并启用带HTTPS过滤的模式！</li>
				<li>【全端口模式】是包括443和80端口以内的全部端口进行过滤，如果被过滤的设备开启这个，也需要安装证书！</li>
				<li>需要自定义列表内没有的主机时，把【主机别名】留空，填写其它的即可！</li>
				<li>访问控制面板中【ip地址】和【mac地址】至少一个不能为空！只有ip时匹配ip，只有mac时匹配mac，两个都有一起匹配！</li>
				<li>在路由器下的设备，不管是电脑，还是移动设备，都可以在浏览器中输入<i><b>110.110.110.110</b></i>来下载证书。</i></li>
				<li>如果想在多台装有koolroxy的路由设备上使用一个证书，请用本插件的证书备份功能，并上传到另一台路由。</li>
				<li><font color="red">注意！【全端口模式】过滤效果牛逼和覆盖的范围更广，但却对设备的性能有非常高的要求，请根据自己的设备的情况进行选择！</font></li>
				<li><font color="red">注意！如果使用全端口模式过滤导致一些端口出现问题，可以开启端口控制，进行例外端口排除！</font></li>
			</div>
			<br><hr>
		</div>
	</div>
	<div class="box boxr4" id="kp_user_rules" style="margin-top: 0px;">
		<div id="kp_user_pannel" class="content">
			<div class="tabContent">
			<div class="section content">
			<script type="text/javascript">
				y = Math.floor(docu.getViewSize().height * 0.75);
				s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
				$('#kp_user_pannel').append('<textarea class="as-script" name="koolproxy_custom_rule" id="_koolproxy_custom_rule" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
			</script>
		</div>
			</div>
		</div>
	</div>
	<div class="box boxr5">
		<div class="heading"></div>
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
		<div class="heading"></div>
		<div class="content">
			<div id="kp_rules_pannel" class="section"></div>
			<script type="text/javascript">
				$('#kp_rules_pannel').forms([
					{ title: '绿坝规则状态', text: '<font id="_koolproxy_rule_status" name=_koolproxy_status color="#1bbf35">正在获取规则状态...</font>' },
					{ title: '第三方规则状态', text: '<font id="_koolproxy_third_rule_status" name=_koolproxy_status color="#1bbf35">正在获取规则状态...</font>' },	
					{ title: '默认规则订阅', multi: [
						{ name: 'koolproxy_oline_rules',type:'checkbox',value: dbus.koolproxy_oline_rules == '1', suffix: '<lable id="_kp_oline_rules">绿坝规则</lable>&nbsp;&nbsp;' }
					]},
					{ title: '第三方规则订阅', multi: [
						{ name: 'koolproxy_encryption_rules',type:'checkbox',value: dbus.koolproxy_encryption_rules == '1', suffix: '<lable id="_kp_encryption_rules">加密规则</lable>&nbsp;&nbsp;' }					
//						{ name: 'koolproxy_easylist_rules',type:'checkbox',value: dbus.koolproxy_easylist_rules == '1', suffix: '<lable id="_kp_easylist">ABP规则</lable>&nbsp;&nbsp;' },
//						{ name: 'koolproxy_abx_rules',type:'checkbox',value: dbus.koolproxy_abx_rules == '1', suffix: '<lable id="_kp_abx">乘风规则</lable>&nbsp;&nbsp;' },
//						{ name: 'koolproxy_fanboy_rules',type:'checkbox',value: dbus.koolproxy_fanboy_rules == '1', suffix: '<lable id="_kp_fanboy">Fanboy规则</lable>&nbsp;&nbsp;' }
					]}
				]);
			</script>
			<br><hr>
			<h4>规则管理说明</h4>
				<div class="section" id="sesdiv_notes2">
				<li> KoolProxy推荐使用默认规则即可满足屏蔽的效果。</li>
				<li><font color="green"> 【绿坝规则】</font>经过KoolProxy审核并通过兼容性测试的。</li>
				<li> 第三方规则是由一些爱好者编写的，兼容性很难保证。</li>
				<li><font color="red"> 注意！规则加载的越多产生冲突且不兼容的问题就会大大增加。</font></li>		
				<li><font color="red"> 注意！我们无法去保证所有规则都能完美地在KoolProxy上面运行。</font></li>
				<li><font color="red"> 注意！规则不是越多越好，建议第三方规则根据自己需要勾选一种即可。</font></li>
				<li><font color="red"> 如果用户在选择规则上出现的风险，将由用户去承担，KoolProxy不承担任何责任。</font></li>
			</div>
			<br><hr>			
		</div>
	</div>
	<div class="box boxr7" id="kp_log_tab" style="margin-top: 0px;">
		<div id="kp_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#kp_log_pannel').append('<textarea class="as-script" name="koolproxy_log" id="_koolproxy_log" wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
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
