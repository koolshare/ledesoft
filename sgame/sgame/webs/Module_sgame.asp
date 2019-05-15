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
		get_arp_list();
		get_dbus_data();
		var table3_node_nu;
		var softcenter = 0;
		var _responseLen;
		var _responseLenudp2raw;
		var _responseLentinyvpn;
		var noChange = 0;
		var status_time = 1;
		var option_acl_mode = [['0', '不代理'], ['1', 'gfwlist黑名单'], ['2', '大陆白名单'], ['3', '全局模式'], ['4', '兼容模式']];
		var option_acl_mode_name = ['不代理', 'gfwlist黑名单', '大陆白名单', '全局模式', '兼容模式'];
		var option_acl_port = [['80,443', '80,443'], ['22,80,443', '22,80,443'], ['all', '全部端口'],['0', '自定义']];
		var option_acl_port_name = ['80,443', '22,80,443', '全部端口', '自定义'];
		var option_arp_list = [];
		var option_arp_local = [];
		var option_arp_web = [];
		var option_udp = [['0', '开启'],['1', '关闭']];
		var option_udp_name = ['开启', '关闭'];
		var option_time_hour = [];
		var option_time_minute = [];
		for(var i = 0; i < 24; i++){
			option_time_hour[i] = [i, i + "点"];
		}
		for(var i = 0; i < 60; i++){
			option_time_minute[i] = [i, i + "分"];
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
			return [ data[0], option_udp_name[data[1]] ];
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
				{ type: 'text',maxlen:5},
				{ type: 'select',maxlen:10, options:option_udp}
			] );
			this.headerSet( [ '端口号', 'UDP端口' ] );

			for ( var i = 1; i <= dbus["sgame_tiynmapper_node_max"]; i++){
				var t2 = [ dbus["sgame_tiynmapper_port_" + i ], dbus["sgame_tiynmapper_udp_" + i ]]
				if ( t2.length == 2 ) this.insertData( -1, t2);
			}
			this.recolor();
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		var sgame_acl = new TomatoGrid();
		sgame_acl.dataToView = function( data ) {
			var option_acl_port = [['80,443', '80,443'], ['22,80,443', '22,80,443'], ['all', 'all'], ['0', '自定义']];
			var option_acl_port_value = ['80,443', '22,80,443', 'all', '0'];
			var option_acl_port_name = ['80,443', '22,80,443', '全部端口', '自定义'];
			var a = option_acl_port_value.indexOf(data[4]);
			var b = option_acl_port_name[a]
			if (data[4] == 0){
				b = data[5]
			}
		
			if (data[0]){
				return [ "【" + data[0] + "】", data[1], data[2], option_acl_mode_name[data[3]], b, data[5] ];
			}else{
				if (data[1]){
					return [ "【" + data[1] + "】", data[1], data[2], option_acl_mode_name[data[3]], b, data[5] ];
				}else{
					if (data[2]){
						return [ "【" + data[2] + "】", data[1], data[2], option_acl_mode_name[data[3]], b, data[5] ];
					}
				}
			}
		}
		sgame_acl.fieldValuesToData = function( row ) {
			var f = fields.getAll( row );
			if (f[0].value){
				return [ f[0].value, f[1].value, f[2].value, f[3].value, f[4].value, f[5].value ];
			}else{
				if (f[1].value){
					return [ f[1].value, f[1].value, f[2].value, f[3].value, f[4].value, f[5].value ];
				}else{
					if (f[2].value){
						return [ f[2].value, f[1].value, f[2].value, f[3].value, f[4].value, f[5].value ];
					}
				}
			}
		}
		sgame_acl.dataToFieldValues = function (data) {
			return [data[0], data[1], data[2], data[3], data[4], data[5]];
		}
    	sgame_acl.onChange = function(which, cell) {
    	    return this.verifyFields((which == 'new') ? this.newEditor: this.editor, true, cell);
    	}
		sgame_acl.verifyFields = function( row, quiet,cell ) {
			var f = fields.getAll( row );
			// fill the ip and mac when chose the name
			if ( $(cell).attr("id") == "_[object HTMLTableElement]_1" ) {
				if (f[0].value){
					f[1].value = option_arp_list[f[0].selectedIndex][2];
					f[2].value = option_arp_list[f[0].selectedIndex][3];
				}
			}

			// user port
			if (f[4].selectedIndex == 3){
				$("#sgame_acl_pannel > tbody > tr > td:nth-child(6)").show();
				$("#_sgame_acl_pannel_6").show();
			}else{
				$("#sgame_acl_pannel > tbody > tr > td:nth-child(6)").hide();
				$("#_sgame_acl_pannel_6").hide();
			}
			//check if ip and mac column correct
			if (f[1].value && !f[2].value){
				return v_ip( f[1], quiet );
			}
			if (!f[1].value && f[2].value){
				return v_mac( f[2], quiet );
			}
			if (f[1].value && f[2].value){
				return v_ip( f[1], quiet ) || v_mac( f[2], quiet );
			}
		}
		sgame_acl.alter_txt = function() {
			if (this.tb.rows.length == "6"){
				$('#footer_ip').html("<i>全部主机 - ip</i>")
				$('#footer_mac').html("<i>全部主机 - mac</i>")
			}else{
				$('#footer_ip').html("<i>其它主机 - ip</i>")
				$('#footer_mac').html("<i>其它主机 - mac</i>")
			}
		}
		sgame_acl.onAdd = function() {
			var data;
			this.moving = null;
			this.rpHide();
			if (!this.verifyFields(this.newEditor, false)) return;
			data = this.fieldValuesToData(this.newEditor);
			this.insertData(1, data);
			this.disableNewEditor(false);
			this.resetNewEditor();
			this.alter_txt(); // added by sadog
		}
		sgame_acl.rpDel = function(b) {
			b = PR(b);
			TGO(b).moving = null;
			b.parentNode.removeChild(b);
			this.recolor();
			this.rpHide()
			this.alter_txt(); // added by sadog
		}
		sgame_acl.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value = '';
			f[ 1 ].value   = '';
			f[ 2 ].value   = '';
			f[ 3 ].value   = '1';
			f[ 4 ].value   = '80,443';
			f[ 5 ].value   = '';
		}
		sgame_acl.footerSet = function(c, b) {
			var f, d;
			elem.remove(this.footer);
			this.footer = f = this._insert(-1, c, b);
			//f.className = "alert alert-info";
			for (d = 0; d < f.cells.length; ++d) {
				f.cells[d].cellN = d;
				f.cells[d].onclick = function() {
					TGO(this).footerClick(this)
				}
			}
			return f
		}
		sgame_acl.setup = function() {
			this.init( 'sgame_acl_pannel', '', 254, [
			{ type: 'select',maxlen:20,options:option_arp_list},	//name
			{ type: 'text',maxlen:20},	//name
			{ type: 'text',maxlen:20},	//name
			{ type: 'select',maxlen:20,options:option_acl_mode},	//control
			{ type: 'select',maxlen:20,options:option_acl_port},
			{ type: 'text',maxlen:20}
			] );
			this.headerSet( [ '主机别名', '主机IP地址', 'MAC地址', '访问控制', '目标端口', '自定义端口'] );
			if (typeof(dbus["sgame_acl_node_max"]) == "undefined"){
				this.footerSet( [ '<small id="footer_name" style="color:#1bbf35"><i>缺省规则</i></small>','<small id="footer_ip" style="color:#1bbf35"><i>全部主机 - ip</i></small>','<small id="footer_mac" style="color:#1bbf35"><i>全部主机 - mac</small></i>','<select id="_sgame_acl_default_mode1" name="sgame_acl_default_mode1" style="border: 0px solid #222;background: transparent;margin-left:-4px;padding:-0 -0;height:16px;" onchange="verifyFields(this, 1)"><option value="0">不代理</option><option value="1">gfwlist黑名单</option><option value="2">大陆白名单</option><option value="3">全局模式</option><option value="4">兼容模式</option></select>','<small id="footer_port" style="color:#1bbf35"><i>全部主机 - 全部端口</i></small>','<small id="footer_port_user" style="color:#1bbf35"></small>']);
			}else{
				this.footerSet( [ '<small id="footer_name" style="color:#1bbf35"><i>缺省规则</i></small>','<small id="footer_ip" style="color:#1bbf35"><i>其它主机 - ip</i></small>','<small id="footer_mac" style="color:#1bbf35"><i>其它主机 - mac</small></i>','<select id="_sgame_acl_default_mode1" name="sgame_acl_default_mode1" style="border: 0px solid #222;background: transparent;margin-left:-4px;padding:-0 -0;height:16px;" onchange="verifyFields(this, 1)"><option value="0">不代理</option><option value="1">gfwlist黑名单</option><option value="2">大陆白名单</option><option value="3">全局模式</option><option value="4">兼容模式</option></select>','<small id="footer_port" style="color:#1bbf35"><i>其它主机 - 全部端口</i></small>','<small id="footer_port_user" style="color:#1bbf35"></small>']);
			}
			
			if(typeof(dbus["sgame_acl_default_mode"]) != "undefined" ){
				E("_sgame_acl_default_mode1").value = dbus["sgame_acl_default_mode"];
			}else{
				E("_sgame_acl_default_mode1").value = 1;
			}
			
			for ( var i = 1; i <= dbus["sgame_acl_node_max"]; i++){
				var t = [dbus["sgame_acl_name_" + i ], 
						dbus["sgame_acl_ip_" + i ]  || "",
						dbus["sgame_acl_mac_" + i ]  || "",
						dbus["sgame_acl_mode_" + i ],
						dbus["sgame_acl_port_" + i ],
						dbus["sgame_acl_port_user_" + i ]||""
						]
				if ( t.length == 6 ) this.insertData( -1, t );
			}
			this.recolor();
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		function init_sgame(){
			get_dbus_data();
			table3.setup();
			tabSelect("app1");
			verifyFields();
			set_version();
			show_hide_panel();
			setTimeout("get_run_status();", 1000);
		}

		function show_hide_panel(){
			var a  = E('_sgame_basic_enable').checked;
			var b  = E('_sgame_udp2raw_enable').checked;
			var c  = E('_sgame_basic_cron').checked;
			var d  = E('_sgame_basic_proxy').checked;
			elem.display('sgame_status_pannel', a);
			elem.display('sgame_tabs', a);
			elem.display('sgame_basic_tab', a);
			elem.display('sgame_basic_tab_tinyvpn', a);
			elem.display('sgame_basic_tab_udp2raw', a&&b);
			elem.display(PR('_sgame_basic_server'), !b);
			elem.display(PR('_sgame_basic_port'), !b);
			elem.display(PR('_sgame_basic_cron_enablehour'), c);
			elem.display(PR('_sgame_basic_cron_enableminute'), c);
			elem.display(PR('_sgame_basic_cron_disablehour'), c);
			elem.display(PR('_sgame_basic_cron_disableminute'), c);
		}

		function get_arp_list(){
			var id5 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id5, "method": "sgame_getarp.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					if (response.result != "-1"){
						var s2 = response.result.split( '>' );
						for ( var i = 0; i < s2.length; ++i ) {
							option_arp_local[i] = [s2[ i ].split( '<' )[0], "【" + s2[ i ].split( '<' )[0] + "】", s2[ i ].split( '<' )[1], s2[ i ].split( '<' )[2]];
						}
						var node_acl = parseInt(dbus["sgame_acl_node_max"]) || 0;
						for ( var i = 0; i < node_acl; ++i ) {
							option_arp_web[i] = [dbus["sgame_acl_name_" + (i + 1)], "【" + dbus["sgame_acl_name_" + (i + 1)] + "】", dbus["sgame_acl_ip_" + (i + 1)], dbus["sgame_acl_mac_" + (i + 1)]];
						}			
						option_arp_list = unique_array(option_arp_local.concat( option_arp_web ));
						sgame_acl.setup();
					}
				},
				error:function(){
					sgame_acl.setup();
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
			 	url: "/_api/sgame_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
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
						if(dbus["sgame_basic_enable"] != "1"){
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

		function tabSelect(obj){
			var tableX = ['app1-tab', 'app2-tab', 'app3-tab', 'app4-tab', 'app5-tab', 'app6-tab', 'app7-tab', 'app8-tab'];
			var boxX = ['boxr1', 'boxr2', 'boxr3', 'boxr4', 'boxr5', 'boxr6', 'boxr7', 'boxr8'];
			var appX = ['app1', 'app2', 'app3', 'app4', 'app5', 'app6', 'app7', 'app8'];
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
				elem.display('stop-button', true);
				elem.display('save-button', true);
				noChange=2001;
			}else if(obj=='app3'){
				elem.display('save-button', false);
				elem.display('stop-button', false);
				noChange=0;
				setTimeout("get_udp2raw_log();", 200);
			}else if(obj=='app4'){
				elem.display('save-button', false);
				elem.display('stop-button', false);
				noChange=0;
				setTimeout("get_tinyvpn_log();", 200);
			}else if(obj=='app5'){
				elem.display('save-button', false);
				elem.display('stop-button', false);
				noChange=0;
				setTimeout("get_sgame_log();", 200);
			}else{
				elem.display('save-button', true);
				elem.display('stop-button', true);
				noChange=2001;
			}
			if(obj=='fuckapp'){
				elem.display('sgame_status_pannel', false);
				elem.display('sgame_tabs', false);
				elem.display('sgame_basic_tab', false);
				elem.display('table_3', false);
				elem.display('udp2raw_log_tab', false);
				elem.display('tinyvpn_log_tab', false);
				elem.display('sgame_log_tab', false);
				elem.display('sgame_wblist_tab', false);
				elem.display('sgame_acl_tab', false);
				E('save-button').style.display = "";
				E('stop-button').style.display = "";
			}
		}

		function verifyFields(r){
			var a  = E('_sgame_basic_enable').checked;
			if ( $(r).attr("id") == "_sgame_basic_enable" ) {
				if(a){
					elem.display('sgame_status_pannel', a);
					elem.display('sgame_tabs', a);
					elem.display('sgame_basic_tab', a);
					elem.display('sgame_basic_tab_tinyvpn', a);
					elem.display('sgame_basic_tab_readme', a);
					tabSelect('app1')
				}else{
					tabSelect('fuckapp')
				}
			}
			// change main mode adn acl mode
			if ( $(r).attr("id") == "_sgame_acl_default_mode" ) {
				E("_sgame_acl_default_mode1").value = E("_sgame_acl_default_mode").value;
			}
			if ( $(r).attr("id") == "_sgame_acl_default_mode1" ) {
				E("_sgame_acl_default_mode").value = E("_sgame_acl_default_mode1").value;
			}
			var b  = E('_sgame_udp2raw_enable').checked;
			var c  = E('_sgame_basic_cron').checked;
			var d  = E('_sgame_basic_proxy').checked;
			elem.display(PR('_sgame_acl_default_mode'), d);
			elem.display('sgame_basic_tab_udp2raw', a&&b);
			//elem.display('udp2raw_log_tab', a&&b);
			elem.display(PR('_sgame_basic_server'), !b);
			elem.display(PR('_sgame_basic_port'), !b);
			elem.display(PR('_sgame_basic_cron_enablehour'), c);
			elem.display(PR('_sgame_basic_cron_enableminute'), c);
			elem.display(PR('_sgame_basic_cron_disablehour'), c);
			elem.display(PR('_sgame_basic_cron_disableminute'), c);
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

		function count_down_switch() {
			if (x == "0") {
				setTimeout("window.location.reload()", 500);
			}
			if (x < 0) {
				return false;
			}
				--x;
			setTimeout("count_down_switch();", 500);
		}

		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}

		function save(){
			status_time = 999999990;
			setTimeout("tabSelect('app5')", 500);
			//get_run_status();
			E("_sgame_status").innerHTML = "提交中...暂停获取状态！";
			E("_sgame_status_ping").innerHTML = "提交中...暂停获取状态！";
			var paras_chk = ["enable", "cron", "proxy"];
			var paras_inp = ["sgame_acl_default_mode", "sgame_udp2raw_server", "sgame_udp2raw_port", "sgame_udp2raw_mode", "sgame_basic_server", "sgame_basic_port", "sgame_basic_subnet",  "sgame_basic_cron_enablehour", "sgame_basic_cron_disablehour", "sgame_basic_cron_enableminute", "sgame_basic_cron_disableminute"];
			// collect data from checkbox
			dbus["sgame_udp2raw_enable"] = E("_sgame_udp2raw_enable").checked ? '1':'0';
			
			for (var i = 0; i < paras_chk.length; i++) {
				dbus["sgame_basic_" + paras_chk[i]] = E('_sgame_basic_' + paras_chk[i] ).checked ? '1':'0';
			}
			// data from other element
			for (var i = 0; i < paras_inp.length; i++) {
				if (typeof(E('_' + paras_inp[i] ).value) == "undefined"){
					dbus[paras_inp[i]] = "";
				}else{
					dbus[paras_inp[i]] = E('_' + paras_inp[i]).value;
				}
			}
			// data need base64 encode
			var paras_base64 = ["sgame_wan_white_ip", "sgame_wan_white_domain", "sgame_wan_black_ip", "sgame_wan_black_domain", "sgame_udp2raw_password", "sgame_udp2raw_other", "sgame_basic_password", "sgame_basic_other"];
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
				dbus["sgame_tiynmapper_node_max"] = data.length;
			}else{
				dbus["sgame_tiynmapper_node_max"] = "";
			}
			// collect acl data from acl pannel
			var sgame_acl_conf = ["sgame_acl_name_", "sgame_acl_ip_", "sgame_acl_mac_", "sgame_acl_mode_", "sgame_acl_port_", "sgame_acl_port_user_" ];
			// mark all acl data for delete first
			for ( var i = 1; i <= dbus["sgame_acl_node_max"]; i++){
				for ( var j = 0; j < sgame_acl_conf.length; ++j ) {
					dbus[sgame_acl_conf[j] + i ] = ""
				}
			}
			var data2 = sgame_acl.getAllData();
			if(data2.length > 0){
				for ( var i = 0; i < data2.length; ++i ) {
					for ( var j = 1; j < sgame_acl_conf.length; ++j ) {
						dbus[sgame_acl_conf[0] + (i + 1)] = data2[i][0];
						dbus[sgame_acl_conf[j] + (i + 1)] = data2[i][j];
					}
				}
				dbus["sgame_acl_node_max"] = data2.length;
			}else{
				dbus["sgame_acl_node_max"] = "";
			}
			// now post data
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "sgame_config.sh", "params":[1], "fields": dbus};
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
						if(E('_sgame_basic_enable').checked){
							showMsg("msg_success","提交成功","<b>SGAME成功提交数据</b>");
							$('#msg_warring').hide();
							setTimeout("$('#msg_success').hide()", 500);
							x = 4;
							count_down_switch();
						}else{
							// when shut down ss finished, close the log tab
							$('#msg_warring').hide();
							showMsg("msg_success","提交成功","<b>SGAME成功关闭！</b>");
							setTimeout("$('#msg_success').hide()", 4000);
							setTimeout("tabSelect('fuckapp')", 4000);
						}
					}else{
						$('#msg_warring').hide();
						showMsg("msg_error","提交失败","<b>提交数据失败！错误代码：" + response.result + "</b>");
						setTimeout("window.location.reload()", 500);
					}
				},
				error: function(){
					showMsg("msg_error","失败","<b>当前系统存在异常查看系统日志！</b>");
					status_time = 1;
				}
			});
		}

		function manipulate_conf(script, arg){
			var dbus3 = {};
			if(arg == 2){
				tabSelect("app5");
			}
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[arg], "fields": dbus3 };
			$.ajax({
				type: "POST",
				url: "/_api/",
				async: true,
				cache:false,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function(response){
					if (script == "sgame_config.sh"){
						if (arg == 2){
							if (response.result == id){
								showMsg("msg_success","提交成功","<b>服务器暂停成功！</b>");
								setTimeout("$('#msg_success').hide()", 4000);								
							}else{
								$('#msg_warring').hide();
								showMsg("msg_error","提交失败","<b>服务器暂停失败！错误代码：" + response.result + "</b>");
							}
							setTimeout("tabSelect('app5')", 500);
							setTimeout("window.location.reload()", 500);
						}else if (arg == 1){
							if (response.result == id){
								showMsg("msg_success","提交成功","<b>服务器运行成功！</b>");
								setTimeout("$('#msg_success').hide()", 4000);								
							}else{
								$('#msg_warring').hide();
								showMsg("msg_error","提交失败","<b>服务器运行失败！错误代码：" + response.result + "</b>");
							}
							setTimeout("tabSelect('app5')", 500);
							setTimeout("window.location.reload()", 800);
						}
					}
				}
			});
		}

		function get_udp2raw_log(){
			$.ajax({
				url: '/_temp/udp2raw_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(responseudp2raw) {
					var retArea = E("_udp2raw_basic_log");
					if (responseudp2raw.search("XU6J03M6") != -1) {
						retArea.value = responseudp2raw.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						return true;
					}
					if (_responseLenudp2raw == responseudp2raw.length) {
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
					retArea.value = responseudp2raw;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLenudp2raw = responseudp2raw.length;
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
				success: function(responsetinyvpn) {
					var retArea = E("_tinyvpn_basic_log");
					if (responsetinyvpn.search("XU6J03M6") != -1) {
						retArea.value = responsetinyvpn.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						return true;
					}
					if (_responseLentinyvpn == responsetinyvpn.length) {
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
					retArea.value = responsetinyvpn;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLentinyvpn = responsetinyvpn.length;
				},
				error: function() {
					E("_tinyvpn_basic_log").value = "获取日志失败！";
				}
			});
		}

		function get_sgame_log(){
			$.ajax({
				url: '/_temp/sgame_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(response) {
					var retArea = E("_sgame_basic_log");
					if (response.search("XU6J03M6") != -1) {
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
						setTimeout("get_sgame_log();", 100); //100 is radical but smooth!
					}
					retArea.value = response;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLen = response.length;
				},
				error: function() {
					E("_sgame_basic_log").value = "获取日志失败！";
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
					{ title: '加速器开关', name:'sgame_basic_enable',type:'checkbox',  value: dbus.sgame_basic_enable == 1 }  // ==1 means default close; !=0 means default open
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
		<li><a href="javascript:void(0);" onclick="tabSelect('app7');" id="app7-tab"><i class="icon-warning"></i> 黑白名单</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app8');" id="app8-tab"><i class="icon-lock"></i> 访问控制</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab" ><i class="icon-hourglass"></i> UDP2raw日志</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app4');" id="app4-tab" ><i class="icon-hourglass"></i> TinyVPN日志</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app5');" id="app5-tab" ><i class="icon-hourglass"></i> 查看日志</a></li>
	</ul>
	<div class="box boxr1" id="sgame_basic_tab" style="margin-top: 15px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '已安装无限制TinyVPN服务器端，在路由上配置代理', name:'sgame_basic_proxy',type:'checkbox',  value: dbus.sgame_basic_proxy == 1 },
					{ title: '代理模式', name:'sgame_acl_default_mode',type:'select',options:option_acl_mode,value: dbus.sgame_acl_default_mode || "4"},
					{ title: '开启Udp2raw突破UDP屏蔽或QOS限速', name:'sgame_udp2raw_enable',type:'checkbox',  value: dbus.sgame_udp2raw_enable == 1 },
					{ title: '定时自动开关', name:'sgame_basic_cron',type:'checkbox',  value: dbus.sgame_basic_cron == 1 },
					{ title: '定时开启', multi: [
						{ name: 'sgame_basic_cron_enablehour',type: 'select', options:option_time_hour, value: dbus.sgame_basic_cron_enablehour || '19' ,suffix: ' 时' },
						{ name: 'sgame_basic_cron_enableminute',type: 'select', options:option_time_minute, value: dbus.sgame_basic_cron_enableminute || '30' ,suffix: ' 分' },
					]},
					{ title: '定时关闭', multi: [
						{ name: 'sgame_basic_cron_disablehour',type: 'select', options:option_time_hour, value: dbus.sgame_basic_cron_disablehour || '2' ,suffix: ' 时' },
						{ name: 'sgame_basic_cron_disableminute',type: 'select', options:option_time_minute, value: dbus.sgame_basic_cron_disableminute || '2' ,suffix: ' 分' },
					]},
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
						{ name:'sgame_udp2raw_server',type:'text',size: 20,value: dbus.sgame_udp2raw_server || "111.111.111.111", suffix: ' &nbsp;&nbsp;端口：'},
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
						{ name:'sgame_basic_server',type:'text',size: 20,value: dbus.sgame_basic_server || "111.111.111.111", suffix: ' &nbsp;&nbsp;端口：'},
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
			<li> 兼容模式可以与SS、V2ray等插件兼容使用，但主模式为不代理，只有访问控制里的配置生效</li>
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
	<!-- ------------------ 表格5 --------------------- -->
	<div class="box boxr5" id="sgame_log_tab" style="margin-top: 0px;">
		<div id="sgame_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.45);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#sgame_log_pannel').append('<textarea class="as-script" name="_sgame_basic_log" id="_sgame_basic_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
		</div>
	</div>
	<!-- ------------------ 表格7 --------------------- -->
	<div class="box boxr7" id="sgame_wblist_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="sgame_wblist_pannel" class="section"></div>
			<script type="text/javascript">
				$('#sgame_wblist_pannel').forms([
					{ title: '<b>IP/CIDR白名单</b></br></br><font color="#B2B2B2">不需要加速的外网ip/cidr地址，一行一个，例如：</br>2.2.2.2</br>3.3.0.0/16</font>', name: 'sgame_wan_white_ip', type: 'textarea', value: Base64.decode(dbus.sgame_wan_white_ip)||"", style: 'width: 100%; height:150px;' },
					{ title: '<b>域名白名单</b></br></br><font color="#B2B2B2">不需要加速的域名，例如：</br>google.com</br>facebook.com</font>', name: 'sgame_wan_white_domain', type: 'textarea', value: Base64.decode(dbus.sgame_wan_white_domain)||"", style: 'width: 100%; height:150px;' },
					{ title: '<b>IP/CIDR黑名单</b></br></br><font color="#B2B2B2">需要加速的外网ip/cidr地址，一行一个，例如：</br>4.4.4.4</br>5.0.0.0/8</font>', name: 'sgame_wan_black_ip', type: 'textarea', value: Base64.decode(dbus.sgame_wan_black_ip)||"", style: 'width: 100%; height:150px;' },
					{ title: '<b>域名黑名单</b></br></br><font color="#B2B2B2">需要加速的域名,例如：</br>baidu.com</br>koolshare.cn</font>', name: 'sgame_wan_black_domain', type: 'textarea', value: Base64.decode(dbus.sgame_wan_black_domain)||"", style: 'width: 100%; height:150px;' }
				]);
			</script>
		</div>
	</div>	
	<!-- ------------------ 表格8 --------------------- -->
	<div class="box boxr8" id="sgame_acl_tab" style="margin-top: 0px;">
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="sgame_acl_pannel"></table>
			</div>
			<br><hr>
		</div>
	</div>
	<div id="acl_userreadme" class="box boxr8" style="margin-top: 15px;">
	<div class="heading"><a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 所有模式均支持UDP代理</li>
	</div>
	</div>
	<!-- ------------------ 其它 --------------------- -->
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">提交 <i class="icon-check"></i></button>
	<button type="button" value="Save" id="stop-button" onclick="manipulate_conf('sgame_config.sh', 2)" class="btn">暂停 <i class="icon-disable"></i></button>
	<script type="text/javascript">init_sgame();</script>
</content>
