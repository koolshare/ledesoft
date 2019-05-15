<title>软件中心-瑞士军刀</title>
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
		get_dbus_data();
		var table3_node_nu;
		var softcenter = 0;
		var _responseLen;
		var noChange = 0;
		var status_time = 1;
		var option_ipv = [['0', 'IPV4 - TCP'],['1', 'IPV4 - UDP'],['2', 'IPV6 - TCP'],['3', 'IPV6 - UDP']];
		var option_ipv_name = ['IPV4 - TCP', 'IPV4 - UDP', 'IPV6 - TCP', 'IPV6 - UDP'];
		//============================================
		var table3 = new TomatoGrid();
		table3.dataToView = function(data) {
			return [option_ipv_name[data[0]], data[1], data[2], data[3]];
		}
		table3.fieldValuesToData = function( row ) {
			var f = fields.getAll( row );
			if (f[0].value){
				return [f[0].value, f[1].value, f[2].value, f[3].value];
			}else{
				if (f[1].value){
					return [f[1].value, f[1].value, f[2].value, f[3].value];
				}else{
					if (f[2].value){
						return [f[2].value, f[1].value, f[2].value, f[3].value];
					}
				}
			}
		}
    	table3.onChange = function(which, cell) {
    	    return this.verifyFields((which == 'new') ? this.newEditor: this.editor, true, cell);
    	}
		table3.onAdd = function() {
			var data;
			this.moving = null;
			this.rpHide();
			if (!this.verifyFields(this.newEditor, false)) return;
			data = this.fieldValuesToData(this.newEditor);
			this.insertData(1, data);
			this.disableNewEditor(false);
			this.resetNewEditor();
		}
		table3.rpDel = function(b) {
			b = PR(b);
			TGO(b).moving = null;
			b.parentNode.removeChild(b);
			this.recolor();
			this.rpHide()
		}
		table3.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value  = '';
			f[ 1 ].value  = '';
			f[ 2 ].value  = '';
			f[ 3 ].value  = '';
		}
		table3.footerSet = function(c, b) {
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
		table3.dataToFieldValues = function (data) {
			return [data[0], data[1], data[2], data[3], data[4]];
		}
		table3.setup = function() {
			this.init( 'table_3_grid', '', 100, [
				{ type: 'select',maxlen:5, options:option_ipv},
				{ type: 'text',maxlen:5},
				{ type: 'text',maxlen:128},
				{ type: 'text',maxlen:5}
			] );
			this.headerSet( [ '协议类型', '路由上的本地端口', '远程服务器IP或要映射的内网IP', '远程服务器端口或要映射的内网端口' ] );
			for ( var i = 1; i <= dbus["relay_node_max"]; i++){
				var t2 = [ 
							dbus["relay_list_localipv_" + i ], 
							dbus["relay_list_localport_" + i ], 
							dbus["relay_list_remoteip_" + i ], 
							dbus["relay_list_remoteport_" + i ]
						]
				if ( t2.length == 4 ) this.insertData( -1, t2);
			}
			this.recolor();
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		function init_relay(){
			get_dbus_data();
			table3.setup();
			verifyFields();
			set_version();
			setTimeout("get_run_status();", 1000);
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
			 	url: "/_api/relay_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}

		function get_run_status(){
			if (status_time > 99999){
				E("_relay_status").innerHTML = "暂停获取状态...";
				return false;
			}
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "relay_status.sh", "params":[2], "fields": ""};
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
						E("_relay_status").innerHTML = "获取运行状态失败！";
						setTimeout("get_run_status();", 5000);
					}else{
						E("_relay_status").innerHTML = response.result.split("@@")[0];
						setTimeout("get_run_status();", 5000);
					}
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_relay_status").innerHTML = "获取运行状态失败！";
					setTimeout("get_run_status();", 5000);
				}
			});
		}

		function set_version(){
			$('#_relay_version').html( '<font color="#1bbf35">瑞士军刀 ' + (dbus["relay_version"]  || "") + '</font></a>' );
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
			//get_run_status();
			E("_relay_status").innerHTML = "提交中...暂停获取状态！";
			// collect data from checkbox
			dbus["relay_basic_enable"] = E("_relay_basic_enable").checked ? '1':'0';
			
			// collect data from table3
			var table3_conf = ["relay_list_localipv_", "relay_list_localport_", "relay_list_remoteip_", "relay_list_remoteport_"];
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
						dbus[table3_conf[0] + (i + 1)] = data[i][0];
						dbus[table3_conf[j] + (i + 1)] = data[i][j];
					}
				}
				dbus["relay_node_max"] = data.length;
			}else{
				dbus["relay_node_max"] = "";
			}
			// now post data
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "relay_config.sh", "params":[1], "fields": dbus};
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
						if(E('_relay_basic_enable').checked){
							showMsg("msg_success","提交成功","<b>relay成功提交数据</b>");
							$('#msg_warring').hide();
							setTimeout("$('#msg_success').hide()", 500);
							x = 4;
							count_down_switch();
						}else{
							// when shut down ss finished, close the log tab
							$('#msg_warring').hide();
							showMsg("msg_success","提交成功","<b>relay成功关闭！</b>");
							setTimeout("$('#msg_success').hide()", 4000);
							setTimeout("window.location.reload()", 500);
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

	</script>
	<div class="box">
		<div class="heading">
			<span id="_relay_version"></span>
			<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
		</div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				简单方便的设置端口映射，或将你的软路由当做远程服务器的中继器，优化网络连接质量或者隐藏远程服务器IP
			</span>
		</div>	
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="relay_switch_pannel" class="section" style="margin-top: -20px;"></div>
			<script type="text/javascript">
				$('#relay_switch_pannel').forms([
					{ title: '服务开关', name:'relay_basic_enable',type:'checkbox',  value: dbus.relay_basic_enable == 1 }  // ==1 means default close; !=0 means default open
				]);
			</script>
			<hr />
			<fieldset id="relay_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">运行状态</label>
				<div class="col-sm-9">
					<font id="_relay_status" name="_relay_status" color="#1bbf35">正在检查运行状态...</font>
				</div>
			</fieldset>
		</div>
	</div>
	<!-- ------------------ 表格1 --------------------- -->
	<div class="box boxr1" id="table_3" style="margin-top: 15px;">
		<div class="heading"></div>
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
			<li> 请不要和路由上已经开启的端口冲突，否则运行失败</li>
			<li> 协议类型只针对本地路由开放的端口，远程IP可以是IPV4或者IPV6，插件会自动识别</li>
			<li> 可以将路由当作远程IPV4或IPV6(路由必须有IPV6连接)服务器的中转站</li>
			<li> 可以将路由上的端口映射到局域网或者路由自身的其它端口，相当于防火墙的端口映射功能</li>
	</div>
	</div>
	</div>
	<!-- ------------------ 其它 --------------------- -->
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">提交 <i class="icon-check"></i></button>
	<script type="text/javascript">init_relay();</script>
</content>
