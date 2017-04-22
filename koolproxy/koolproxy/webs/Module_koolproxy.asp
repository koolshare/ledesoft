<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<title>KoolProxy</title>
<content>
	<script type="text/javascript">
		var params = ["koolproxy_enable", "koolproxy_host", "koolproxy_mode", "koolproxy_reboot", "koolproxy_reboot_hour", "koolproxy_reboot_inter_hour", "koolproxy_acl_method", "koolproxy_acl_default"];
		var options_type = [];
		var options_list = [];
		var _responseLen;
		var noChange = 0;
		var reload = 0;
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
			return [ data[0] , data[1], data[2], ['不过滤', 'http only', 'http + https'][data[3]] ];
		}
		kpacl.fieldValuesToData = function( row ) {
			var f = fields.getAll( row );
			return [ f[0].value, f[1].value, f[2].value, f[3].value ];
		}
		kpacl.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return v_ip( f[ 0 ], quiet ) || v_mac( f[ 1 ], quiet );
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
		kpacl.setup = function(dbus) {
			this.init( 'ctrl-grid', '', 50, [
			{ type: 'text', maxlen: 50 },
			{ type: 'text', maxlen: 50 },
			{ type: 'text', maxlen: 50 },
			{ type: 'select',maxlen:20,options:[['0', '不过滤'], ['1', 'http only'], ['2', 'http + https']], value:'1'}
			] );
			
			this.headerSet( [ '主机IP地址', 'MAC地址', '主机别名', '访问控制' ] );
			this.footerSet( [ '<small><i>其它主机</small></i>', '<small><i>缺省规则</small></i>','',('<select id="_koolproxy_acl_default" name="koolproxy_acl_default"><option value="0">不过滤</option><option value="1" selected>http only</option><option value="2">http + https</option></select>')]);
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
			get_local_data();
			get_user_txt();
			$("#_koolproxy_log").click(
				function() {
					x = -1;
			});
			setTimeout("get_run_status();", 1000);
		}

		function conf2obj(dbus){
			for (var i = 0; i < params.length; i++) {
			if(typeof(dbus[params[i]]) != "undefined"){
					if (document.getElementById("_" + params[i]).getAttribute("type") == "checkbox"){
						if (dbus[params[i]] == 1){
							E("_" + params[i]).checked = true;
						}else{
							E("_" + params[i]).checked = false;
						}
					}else{
						E("_" + params[i]).value = dbus[params[i]];
					}
				}
			}
			$('#_koolproxy_host_nu').html((dbus["koolproxy_host_nu"] || 0) + '条')
			verifyFields();
		}

		function get_local_data(){
			var dbus = {};
			$.getJSON("/_api/koolproxy_", function(res) {
				dbus=res.result[0];
				get_remote_msg(dbus);
			});
		}

		function get_remote_msg(dbus){
		    $.ajax({
		        url: 'https://koolshare.ngrok.wang/koolproxy/push_rule.json.js',
		        type: 'GET',
		        cache:false,
		        dataType: 'jsonp',
		        success: function(res) {
					console.log("json:", "get web json susscess!");
					$("#msg").html(res.hi1);
					if (res.rules){
						res.rules[res.rules.length] = ["自定义规则", "" ,"", ""];
						for (var i = 0; i < res.rules.length; ++i) {
							options_type.push([i, res.rules[i][0]]);
							options_list[i] = res.rules[i][0];
						}
						kpacl.setup(dbus);
						conf2obj(dbus);
						return online_rule = res;
					}
		        },
		        // incase of internet not avaliable
				error :function(){
					console.log("json:", "get web json fail!");
					options_type = [['0', '视频规则'], ['1', '静态规则']];
					options_list = ['视频规则', '静态规则'];
					kpacl.setup(dbus);
					conf2obj(dbus);
					return online_rule = 0;
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
					document.getElementById("_koolproxy_status").innerHTML = response.result.split("@@")[0];
					document.getElementById("_koolproxy_rule_status").innerHTML = response.result.split("@@")[1];
					setTimeout("get_run_status();", 10000);
				},
				error: function(){
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
		function join_TG(){
			window.open("https://t.me/joinchat/AAAAAD-tO7GPvfOU131_vg");
		}
		function verifyFields(){
			var a = E('_koolproxy_enable').checked;
			var f = (E('_koolproxy_reboot').value == '1');
			var g = (E('_koolproxy_reboot').value == '2');
			var h = (E('_koolproxy_mode').value == '2');
			
			E('_koolproxy_mode').disabled = !a;
			E('_koolproxy_reboot').disabled = !a;
			E('_koolproxy_acl_method').disabled = !a;
			E('_download_cert').disabled = !a;
		
			elem.display('_koolproxy_reboot_hour', a && f);
			elem.display('koolproxy_reboot_hour_suf', a && f);
			elem.display('koolproxy_reboot_hour_pre', a && f);
			elem.display('_koolproxy_reboot_inter_hour', a && g);
			elem.display('koolproxy_reboot_inter_hour_suf', a && g);
			elem.display('koolproxy_reboot_inter_hour_pre', a && g);
			
			elem.display(PR('_koolproxy_host'), h);
		}
		
		function tabSelect(obj){
			var tableX = ['app1-server1-jb-tab','app3-server1-kz-tab','app4-server1-zdy-tab','app5-server1-rz-tab'];
			var boxX = ['boxr1','boxr3','boxr4','boxr5'];
			var appX = ['app1','app3','app4','app5'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app5'){
				setTimeout("get_log();", 100);
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
			verifyFields();
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
			// collect value in user rule textarea
			dbus2["koolproxy_custom_rule"] = Base64.encode(document.getElementById("_koolproxy_custom_rule").value);
			
			// collect data from acl pannel
			var data2 = kpacl.getAllData();
			var acllist = '';
			if(data2.length > 0){
				for ( var i = 0; i < data2.length; ++i ) {
					acllist += data2[ i ].join( '<' ) + '>';
				}
				dbus2["koolproxy_acl_list"] = acllist;
			}else{
				dbus2["koolproxy_acl_list"] = " ";
			}
			
			// post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "KoolProxy_config.sh", "params":[1], "fields": dbus2};
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
			tabSelect("app5");
			//save_user_txt();
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
							x = 4;
							count_down_switch();
							//window.location.reload();
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
						setTimeout("get_log();", 100);
					}
					retArea.value = response.replace("XU6J03M6", " ");
					retArea.scrollTop = retArea.scrollHeight;
					_responseLen = response.length;
				}
			});
		}

		var x = 4;
		function count_down_switch() {
			if (x == "0") {
				window.location.reload();
			}
			if (x < 0) {
				return false;
			}
				--x;
			setTimeout("count_down_switch();", 500);
		}
		
		function get_user_txt() {
			$.ajax({
				url: '/_temp/user.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(res) {
					$('#_koolproxy_custom_rule').val(res);
					//console.log("res", res);
				}
			});
		}

	</script>

	<div class="box">
		<div class="heading">KoolProxy<a href="/#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span id="msg" class="col-sm-9" style="margin-top:10px;width:700px"></span>
		</div>	
	</div>
	<ul class="nav nav-tabs">
		<li><a href="javascript:tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:tabSelect('app3');" id="app3-server1-kz-tab"><i class="icon-tools"></i> 访问控制</a></li>
		<li><a href="javascript:tabSelect('app4');" id="app4-server1-zdy-tab"><i class="icon-hammer"></i> 自定义规则</a></li>
		<li><a href="javascript:tabSelect('app5');" id="app5-server1-rz-tab"><i class="icon-info"></i> 状态日志</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启Koolproxy', name:'koolproxy_enable',type:'checkbox',value: "0" == '1' },
					{ title: 'Koolproxy运行状态', text: '<font id="_koolproxy_status" name=_koolproxy_status color="#1bbf35">正在获取运行状态...</font>' },
					{ title: 'Koolproxy规则状态', text: '<font id="_koolproxy_rule_status" name=_koolproxy_status color="#1bbf35">正在获取规则状态...</font>' },
					{ title: '过滤模式', name:'koolproxy_mode',type:'select',options:[['1','全局模式'],['2','IPSET模式'],['3','视频模式']],value: "1" },
					{ title: '开启Adblock Plus Host', name:'koolproxy_host',type:'checkbox',value: "0" == '1', suffix: '<lable id="_koolproxy_host_nu"></lable>' },
					{ title: '插件自动重启', multi: [
						{ name:'koolproxy_reboot',type:'select',options:[['1','定时'],['2','间隔'],['0','关闭']],value: "0", suffix: ' &nbsp;&nbsp;' },
						{ name: 'koolproxy_reboot_hour', type: 'select', options: [], value: "", suffix: '<lable id="koolproxy_reboot_hour_suf">更新</lable>', prefix: '<span id="koolproxy_reboot_hour_pre" class="help-block"><lable>每天</lable></span>' },
						{ name: 'koolproxy_reboot_inter_hour', type: 'select', options: [], value: "", suffix: '<lable id="koolproxy_reboot_inter_hour_suf">更新</lable>', prefix: '<span id="koolproxy_reboot_inter_hour_pre" class="help-block"><lable>每隔</lable></span>' }
					] },
					{ title: '访问控制匹配策略', name:'koolproxy_acl_method',type:'select',options:[['1','IP + MAC匹配'],['2','仅IP匹配'],['2','仅MAC匹配']],value: "1" },
					{ title: '证书下载', suffix: ' <button id="_download_cert" onclick="download_cert();" class="btn btn-danger">证书下载 <i class="icon-download"></i></button>&nbsp;&nbsp;<a class="kp_btn" href="http://koolshare.cn/thread-80430-1-1.html" target="_blank">【https过滤使用教程】<a>' },
					{ title: 'KoolProxy交流', suffix: ' <button id="_join_QQ" onclick="join_QQ();" class="btn">加入QQ群</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="join_TG();" class="btn">加入电报群</button>' }
				]);
				for(var i = 0; i < 24; i++){
					$("#_koolproxy_reboot_hour").append("<option value='"  + i + "'>" + i + "时</option>");
					$("#_koolproxy_reboot_hour").val(3);
				}
				for(var i = 1; i < 73; i++){
					$("#_koolproxy_reboot_inter_hour").append("<option value='"  + i + "'>" + i + "时</option>");
					$("#_koolproxy_reboot_inter_hour").val(72);
				}
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
			<h4>Notes</h4>
			<div class="section" id="sesdiv_notes2">
				<ul>
					<li>过滤https站点需要为相应设备安装证书，并启用http + https过滤！</li>
					<li>在路由器下的设备，不管是电脑，还是移动设备，都可以在浏览器中输入<i><b>110.110.110.110</b></i>来下载证书。</i></li>
					<li>如果想在多台装有koolroxy的路由设备上使用一个证书，请用winscp软件备份/koolshare/koolproxy/data文件夹，并上传到另一台路由。</li>
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
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
	<script type="text/javascript">init_kp();</script>
</content>
