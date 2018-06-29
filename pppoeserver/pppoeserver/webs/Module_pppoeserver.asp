<title>PPPoE服务器</title>
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
		var softcenter = 0;
		//var option_wan = [['wan', 'wan'], ['wan2', 'wan2']];
		var option_wan = [];
		var option_wan_name = [];
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
		var table2 = new TomatoGrid();
	
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
				{ type: 'text', value:'' },
				{ type: 'text', value:'' }
			] );
			this.headerSet( [ '用户名',  '密码'] );
			for ( var i = 1; i <= table2_node_nu; i++){
				var t1 = [dbus["pppoeserver_user_name_" + i ], dbus["pppoeserver_user_passwd_" + i ] ]
				if ( t1.length == 2 ) this.insertData( -1, t1 );
			}
			this.showNewEditor();
			this.resetNewEditor();
		}

		//============================================

		function init_pbr(){
			get_dbus_data();
			tabSelect("app1");
			table2.setup();
			//get_wans_list2();
			setTimeout("get_run_status();", 1000);
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/pppoeserver_",
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
			E("_pppoeserver_enable").checked = dbus["pppoeserver_enable"] == 1 ? true : false;
			E("_pppoeserver_usernum").value = dbus["pppoeserver_usernum"];
			E("_pppoeserver_svname").value = dbus["pppoeserver_svname"];
			E("_pppoeserver_ip").value = dbus["pppoeserver_ip"];
			E("_pppoeserver_dns1").value = dbus["pppoeserver_dns1"];
			E("_pppoeserver_dns2").value = dbus["pppoeserver_dns2"];
			if(!dbus.pppoeserver_usernum){E("_pppoeserver_usernum").value = "1";};
			if(!dbus.pppoeserver_svname){E("_pppoeserver_svname").value = "koolshare";};
			if(!dbus.pppoeserver_ip){E("_pppoeserver_ip").value = "10.0.10.1";};
			if(!dbus.pppoeserver_dns1){E("_pppoeserver_dns1").value = "10.0.10.1";};
			if(!dbus.pppoeserver_dns2){E("_pppoeserver_dns2").value = "223.5.5.5";};
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "pppoeserver_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_pppoeserver_status").innerHTML = response.result.split("@@")[0];
					setTimeout("get_run_status();", 5000);
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_pppoeserver_status").innerHTML = "获取本地版本信息失败！";
					setTimeout("get_run_status();", 2000);
				}
			});
		}

		function calculate_max_node(){
			//--------------------------------------
			// count table3 line data nu
			var tmp_1 = [];
			var tmp_2 = [];
			
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
				b = field.split("pppoeserver_user_passwd_");
				tmp_3.push(b)
			}
			
			for ( var i = 0; i < tmp_3.length; i++){
				if (tmp_3[i][0] == ""){
					tmp_4.push(tmp_3[i][1]);
				}
			}
			table2_node_nu = tmp_4.length;
		}
		function tabSelect(obj){
			var tableX = ['app1-tab', 'app2-tab'];
			var boxX = ['boxr1', 'boxr2'];
			var appX = ['app1', 'app2'];
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
			var table2_conf = ["pppoeserver_user_name_", "pppoeserver_user_passwd_"];
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
			//console.log(dbus)
			// now post data
			postdata("pppoeserver_config.sh", dbus)
		}

		function postdata(script, obj){
			softcenter = 0;
			var id2 = parseInt(Math.random() * 100000000);
			var postData = {"id": id2, "method": script, "params":[], "fields": obj};
			dbus.pppoeserver_enable = E('_pppoeserver_enable').checked ? '1':'0';
			dbus.pppoeserver_usernum = E('_pppoeserver_usernum').value;
			dbus.pppoeserver_svname = E('_pppoeserver_svname').value;
			dbus.pppoeserver_ip = E('_pppoeserver_ip').value;
			dbus.pppoeserver_dns1 = E('_pppoeserver_dns1').value;
			dbus.pppoeserver_dns2 = E('_pppoeserver_dns2').value;
			showMsg("msg_warring","正在提交数据！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				type: "POST",
				async:true,
				cache:false,
				dataType: "json",
				data: JSON.stringify(postData),
				success: function(response){
					if (response.result == id2){
						showMsg("msg_status","提交成功","<b>提交数据成功！种马返回：" + response.result + "</b>");
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
		<div class="heading">PPPoE服务器<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				可以使以太网的主机通过一个简单的桥接设备连到一个远端的接入集中器上。<br>通过pppoe协议，远端接入设备能够实现对每个接入用户的控制和计费。
			</span>
		</div>	
	</div>
	<!-- ------------------ 标签页 --------------------- -->
	<ul id="pbr_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" ><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" ><i class="icon-globe"></i> 账号设置</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 15px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启PPPoE服务器', name:'pppoeserver_enable',type:'checkbox',value: "" },
					{ title: '运行状态', text: '<font id="_pppoeserver_status" name=_pppoeserver_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '服务名称', name:'pppoeserver_svname',type:'text', maxlen: 30, size: 30,value: "" },
					{ title: '每用户最大会话数', name:'pppoeserver_usernum',type:'text', maxlen: 4, size: 4 ,value: "" },
					{ title: '服务器IP', name:'pppoeserver_ip',type:'text', maxlen: 15, size: 15 ,value: "" },
					{ title: '下发客户端DNS1', name:'pppoeserver_dns1',type:'text', maxlen: 15, size: 15 ,value: "" },
					{ title: '下发客户端DNS2', name:'pppoeserver_dns2',type:'text', maxlen: 15, size: 15 ,value: "" },
				]);
			</script>
		</div>
		</div>
	<!-- ------------------ 表格2--------------------- -->
	<div class="box boxr2" id="table_2" style="margin-top: 15px;">
		<div class="heading">账号设置</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="table_2_grid">
				</table>
			</div>
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
