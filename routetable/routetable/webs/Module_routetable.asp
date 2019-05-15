<title>路由表设置</title>
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
		var wans_value =[];
		var option_wan_name = [];
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
				{ type: 'select', options:option_wan, value:'' },
				{ type: 'text', value:'' }
			] );
			this.headerSet( [ 'WAN口名称',  'IP地址（不支持CIDR）'] );
			for ( var i = 1; i <= table2_node_nu; i++){
				var t1 = [dbus["routetable_wan_name_" + i ], dbus["routetable_wan_isp_" + i ] ]
				if ( t1.length == 2 ) this.insertData( -1, t1 );
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
				b = field.split("routetable_wan_name_");
				tmp_3.push(b)
			}
			
			for ( var i = 0; i < tmp_3.length; i++){
				if (tmp_3[i][0] == ""){
					tmp_4.push(tmp_3[i][1]);
				}
			}
			table2_node_nu = tmp_4.length;
			get_wans_list();
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/routetable_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			 	 	//console.log(dbus);
			 	 	calculate_max_node();
					//get_wans_list();
			 	 	conf2obj();
			  	}
			});
		}

		function conf2obj(){
			E("_routetable_enable").checked = dbus["routetable_enable"] == 1 ? true : false;
			E("_routetable_ip_wan").value = dbus["routetable_ip_wan"];
			E("_routetable_ip_list").value = Base64.decode(dbus.routetable_ip_list);
			E("_routetable_domain_wan").value = dbus["routetable_domain_wan"];
			E("_routetable_domain_list").value =Base64.decode(dbus.routetable_domain_list);
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "routetable_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_routetable_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_routetable_status").innerHTML = "获取本地版本信息失败！";
					setTimeout("get_run_status();", 2000);
				}
			});
		}

		function mwan_set(){
			for ( var i = 0; i < wans.length; ++i ) {
				$("#_routetable_ip_wan").append("<option value='"  + wans[i][0] + "'>" + wans[i][0] + "</option>");
				$("#_routetable_domain_wan").append("<option value='"  + wans[i][0] + "'>" + wans[i][0] + "</option>");
			}
			// fill the 3 input
			if(wans.length > 1){
				E("_routetable_ip_wan").value = dbus["routetable_ip_wan"] || "0";
				E("_routetable_domain_wan").value = dbus["routetable_domain_wan"] || "0";
			}else if (wans.length == 0){
				E("_routetable_ip_wan").value = "0";
				E("_routetable_domain_wan").value = "0";
			}else{
				E("_routetable_ip_wan").value = wans[0][0];
				E("_routetable_domain_wan").value = wans[0][0];
			}
			for ( var i = 0; i < wans.length; ++i ) {
				wans_value[i] = wans[i][0];
			}
		}

		function get_wans_list(){
			var id2 = parseInt(Math.random() * 100000000);
			var postData2 = {"id": id2, "method": "routetable_getwan.sh", "params":[], "fields": ""};
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
							//$("#_wireguard_basic_vpn").append("<option value='" + s2[i] + "'>" + s2[i] + "</option>");
						}
						option_wan_name = wans.sort();
						table2.setup();
						mwan_set();
					}
				},
				timeout:5000
			});
		}

		function tabSelect(obj){
			var tableX = ['app1-tab', 'app2-tab', 'app3-tab'];
			var boxX = ['boxr1', 'boxr2', 'boxr3'];
			var appX = ['app1', 'app2', 'app3'];
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
			dbus["routetable_enable"] = E("_routetable_enable").checked ? "1" : "0";

			// collect data from table2
			var table2_conf = ["routetable_wan_name_", "routetable_wan_isp_"];
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
			// data need base64 encode
			var paras_base64 = [ "routetable_ip_list", "routetable_domain_list"];
			for (var i = 0; i < paras_base64.length; i++) {
				if (typeof(E('_' + paras_base64[i] ).value) == "undefined"){
					dbus[paras_base64[i]] = "";
				}else{
					dbus[paras_base64[i]] = Base64.encode(E('_' + paras_base64[i]).value);
				}
			}
			// now post data
			postdata("routetable_config.sh", dbus)
		}

		function postdata(script, obj){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[1], "fields": obj};
			dbus.routetable_enable = E('_routetable_enable').checked ? '1':'0';
			dbus.routetable_ip_wan = E('_routetable_ip_wan').value;
			dbus.routetable_domain_wan = E('_routetable_domain_wan').value;
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
		<div class="heading">路由表设置<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				路由表不直接参与数据包的传输，而是用于生成一个小型指向表，这个指向表仅仅包含由路由算法选择的数据包传输优先路径。
			</span>
		</div>	
	</div>
	<!-- ------------------ 标签页 --------------------- -->
	<ul id="pbr_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" ><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" ><i class="icon-globe"></i> 更多设置</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 15px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启指定路由出口', name:'routetable_enable',type:'checkbox',value: "" },
					{ title: '运行状态', text: '<font id="_routetable_status" name=_routetable_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '指定IP出口', multi: [
						{ name:'routetable_ip_wan',type:'select',options:[],value: "" ,suffix: '</br></br>'},
						{ name:'routetable_ip_list',type:'textarea', maxlen: 200, size: 200, value: dbus.routetable_tarckip, style: 'width: 100%; height:150px;',suffix: '在上面的输入需要指定出口的外网ip/cidr地址，一行一个，例如：</br>4.4.4.4</br>5.0.0.0/8</font>'},
					]},
					{ title: '指定域名出口', multi: [
						{ name:'routetable_domain_wan',type:'select',options:[],value: "",suffix: '</br></br>' },
						{ name:'routetable_domain_list',type:'textarea', maxlen: 200, size: 200, value: dbus.routetable_tarckip, style: 'width: 100%; height:150px;',suffix: '在上面的输入需要指定出口的域名，一行一个，例如：</br>www.ip.cn</br>taobao.com</font></br>'},
					]},
				]);
			</script>
		</div>
		</div>
	<div id="pbr_basic_readme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 路由表的指定可以对路由自身发起的流量和路由器下面客户端的流量生效。</li>	
	</div>
	</div>
	<!-- ------------------ 表格2--------------------- -->
	<div class="box boxr2" id="table_2" style="margin-top: 15px;">
		<div class="heading">更多设置</div>
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
