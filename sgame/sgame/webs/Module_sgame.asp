<title>软件中心-游戏加器</title>
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
		var table3_node_nu;
		var softcenter = 0;
		var _responseLen;
		var noChange = 0;
		var status_time = 1;
		var option_udp = [['√', '开启'],['x', '关闭']];
		var option_time = [];
		for(var i = 0; i < 24; i++){
			option_time[i] = [i, i + "点"];
		}
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
		table3.dataToView = function(data) {
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
			f[ 1 ].selectedIndex   = '';
		}
		table3.setup = function() {
			this.init( 'table_3_grid', '', 500, [
				{ type: 'text'},
				{ type: 'select', options:option_udp, value:''}
			] );
			this.headerSet( [ '端口号', 'UDP端口' ] );
			for ( var i = 1; i <= table3_node_nu; i++){
				var t2 = [ dbus["sgame_tiynmapper_port_" + i ], dbus["sgame_tiynmapper_udp_" + i ]]
				if ( t2.length == 2 ) this.insertData( -1, t2);
			}
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================

		function init_sgame(){
			get_dbus_data();
			tabSelect("app1");
			set_version();
			show_hide_panel();
			setTimeout("get_run_status();", 1000);
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/sgame_",
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
			E("_sgame_enable").checked = dbus["sgame_enable"] == 1 ? true : false;
			E("_sgame_base_cron").checked = dbus["sgame_base_cron"] == 1 ? true : false;
			E("_sgame_udp2raw_enable").checked = dbus["sgame_udp2raw_enable"] == 1 ? true : false;
			E("_sgame_udp2raw_server").value = dbus["sgame_udp2raw_server"] || "114.114.114.114";
			E("_sgame_udp2raw_port").value = dbus["sgame_udp2raw_port"] || "867";
			E("_sgame_udp2raw_mode").value = dbus["sgame_udp2raw_mode"] || "faketcp";
			E("_sgame_basic_server").value = dbus["sgame_basic_server"] || "114.114.114.114";
			E("_sgame_basic_port").value = dbus["sgame_basic_port"] || "867";
			E("_sgame_base_cron_enable").value = dbus["sgame_basic_cron_enable"] || "20";
			E("_sgame_base_cron_disable").value = dbus["sgame_base_cron_disable"] || "2";
			E("_sgame_basic_subnet").value = dbus["sgame_basic_subnet"] || "10.22.22.0";
			E("_sgame_udp2raw_password").value = Base64.decode(dbus["sgame_udp2raw_password"]);
			E("_sgame_udp2raw_other").value = Base64.decode(dbus["sgame_udp2raw_other"]) || "-a --log-level 4 --log-position";
			E("_sgame_basic_password").value = Base64.decode(dbus["sgame_basic_password"]);
			E("_sgame_basic_other").value = Base64.decode(dbus["sgame_basic_other"]) || "-f2:2 --timeout 0 --keep-reconnect --log-level 2 --log-position";
		}

		function get_run_status(){
			if (status_time > 99999){
				E("_sgame_status").innerHTML = "暂停获取状态...";
				return false;
			}
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "sgame_status.sh", "params":[2], "fields": ""};
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
					++status_time;
					if (response.result == '-2'){
						E("_sgame_status").innerHTML = "获取运行状态失败！";
						E("_sgame_status_ping").innerHTML = "获取运行状态失败！";
						setTimeout("get_run_status();", 5000);
					}else{
						if(dbus["sgame_enable"] != "1"){
							E("_sgame_status").innerHTML = "尚未提交，暂停获取状态！";
							E("_sgame_status_ping").innerHTML = "尚未提交，暂停获取状态！";
						}else{
							E("_sgame_status").innerHTML = response.result.split("@@")[0];
							E("_sgame_status_ping").innerHTML = response.result.split("@@")[1];
						}
						setTimeout("get_run_status();", 5000);
					}
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_sgame_status").innerHTML = "获取运行状态失败！";
					document.getElementById("_sgame_status_ping").innerHTML = "获取连接状态失败！";
					setTimeout("get_run_status();", 5000);
				}
			});
		}

		function set_version(){
			$('#_sgame_version').html( '<font color="#1bbf35">游戏加速器 ' + (dbus["sgame_version"]  || "") + '</font></a>' );
		}

		function calculate_max_node(){
			//--------------------------------------
			// count table3 line data nu
			var tmp_1 = [];
			var tmp_2 = [];
			for (var field in dbus) {
				a = field.split("sgame_tiynmapper_port_");
				tmp_1.push(a);
			}
			for ( var i = 0; i < tmp_1.length; i++){
				if (tmp_1[i][0] == ""){
					tmp_2.push(tmp_1[i][1]);
				}
			}
			table3_node_nu = tmp_2.length;
			table3.setup();
		}
		function tabSelect(obj){
			var tableX = ['app1-tab', 'app2-tab', 'app3-tab', 'app4-tab'];
			var boxX = ['boxr1', 'boxr2', 'boxr3', 'boxr4'];
			var appX = ['app1', 'app2', 'app3', 'app4'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app1'){
				var b  = E('_sgame_udp2raw_enable').checked;
				elem.display('sgame_basic_tab_udp2raw', b);
				elem.display('save-button', true);
				noChange=2001;
			}else if(obj=='app3'){
				elem.display('save-button', false);
				noChange=0;
				setTimeout("get_udp2raw_log();", 200);
			}else if(obj=='app4'){
				elem.display('save-button', false);
				noChange=0;
				setTimeout("get_tinyvpn_log();", 200);
			}else{
				elem.display('save-button', true);
				noChange=2001;
			}
		}
		function verifyFields(r){
			show_hide_panel();
			return true;
		}

		function show_hide_panel(){
			var a  = E('_sgame_enable').checked;
			var b  = E('_sgame_udp2raw_enable').checked;
			var c  = E('_sgame_base_cron').checked;
			elem.display('sgame_status_pannel', a);
			elem.display('sgame_tabs', a);
			elem.display('sgame_basic_tab', a);
			elem.display('sgame_basic_tab_tinyvpn', a);
			elem.display('sgame_basic_tab_udp2raw', a&&b);
			elem.display(PR('_sgame_basic_server'), !b);
			elem.display(PR('_sgame_basic_port'), !b);
			elem.display(PR('_sgame_base_cron_enable'), c);
			elem.display(PR('_sgame_base_cron_disable'), c);
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
			dbus["sgame_enable"] = E("_sgame_enable").checked ? "1" : "0";
			// data need base64 encode
			var paras_base64 = ["sgame_udp2raw_password", "sgame_udp2raw_other", "sgame_basic_password", "sgame_basic_other"];
			for (var i = 0; i < paras_base64.length; i++) {
				if (typeof(E('_' + paras_base64[i] ).value) == "undefined"){
					dbus[paras_base64[i]] = "";
				}else{
					dbus[paras_base64[i]] = Base64.encode(E('_' + paras_base64[i]).value);
				}
			}
			
			// collect data from table3
			var table3_conf = ["sgame_tiynmapper_port_", "sgame_tiynmapper_udp_"];
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
			// now post data
			postdata("sgame_config.sh", dbus)
		}

		function get_udp2raw_log(){
			$.ajax({
				url: '/_temp/udp2raw_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(response) {
					var retArea = E("_udp2raw_basic_log");
					if (response.search("XU6J03M6") == -1) {
						retArea.value = response.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						return true;
					}
					if (_responseLen == response.length) {
						noChange++;
					} else {
						noChange = 0;
					}
					if (noChange > 2000) {
						//tabSelect("app1");
						return true;
					} else {
						setTimeout("get_udp2raw_log();", 100); //100 is radical but smooth!
					}
					retArea.value = response;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLen = response.length;
				},
				error: function() {
					E("_udp2raw_basic_log").value = "获取日志失败！";
				}
			});
		}

		function get_tinyvpn_log(){
			$.ajax({
				url: '/_temp/tinyvpn_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(response) {
					var retArea = E("_tinyvpn_basic_log");
					if (response.search("XU6J03M6") == -1) {
						retArea.value = response.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						return true;
					}
					if (_responseLen == response.length) {
						noChange++;
					} else {
						noChange = 0;
					}
					if (noChange > 2000) {
						//tabSelect("app1");
						return true;
					} else {
						setTimeout("get_tinyvpn_log();", 100); //100 is radical but smooth!
					}
					retArea.value = response;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLen = response.length;
				},
				error: function() {
					E("_tinyvpn_basic_log").value = "获取日志失败！";
				}
			});
		}

		function postdata(script, obj){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[1], "fields": obj};
			dbus.sgame_enable = E('_sgame_enable').checked ? '1':'0';
			dbus.sgame_base_cron = E('_sgame_base_cron').checked ? '1':'0';
			dbus.sgame_udp2raw_enable = E('_sgame_udp2raw_enable').checked ? '1':'0';
			dbus.sgame_udp2raw_port = E('_sgame_udp2raw_port').value;
			dbus.sgame_udp2raw_server = E('_sgame_udp2raw_server').value;
			dbus.sgame_udp2raw_mode = E('_sgame_udp2raw_mode').value;
			dbus.sgame_basic_server = E('_sgame_basic_server').value;
			dbus.sgame_basic_port = E('_sgame_basic_port').value;
			dbus.sgame_basic_subnet = E('_sgame_basic_subnet').value;
			dbus.sgame_base_cron_enable = E('_sgame_base_cron_enable').value;
			dbus.sgame_base_cron_disable = E('_sgame_base_cron_disable').value;
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
		<div class="heading">
			<span id="_sgame_version"></span>
			<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
		</div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				<li>利用UDP2raw、TinyVPN等双边网络加速工具通过合理配置参数后大幅度降低网络丢包，增加游戏连接稳定性</li>
				<li>关于这些工具： <a href='https://github.com/wangyu-/udp2raw-tunnel/blob/master/doc/README.zh-cn.md'  target='_blank'>★Udp2raw</a><a href='https://github.com/wangyu-/tinyfecVPN/blob/master/doc/README.zh-cn.md'  target='_blank'> ←TinyfecVPN</a><a href='https://github.com/wangyu-/tinyPortMapper'  target='_blank'> ←TinyPortMapper</a></li>
			</span>
		</div>	
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="sgame_switch_pannel" class="section" style="margin-top: -20px;"></div>
			<script type="text/javascript">
				$('#sgame_switch_pannel').forms([
					{ title: '加速器开关', name:'sgame_enable',type:'checkbox',  value: dbus.sgame_enable == 1 }  // ==1 means default close; !=0 means default open
				]);
			</script>
			<hr />
			<fieldset id="sgame_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">加速器运行状态</label>
				<div class="col-sm-9">
					<font id="_sgame_status" name="_sgame_status" color="#1bbf35">正在检查运行状态...</font>
				</div>
				<div class="col-sm-9" style="margin-top:2px">
					<font id="_sgame_status_ping" name="sgame_status_ping" color="#1bbf35">正在测试连接状态...</font>
				</div>
			</fieldset>
		</div>
	</div>
	<!-- ------------------ 标签页 --------------------- -->
	<ul id="sgame_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" ><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" ><i class="icon-tools"></i> 端口映射</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab" ><i class="icon-hourglass"></i> UDP2raw日志</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app4');" id="app4-tab" ><i class="icon-hourglass"></i> TinyVPN日志</a></li>
	</ul>
	<div class="box boxr1" id="sgame_basic_tab" style="margin-top: 15px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启Udp2raw突破UDP屏蔽或QOS限速', name:'sgame_udp2raw_enable',type:'checkbox',  value: dbus.sgame_udp2raw_enable == 1 },
					{ title: '定时自动开关', name:'sgame_base_cron',type:'checkbox',  value: dbus.sgame_base_cron == 1 },
					{ title: '定时开启', name: 'sgame_base_cron_enable',type: 'select', options:option_time, value: dbus.sgame_base_cron_enable || '20' ,suffix: ' 时' },
					{ title: '定时关闭', name: 'sgame_base_cron_disable',type: 'select', options:option_time, value: dbus.sgame_base_cron_disable || '2' ,suffix: ' 时' },
				]);
			</script>
		</div>
		</div>
	<div class="box boxr1" id="sgame_basic_tab_udp2raw" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="sgame_basic_udppannel" class="section"></div>
			<script type="text/javascript">
				$('#sgame_basic_udppannel').forms([
					{ title: 'Udp2raw 服务器地址', multi: [
						{ name:'sgame_udp2raw_server',type:'text',size: 20,value: dbus.sgame_udp2raw_server || "2", suffix: ' &nbsp;&nbsp;端口：'},
						{ name: 'sgame_udp2raw_port',type:'text',size: 6,value:dbus.sgame_udp2raw_port || "4031"},
					],help: '尽管支持域名格式，但是仍然建议首先使用IP地址。'},
					{ title: 'Udp2raw 连接密码', name:'sgame_udp2raw_password',type:'password',size: 20,maxLength:30,value: Base64.decode(dbus.sgame_udp2raw_password), peekaboo: 1},
					{ title: '模式', name:'sgame_udp2raw_mode',type:'select',options:[['faketcp','faketcp'],['udp','udp'],['icmp','icmp']],value:dbus.sgame_udp2raw_mode || "faketcp", suffix: 'raw-mode 默认:faketcp' },
					{ title: '其它参数', name:'sgame_udp2raw_other',type:'text',size: 100,value: Base64.decode(dbus.sgame_udp2raw_other) || "-a --log-level 2" ,suffix: ' 其它自定义参数，请手动输入，如 -q1 等' },
				]);
			</script>
		</div>
	</div>
	<div class="box boxr1" id="sgame_basic_tab_tinyvpn" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="sgame_basic_tinypannel" class="section"></div>
			<script type="text/javascript">
				$('#sgame_basic_tinypannel').forms([
					{ title: 'TinyVPN服务器地址', multi: [
						{ name:'sgame_basic_server',type:'text',size: 20,value: dbus.sgame_basic_server || "2", suffix: ' &nbsp;&nbsp;端口：'},
						{ name: 'sgame_basic_port',type:'text',size: 6,value:dbus.sgame_basic_port || "4031"},
					],help: '尽管支持域名格式，但是仍然建议首先使用IP地址。'},
					{ title: 'TinyVPN连接密码', name:'sgame_basic_password',type:'password',size: 20,maxLength:30,value: Base64.decode(dbus.sgame_basic_password), peekaboo: 1, suffix: ' 如开启udp2raw可以无需配置密码' },
					{ title: '本地子网', name:'sgame_basic_subnet',type:'text',size: 18,value:dbus.sgame_basic_subnet|| "10.22.22.0" },
					{ title: '其它自定义参数', name:'sgame_basic_other',type:'text',size: 100,value: Base64.decode(dbus.sgame_basic_other) || "-f2:2 --timeout 0 --keep-reconnect --log-level 2" ,suffix: ' 其它自定义参数，请手动输入，如-f 20:10' },
				]);
			</script>
		</div>
	</div>
	<div id="sgame_basic_tab_readme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 本插件只是作为网络前端的加速方案，需要配合服务器使用</li>
			<li> 将远程服务器的服务端口映射到本地路由上后，再使用本地客户端连接</li>
	</div>
	</div>
	<!-- ------------------ 表格2 --------------------- -->
	<div class="box boxr2" id="table_3" style="margin-top: 15px;">
		<div class="heading">TinyMapper配置</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="table_3_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="pbr_userreadme" class="box boxr2" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 将服务器上服务端口映射到本地，如科学上网、SOCKS等</li>
			<li> 请不要和路由上已经开启的端口冲突，否则会导致映射失败</li>
	</div>
	</div>
	</div>
	<!-- ------------------ 表格3 --------------------- -->
	<div class="box boxr3" id="udp2raw_log_tab" style="margin-top: 0px;">
		<div id="udp2raw_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.45);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#udp2raw_log_pannel').append('<textarea class="as-script" name="_udp2raw_basic_log" id="_udp2raw_basic_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
		</div>
	</div>
	<!-- ------------------ 表格4 --------------------- -->
	<div class="box boxr4" id="tinyvpn_log_tab" style="margin-top: 0px;">
		<div id="tinyvpn_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.45);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#tinyvpn_log_pannel').append('<textarea class="as-script" name="_tinyvpn_basic_log" id="_tinyvpn_basic_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
		</div>
	</div>
	<!-- ------------------ 其它 --------------------- -->
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">提交 <i class="icon-check"></i></button>
	<script type="text/javascript">init_sgame();</script>
</content>
