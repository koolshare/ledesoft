<title>软件中心 - 家长控制</title>
<content>
	<script type="text/javascript" src="/js/jquery.min.js"></script>
	<script type="text/javascript" src="/js/tomato.js"></script>
	<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbus = {};
		var table1_node_nu;
		var softcenter = 0;
		var option_enable = [];
		var option_url_mode = [];
		var option_proto = [];
		var option_proto_name = [];
		var option_day_time = [];
		var option_enable = [["0", "关闭"], ["1", "开启"]];
		var option_enable_name = ["关闭", "开启"];
		var option_url_mode = [["0", "普通过滤"], ["1", "强效过滤"]];
		var option_url_modename = ["普通过滤", "强效过滤"];
		var option_day_time = [["7", "每天"], ["1", "周一"], ["2", "周二"], ["3", "周三"], ["4", "周四"], ["5", "周五"], ["6", "周六"], ["0", "周日"], ["8", "工作日（周一至周五）"], ["9", "双休日（周六周日）"]];
		var option_day_timename = ["周日", "周一", "周二", "周三", "周四", "周五", "周六", "每天", "工作日（周一至周五）", "双休日（周六周日）"];
		//============================================
		var table1 = new TomatoGrid();
		table1.dataToView = function(data, i) {
			return [ option_enable_name[data[0]], data[1] , data[2] , option_day_timename[data[3]], data[4] ];
		}
		table1.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table1.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value  = '1';
			f[ 1 ].value  = '22:00';
			f[ 2 ].value  = '8:00';
			f[ 3 ].value  = '7';
			f[ 4 ].value  = 'ALL';
		}
		table1.setup = function() {
			this.init( 'table_1_grid', '', 500, [
				{ type: 'select', options:option_enable, value:'' },
				{ type: 'text' },
				{ type: 'text' },
				{ type: 'select', options:option_day_time, value:'' },
				{ type: 'text' }
			] );
			this.headerSet( [ '规则开关', '开始时间', '结束时间', '星期', '客户端MAC地址' ] );
			for ( var i = 1; i <= table1_node_nu; i++){
				var t1 = [ 
					dbus["mia_list_enable_" + i ],
					dbus["mia_list_start_" + i ],
					dbus["mia_list_stop_" + i ],
					dbus["mia_list_week_" + i ],
					dbus["mia_list_mac_" + i ]
					]
				if ( t1.length == 5 ) this.insertData( -1, t1);
			}
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		var table2 = new TomatoGrid();
		table2.dataToView = function(data, i) {
			return [ option_enable_name[data[0]], data[1] , data[2] , option_url_modename[data[3]], data[4], data[5] ];
		}
		table2.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table2.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value  = '1';
			f[ 1 ].value  = '3:00';
			f[ 2 ].value  = '2:59';
			f[ 3 ].value  = '0';
			f[ 4 ].value  = 'ALL';
			f[ 5 ].value  = '';
		}
		table2.setup = function() {
			this.init( 'table_2_grid', '', 500, [
				{ type: 'select', options:option_enable, value:'' },
				{ type: 'text' },
				{ type: 'text' },
				{ type: 'select', options:option_url_mode, value:'' },
				{ type: 'text' },
				{ type: 'text' }
			] );
			this.headerSet( [ '规则开关', '开始时间', '结束时间', '过滤模式', '客户端MAC地址', '网址关键词' ] );
			for ( var i = 1; i <= table2_node_nu; i++){
				var t2 = [ 
					dbus["mia_url_enable_" + i ],
					dbus["mia_url_start_" + i ],
					dbus["mia_url_stop_" + i ],
					dbus["mia_url_mode_" + i ],
					dbus["mia_url_mac_" + i ],
					dbus["mia_url_name_" + i ]
					]
				if ( t2.length == 6 ) this.insertData( -1, t2);
			}
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		var table3 = new TomatoGrid();
		table3.dataToView = function(data, i) {
			return [ option_enable_name[data[0]], data[1] , data[2] , data[3], data[4] ];
		}
		table3.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table3.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value  = '1';
			f[ 1 ].value  = '3:00';
			f[ 2 ].value  = '2:59';
			f[ 3 ].value  = 'ALL';
			f[ 4 ].value  = '';
		}
		table3.setup = function() {
			this.init( 'table_3_grid', '', 500, [
				{ type: 'select', options:option_enable, value:'' },
				{ type: 'text' },
				{ type: 'text' },
				{ type: 'text' },
				{ type: 'select', options:option_proto, value:'' },
			] );
			this.headerSet( [ '规则开关', '开始时间', '结束时间', '客户端MAC地址', '协议类型' ] );
			for ( var i = 1; i <= table3_node_nu; i++){
				var t3 = [ 
					dbus["mia_proto_enable_" + i ],
					dbus["mia_proto_start_" + i ],
					dbus["mia_proto_stop_" + i ],
					dbus["mia_proto_mac_" + i ],
					dbus["mia_proto_name_" + i ]
					]
				if ( t3.length == 5 ) this.insertData( -1, t3);
			}
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================

		function init_wol(){
			get_dbus_data();
			tabSelect("app1");
			setTimeout("get_run_status();", 1000);
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/mia_",
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
			E("_mia_enable").checked = dbus["mia_enable"] == 1 ? true : false;
		}

		function get_protos_list(){
			var id2 = parseInt(Math.random() * 100000000);
			var postData2 = {"id": id2, "method": "mia_getproto.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData2),
				dataType: "json",
				success: function(response){
					if (response.result != "-1"){
						protos = response.result.split( '>' );
						//console.log(s3);
						for ( var i = 0; i < protos.length; ++i ) {
							var protos_temp = [];
							protos_temp[0] = protos[i]
							protos_temp[1] = protos[i]
							option_proto.push(protos_temp);
						}
						option_proto_name = protos.sort();
						table3.setup();
					}
				},
				timeout:5000
			});
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "mia_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_mia_status").innerHTML = response.result.split("@@")[0];
					setTimeout("get_run_status();", 5000);
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_mia_status").innerHTML = "获取本地版本信息失败！";
					setTimeout("get_run_status();", 2000);
				}
			});
		}

		function calculate_max_node(){
			//--------------------------------------
			// count table1 line data nu
			var tmp_1 = [];
			var tmp_2 = [];
			for (var field in dbus) {
				a = field.split("mia_list_mac_");
				tmp_1.push(a);
			}
			
			for ( var i = 0; i < tmp_1.length; i++){
				if (tmp_1[i][0] == ""){
					tmp_2.push(tmp_1[i][1]);
				}
			}
			table1_node_nu = tmp_2.length;
			table1.setup();
			//--------------------------------------
			// count table2 line data nu
			var tmp_3 = [];
			var tmp_4 = [];
			for (var field in dbus) {
				a = field.split("mia_url_name_");
				tmp_3.push(a);
			}
			
			for ( var i = 0; i < tmp_1.length; i++){
				if (tmp_3[i][0] == ""){
					tmp_4.push(tmp_3[i][1]);
				}
			}
			table2_node_nu = tmp_4.length;
			table2.setup();
			//--------------------------------------
			// count table3 line data nu
			var tmp_5 = [];
			var tmp_6 = [];
			for (var field in dbus) {
				a = field.split("mia_proto_name_");
				tmp_5.push(a);
			}
			
			for ( var i = 0; i < tmp_1.length; i++){
				if (tmp_5[i][0] == ""){
					tmp_6.push(tmp_5[i][1]);
				}
			}
			table3_node_nu = tmp_6.length;
			get_protos_list();
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
			dbus["mia_enable"] = E("_mia_enable").checked ? "1" : "0";

			
			// collect data from table1
			var table1_conf = ["mia_list_enable_", "mia_list_start_", "mia_list_stop_", "mia_list_week_", "mia_list_mac_"];
			// mark all data for delete first
			for ( var i = 1; i <= table1_node_nu; i++){
				for ( var j = 0; j < table1_conf.length; ++j ) {
					dbus[table1_conf[j] + i ] = ""
				}
			}
			//now save table1 data to object dbus
			var data = table1.getAllData();
			if(data.length > 0){
				for ( var i = 0; i < data.length; ++i ) {
					for ( var j = 0; j < table1_conf.length; ++j ) {
						dbus[table1_conf[j] + (i + 1)] = data[i][j];
					}
				}
			}
			
			// ---------------------collect data from table2
			var table2_conf = ["mia_url_enable_", "mia_url_start_", "mia_url_stop_", "mia_url_mode_", "mia_url_mac_", "mia_url_name_"];
			// mark all data for delete first
			for ( var i = 1; i <= table2_node_nu; i++){
				for ( var j = 0; j < table2_conf.length; ++j ) {
					dbus[table2_conf[j] + i ] = ""
				}
			}
			//now save table2 data to object dbus
			var data2 = table2.getAllData();
			if(data2.length > 0){
				for ( var i = 0; i < data2.length; ++i ) {
					for ( var j = 0; j < table2_conf.length; ++j ) {
						dbus[table2_conf[j] + (i + 1)] = data2[i][j];
					}
				}
			}
			// -----------------------collect data from table2
			var table3_conf = ["mia_proto_enable_", "mia_proto_start_", "mia_proto_stop_", "mia_proto_mac_", "mia_proto_name_"];
			// mark all data for delete first
			for ( var i = 1; i <= table3_node_nu; i++){
				for ( var j = 0; j < table3_conf.length; ++j ) {
					dbus[table3_conf[j] + i ] = ""
				}
			}
			//now save table2 data to object dbus
			var data3 = table3.getAllData();
			if(data3.length > 0){
				for ( var i = 0; i < data3.length; ++i ) {
					for ( var j = 0; j < table3_conf.length; ++j ) {
						dbus[table3_conf[j] + (i + 1)] = data3[i][j];
					}
				}
			}
			
			postdata("mia_config.sh", dbus)
		}

		function postdata(script, obj){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[1], "fields": obj};
			dbus.mia_enable = E('_mia_enable').checked ? '1':'0';
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
		<div class="heading">家长控制<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				可以设置客户端禁止使用的时间、禁止访问的网址及禁止特定的协议
			</span>
		</div>
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="mia_switch_pannel" class="section" style="margin-top: -20px;"></div>
			<script type="text/javascript">
				$('#mia_switch_pannel').forms([
					{ title: '服务开关', name:'mia_enable',type:'checkbox',  value: dbus.mia_enable == 1 }  // ==1 means default close; !=0 means default open
				]);
			</script>
			<hr />
			<fieldset id="mia_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">运行状态</label>
				<div class="col-sm-9">
					<font id="_mia_status" name="_mia_status" color="#1bbf35">正在检查运行状态...</font>
				</div>
			</fieldset>
		</div>
	</div>
	<ul id="pbr_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" ><i class="icon-system"></i> 时间限制</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" ><i class="icon-globe"></i> 网址过滤</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab" ><i class="icon-hammer"></i> 协议过滤</a></li>
	</ul>
	<!-- ------------------ 表格1 --------------------- -->
	<div class="box boxr1" id="table_1" style="margin-top: 15px;">
		<div class="heading"></div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="table_1_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="url_readme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> MAC地址设置为ALL为全客户端限制 </li>
			<li> 开始时间设置为OFF为全天限制 </li>
	</div>
	</div>
	<!-- ------------------ 表格2 --------------------- -->
	<div class="box boxr2" id="table_2" style="margin-top: 15px;">
		<div class="heading"></div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="table_2_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="url_readme" class="box boxr2" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 关键词可以是taobao.com也可以是taobao </li>
			<li> MAC地址设置为ALL为全客户端过滤 </li>
			<li> 开始时间设置为OFF为全天限制</li>
			<li> 一般来说普通过滤效果就很好了，强制过滤会使用更复杂的算法导致更高的CPU占用</li>
	</div>
	</div>
	<!-- ------------------ 表格3 --------------------- -->
	<div class="box boxr3" id="table_3" style="margin-top: 15px;">
		<div class="heading"></div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="table_3_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="poro_readme" class="box boxr3" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> MAC地址设置为ALL为全客户端限制 </li>
			<li> 开始时间设置为OFF为全天限制 </li>
	</div>
	</div>
	<!-- ------------------ 其它 --------------------- -->
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存配置 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">刷新网页 <i class="icon-cancel"></i></button>
	<script type="text/javascript">init_wol();</script>
</content>
