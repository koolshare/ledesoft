<title>什么值得买-自动签到</title>
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
		var table2 = new TomatoGrid();
		var option_cru_hour = [];
    for(var i = 0; i < 24; i++){
      option_cru_hour[i] = [i, i + "时"];
    }
	
		table2.dataToView = function(data, i) {
			return [ data[0], data[1] ];
		}
		table2.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return true;
		}
		table2.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value  = '';
			f[ 1 ].value  = '';
		}
		table2.setup = function() {
			this.init( 'table_2_grid', '', 500, [
				{ type: 'text'},
				{ type: 'text'}
			] );
			this.headerSet( [ '用户名', '密码' ] );
			for ( var i = 1; i <= table2_node_nu; i++){
				var t2 = [ dbus["smzdm_user_name_" + i ], dbus["smzdm_user_passwd_" + i ]]
				if ( t2.length == 2 ) this.insertData( -1, t2);
			}
			this.showNewEditor();
			this.resetNewEditor();
		}

		function init_smzdm(){
			get_dbus_data();
			tabSelect("app1");
			setTimeout("get_run_status();", 1000);
		}

		function calculate_max_node(){
			//--------------------------------------
			// count table3 line data nu
			var tmp_1 = [];
			var tmp_2 = [];
			for (var field in dbus) {
				a = field.split("smzdm_user_name_");
				tmp_1.push(a);
			}
			
			for ( var i = 0; i < tmp_1.length; i++){
				if (tmp_1[i][0] == ""){
					tmp_2.push(tmp_1[i][1]);
				}
			}
			table2_node_nu = tmp_2.length;
			table2.setup();
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/smzdm_",
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
			E("_smzdm_enable").checked = dbus["smzdm_enable"] == 1 ? true : false;
			E("_smzdm_hour").value = dbus["smzdm_hour"];
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "smzdm_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_smzdm_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
					setTimeout("get_run_status();", 2000);
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_smzdm_status").innerHTML = "获取本地版本信息失败！";
					setTimeout("get_run_status();", 2000);
				}
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
			dbus["smzdm_enable"] = E("_smzdm_enable").checked ? "1" : "0";
			dbus["smzdm_hour"] = E("_smzdm_hour").value;

			// collect data from table2
			var table2_conf = ["smzdm_user_name_", "smzdm_user_passwd_"];
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
			// now post data
			postdata("smzdm_config.sh", dbus)
		}

		function postdata(script, obj){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": script, "params":[1], "fields": obj};
			dbus.smzdm_enable = E('_smzdm_enable').checked ? '1':'0';
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
		<div class="heading">什么值得买<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				每日签到，张大妈笑哈哈！
			</span>
		</div>	
	</div>
	<!-- ------------------ 标签页 --------------------- -->
	<ul id="pbr_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" ><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" ><i class="icon-globe"></i> 账号密码</a></li>
	</ul>
	<div class="box boxr1" style="margin-top: 15px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '开启自动签到', name:'smzdm_enable',type:'checkbox',value: "" },
					{ title: '运行状态', text: '<font id="_smzdm_status" name=_smzdm_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '自动签到时间', name: 'smzdm_hour', type: 'select', options: option_cru_hour, value: ""}
				]);
			</script>
		</div>
		</div>
	<div id="pbr_basic_readme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">自动签到说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 为了避免每天自动签到的时间一样，自动任务将在设置的时间1-30分钟分钟内随机执行。</li>	
	</div>
	</div>
	<!-- ------------------ 表格2--------------------- -->
	<div class="box boxr2" id="table_2" style="margin-top: 15px;">
		<div class="heading">账户密码</div>
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
	<script type="text/javascript">init_smzdm();</script>
</content>
