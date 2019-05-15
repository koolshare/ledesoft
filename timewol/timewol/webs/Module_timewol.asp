<title>软件中心 - 定时唤醒</title>
<content>
	<script type="text/javascript" src="/js/jquery.min.js"></script>
	<script type="text/javascript" src="/js/tomato.js"></script>
	<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbus = {};
		var table1_node_nu;
		var softcenter = 0;
		var option_day_time = [];
		var option_hour_time = [];
		var option_minute_time = [];
		var option_day_time = [["7", "每天"], ["1", "周一"], ["2", "周二"], ["3", "周三"], ["4", "周四"], ["5", "周五"], ["6", "周六"], ["0", "周日"]];
		for(var i = 0; i < 24; i++){
			option_hour_time[i] = [i, i + "点"];
		}
		for(var i = 0; i < 60; i++){
			option_minute_time[i] = [i, i + "分"];
		}
		//============================================
		var table1 = new TomatoGrid();
		table1.dataToView = function(data, i) {
			return [ data[0], data[1] , data[2] , data[3] ];
		}
		table1.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table1.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value  = '0';
			f[ 1 ].value  = '0';
			f[ 2 ].value  = '7';
			f[ 3 ].value  = '';
		}
		table1.setup = function() {
			this.init( 'table_1_grid', '', 500, [
				{ type: 'select', options:option_hour_time, value:'' },
				{ type: 'select', options:option_minute_time, value:'' },
				{ type: 'select', options:option_day_time, value:'' },
				{ type: 'text' }
			] );
			this.headerSet( [ '小时', '分钟', '星期', '客户端MAC地址' ] );
			for ( var i = 1; i <= table1_node_nu; i++){
				var t2 = [ 
					dbus["timewol_list_h_" + i ],
					dbus["timewol_list_m_" + i ],
					dbus["timewol_list_w_" + i ],
					dbus["timewol_list_mac_" + i ]			
					]
				if ( t2.length == 4 ) this.insertData( -1, t2);
			}
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================

		function init_wol(){
			get_dbus_data();
			setTimeout("get_run_status();", 1000);
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/timewol_",
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
			E("_timewol_enable").checked = dbus["timewol_enable"] == 1 ? true : false;
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "timewol_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_timewol_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_timewol_status").innerHTML = "获取本地版本信息失败！";
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
				a = field.split("timewol_list_mac_");
				tmp_1.push(a);
			}
			
			for ( var i = 0; i < tmp_1.length; i++){
				if (tmp_1[i][0] == ""){
					tmp_2.push(tmp_1[i][1]);
				}
			}
			table1_node_nu = tmp_2.length;
			table1.setup();
			//console.log("table1_node_nu", table1_node_nu);			
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
			dbus["timewol_enable"] = E("_timewol_enable").checked ? "1" : "0";

			
			// collect data from table1
			var table1_conf = ["timewol_list_h_", "timewol_list_m_", "timewol_list_w_", "timewol_list_mac_"];
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
			
			postdata("timewol_config.sh", dbus)
		}

		function postdata(script, obj){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[1], "fields": obj};
			dbus.timewol_enable = E('_timewol_enable').checked ? '1':'0';
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

		function allwol(){
			// disable update botton when in update progress
			var id2 = parseInt(Math.random() * 100000000);
			var postData2 = {"id": id2, "method": "timewol_config.sh", "params":[1], "fields": dbus};
			showMsg("msg_warring","正在提交数据！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				cache:false,
				type: "POST",
				dataType: "json",
				data: JSON.stringify(postData2),
				success: function(response){
					if (response.result == id2){
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
		<div class="heading">定时唤醒<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				利用计划任务实现设备在指定的时间开启。
			</span>
		</div>
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="timewol_switch_pannel" class="section" style="margin-top: -20px;"></div>
			<script type="text/javascript">
				$('#timewol_switch_pannel').forms([
					{ title: '服务开关', name:'timewol_enable',type:'checkbox',  value: dbus.timewol_enable == 1 }  // ==1 means default close; !=0 means default open
				]);
			</script>
			<hr />
			<fieldset id="timewol_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">运行状态</label>
				<div class="col-sm-9">
					<font id="_timewol_status" name="_timewol_status" color="#1bbf35">正在检查运行状态...</font>
				</div>
			</fieldset>
		</div>
	</div>
	<div class="box boxr1" id="table_1" style="margin-top: 15px;">
		<div class="heading"></div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="table_1_grid">
				</table>
			</div>
		</div>
	</div>
	<div id="pbr_userreadme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">设置说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 被唤醒的设备需要连接电源且支持网卡唤醒 </li>
	</div>
	</div>
	<!-- ------------------ 其它 --------------------- -->
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存配置 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="allwol();" class="btn">立即唤醒列表设备 <i class="icon-cancel"></i></button>
	<script type="text/javascript">init_wol();</script>
</content>
