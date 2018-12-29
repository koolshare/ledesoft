<title>Docker</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
.box, #docker_tabs {
	min-width:720px;
}
</style>
	<script type="text/javascript">
		var dbus;
		get_dbus_data();
		get_table_list();
		var softcenter = 0;
		var _responseLen;
		var noChange = 0;
		var x = 4;
		var status_time = 1;
		var image = {};

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
		function createFormFields(data, settings) {
			var id, id1, common, output, form = '';
			var s = $.extend({
					// Defaults
					'align': 'left',
					'grid': ['col-sm-3', 'col-sm-9']
				},
				settings);
			// Loop through array
			$.each(data,
				function(key, v) {
					if (!v) {
						form += '<br />';
						return;
					}
					if (v.ignore) return;
					form += '<fieldset' + ((v.rid) ? ' id="' + v.rid + '"' : '') + ((v.hidden) ? ' style="display: none;"' : '') + '>';
					if (v.help) {
						v.title += ' (<i data-toggle="tooltip" class="icon-info icon-normal" title="' + v.help + '"></i>)';
					}
					if (v.text) {
						if (v.title) {
							form += '<label class="' + s.grid[0] + ' ' + ((s.align == 'center') ? 'control-label' : 'control-left-label') + '">' + v.title + '</label><div class="' + s.grid[1] + ' text-block">' + v.text + '</div></fieldset>';
						} else {
							form += '<label class="' + s.grid[0] + ' ' + ((s.align == 'center') ? 'control-label' : 'control-left-label') + '">' + v.text + '</label></fieldset>';
						}
						return;
					}
					if (v.multi) multiornot = v.multi;
					else multiornot = [v];
					output = '';
					$.each(multiornot,
						function(key, f) {
							if ((f.type == 'radio') && (!f.id)) id = '_' + f.name + '_' + i;
							else id = (f.id ? f.id : ('_' + f.name));
							if (id1 == '') id1 = id;
							common = ' onchange="verifyFields(this, 1)" id="' + id + '"';
							if (f.size > 65) common += ' style="width: 100%; display: block;"';
							if (f.hidden) common += ' style="display:none;"'; //add by sadog
							if (f.attrib) common += ' ' + f.attrib;
							name = f.name ? (' name="' + f.name + '"') : '';
							// Prefix
							if (f.prefix) output += f.prefix;
							switch (f.type) {
								case 'checkbox':
									output += '<div class="checkbox c-checkbox"><label><input class="custom" type="checkbox"' + name + (f.value ? ' checked' : '') + ' onclick="verifyFields(this, 1)"' + common + '>\
		<span></span> ' + (f.suffix ? f.suffix : '') + '</label></div>';
									break;
								case 'radio':
									output += '<div class="radio c-radio"><label><input class="custom" type="radio"' + name + (f.value ? ' checked' : '') + ' onclick="verifyFields(this, 1)"' + common + '>\
		<span></span> ' + (f.suffix ? f.suffix : '') + '</label></div>';
									break;
								case 'password':
									if (f.peekaboo) {
										switch (get_config('web_pb', '1')) {
											case '0':
												f.type = 'text';
											case '2':
												f.peekaboo = 0;
												break;
										}
									}
									if (f.type == 'password') {
										common += ' autocomplete="off"';
										if (f.peekaboo) common += ' onfocus=\'peekaboo("' + id + '",1)\' onclick=\'this.removeAttribute(' + 'readonly' + ');\' readonly="true"';
									}
									// drop
								case 'text':
									output += '<input type="' + f.type + '"' + name + ' value="' + escapeHTML(UT(f.value)) + '" maxlength=' + f.maxlen + (f.size ? (' size=' + f.size) : '') + (f.style ? (' style=' + f.style) : '') + (f.onblur ? (' onblur=' + f.onblur) : '') + common + '>';
									break;
								case 'select':
									output += '<select' + name + (f.style ? (' style=' + f.style) : '') + common + '>';
									for (optsCount = 0; optsCount < f.options.length; ++optsCount) {
										a = f.options[optsCount];
										if (a.length == 1) a.push(a[0]);
										output += '<option value="' + a[0] + '"' + ((a[0] == f.value) ? ' selected' : '') + '>' + a[1] + '</option>';
									}
									output += '</select>';
									break;
								case 'textarea':
									output += '<textarea ' + 'spellcheck=\"false\"' + (f.style ? (' style="' + f.style + '" ') : '') + name + common + (f.wrap ? (' wrap=' + f.wrap) : '') + '>' + escapeHTML(UT(f.value)) + '</textarea>';
									break;
								default:
									if (f.custom) output += f.custom;
									break;
							}
							if (f.suffix && (f.type != 'checkbox' && f.type != 'radio')) output += '<span class="help-block">' + f.suffix + '</span>';
						});
					if (id1 != '') form += '<label class="' + s.grid[0] + ' ' + ((s.align == 'center') ? 'control-label' : 'control-left-label') + '" for="' + id + '">' + v.title + '</label><div class="' + s.grid[1] + '">' + output;
					else form += '<label>' + v.title + '</label>';
					form += '</div></fieldset>';
				});
			return form;
		}
		//============================================
		var search_info
		var seach = new TomatoGrid();
		seach.dataToView = function(data) {
			return [ data[0], data[1], data[2], data[3]];
		}
		
		seach.populate = function(){
			if(search_info){
				search_info = Base64.decode(search_info);
				search_info = search_info.split("<")
				for ( var i = 1; i < search_info.length; ++i ) {
					this.insertData( -1, [
					search_info[i].split(">")[0] || "", 
					search_info[i].split(">")[1] || "", 
					search_info[i].split(">")[2] || "", 
					'<button id="_download_images_now" onclick="manipulate_conf(\'docker_config.sh\', 4, \'' + search_info[i].split(">")[0] + '\' );" class="btn btn-success">下载 <i class="icon-cloud"></i></button>'
					] );
				}
			}
		}
		seach.setup = function() {
			this.init( 'seach-grid', 'sort' [
				{ type: 'text'},
				{ type: 'text'},
				{ type: 'text'},
				{ type: 'text'}
			]);
			this.headerSet( [ '镜像名称', '描述', '收藏数', '操作' ] );
			this.populate();
			//this.sort( 1 );
		}
		//============================================
		var images_info
		var images = new TomatoGrid();
		images.dataToView = function(data) {
			return [ data[0], data[1], data[2], data[3] ];
		}
		
		images.populatei = function(){
			if(images_info){
				images_info = images_info.split("<")
				for ( var i = 1; i < images_info.length; ++i ) {
					this.insertData( -1, [
					images_info[i].split(">")[0] || "", 
					images_info[i].split(">")[1] || "", 
					images_info[i].split(">")[2] || "", 
					'<button id="_run_images_now" onclick="manipulate_conf(\'docker_config.sh\', 5, \'' + images_info[i].split(">")[0] + '\' );" class="btn btn-success">创建 <i class="icon-plus"></i></button>&nbsp;&nbsp;<button id="_del_images_now" onclick="manipulate_conf(\'docker_config.sh\', 6, \'' + images_info[i].split(">")[0] + '\' );" class="btn btn">删除 <i class="icon-cancel"></i></button>'
					] );
				}
			}
		}
		images.setup = function() {
			this.init( 'images-grid', 'sort' [
				{ type: 'text'},
				{ type: 'text'},
				{ type: 'text'},
				{ type: 'text'}
			]);
			this.headerSet( [ '镜像名称', '标签', '镜像大小', '操作' ] );
			this.populatei();
			//this.sort( 1 );
		}
		//============================================
		var container_info
		var container = new TomatoGrid();
		container.dataToView = function(data) {
			return [ data[0], data[1], data[2], data[3] ];
		}
		
		container.populatec = function(){
			if(container_info){
				container_info = container_info.split("<")
				for ( var i = 1; i < container_info.length; ++i ) {
					this.insertData( -1, [
					container_info[i].split(">")[0] || "", 
					container_info[i].split(">")[1] || "", 
					container_info[i].split(">")[2] || "", 
					'<button id="_start_images_now" onclick="manipulate_conf(\'docker_config.sh\', 7, \'' + container_info[i].split(">")[0] + '\' );" class="btn btn-success">启动 <i class="icon-check"></i></button>&nbsp;&nbsp;<button id="_stop_images_now" onclick="manipulate_conf(\'docker_config.sh\', 8, \'' + container_info[i].split(">")[0] + '\' );" class="btn btn-danger">停止 <i class="icon-chevron-up"></i></button>&nbsp;&nbsp;<button id="_rm_images_now" onclick="manipulate_conf(\'docker_config.sh\', 9, \'' + container_info[i].split(">")[0] + '\' );" class="btn">删除 <i class="icon-cancel"></i></button>'
					] );
				}
			}
		}
		container.setup = function() {
			this.init( 'container-grid', 'sort' [
				{ type: 'text'},
				{ type: 'text'},
				{ type: 'text'},
				{ type: 'text'}
			]);
			this.headerSet( [ '容器名称', '镜像名称', '运行状态', '操作' ] );
			this.populatec();
			//this.sort( 1 );
		}
		//============================================
		function init_docker(){
			tabSelect('app1');
			verifyFields();			
			$("#_docker_basic_log").click(
				function() {
					x = 10000000;
			});
			show_hide_panel();
			set_version();
			//version_show();
			setTimeout("get_run_status();", 2000);
			seach.setup();
			container.setup();
			images.setup();
		}

		function set_version(){
			$('#_docker_version').html( '<font color="#1bbf35">Docker for openwrt - ' + (dbus["docker_version"]  || "") + '</font>' );
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/docker_",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
					//conf2obj();
			  	}
			});
		}
		
		function get_table_list(){
			var id5 = parseInt(Math.random() * 100000000);
			var postData2 = {"id": id5, "method": "docker_config.sh", "params":[10], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData2),
				dataType: "json",
				success: function(response){
					if (response.result != "-1"){
						images_info=Base64.decode(response.result.split("@@")[0]);
						images.populatei();
						container_info=Base64.decode(response.result.split("@@")[1]);
						container.populatec();
					}
				},
				timeout:1000
			});
		}
		
		function get_run_status(){
			if (status_time > 99999){
				E("_docker_basic_status").innerHTML = "暂停获取状态...";
				return false;
			}
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "docker_status.sh", "params":[2], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					if(softcenter == 1){
						return false;
					}
					++status_time;
					if (response.result == '-2'){
						E("_docker_basic_status").innerHTML = "获取运行状态失败！";
						setTimeout("get_run_status();", 5000);
					}else{
						if(dbus["docker_basic_enable"] != "1"){
							E("_docker_basic_status").innerHTML = "运行状态 - 尚未提交，暂停获取状态！";
						}else{
							E("_docker_basic_status").innerHTML = response.result.split("@@")[0];
						}
						//setTimeout("get_run_status();", 5000);
					}
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					E("_docker_basic_status").innerHTML = "获取运行状态失败！";
					E("_docker_basic_status_china").innerHTML = "获取运行状态失败！";
					setTimeout("get_run_status();", 5000);
				}
			});
		}

		function conf2obj(){
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

		function show_hide_panel(){
			var a  = E('_docker_basic_enable').checked;
			elem.display('docker_status_pannel', a);
			elem.display('docker_tabs', a);
			elem.display('docker_basic_tab', a);
		}

		function verifyFields(r){			
			// when check/uncheck docker_switch
			var a  = E('_docker_basic_enable').checked;
			if ( $(r).attr("id") == "_docker_basic_enable" ) {
				if(a){
					elem.display('docker_status_pannel', a);
					elem.display('docker_tabs', a);
					tabSelect('app1')
				}else{
					tabSelect('fuckapp')
				}
			}
			// login			
			var b  = E('_docker_basic_login').checked;
			elem.display(PR('_docker_basic_user'), b);
			elem.display(PR('_docker_basic_passwd'), b);

			return true;
		}
		function tabSelect(obj){
			var tableX = ['app1-tab', 'app2-tab','app3-tab','app4-tab','app5-tab','app6-tab','app7-tab'];
			var boxX = ['boxr1','boxr2','boxr3','boxr4','boxr5','boxr6','boxr7'];
			var appX = ['app1','app2','app3','app4','app5','app6','app7'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app6'){
				elem.display('save-button', false);
				noChange=0;
				setTimeout("get_log();", 200);
			}else if(obj=='app2' || obj=='app3' || obj=='app5' || obj=='app7'){
				elem.display('save-button', false);
				noChange=2001;
			}else{
				elem.display('save-button', true);
				noChange=2001;
			}
			if(obj=='fuckapp'){
				elem.display('docker_status_pannel', false);
				elem.display('docker_tabs', false);
				elem.display('docker_basic_tab', false);
				elem.display('docker_dns_tab', false);
				elem.display('docker_log_tab', false);
				E('save-button').style.display = "";
			}
		}
		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}

		function save(){
			setTimeout("tabSelect('app6')", 500);
			status_time = 999999990;
			get_run_status();
			E("_docker_basic_status").innerHTML = "运行状态 - 提交中...暂停获取状态！";
			var paras_chk = ["enable", "login"];
			var paras_inp = ["docker_basic_disk", "docker_basic_url", "docker_basic_user", "docker_basic_passwd"];
			// collect data from checkbox
			for (var i = 0; i < paras_chk.length; i++) {
				dbus["docker_basic_" + paras_chk[i]] = E('_docker_basic_' + paras_chk[i] ).checked ? '1':'0';
			}
			// data from other element
			for (var i = 0; i < paras_inp.length; i++) {
				if (typeof(E('_' + paras_inp[i] ).value) == "undefined"){
					dbus[paras_inp[i]] = "";
				}else{
					dbus[paras_inp[i]] = E('_' + paras_inp[i]).value;
				}
			}
			
			// now post data
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "docker_config.sh", "params":[1], "fields": dbus};
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
						if(E('_docker_basic_enable').checked){
							showMsg("msg_success","提交成功","<b>成功提交数据</b>");
							$('#msg_warring').hide();
							setTimeout("$('#msg_success').hide()", 500);
							x = 4;
							count_down_switch();
						}else{
							// when shut down ss finished, close the log tab
							$('#msg_warring').hide();
							showMsg("msg_success","提交成功","<b>docker成功关闭！</b>");
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

		function get_log(){
			$.ajax({
				url: '/_temp/docker_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(response) {
					var retArea = E("_docker_basic_log");
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
						return false;
					} else {
						setTimeout("get_log();", 100); //100 is radical but smooth!
					}
					retArea.value = response;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLen = response.length;
				},
				error: function() {
					E("_docker_basic_log").value = "获取日志失败！";
				}
			});
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

		function manipulate_conf(script, arg, image){
			var dbus3 = {};
			if(arg == 2){
				dbus3["docker_basic_seach"] = E('_docker_basic_seach').value;
				E("search_warn").innerHTML = "正在搜索，请稍候！";
				$("#seach-grid").find("tr:gt(0)").remove();
				//tabSelect("app6");
			}else if(arg == 3){
				dbus3["docker_basic_cmd"] = Base64.encode(E('_docker_basic_cmd').value);
				tabSelect("app6");
			}else if(arg == 4 || arg == 5 || arg == 6 || arg == 7 || arg == 8 || arg == 9){
				//将table第一列传递给dbus
				dbus3["docker_table_send"] = image;
				tabSelect("app6");
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
					if (script == "docker_config.sh"){
						if(arg == 1){
							setTimeout("window.location.reload()", 800);
						}else if (arg == 2){
							if(response.result != -1){
								if(response.result == 0){
									E("search_warn").innerHTML = "搜索失败！！可能是没找到任何结果！";

								}else{
									E("search_warn").innerHTML = "搜索成功！！";
									search_info=response.result
									seach.populate();
								}
							}else{
								E("search_warn").innerHTML = "错误！提交错误！";
							}
							E("_docker_basic_seach").value = "";
						}else if (arg == 3 || arg == 5 || arg == 6 || arg == 7 || arg == 8 || arg == 9){
							setTimeout("tabSelect('app6')", 500);
							setTimeout("window.location.reload()", 800);
						}else if (arg == 4){
							if(response.result != -1){
								setTimeout("window.location.reload()", 5000);
							}
						}
					}
				}
			});
		}
	</script>
	<div class="box">
		<div class="heading">
			<span id="_docker_version"></span>
			<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
			<a href="https://github.com/koolshare/ledesoft/blob/master/docker/Changelog.txt" target="_blank" class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">更新日志</a>
			<!--<button type="button" id="updateBtn" onclick="check_update()" class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">检查更新 <i class="icon-upgrade"></i></button>-->
		</div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
			Docker 是一个轻量级虚拟应用程序，它可以让您运行世界各地的开发人员创建的容器。<br />
			Docker Hub 是使用广泛的内置映像存储库，可以让您从其它优秀开发人员那里找到共享的应用程序。
		</div>
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="docker_switch_pannel" class="section" style="margin-top: -20px;"></div>
			<script type="text/javascript">
				$('#docker_switch_pannel').forms([
					{ title: '开启服务', name:'docker_basic_enable',type:'checkbox',  value: dbus.docker_basic_enable == 1 }  // ==1 means default close; !=0 means default open
				]);
			</script>
			<hr />
			<fieldset id="docker_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">运行状态</label>
				<div class="col-sm-9">
					<font id="_docker_basic_status" name="docker_basic_status" color="#1bbf35">正在获取状态: waiting...</font>
				</div>
			</fieldset>
		</div>
	</div>
	<ul id="docker_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active"><i class="icon-system"></i> 基本设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab"><i class="icon-tools"></i> 自定义命令</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab"><i class="icon-tools"></i> 注册表</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app7');" id="app7-tab"><i class="icon-cmd"></i> 映像</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app5');" id="app5-tab"><i class="icon-wake"></i> 容器</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app6');" id="app6-tab"><i class="icon-hourglass"></i> 查看日志</a></li>	
	</ul>
	<div class="box boxr1" id="docker_basic_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="docker_basic_pannel" class="section"></div>
			<script type="text/javascript">
				$('#docker_basic_pannel').forms([
					{ title: '安装目录', name:'docker_basic_disk',type:'text', size: 60, value:dbus.docker_basic_disk || "/mnt/sdb1" , suffix: '基础服务最少需要160MB以上空间，不要安装到系统盘'},
					{ title: '镜像库地址', name:'docker_basic_url',type:'text', size: 60, value:dbus.docker_basic_url || "http://hub-mirror.c.163.com" },
					{ title: '登陆Docker Hub', name:'docker_basic_login',type:'checkbox',  value: dbus.docker_basic_login == 1 }, 
					{ title: '用户名', name:'docker_basic_user',type:'text', size: 22, value:dbus.docker_basic_user },
					{ title: '密  码', name:'docker_basic_passwd',type:'password', size: 22, value:dbus.docker_basic_passwd , peekaboo: 1}
				]);
			</script>
		</div>
	</div>
	<!-- ------------------ 自定义命令 --------------------- -->
	<div class="box boxr3" id="docker_cmd_tab" style="margin-top: 0px;">
		<div class="heading">运行自定义命令</div>
		<div class="content" style="margin-top: -20px;">
			<div id="docker_cmd_pannel" class="section"></div>
			<script type="text/javascript">
				$('#docker_cmd_pannel').forms([
					{ title: '自定义命令行</br></br><font color="#B2B2B2"># ssh下使用命令docker COMMAND --help查看<br /><a href="https://docs.docker-cn.com/" target="_blank" ># 查看文档</a></font>', multi: [ 
						{ name:'docker_basic_cmd',type:'textarea', value:Base64.decode(dbus.docker_basic_cmd) || "docker COMMAND --help" ,style: 'width: 100%; height:250px;' },
						{ suffix: '<button id="_cmd_images_now" onclick="manipulate_conf(\'docker_config.sh\', 3);" class="btn btn-success">运行 <i class="icon-wrench"></i></button>' },
					]},	
				]);
			</script>
		</div>
	</div>
	<!-- ------------------ 注册表 --------------------- -->
	<div class="box boxr2" id="docker_dns_tab" style="margin-top: 0px;">
		<div class="heading">映像搜索</div>
		<div class="content" style="margin-top: -20px;">
			<div id="docker_dns_pannel" class="section"></div>
			<script type="text/javascript">
				$('#docker_dns_pannel').forms([
					{ title: '', multi: [ 
						{ name:'docker_basic_seach',type:'text', value:dbus.docker_basic_seach, suffix: '<button id="_seach_images_now" onclick="manipulate_conf(\'docker_config.sh\', 2);" class="btn btn-download">搜索 <i class="icon-search"></i></button><span class="help-block"><lable id="search_warn"></lable></span>' }
					]},	
				]);
			</script>
			<div class="content">
				<div class="tabContent">
					<table class="line-table" cellspacing=1 id="seach-grid"></table>
				</div>
				<br><hr>
			</div>
		</div>
	</div>
	<!-- ------------------ 映像管理 --------------------- -->
	<div class="box boxr7" id="ss_rule_tab" style="margin-top: 0px;">
		<div class="heading">本地映像列表</div>
			<div class="content">
				<div class="tabContent">
					<table class="line-table" cellspacing=1 id="images-grid"></table>
				</div>
				<br><hr>
		</div>
	</div>
	<!-- ------------------ 容器管理 --------------------- -->
	<div class="box boxr5" id="docker_addon_tab" style="margin-top: 0px;">
		<div class="heading">已创建的容器列表</div>
		<div id="docker_container_pannel" class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="container-grid"></table>
			</div>
		</div>
	</div>
	<!-- ------------------ log --------------------- -->
	<div class="box boxr6" id="docker_log_tab" style="margin-top: 0px;">
		<div id="docker_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.45);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#docker_log_pannel').append('<textarea class="as-script" name="_docker_basic_log" id="_docker_basic_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
		</div>
	</div>
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">提交 <i class="icon-check"></i></button>
	<script type="text/javascript">init_docker();</script>
</content>
