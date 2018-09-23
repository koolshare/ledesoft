<title>签到狗2.0</title>
<content>
	<script type="text/javascript" src="/js/jquery.min.js"></script>
	<script type="text/javascript" src="/js/tomato.js"></script>
	<script type="text/javascript" src="/js/advancedtomato.js"></script>
	<style type="text/css">
		textarea {
			height: 6em;
		}
		/*Switch Icon Start*/
		.line-table tr td{
			overflow: hidden;
		    text-overflow: ellipsis;
		    white-space: nowrap;
		    max-width: 800px;
		}
	</style>
	<script type="text/javascript">
		var noChange = 0;
		var _responseLen;
		var dbus = {};
		var option_web_name = [
			['baidu', 'baidu'],
			['v2ex', 'v2ex'],
			['hostloc', 'hostloc'],
			['acfun', 'AcFun'],
			['bilibili', 'bilibili'],
			['smzdm', 'smzdm'],
			['163music', '163music'],
			['miui', 'miui'],
			['kafan', 'kafan'],
			['52pojie', '52pojie'],
			['zimuzu', 'zimuzu'],
			['gztown', 'gztown'],
			['meizu', 'meizu'],
			['hdpfans', 'hdpfans'],
			['chh', 'chh'],
			['koolshare', 'koolshare'],
			['huawei', 'huawei'],
			['jd', 'jd']
		];
		var table2_node_nu;
		var softcenter = 0;
		var option_cru_hour = [];
		for (var i = 0; i < 24; i++) {
			option_cru_hour[i] = [i, i + "时"];
		}
		
		// base64 support
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
					if (typeof(e) == "undefined") {
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
		var table2 = new TomatoGrid();

		table2.dataToView = function(data, i) {
			return [data[0], data[1]];
		}
		table2.resetNewEditor = function() {
			var f = fields.getAll(this.newEditor);
			ferror.clearAll(f);
			f[0].value = '';
			f[1].value = '';
		}
		table2.setup = function() {
			this.init('table_2_grid', '', 500, [
				{ type: 'select', size: 4, options: option_web_name, value: '' },
				{ type: 'text' }
			]);
			this.headerSet(['站点名称', 'Cookie']);
			for (var i = 1; i <= table2_node_nu; i++) {
				var t2 = [
					dbus["autocheckin_user_name_" + i],
					Base64.decode(dbus["autocheckin_user_cookie_" + i])
					]
				if (t2.length == 2) this.insertData(-1, t2);
			}
			this.showNewEditor();
			this.resetNewEditor();
		}

		function init_autocheckin() {
			get_dbus_data();
			tabSelect("app1");
			verifyFields();
			show_hide_panel();
			set_version();
			setTimeout("get_run_status();", 1000);
			$("#_qiandao_log").click(
				function() {
					x = -1;
			});
		}

		function set_version() {
			$('#_qiandao_version').html('<font color="#1bbf35">签到狗 V2.0</font>');
		}

		function calculate_max_node() {
			//--------------------------------------
			// count table3 line data nu
			var tmp_1 = [];
			var tmp_2 = [];
			for (var field in dbus) {
				a = field.split("autocheckin_user_name_");
				tmp_1.push(a);
			}
			console.log(tmp_1);

			for (var i = 0; i < tmp_1.length; i++) {
				if (tmp_1[i][0] == "") {
					tmp_2.push(tmp_1[i][1]);
				}
			}
			console.log(tmp_2);
			table2_node_nu = tmp_2.length;
			table2.setup();
		}

		function get_dbus_data() {
			$.ajax({
				type: "GET",
				url: "/_api/autocheckin_",
				dataType: "json",
				async: false,
				success: function(data) {
					dbus = data.result[0];
					//console.log(dbus);
					calculate_max_node();
					//get_wans_list();
					conf2obj();
				}
			});
		}

		function conf2obj() {
			E("_autocheckin_enable").checked = dbus["autocheckin_enable"] == 1 ? true : false;
			E("_autocheckin_hour").value = dbus["autocheckin_hour"];
		}

		function get_run_status() {
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {
				"id": id1,
				"method": "autocheckin_status.sh",
				"params": [2],
				"fields": ""
			};
			$.ajax({
				type: "POST",
				cache: false,
				url: "/_api/",
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response) {
					if (softcenter == 1) {
						return false;
					}
					document.getElementById("_autocheckin_status").innerHTML = response.result.split("@@")[0];
					verifyFields();
					setTimeout("get_run_status();", 2000);
				},
				error: function() {
					if (softcenter == 1) {
						return false;
					}
					document.getElementById("_autocheckin_status").innerHTML = "获取本地版本信息失败！";
					setTimeout("get_run_status();", 2000);
				}
			});
		}

		function tabSelect(obj) {
			var tableX = ['app1-tab', 'app2-tab', 'app3-tab'];
			var boxX = ['boxr1', 'boxr2', 'boxr3'];
			var appX = ['app1', 'app2', 'app3'];
			for (var i = 0; i < tableX.length; i++) {
				if (obj == appX[i]) {
					$('#' + tableX[i]).addClass('active');
					$('.' + boxX[i]).show();
				} else {
					$('#' + tableX[i]).removeClass('active');
					$('.' + boxX[i]).hide();
				}
			}
			if(obj=='app3' ){
				setTimeout("get_log();");
				elem.display('save-button', false);
//				elem.display('cancel-button', false);
//				reload = 1;
			}else{
				elem.display('save-button', true);
//				elem.display('cancel-button', true);
			}			
			if (obj == 'fuckapp') {
				elem.display('qiandao_status_pannel', false);
				elem.display('pbr_tabs', false);
				elem.display('pbr_basic_readme', false);
				elem.display('_qiandao_settings', false);
				elem.display('identification', false);
				elem.display('table_2', false);
				elem.display('qiandao_log_tab', false);
				E('save-button').style.display = "";
			}
		}

		function show_hide_panel() {
			var a = E('_autocheckin_enable').checked;
			elem.display('qiandao_status_pannel', a);
			elem.display('pbr_tabs', a);
			elem.display('_qiandao_settings', a);
			elem.display('identification', a);
			elem.display('pbr_basic_readme', a);
		}

		function verifyFields(r) {
			// when check/uncheck qiandao_switch
			var a = E('_autocheckin_enable').checked;
			if ($(r).attr("id") == "_autocheckin_enable") {
				if (a) {
					$("#save-button").html("提交")
					elem.display('qiandao_status_pannel', a);
					elem.display('pbr_tabs', a);
					elem.display('identification', a);
					elem.display('_qiandao_settings', a);
					elem.display('pbr_basic_readme', a);
					tabSelect('app1')
				} else {
					$("#save-button").html("停止")
					tabSelect('fuckapp')
				}
			}
			return true;
		}

		function toggleVisibility(whichone) {
			if (E('sesdiv' + whichone).style.display == '') {
				E('sesdiv' + whichone).style.display = 'none';
				E('sesdiv' + whichone + 'showhide').innerHTML = '<i class="icon-chevron-up"></i>';
				cookie.set('adv_dhcpdns_' + whichone + '_vis', 0);
			} else {
				E('sesdiv' + whichone).style.display = '';
				E('sesdiv' + whichone + 'showhide').innerHTML = '<i class="icon-chevron-down"></i>';
				cookie.set('adv_dhcpdns_' + whichone + '_vis', 1);
			}
		}

		function showMsg(Outtype, title, msg) {
			$('#' + Outtype).html('<h5>' + title + '</h5>' + msg + '<a class="close"><i class="icon-cancel"></i></a>');
			$('#' + Outtype).show();
		}

		function save() {
			// collect normal dataToView
			if(!E("_autocheckin_hour").value){
				alert("你尚未设置签到时间！");
				return false;
			}
			dbus["autocheckin_enable"] = E("_autocheckin_enable").checked ? "1" : "0";
			dbus["autocheckin_hour"] = E("_autocheckin_hour").value;

			// collect data from table2
			var table2_conf = ["autocheckin_user_name_", "autocheckin_user_cookie_"];
			// mark all data for delete first
			for (var i = 1; i <= table2_node_nu; i++) {
				for (var j = 0; j < table2_conf.length; ++j) {
					dbus[table2_conf[j] + i] = ""
				}
			}
			//now save table2 data to object dbus
			var data = table2.getAllData();
			console.log(data);
			if (data.length > 0) {
				for (var i = 0; i < data.length; ++i) {
					dbus[table2_conf[0] + (i + 1)] = data[i][0];
					for (var j = 1; j < table2_conf.length; ++j) {
						dbus[table2_conf[j] + (i + 1)] = Base64.encode(data[i][j]);
					}
				}
			}else{
				alert("你尚未定义任何cookie！");
				//return false;
			}
			// now post data
			postdata("autocheckin_config.sh", dbus)
		}

		function qiandao_now(arg){
			if (arg == 5){
				shellscript = 'autocheckin_config.sh';
			}
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": shellscript, "params":[6], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async: true,
				cache:false,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function(response){
					if(response.result == id){
						tabSelect("app3");
						setTimeout("window.location.reload()", 10000);
						return true;
					}
				}
			});
			reload = 1;			
		}	
		
		function postdata(script, obj) {
			var id = parseInt(Math.random() * 100000000);
			var postData = {
				"id": id,
				"method": script,
				"params": [1],
				"fields": obj
			};
			dbus.autocheckin_enable = E('_autocheckin_enable').checked ? '1' : '0';
			showMsg("msg_warring", "正在提交数据！", "<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				type: "POST",
				async: true,
				cache: false,
				dataType: "json",
				data: JSON.stringify(postData),
				success: function(response) {
					if (response.result == id) {
						tabSelect("app3");
					} else {
						$('#msg_warring').hide();
						showMsg("msg_error", "提交失败", "<b>提交数据失败！错误代码：" + response.result + "</b>");
					}
				},
				error: function() {
					showMsg("msg_error", "失败", "<b>当前系统存在异常查看系统日志！</b>");
					status_time = 1;
				}
			});
			reload = 1;
		}
		
		function get_log(){
			$.ajax({
				url: '/_temp/qiandao_log.txt',
				type: 'GET',
				cache:false,
				dataType: 'text',
				success: function(response) {
					var retArea = E("_qiandao_log");
					if (response.search("XU6J03M6") != -1) {
						retArea.value = response.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						if (reload == 1){
							setTimeout("window.location.reload()", 2000);
						}else{
							return true;
						}
					}
					if (_responseLen == response.length) {
						noChange++;
					} else {
						noChange = 0;
					}
					if (noChange > 1000) {
						tabSelect("app1");
						return false;
					} else {
						setTimeout("get_log();", 200);
					}
					retArea.value = response.replace("XU6J03M6", " ");
					retArea.scrollTop = retArea.scrollHeight;
					_responseLen = response.length;
				},
				error: function() {
					E("_qiandao_log").value = "获取日志失败！";
					return false;
				}
			});
		}		

		function join_qq(){
			window.open("https://jq.qq.com/?_wv=1027&k=5RiTrKC");
		}		
		
	</script>
	<div class="box">
		<div class="heading">
			<span id="_qiandao_version"></span>
			<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
			<a href="http://koolshare.cn/thread-127783-1-1.html" target="_blank" class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">配置教程</a>
		</div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
				每日签到，张大妈笑哈哈！这也是一款全新的签到插件，谁用谁知道，(￣▽￣)"！
			</span>
		</div>	
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="qiandao_switch_pannel" class="section" style="margin-top: -20px;"></div>
			<script type="text/javascript">
				$('#qiandao_switch_pannel').forms([
					{ title: '开启自动签到', name:'autocheckin_enable',type:'checkbox',value: "" }
				]);
			</script>
			<hr />
			<fieldset id="qiandao_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">运行状态</label>
				<div class="col-sm-9" style="margin-top:2px">
					<font id="_autocheckin_status" name="autocheckin_status" color="#1bbf35">正在检查运行状态...</font>
				</div>
			</fieldset>
		</div>
	</div>	
	<!-- ------------------ 标签页 --------------------- -->
	<ul id="pbr_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" ><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" ><i class="icon-globe"></i> 站点选择</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab" ><i class="icon-info"></i> 运行日志</a></li>
	</ul>
	<div class="box boxr1" id="_qiandao_settings" style="margin-top: 15px;">
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					//{ title: '开启自动签到', name:'autocheckin_enable',type:'checkbox',value: "" },
					//{ title: '运行状态', text: '<font id="_autocheckin_status" name=_autocheckin_status color="#1bbf35">正在检查运行状态...</font>' },
					{ title: '签到时间', name: 'autocheckin_hour', type: 'select', options: option_cru_hour, value: "" },
					{ title: '一键签到', suffix: '<button id="qiandao_now" onclick="qiandao_now(5);" class="btn btn-success">一键签到 <i class="icon-cloud"></i></button>'},
					{ title: '交流反馈', suffix: '<button id="join_qq" onclick="join_qq();" class="btn btn-danger">加入QQ群 <i class="icon-tools"></li></button>'}
				]);
			</script>
		</div>
	</div>
	<div id="pbr_basic_readme" class="box boxr1" style="margin-top: 15px;">
	<div class="heading">自动签到说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:">
			<li> 为了避免每天自动签到的时间一样，自动任务将在设置的时间1-30分钟分钟内随机执行。</li>
			<li> 支持同一个站点多个账号进行同时签到。</li>
			<li><font color="red"> 注意！保存自己的Cookie，防止泄露出去。</font></li>
			<li><font color="red"> Cookie是有时效性的，需重新获取Cookie。</font></li>
	</div>
	</div>
	<!-- ------------------ 表格2--------------------- -->
	<div class="box boxr2" id="table_2" style="margin-top: 15px;">
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="table_2_grid">
				</table>
			</div>
		</div>
	</div>
	<!-- ------------------ 查看日志 --------------------- -->
	<div class="box boxr3" id="qiandao_log_tab" style="margin-top: 0px;">
		<div id="qiandao_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#qiandao_log_pannel').append('<textarea class="as-script" name="qiandao_log" id="_qiandao_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
		</div>
	</div>	
	<!-- ------------------ 其它 --------------------- -->
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">提交 <i class="icon-check"></i></button>
	<script type="text/javascript">init_autocheckin();</script>
</content>
