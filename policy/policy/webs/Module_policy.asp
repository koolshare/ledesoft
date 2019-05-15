<title>策略路由</title>
<content>
	<script type="text/javascript" src="/js/jquery.min.js"></script>
	<script type="text/javascript" src="/js/tomato.js"></script>
	<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<style type="text/css">
		textarea {
			height: 6em;
		}
		/*Switch Icon Start*/
	</style>
	<script type="text/javascript">
		var dbus = {};
		var table2_node_nu;
		var table3_node_nu;
		var table4_node_nu;
		var table5_node_nu;
		var softcenter = 0;
		//var option_wan = [['wan', 'wan'], ['wan2', 'wan2']];
		var option_wan = [];
		var option_wan_name = [];
		var option_isp = [['1', '中国电信'],['2', '中国联通'], ['3', '中国移动'], ['4', '教育网'], ['5', '国内'], ['6', '国外']];
		var option_isp_name = [];
		if (typeof btoa == "Function") {
			Base64 = {
				encode: function(e) {
					return btoa(e);
				},
				decode: function(e) {
					return atob(e);
				}
			};
		} else {
			Base64 = {
				_keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
				encode: function(e) {
					var t = "";
					var n, r, i, s, o, u, a;
					var f = 0;
					e = Base64._utf8_encode(e);
					while (f < e.length) {
						n = e.charCodeAt(f++);
						r = e.charCodeAt(f++);
						i = e.charCodeAt(f++);
						s = n >> 2;
						o = (n & 3) << 4 | r >> 4;
						u = (r & 15) << 2 | i >> 6;
						a = i & 63;
						if (isNaN(r)) {
							u = a = 64
						} else if (isNaN(i)) {
							a = 64
						}
						t = t + this._keyStr.charAt(s) + this._keyStr.charAt(o) + this._keyStr.charAt(u) + this._keyStr.charAt(a)
					}
					return t
				},
				decode: function(e) {
					var t = "";
					var n, r, i;
					var s, o, u, a;
					var f = 0;
					if (typeof(e) == "undefined"){
						return t = "";
					}
					e = e.replace(/[^A-Za-z0-9\+\/\=]/g, "");
					while (f < e.length) {
						s = this._keyStr.indexOf(e.charAt(f++));
						o = this._keyStr.indexOf(e.charAt(f++));
						u = this._keyStr.indexOf(e.charAt(f++));
						a = this._keyStr.indexOf(e.charAt(f++));
						n = s << 2 | o >> 4;
						r = (o & 15) << 4 | u >> 2;
						i = (u & 3) << 6 | a;
						t = t + String.fromCharCode(n);
						if (u != 64) {
							t = t + String.fromCharCode(r)
						}
						if (a != 64) {
							t = t + String.fromCharCode(i)
						}
					}
					t = Base64._utf8_decode(t);
					return t
				},
				_utf8_encode: function(e) {
					e = e.replace(/\r\n/g, "\n");
					var t = "";
					for (var n = 0; n < e.length; n++) {
						var r = e.charCodeAt(n);
						if (r < 128) {
							t += String.fromCharCode(r)
						} else if (r > 127 && r < 2048) {
							t += String.fromCharCode(r >> 6 | 192);
							t += String.fromCharCode(r & 63 | 128)
						} else {
							t += String.fromCharCode(r >> 12 | 224);
							t += String.fromCharCode(r >> 6 & 63 | 128);
							t += String.fromCharCode(r & 63 | 128)
						}
					}
					return t
				},
				_utf8_decode: function(e) {
					var t = "";
					var n = 0;
					var r = c1 = c2 = 0;
					while (n < e.length) {
						r = e.charCodeAt(n);
						if (r < 128) {
							t += String.fromCharCode(r);
							n++
						} else if (r > 191 && r < 224) {
							c2 = e.charCodeAt(n + 1);
							t += String.fromCharCode((r & 31) << 6 | c2 & 63);
							n += 2
						} else {
							c2 = e.charCodeAt(n + 1);
							c3 = e.charCodeAt(n + 2);
							t += String.fromCharCode((r & 15) << 12 | (c2 & 63) << 6 | c3 & 63);
							n += 3
						}
					}
					return t
				}
			}
		}
		//============================================
		var table3 = new TomatoGrid();
		table3.dataToView = function(data, i) {
			return [ data[0], data[1] ];
		}
		table3.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table3.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value  = '';
			f[ 1 ].value  = '';
		}
		table3.setup = function() {
			this.init( 'table_3_grid', '', 500, [
				{ type: 'text'},
				{ type: 'text'}
			] );
			this.headerSet( [ '自定义运营商名称', '运营商路由表文件地址' ] );
			for ( var i = 1; i <= table3_node_nu; i++){
				var t2 = [ dbus["policy_user_isp_" + i ], dbus["policy_user_routefile_" + i ]]
				if ( t2.length == 2 ) this.insertData( -1, t2);
			}
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		var table2 = new TomatoGrid();
	
		table2.dataToView = function(data) {
			return [ data[0], option_isp_name[data[1] - 1] ];
		}
		table2.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table2.resetNewEditor = function() {
			var f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].selectedIndex   = '';
			f[ 1 ].selectedIndex   = '';
		}
		table2.setup = function() {
			this.init( 'table_2_grid', 'move', 500, [
				{ type: 'select', options:option_wan, value:'' },
				{ type: 'select', options:option_isp, value:'' }
			] );
			this.headerSet( [ 'WAN口名称',  '路由表设置'] );
			for ( var i = 1; i <= table2_node_nu; i++){
				var t1 = [dbus["policy_wan_name_" + i ], dbus["policy_wan_isp_" + i ] ]
				if ( t1.length == 2 ) this.insertData( -1, t1 );
			}
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		var table4 = new TomatoGrid();
	
		table4.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table4.resetNewEditor = function() {
			var f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].selectedIndex   = '';
			f[ 1 ].selectedIndex   = '';
		}
		table4.setup = function() {
			this.init( 'table_4_grid', 'move', 500, [
				{ type: 'select', options:option_wan, value:'' },
				{ type: 'text', value:'' }
			] );
			this.headerSet( [ 'WAN口名称',  '国家区域'] );
			for ( var i = 1; i <= table4_node_nu; i++){
				var t1 = [dbus["policy_cwan_name_" + i ], dbus["policy_cwan_isp_" + i ] ]
				if ( t1.length == 2 ) this.insertData( -1, t1 );
			}
			this.showNewEditor();
			this.resetNewEditor();
		}

		//============================================
		var table5 = new TomatoGrid();
	
		table5.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table5.resetNewEditor = function() {
			var f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].selectedIndex   = '';
			f[ 1 ].selectedIndex   = '';
		}
		table5.setup = function() {
			this.init( 'table_5_grid', 'move', 500, [
				{ type: 'select', options:option_wan, value:'' },
				{ type: 'text', value:'' }
			] );
			this.headerSet( [ 'WAN口名称',  '客户端IP地址'] );
			for ( var i = 1; i <= table5_node_nu; i++){
				var t5 = [dbus["policy_iwan_name_" + i ], dbus["policy_iwan_ip_" + i ] ]
				if ( t5.length == 2 ) this.insertData( -1, t5 );
			}
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================

		function init_pbr(){
			get_dbus_data();
			tabSelect("app1");
			//get_wans_list2();
			setTimeout("get_run_status();", 1000);
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/policy_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			 	 	//console.log(dbus);
			 	 	calculate_max_node();
			 	 	conf2obj();
			  	}
			});
		}

		function conf2obj(){
			E("_policy_enable").checked = dbus["policy_enable"] == 1 ? true : false;
			E("_policy_ssl").checked = dbus["policy_ssl"] == 1 ? true : false;
			E("_policy_config").value = dbus["policy_config"];
			E("_policy_tarckip").value = dbus["policy_tarckip"];
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "policy_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_policy_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_policy_status").innerHTML = "获取本地版本信息失败！";
					setTimeout("get_run_status();", 2000);
				}
			});
		}

		function calculate_max_node(){
			//--------------------------------------
			// count table3 line data nu
			var tmp_1 = [];
			var tmp_2 = [];
			for (var field in dbus) {
				a = field.split("policy_user_routefile_");
				tmp_1.push(a);
			}
			
			for ( var i = 0; i < tmp_1.length; i++){
				if (tmp_1[i][0] == ""){
					tmp_2.push(tmp_1[i][1]);
				}
			}
			table3_node_nu = tmp_2.length;
			//console.log("table3_node_nu", table3_node_nu);
			//--------------------------------------
			// count table2 line data nu
			var tmp_3 = [];
			var tmp_4 = [];
			for (var field in dbus) {
				b = field.split("policy_wan_isp_");
				tmp_3.push(b)
			}
			
			for ( var i = 0; i < tmp_3.length; i++){
				if (tmp_3[i][0] == ""){
					tmp_4.push(tmp_3[i][1]);
				}
			}
			table2_node_nu = tmp_4.length;
			//console.log("table2_node_nu", table2_node_nu);
			//--------------------------------------
			if(table3_node_nu > 0){
				for ( var i = 1; i <= table3_node_nu; i++){
					option_isp[i + 5] = [ String(i + 6), dbus["policy_user_isp_" + i] ];
				}
			}
			
			for ( var i = 0; i < option_isp.length; i++){
				option_isp_name.push(option_isp[i][1]);
			}
			//--------------------------------------
			// count table4 line data nu
			var tmp_5 = [];
			var tmp_6 = [];
			for (var field in dbus) {
				c = field.split("policy_cwan_isp_");
				tmp_5.push(c)
			}
			
			for ( var i = 0; i < tmp_5.length; i++){
				if (tmp_5[i][0] == ""){
					tmp_6.push(tmp_5[i][1]);
				}
			}
			table4_node_nu = tmp_6.length;
			//console.log("table3_node_nu", table3_node_nu);
			//--------------------------------------
			// count table5 line data nu
			var tmp_7 = [];
			var tmp_8 = [];
			for (var field in dbus) {
				c = field.split("policy_iwan_ip_");
				tmp_7.push(c)
			}
			
			for ( var i = 0; i < tmp_7.length; i++){
				if (tmp_7[i][0] == ""){
					tmp_8.push(tmp_7[i][1]);
				}
			}
			table5_node_nu = tmp_8.length;
			table3.setup();
			get_wans_list();
		}

		function get_wans_list(){
			var id2 = parseInt(Math.random() * 100000000);
			var postData2 = {"id": id2, "method": "policy_getwan.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData2),
				dataType: "json",
				success: function(response){
					if (response.result != "-1"){
						wans = response.result.split( '>' );
						//console.log(s3);
						for ( var i = 0; i < wans.length; ++i ) {
							var wans_temp = [];
							wans_temp[0] = wans[i]
							wans_temp[1] = wans[i]
							option_wan.push(wans_temp);
						}
						option_wan_name = wans.sort();
						table2.setup();
						table4.setup();
						table5.setup();
					}
				},
				timeout:5000
			});
		}

		function tabSelect(obj){
			var tableX = ['app1-tab', 'app2-tab', 'app3-tab', 'app4-tab', 'app5-tab'];
			var boxX = ['boxr1', 'boxr2', 'boxr3', 'boxr4', 'boxr5'];
			var appX = ['app1', 'app2', 'app3', 'app4', 'app5'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
		}
		function verifyFields(r){
			return true;
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

		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}
		
		function save(){
			// collect normal dataToView
			dbus["policy_enable"] = E("_policy_enable").checked ? "1" : "0";

			
			// collect data from table3
			var table3_conf = ["policy_user_isp_", "policy_user_routefile_"];
			// mark all data for delete first
			for ( var i = 1; i <= table3_node_nu; i++){
				for ( var j = 0; j < table3_conf.length; ++j ) {
					dbus[table3_conf[j] + i ] = ""
				}
			}
			//now save table3 data to object dbus
			var data = table3.getAllData();
			if(data.length > 0){
				for ( var i = 0; i < data.length; ++i ) {
					for ( var j = 0; j < table3_conf.length; ++j ) {
						dbus[table3_conf[j] + (i + 1)] = data[i][j];
					}
				}
			}
			
			// collect data from table2
			var table2_conf = ["policy_wan_name_", "policy_wan_isp_"];
			// mark all data for delete first
			for ( var i = 1; i <= table2_node_nu; i++){
				for ( var j = 0; j < table2_conf.length; ++j ) {
					dbus[table2_conf[j] + i ] = ""
				}
			}
			//now save table2 data to object dbus
			var data = table2.getAllData();
			if(data.length > 0){
				for ( var i = 0; i < data.length; ++i ) {
					for ( var j = 0; j < table2_conf.length; ++j ) {
						dbus[table2_conf[j] + (i + 1)] = data[i][j];
					}
				}
			}
			// collect data from table4
			var table4_conf = ["policy_cwan_name_", "policy_cwan_isp_"];
			// mark all data for delete first
			for ( var i = 1; i <= table4_node_nu; i++){
				for ( var j = 0; j < table4_conf.length; ++j ) {
					dbus[table4_conf[j] + i ] = ""
				}
			}
			//now save table2 data to object dbus
			var data = table4.getAllData();
			if(data.length > 0){
				for ( var i = 0; i < data.length; ++i ) {
					for ( var j = 0; j < table4_conf.length; ++j ) {
						dbus[table4_conf[j] + (i + 1)] = data[i][j];
					}
				}
			}
			// collect data from table4
			var table5_conf = ["policy_iwan_name_", "policy_iwan_ip_"];
			// mark all data for delete first
			for ( var i = 1; i <= table5_node_nu; i++){
				for ( var j = 0; j < table5_conf.length; ++j ) {
					dbus[table5_conf[j] + i ] = ""
				}
			}
			//now save table2 data to object dbus
			var data = table5.getAllData();
			if(data.length > 0){
				for ( var i = 0; i < data.length; ++i ) {
					for ( var j = 0; j < table5_conf.length; ++j ) {
						dbus[table5_conf[j] + (i + 1)] = data[i][j];
					}
				}
			}
			//console.log(dbus)
			// now post data
			postdata("policy_config.sh", dbus)
		}

		function postdata(script, obj){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[1], "fields": obj};
			dbus.policy_enable = E('_policy_enable').checked ? '1':'0';
			dbus.policy_ssl = E('_policy_ssl').checked ? '1':'0';
			dbus.policy_config = E('_policy_config').value;
			dbus.policy_tarckip = E('_policy_tarckip').value;
			showMsg("msg_warring","正在提交数据！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				type: "POST",
				async:true,
				cache:false,
				dataType: "json",
				data: JSON.stringify(postData),
				success: function(response){
					if (response.result == id){
						window.location.reload();
					}else{
						$('#msg_warring').hide();
						showMsg("msg_error","提交失败","<b>提交数据失败！错误代码：" + response.result + "</b>");
					}
				},
				error: function(){
					showMsg("msg_error","失败","<b>当前系统存在异常查看系统日志！</b>");
					status_time = 1;
				}
			});
		}
	</script>
	<div class="box">
		<div class="heading">策略路由<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				如果你有多个宽带运营商，可以在此设置分流策略。
			</span>
		</div>	
	</div>
	<!-- ------------------ 标签页 --------------------- -->
	<ul id="pbr_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" ><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" ><i class="icon-globe"></i> 运营商分流设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab" ><i class="icon-tools"></i> 自定义运营商</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app4');" id="app4-tab" ><i class="icon-tools"></i> 国家分流</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app5');" id="app5-tab" ><i class="icon-tools"></i> 客户端分流</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 15px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启策略路由', name:'policy_enable',type:'checkbox',value: "" },
					{ title: '运行状态', text: '<font id="_policy_status" name=_policy_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '分流策略', name:'policy_config',type:'select',options:[['1','全局分流'],['2','只分流WEB'],['3','负载均衡']],value: "" },
					{ title: 'SSL源进源出', name:'policy_ssl',type:'checkbox',value: "" },
					{ title: '追踪IP设置', name:'policy_tarckip',type:'textarea', maxlen: 200, size: 200, value: dbus.policy_tarckip || "114.114.114.114 taobao.com www.baidu.com 119.29.29.29" },
				]);
			</script>
		</div>
		</div>
	<div id="pbr_basic_readme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 策略路由只对路由器下面客户端的流量生效，对路由自身发起的流量无效</li>
			<li> 全局分流对路由下客户端的所有流量进行分流</li>
			<li> 只分流WEB对路由下客户端的80、443端口的流量进行分流</li>
			<li> 负载均衡则不进行分流，对所有流量负载均衡，当流量没有达到最低跃点的宽带的上限时可能不会把流量平均到每个接口</li>
			<li> 追踪IP可以设置IP地址和网址，设置多个以空格分隔</li>
			<li> 网络-负载均衡-接口中必须存在一条启用的规则</li>	
	</div>
	</div>
	<!-- ------------------ 表格2--------------------- -->
	<div class="box boxr2" id="table_2" style="margin-top: 15px;">
		<div class="heading">运营商分流设置</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="table_2_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="pbr_wan_readme" class="box boxr2" style="margin-top: 15px;">
	<div class="heading">优化建议： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 列表越上面的规则优先级越高，点击列表项右上角箭头可以对项目优先级重新排序</li>
			<li> 移动、教育网、自定义配置等IP段比较少的运营商放到列表的最上面</li>
			<li> 国内和国外配置请放到列表的最下面</li>
	</div>
	</div>
	<!-- ------------------ 表格3 --------------------- -->
	<div class="box boxr3" id="table_3" style="margin-top: 15px;">
		<div class="heading">自定义运营商</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="table_3_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="pbr_userreadme" class="box boxr3" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 自定义运营商名称可随意填写</li>
			<li> 路由表文件地址必须为绝对地址，如：/etc/cmcc.txt</li>
	</div>
	</div>
	<!-- ------------------ 表格4--------------------- -->
	<div class="box boxr4" id="table_4" style="margin-top: 15px;">
		<div class="heading">国家分流</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="table_4_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="pbr_wan_readme4" class="box boxr4" style="margin-top: 15px;">
	<div class="heading">优化建议： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 列表越上面的规则优先级越高，点击列表项右上角箭头可以对项目优先级重新排序</li>
			<li> 国家区域仅支持Geoip区域名称缩写，字母必须大写。<a href="http://www.jctrans.com/tool/gjym.htm" target="_blank"> (常见区域名称缩写)</a></li>
			<li> 支持的区域名称：A1 A2 AD AE AF AG AI AL AM AO AP AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET EU FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW</li>
	</div>
	</div>
	<!-- ------------------ 表格5--------------------- -->
	<div class="box boxr5" id="table_5" style="margin-top: 15px;">
		<div class="heading">客户端分流设置</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="table_5_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="pbr_wan_readme" class="box boxr5" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 填写客户端IP地址或IP段，如：192.168.1.200 或 192.168.1.200/23</li>
	</div>
	</div>
	<!-- ------------------ 其它 --------------------- -->
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">提交 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
	<script type="text/javascript">init_pbr();</script>
</content>
