<title>QOS</title>
<content>
	<script type="text/javascript" src="/js/jquery.min.js"></script>
	<script type="text/javascript" src="/js/tomato.js"></script>
	<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbus = {};
		var table2_node_nu;
		var table3_node_nu;
		var table4_node_nu;
		var softcenter = 0;
		var option_poroto = [['tcp', 'TCP'], ['udp', 'UDP']];
		var option_wan = [];
		var wans_value =[];
		var option_wan_name = [];
		var option_isp_name = [];
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
			f[ 2 ].selectedIndex   = '';
			f[ 3 ].selectedIndex   = '';
			f[ 4 ].selectedIndex   = '';
		}
		table2.setup = function() {
			this.init( 'table_2_grid', 'move', 500, [
				{ type: 'text', value:'' },
				{ type: 'text', value:'' },
				{ type: 'text', value:'' },
				{ type: 'text', value:'' },
				{ type: 'text', value:'' },
			] );
			this.headerSet( [ '内部IP地址',  '最大下载速度',  '下载保证速度',  '最大上传速度',  '上传保证速度'] );
			for ( var i = 1; i <= table2_node_nu; i++){
				var t1 = [dbus["sqos_ip_name_" + i ], dbus["sqos_ip_downc_" + i ], dbus["sqos_ip_downr_" + i ], dbus["sqos_ip_upc_" + i ], dbus["sqos_ip_upr_" + i ] ]
				if ( t1.length == 5 ) this.insertData( -1, t1 );
			}
			this.showNewEditor();
			this.resetNewEditor();
		}

		//============================================
		var table3 = new TomatoGrid();
	
		table3.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table3.resetNewEditor = function() {
			var f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].selectedIndex   = '';
			f[ 1 ].selectedIndex   = '';
		}
		table3.setup = function() {
			this.init( 'table_3_grid', 'move', 500, [
				{ type: 'select', options:option_poroto, value:'' },
				{ type: 'text', value:'' },
			] );
			this.headerSet( [ '协议', '端口范围' ] );
			for ( var i = 1; i <= table3_node_nu; i++){
				var t2 = [dbus["sqos_port_name_" + i ], dbus["sqos_port_port_" + i ]]
				if ( t2.length == 2 ) this.insertData( -1, t2 );
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
			f[ 2 ].selectedIndex   = '';
		}
		table4.setup = function() {
			this.init( 'table_4_grid', 'move', 500, [
				{ type: 'text', value:'' },
				{ type: 'text', value:'' },
				{ type: 'text', value:'' },
			] );
			this.headerSet( [ '内部IP地址',  '最大TCP连接数',  '最大UDP连接数' ] );
			for ( var i = 1; i <= table4_node_nu; i++){
				var t3 = [dbus["sqos_connlmt_name_" + i ], dbus["sqos_connlmt_tcp_" + i ], dbus["sqos_connlmt_udp_" + i ]]
				if ( t3.length == 3 ) this.insertData( -1, t3 );
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
			// count table2 line data nu
			var tmp_1 = [];
			var tmp_2 = [];
			for (var field in dbus) {
				b = field.split("sqos_ip_name_");
				tmp_1.push(b)
			}
			
			for ( var i = 0; i < tmp_1.length; i++){
				if (tmp_1[i][0] == ""){
					tmp_2.push(tmp_1[i][1]);
				}
			}
			table2_node_nu = tmp_2.length;
			table2.setup();
			// count table3 line data nu
			var tmp_3 = [];
			var tmp_4 = [];
			for (var field in dbus) {
				b = field.split("sqos_port_name_");
				tmp_3.push(b)
			}
			
			for ( var i = 0; i < tmp_3.length; i++){
				if (tmp_3[i][0] == ""){
					tmp_4.push(tmp_3[i][1]);
				}
			}
			table3_node_nu = tmp_4.length;
			table3.setup();
			// count table4 line data nu
			var tmp_5 = [];
			var tmp_6 = [];
			for (var field in dbus) {
				b = field.split("sqos_connlmt_name_");
				tmp_5.push(b)
			}
			
			for ( var i = 0; i < tmp_5.length; i++){
				if (tmp_5[i][0] == ""){
					tmp_6.push(tmp_5[i][1]);
				}
			}
			table4_node_nu = tmp_6.length;
			table4.setup();
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/sqos_",
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
			E("_sqos_enable").checked = dbus["sqos_enable"] == 1 ? true : false;
			E("_sqos_global_down").value = dbus["sqos_global_down"];
			E("_sqos_global_up").value = dbus["sqos_global_up"];
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "sqos_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_sqos_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_sqos_status").innerHTML = "获取本地版本信息失败！";
					setTimeout("get_run_status();", 2000);
				}
			});
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
			dbus["sqos_enable"] = E("_sqos_enable").checked ? "1" : "0";

			////////////////////////////////////////////////////////////////////////////////
			// collect data from table2
			var table2_conf = ["sqos_ip_name_", "sqos_ip_downc_", "sqos_ip_downr_", "sqos_ip_upc_", "sqos_ip_upr_"];
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
			////////////////////////////////////////////////////////////////////////////////
			// collect data from table3
			var table3_conf = ["sqos_port_name_", "sqos_port_port_"];
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
			////////////////////////////////////////////////////////////////////////////////
			// collect data from table3
			var table4_conf = ["sqos_connlmt_name_", "sqos_connlmt_tcp_", "sqos_connlmt_udp_"];
			// mark all data for delete first
			for ( var i = 1; i <= table4_node_nu; i++){
				for ( var j = 0; j < table4_conf.length; ++j ) {
					dbus[table4_conf[j] + i ] = ""
				}
			}
			//now save table3 data to object dbus
			var data = table4.getAllData();
			if(data.length > 0){
				for ( var i = 0; i < data.length; ++i ) {
					for ( var j = 0; j < table4_conf.length; ++j ) {
						dbus[table4_conf[j] + (i + 1)] = data[i][j];
					}
				}
			}
			// now post data
			postdata("sqos_config.sh", dbus)
		}

		function postdata(script, obj){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[1], "fields": obj};
			dbus.sqos_enable = E('_sqos_enable').checked ? '1':'0';
			dbus.sqos_global_down = E('_sqos_global_down').value;
			dbus.sqos_global_up = E('_sqos_global_up').value;
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
		<div class="heading">QOS<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				通过tc iptable ndpi构建的简单易用的QOS，不要和其它QOS同时开启。
			<br>
				内置小包优先、游戏优先规则。
			</span>
		</div>	
	</div>
	<!-- ------------------ 标签页 --------------------- -->
	<ul id="pbr_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" ><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" ><i class="icon-globe"></i> 单IP或者IP段限速</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app4');" id="app4-tab" ><i class="icon-globe"></i> 连接数限制</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab" ><i class="icon-globe"></i> 端口优先</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 15px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启', name:'sqos_enable',type:'checkbox',value: "" },
					{ title: '运行状态', text: '<font id="_sqos_status" name=_sqos_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '全局下载速度', name:'sqos_global_down',type:'text', size: 10, value: dbus.sqos_tarckip ,suffix: '单位(KB/s)'},
					{ title: '全局上传速度', name:'sqos_global_up',type:'text', size: 10, value: dbus.sqos_tarckip,suffix: '单位(KB/s)'},
				]);
			</script>
		</div>
		</div>
	<!-- ------------------ 表格2--------------------- -->
	<div class="box boxr2" id="table_2" style="margin-top: 15px;">
		<div class="heading">单IP或者IP段限速</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="table_2_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="pbr_basic_readme2" class="box boxr2" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 内部IP地址可写成192.168.1.100或192.168.1.100/25，但不要使用192.168.1.100-192.168.1.150</li>
			<li> 所有速度单位(KB/s)。</li>	
	</div>
	</div>
	<!-- ------------------ 表格3--------------------- -->
	<div class="box boxr3" id="table_3" style="margin-top: 15px;">
		<div class="heading">端口优先</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="table_3_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="pbr_basic_readme3" class="box boxr3" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 优先端口不会被打上标记进入队列，可将对延时要求高的应用加入这里。</li>
			<li> 内部IP地址可写成192.168.1.100或192.168.1.100/25，但不要使用192.168.1.100-192.168.1.150</li>
			<li> 端口范围可设置成23,80,443:450</li>
	</div>
	</div>
	<!-- ------------------ 表格4--------------------- -->
	<div class="box boxr4" id="table_4" style="margin-top: 15px;">
		<div class="heading">允许客户端TCP和UDP最大连接数限制</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="table_4_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="pbr_basic_readme4" class="box boxr4" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 内部IP地址可写成192.168.1.100或192.168.1.100/25，但不要使用192.168.1.100-192.168.1.150</li>
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
