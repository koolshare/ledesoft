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
		var params = ["koolproxy_open", "koolproxy_mode", "koolproxy_update", "koolproxy_update_hour", "koolproxy_update_inter_hour", "koolproxy_reboot", "koolproxy_reboot_hour", "koolproxy_reboot_inter_hour", "koolproxy_acl_method"];
		var kprules = [];
		var ruletmp = '';
		var rule_lists = new Array();
		var options_type = [];
		
		function init_kp(){
			get_local_data();
		}

		function get_local_data(){
			var dbus = {};
			$.getJSON("/_api/koolproxy_", function(res) {
				dbus=res.result[0];
				console.log("dbus", dbus);
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
				verifyFields();
				get_remote_msg(dbus);
			});
		}

		function get_remote_msg(obj){
		    $.ajax({
		        url: 'https://koolshare.ngrok.wang/koolproxy/push_rule.json.js',
		        type: 'GET',
		        dataType: 'jsonp',
		        success: function(res) {
					$("#msg").html(res.hi1);
					if (res.rules){
						res.rules[res.rules.length] = ["自定义规则", ""];
						for (var i = 0; i < res.rules.length; ++i) {
							options_type.push([i, res.rules[i][0]]);
						}
						kprule.setup(obj);
						kpacl.setup(obj);
						//console.log("res.rules", res.rules);
						return online_rule = res;
					}
		        },
		        // incase of internet not avaliable
				error :function(){
					options_type = [['0', '视频规则'], ['1', '静态规则']];
					kprule.setup(obj);
					return online_rule = "";
				}
		    });
		}

		function reload_Soft_Center(){
			location.href = "#soft-center.asp";
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
		//============================================
		var kprule = new TomatoGrid();

		kprule.exist = function( f, v ) {
			var data = this.getAllData();
			for ( var i = 0; i < data.length; ++i ) {
				if ( data[ i ][ f ] == v ) return true;
			}
			return false;
		}

		kprule.existName = function(name) {
			return this.exist(2, name);
		}

		kprule.dataToView = function( data ) {
			console.log("data", data);
			return [ (data[ 0 ] != '0') ? ' [ <i class="icon-check icon-green"></i> ]' : ' [ <i class="icon-cancel icon-red"></i> ]', ['视频规则', '静态规则'][data[1]], data[ 2 ], data[ 3 ] ];
		}

		kprule.fieldValuesToData = function( row ) {
			var f = fields.getAll( row );
			return [ f[ 0 ].checked ? 1 : 0, f[ 1 ].value, f[ 2 ].value, f[ 3 ].value ];
		}

		kprule.verifyFields = function( row, quiet ) {
			var ok = 1;
			var f;
			f = fields.getAll( row );
			if(online_rule){
				f[2].value = online_rule.rules[f[1].value][1];
			}else{
				if(f[1].value == 0){
					f[2].value = "https:\/\/rules.ngrok.wang\/1.dat";
					
				}else if(f[1].value == 1){
					f[2].value = "https:\/\/rules.ngrok.wang\/koolproxy.dat";
				}else{
					f[2].value = "";
					f[3].value = "";
				}
			}

			s = f[2].value.trim().replace(/\s+/g, ' ');
			//console.log("s", s);
			if (s.length > 0) {
				if (this.existName(s)) {
					ferror.set(f[2], '规则重复！', quiet);
					return 0;
				}
			}else{
				ferror.set(f[2], '规则地址为空！', quiet);
				return 0;
			}
			return ok;
		}

		kprule.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].checked = 1;
			f[ 1 ].value   = '';
			f[ 2 ].value   = '';
			f[ 3 ].value   = '';
		}


		kprule.setup = function(dbus) {
			this.init( 'kprule-grid', '', 50, [
				{ type: 'checkbox' },
				{ type: 'select',maxlen:20,options:options_type,value:'-1'},
				{ type: 'text', maxlen: 110 },
				{ type: 'text', maxlen: 50 }
			] );
			this.headerSet( [ '加载', '规则类型', '规则地址', '规则别名' ] );
			
			if(typeof(dbus["koolproxy_rule_list"]) == "undefined"){
				var s =""
			}else{
				var s = dbus["koolproxy_rule_list"].split( '>' );
			}

			for ( var i = 0; i < s.length; ++i ) {
				var t = s[ i ].split( '<' );
				if ( t.length == 4 ) this.insertData( -1, t );
			}
			//kprule.recolor();
			this.showNewEditor();
			this.resetNewEditor();
		}
	
		
		$( window ).on( 'load', function() {
			kprule.recolor();
		});

		//============================================

		var kpacl = new TomatoGrid();
		
		kpacl.exist = function( f, v ) {
			var data = this.getAllData();
			for ( var i = 0; i < data.length; ++i ) {
				if ( data[ i ][ f ] == v ) return true;
			}
			return false;
		}
			//data[data.length] = ["其它主机", "缺省规则", "", "1"];


		kpacl.dataToView = function( data ) {
				console.log("data11", data);
			
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
			this.footerSet( [ '<small><i>其它主机</small></i>', '<small><i>缺省规则</small></i>','',('<select id="_koolproxy_acl_default" name="koolproxy_acl_default"><option value="0">不过滤</option><option value="1">http only</option><option value="2">http + https</option></select>')]);

			if(typeof(dbus["koolproxy_acl_list"]) != "undefine" ){
				var s = dbus["koolproxy_acl_list"].split( '>' );
			}else{
				var s =""
			}
			E("_koolproxy_acl_default").value = dbus["koolproxy_acl_default"];
			for ( var i = 0; i < s.length; ++i ) {
				var t = s[ i ].split( '<' );
				if ( t.length == 4 ) this.insertData( -1, t );
			}
			//this.insertData( -1, ["其它主机", "缺省规则", "", "1"] );
			this.showNewEditor();
			this.resetNewEditor();
		}
		
		//============================================
		
		function verifyFields(){
			var c = E('_koolproxy_update').value;
			var e = E('_koolproxy_reboot').value;
			if(c == 1){
				E("_koolproxy_update_hour").style.display='';
				E("koolproxy_update_hour_suf").style.display='';
				E("koolproxy_update_hour_pre").style.display='';
				E("_koolproxy_update_inter_hour").style.display='none';
				E("koolproxy_update_inter_hour_suf").style.display='none';
				E("koolproxy_update_inter_hour_pre").style.display='none';
			}else if (c == 2){
				E("_koolproxy_update_hour").style.display='none';
				E("koolproxy_update_hour_suf").style.display='none';
				E("koolproxy_update_hour_pre").style.display='none';
				E("_koolproxy_update_inter_hour").style.display='';
				E("koolproxy_update_inter_hour_suf").style.display='';
				E("koolproxy_update_inter_hour_pre").style.display='';
			}else{
				E("_koolproxy_update_hour").style.display='none';
				E("koolproxy_update_hour_suf").style.display='none';
				E("koolproxy_update_hour_pre").style.display='none';
				E("_koolproxy_update_inter_hour").style.display='none';
				E("koolproxy_update_inter_hour_suf").style.display='none';
				E("koolproxy_update_inter_hour_pre").style.display='none';
			}
			if(e == 1){
				E("_koolproxy_reboot_hour").style.display='';
				E("koolproxy_reboot_hour_suf").style.display='';
				E("koolproxy_reboot_hour_pre").style.display='';
				E("_koolproxy_reboot_inter_hour").style.display='none';
				E("koolproxy_reboot_inter_hour_suf").style.display='none';
				E("koolproxy_reboot_inter_hour_pre").style.display='none';
			}else if (e == 2){
				E("_koolproxy_reboot_hour").style.display='none';
				E("koolproxy_reboot_hour_suf").style.display='none';
				E("koolproxy_reboot_hour_pre").style.display='none';
				E("_koolproxy_reboot_inter_hour").style.display='';
				E("koolproxy_reboot_inter_hour_suf").style.display='';
				E("koolproxy_reboot_inter_hour_pre").style.display='';
			}else{
				E("_koolproxy_reboot_hour").style.display='none';
				E("koolproxy_reboot_hour_suf").style.display='none';
				E("koolproxy_reboot_hour_pre").style.display='none';
				E("_koolproxy_reboot_inter_hour").style.display='none';
				E("koolproxy_reboot_inter_hour_suf").style.display='none';
				E("koolproxy_reboot_inter_hour_pre").style.display='none';
			}
		}
		
		function tabSelect(obj){
			if(obj=="app1"){
				$('#app1-server1-jb-tab').addClass("active");
				$('#app2-server1-gz-tab').removeClass("active");
				$('#app3-server1-kz-tab').removeClass("active");
				$('#app4-server1-zdy-tab').removeClass("active");
				$('#app5-server1-rz-tab').removeClass("active");
				$('.boxr1').show();
				$('.boxr2').hide();
				$('.boxr3').hide();
				$('.boxr4').hide();
				$('.boxr5').hide();
			}else if(obj=="app2"){
				$('#app1-server1-jb-tab').removeClass("active");
				$('#app2-server1-gz-tab').addClass("active");
				$('#app3-server1-kz-tab').removeClass("active");
				$('#app4-server1-zdy-tab').removeClass("active");
				$('#app5-server1-rz-tab').removeClass("active");
				$('.boxr1').hide();
				$('.boxr2').show();
				$('.boxr3').hide();
				$('.boxr4').hide();
				$('.boxr5').hide();
			}else if(obj=="app3"){
				$('#app1-server1-jb-tab').removeClass("active");
				$('#app2-server1-gz-tab').removeClass("active");
				$('#app3-server1-kz-tab').addClass("active");
				$('#app4-server1-zdy-tab').removeClass("active");
				$('#app5-server1-rz-tab').removeClass("active");
				$('.boxr1').hide();
				$('.boxr2').hide();
				$('.boxr3').show();
				$('.boxr4').hide();
				$('.boxr5').hide();
			}else if(obj=="app4"){
				$('#app1-server1-jb-tab').removeClass("active");
				$('#app2-server1-gz-tab').removeClass("active");
				$('#app3-server1-kz-tab').removeClass("active");
				$('#app4-server1-zdy-tab').addClass("active");
				$('#app5-server1-rz-tab').removeClass("active");
				$('.boxr1').hide();
				$('.boxr2').hide();
				$('.boxr3').hide();
				$('.boxr4').show();
				$('.boxr5').hide();
			}else if(obj=="app5"){
				$('#app1-server1-jb-tab').removeClass("active");
				$('#app2-server1-gz-tab').removeClass("active");
				$('#app3-server1-kz-tab').removeClass("active");
				$('#app4-server1-zdy-tab').removeClass("active");
				$('#app5-server1-rz-tab').addClass("active");
				$('.boxr1').hide();
				$('.boxr2').hide();
				$('.boxr3').hide();
				$('.boxr4').hide();
				$('.boxr5').show();
			}
		}

		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}

		function update_rules_now(){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "KoolProxy_config.sh", "params":[2], "fields": ""};
			showMsg("msg_warring","后台正在更新规则，请稍候！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				type: "POST",
				url: "/_api/",
				data: JSON.stringify(postData),
				success: function(response){
					showMsg("msg_success","规则更新成功","<b>成功提交数据</b>");
					$('#msg_warring').hide();
					setTimeout("$('#msg_success').hide()", 500);
				},
				error: function(){
					showMsg("msg_error","规则更新失败","<b>当前系统存在异常查看系统日志！</b>");
				},
				dataType: "json"
			});
			
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
			// collect data from rule pannel
			var data = kprule.getAllData();
			var blacklist = '';
			if(data.length > 0){
				for ( var i = 0; i < data.length; ++i ) {
					blacklist += data[ i ].join( '<' ) + '>';
				}
				dbus2["koolproxy_rule_list"] = blacklist;
			}else{
				dbus2["koolproxy_rule_list"] = " ";
			}
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
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "KoolProxy_config.sh", "params":[1], "fields": dbus2};
			showMsg("msg_warring","正在提交数据！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				type: "POST",
				url: "/_api/",
				data: JSON.stringify(postData),
				success: function(response){
					showMsg("msg_success","提交成功","<b>成功提交数据</b>");
					$('#msg_warring').hide();
					setTimeout("$('#msg_success').hide()", 500);
				},
				error: function(){
					showMsg("msg_error","失败","<b>当前系统存在异常查看系统日志！</b>");
				},
				dataType: "json"
			});
		}
	</script>
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;">
	</div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;">
	</div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;">
	</div>
	<div class="box">
		<fieldset>
		<div class="heading">KoolProxy 3.3.3</div>
		<button onclick="reload_Soft_Center();" class="btn backsoftcenter pull-right">返回 <i class="icon-cloud"></i></button>
		<div class="content">
			<span id="msg" class="col-sm-9" style="margin-top:10px;width:700px">
			</span>
		</div>	
		</fieldset>
	</div>
<ul class="nav nav-tabs">
	<li>
		<a href="javascript:tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 基本设置</a>
	</li>
	<li>
		<a href="javascript:tabSelect('app2');" id="app2-server1-gz-tab"><i class="icon-globe"></i> 规则订阅</a>
	</li>
	<li>
		<a href="javascript:tabSelect('app3');" id="app3-server1-kz-tab"><i class="icon-tools"></i> 访问控制</a>
	</li>
	<li>
		<a href="javascript:tabSelect('app4');" id="app4-server1-zdy-tab"><i class="icon-hammer"></i> 自定义规则</a>
	</li>
	<li>
		<a href="javascript:tabSelect('app5');" id="app5-server1-rz-tab"><i class="icon-info"></i> 状态日志</a>
	</li>
</ul>
	
	<div class="box boxr1" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
				<fieldset>
					<label class="col-sm-3 control-left-label">开启Koolproxy</label>
					<div class="col-sm-9">
						<span class='tg-list-item'>
							<input class='tgl tgl-flat' id='_koolproxy_open' type='checkbox'>
							<label class='tgl-btn' for='_koolproxy_open'></label>
						</span>
					</div>
				</fieldset>
				<fieldset>
					<label class="col-sm-3 control-left-label">运行状态</label>
					<div class="col-sm-9 text-block">
						<span id='koolproxy_status'><font color="#1bbf35">koolprxoy v3.3.3 进程运行正常！</font></span>
					</div>
				</fieldset>	
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '过滤模式', name:'koolproxy_mode',type:'select',options:[['1','全局模式'],['2','IPSET模式']],value: "1" },
					{ title: '规则自动更新', multi: [
						{ name:'koolproxy_update',type:'select',options:[['1','定时'],['2','间隔'],['0','关闭']],value: "0", suffix: ' &nbsp;&nbsp;' },
						{ name: 'koolproxy_update_hour', type: 'select', options: [], value: "", suffix: '<lable id="koolproxy_update_hour_suf">更新</lable>', prefix: '<span id="koolproxy_update_hour_pre" class="help-block"><lable>每天</lable></span>' },
						{ name: 'koolproxy_update_inter_hour', type: 'select', options: [], value: "", suffix: '<lable id="koolproxy_update_inter_hour_suf">更新</lable>', prefix: '<span id="koolproxy_update_inter_hour_pre" class="help-block"><lable>每隔</lable></span>' },
						{ suffix: ' <button onclick="update_rules_now();" class="btn btn-success">手动更新<i class="icon-cloud"></i></button>' }
					] },
					{ title: '插件自动重启', multi: [
						{ name:'koolproxy_reboot',type:'select',options:[['1','定时'],['2','间隔'],['0','关闭']],value: "0", suffix: ' &nbsp;&nbsp;' },
						{ name: 'koolproxy_reboot_hour', type: 'select', options: [], value: "", suffix: '<lable id="koolproxy_reboot_hour_suf">更新</lable>', prefix: '<span id="koolproxy_reboot_hour_pre" class="help-block"><lable>每天</lable></span>' },
						{ name: 'koolproxy_reboot_inter_hour', type: 'select', options: [], value: "", suffix: '<lable id="koolproxy_reboot_inter_hour_suf">更新</lable>', prefix: '<span id="koolproxy_reboot_inter_hour_pre" class="help-block"><lable>每隔</lable></span>' }
					] },
					{ title: '访问控制匹配策略', name:'koolproxy_acl_method',type:'select',options:[['1','IP + MAC匹配'],['2','仅IP匹配'],['2','仅MAC匹配']],value: "1" },
					{ title: '证书下载', suffix: ' <button onclick="download_cert();" class="btn btn-danger">证书下载 <i class="icon-download"></i></button>&nbsp;&nbsp;<a class="kp_btn" href="http://koolshare.cn/thread-80430-1-1.html" target="_blank">【https过滤使用教程】<a>' },
					{ title: 'KoolProxy交流', suffix: ' <button onclick="join_QQ();" class="btn">加入QQ群</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="join_TG();" class="btn">加入电报群</button>' }
				]);
				for(var i = 0; i < 24; i++){
					$("#_koolproxy_update_hour").append("<option value='"  + i + "'>" + i + "时</option>");
					$("#_koolproxy_reboot_hour").append("<option value='"  + i + "'>" + i + "时</option>");
					$("#_koolproxy_update_hour").val(3);
					$("#_koolproxy_reboot_hour").val(3);
				}
				for(var i = 1; i < 73; i++){
					$("#_koolproxy_update_inter_hour").append("<option value='"  + i + "'>" + i + "时</option>");
					$("#_koolproxy_reboot_inter_hour").append("<option value='"  + i + "'>" + i + "时</option>");
					$("#_koolproxy_update_inter_hour").val(72);
					$("#_koolproxy_reboot_inter_hour").val(72);
				}
			</script>
		</div>
	</div>
<div class="box boxr2">
		<div class="heading">规则订阅</div>
		<div class="content">
			<h4>Notes</h4>
			<div class="section" id="sesdiv_notes1">
				<ul>
					<li>订阅第三方规则（例如adblock, adbyby, chinalist, easylist等）会导致兼容性问题，请确保你订阅的第三方规则支持koolproxy！</li>
					<li>规则下拉菜单里提供了一些基础的koolproxy兼容规则，如果你想自己开发并共享为第三方规则，可以参考此规则书写语法。</li>
				</ul>
			</div>
			<br><hr>
			<div class="tabContent">
				<!--app info -->
				<!--<table class="line-table" cellspacing=1 id="koolproxy-grid"></table>
				<script type="text/javascript">koolproxy.setup()</script>
				<!--app info -->
				<table class="line-table" cellspacing=1 id="kprule-grid"></table>
				<!--<script type="text/javascript">kprule.setup();</script>-->
			</div>

		</div>
	</div>
	
	<div class="box boxr3">
		<div class="heading">访问控制</div>
		<div class="content">

			<div class="tabContent">	
				<!--app info -->
				<table class="line-table" cellspacing=1 id="ctrl-grid"></table>
				<!--<script type="text/javascript">kpacl.setup()</script>
				<!--app info -->

			</div>
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
				<!--app info -->
				<!--app info -->
			</div>
		</div>
	</div>
	<div class="box boxr5">
		<div class="heading">状态日志</div>
		<div class="content">
			<div class="tabContent">
				<!--app info -->
				<!--app info -->
			</div>
		</div>
	</div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">Save <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">Cancel <i class="icon-cancel"></i></button>
	<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span>
	<script type="text/javascript">init_kp();</script>
</content>