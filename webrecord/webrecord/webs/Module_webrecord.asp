<title>软件中心 - 上网记录</title>
<content>
	<script type="text/javascript" src="/js/jquery.min.js"></script>
	<script type="text/javascript" src="/js/tomato.js"></script>
	<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<script type="text/javascript">
		var dbus = {};
		var softcenter = 0;
		var _responseLenurl;
		var _responseLenseach;
		//============================================

		function init_wol(){
			tabSelect("app1");
			get_dbus_data();
			setTimeout("get_run_status();", 1000);
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/webrecord_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			 	 	//console.log(dbus);
			 	 	conf2obj();
			  	}
			});
		}

		function conf2obj(){
			E("_webrecord_enable").checked = dbus["webrecord_enable"] == 1 ? true : false;
		}

		function get_run_status(){
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "webrecord_status.sh", "params":[2], "fields": ""};
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
					document.getElementById("_webrecord_status").innerHTML = response.result.split("@@")[0];
					get_url_log();
					verifyFields();
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					document.getElementById("_webrecord_status").innerHTML = "获取本地版本信息失败！";
					setTimeout("get_run_status();", 2000);
				}
			});
		}

		function verifyFields(r){
			return true;
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
			if(obj=='app1'){
				noChange=0;
				setTimeout("get_url_log();", 200);
			}else{
				noChange=0;
				setTimeout("get_seach_log();", 200);
			}
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
			dbus["webrecord_enable"] = E("_webrecord_enable").checked ? "1":"0";
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "webrecord_config.sh", "params":[1], "fields": dbus};
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

		function get_url_log(){
			$.ajax({
				url: '/_temp/webrecord_url_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(responseurl) {
					var retArea = E("_url_basic_log");
					if (responseurl.search("XU6J03M6") != -1) {
						retArea.value = responseurl.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						return true;
					}
					if (_responseLenurl == responseurl.length) {
						noChange++;
					} else {
						noChange = 0;
					}
					if (noChange > 2000) {
						//tabSelect("app1");
						return true;
					} else {
						setTimeout("get_url_log();", 100); //100 is radical but smooth!
					}
					retArea.value = responseurl;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLenurl = responseurl.length;
				},
				error: function() {
					E("_url_basic_log").value = "获取日志失败！";
				}
			});
		}

		function get_seach_log(){
			$.ajax({
				url: '/_temp/webrecord_seach_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(responseseach) {
					var retArea = E("_seach_basic_log");
					if (responseseach.search("XU6J03M6") != -1) {
						retArea.value = responseseach.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						return true;
					}
					if (_responseLenseach == responseseach.length) {
						noChange++;
					} else {
						noChange = 0;
					}
					if (noChange > 2000) {
						//tabSelect("app1");
						return true;
					} else {
						setTimeout("get_seach_log();", 100); //100 is radical but smooth!
					}
					retArea.value = responseseach;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLenseach = responseseach.length;
				},
				error: function() {
					E("_seach_basic_log").value = "获取日志失败！";
				}
			});
		}

	</script>
	<div class="box">
		<div class="heading">上网记录<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				开启后可以查看客户端网址和搜索记录，只能查看http网站记录
			</span>
		</div>
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="webrecord_switch_pannel" class="section" style="margin-top: -20px;"></div>
			<script type="text/javascript">
				$('#webrecord_switch_pannel').forms([
					{ title: '服务开关', name:'webrecord_enable',type:'checkbox',  value: dbus.webrecord_enable == 1 }  // ==1 means default close; !=0 means default open
				]);
			</script>
			<hr />
			<fieldset id="webrecord_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">运行状态</label>
				<div class="col-sm-9">
					<font id="_webrecord_status" name="_webrecord_status" color="#1bbf35">正在检查运行状态...</font>
				</div>
			</fieldset>
		</div>
	</div>
	<ul id="pbr_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" ><i class="icon-system"></i> 网址记录</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" ><i class="icon-globe"></i> 搜索记录</a></li>
	</ul>
	<!-- ------------------ 表格1 --------------------- -->
	<div class="box boxr1" id="url_log_tab" style="margin-top: 0px;">
		<div id="url_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.45);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#url_log_pannel').append('<textarea class="as-script" name="_url_basic_log" id="_url_basic_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
		</div>
	</div>
	<!-- ------------------ 表格2 --------------------- -->
	<div class="box boxr2" id="seach_log_tab" style="margin-top: 0px;">
		<div id="seach_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.45);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#seach_log_pannel').append('<textarea class="as-script" name="_seach_basic_log" id="_seach_basic_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
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
