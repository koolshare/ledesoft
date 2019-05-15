<title>koolddns</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
.box, #koolddns_tabs {
	min-width:720px;
}
</style>
	<script type="text/javascript">
		var dbus;
		var option_wan_list = [];
		get_wan_list();
		get_dbus_data();
		var _responseLen;
		var noChange = 0;
		var x = 4;
		var status_time = 1;
		var option_dm_api = [['0', '阿里DDNS'], ['1', 'DNSPOD'], ['2', 'CloudXNS'], ['3', 'Cloudflare'], ['4', 'Godaddy']];
		var option_dm_api_name = ['阿里DDNS', 'DNSPOD', 'CloudXNS', 'Cloudflare', 'Godaddy'];
		var option_dm_switch = [['0', '关闭'], ['1', '开启']];
		var option_dm_switch_name = ['×', '√'];
		var option_dm_mode = [['0', 'IPV4'], ['1', 'IPV6']];
		var option_dm_mode_name = ['IPV4', 'IPV6'];
		var option_wan_local = [];
		var option_wan_web = [];
		var softcenter = 0;
		var option_time_watch = [];
		for(var i = 1; i < 60; i++){
			option_time_watch[i-1] = [i, i + "分钟"];
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
		var koolddns_dm = new TomatoGrid();
		koolddns_dm.dataToView = function( data ) {
			if (data[0]){
				return [ option_dm_switch_name[data[0]], option_dm_api_name[data[1]], data[2], data[3], data[4], "******", "******", option_dm_mode_name[data[7]] ];
			}else{
				if (data[1]){
					return [ option_dm_switch_name[data[1]], option_dm_api_name[data[1]], data[2], data[3], data[4], "******", "******", option_dm_mode_name[data[7]]];
				}else{
					if (data[2]){
						return [ option_dm_switch_name[data[2]], option_dm_api_name[data[1]], data[2], data[3], data[4], "******", "******", option_dm_mode_name[data[7]] ];
					}
				}
			}
		}
		koolddns_dm.fieldValuesToData = function( row ) {
			var f = fields.getAll( row );
			if (f[0].value){
				return [ f[0].value, f[1].value, f[2].value, f[3].value, f[4].value, f[5].value, f[6].value , f[7].value ];
			}else{
				if (f[1].value){
					return [ f[1].value, f[1].value, f[2].value, f[3].value, f[4].value, f[5].value, f[6].value , f[7].value ];
				}else{
					if (f[2].value){
						return [ f[2].value, f[1].value, f[2].value, f[3].value, f[4].value, f[5].value, f[6].value , f[7].value ];
					}
				}
			}
		}
    	koolddns_dm.onChange = function(which, cell) {
    	    return this.verifyFields((which == 'new') ? this.newEditor: this.editor, true, cell);
    	}
		koolddns_dm.onAdd = function() {
			var data;
			this.moving = null;
			this.rpHide();
			if (!this.verifyFields(this.newEditor, false)) return;
			data = this.fieldValuesToData(this.newEditor);
			this.insertData(1, data);
			this.disableNewEditor(false);
			this.resetNewEditor();
		}
		koolddns_dm.rpDel = function(b) {
			b = PR(b);
			TGO(b).moving = null;
			b.parentNode.removeChild(b);
			this.recolor();
			this.rpHide()
		}
		koolddns_dm.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value = '1';
			f[ 1 ].value   = '';
			f[ 2 ].value   = '';
			f[ 3 ].value   = '*';
			f[ 4 ].value   = 'ali.com';
			f[ 5 ].value   = '';
			f[ 6 ].value   = '';
			f[ 7 ].value   = '0';
		}
		koolddns_dm.footerSet = function(c, b) {
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
		koolddns_dm.dataToFieldValues = function (data) {
			return [data[0], data[1], data[2], data[3], data[4], data[5], data[6], data[7]];
		}
		koolddns_dm.setup = function() {
			this.init( 'koolddns_dm_pannel', '', 254, [
			{ type: 'select',maxlen:2,options:option_dm_switch},
			{ type: 'select',maxlen:2,options:option_dm_api},	//name
			{ type: 'select',maxlen:20,options:option_wan_list},	//name
			{ type: 'text',maxlen:20},	//name
			{ type: 'text',maxlen:30},	//name
			{ type: 'text',maxlen:100},	//name
			{ type: 'text',maxlen:100},	//name
			{ type: 'select',maxlen:20,options:option_dm_mode}	//control
			] );
			this.headerSet( [ '启用', 'DDNS服务商', '接口', '子域名', '主域名', '校验码1', '校验码2', '接口类型'] );						
			for ( var i = 1; i <= dbus["koolddns_dm_node_max"]; i++){
				var t = [dbus["koolddns_dm_enable_" + i ], 
						dbus["koolddns_dm_api_" + i ]  || "",
						dbus["koolddns_dm_wan_" + i ]  || "",
						dbus["koolddns_dm_subdomain_" + i ]  || "",
						dbus["koolddns_dm_maindomain_" + i ]  || "",
						dbus["koolddns_dm_key_" + i ]  || "",
						dbus["koolddns_dm_secret_" + i ]  || "",
						dbus["koolddns_dm_mode_" + i ]]
				if ( t.length == 8 ) this.insertData( -1, t );
			}
			this.recolor();
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		function init_koolddns(){
			tabSelect('app1');
			verifyFields();
			$("#_koolddns_basic_log").click(
				function() {
					x = 10000000;
			});
			show_hide_panel();
			set_version();
			//version_show();
		}

		function set_version(){
			$('#_koolddns_version').html( '<font color="#1bbf35">koolddns for openwrt - ' + (dbus["koolddns_version"]  || "") + '</font>' );
		}

		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/koolddns",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
			  	}
			});
		}
		
		function get_wan_list(){
			var id5 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id5, "method": "koolddns_getwan.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					if (response.result != "-1"){
						var s2 = response.result.split( '>' );
						for ( var i = 0; i < s2.length; ++i ) {
							option_wan_local[i] = [s2[ i ].split( '<' )[0], s2[ i ].split( '<' )[0], s2[ i ].split( '<' )[1], s2[ i ].split( '<' )[2]];
						}
						var node_acl = parseInt(dbus["koolddns_dm_node_max"]) || 0;
						for ( var i = 0; i < node_acl; ++i ) {
							option_wan_web[i] = [dbus["koolddns_dm_wan_" + (i + 1)], dbus["koolddns_dm_wan_" + (i + 1)]];
						}			
						option_wan_list = unique_array(option_wan_local.concat( option_wan_web ));
						koolddns_dm.setup();
					}
				},
				error:function(){
					koolddns_dm.setup();
				},
				timeout:1000
			});
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
			var a  = E('_koolddns_basic_enable').checked;
			elem.display('koolddns_tabs', a);
			elem.display('koolddns_dm_tab', a);
		}

		function verifyFields(r){
			// when check/uncheck koolddns_switch
			var a  = E('_koolddns_basic_enable').checked;
			if ( $(r).attr("id") == "_koolddns_basic_enable" ) {
				if(a){
					elem.display('koolddns_tabs', a);
					elem.display(PR('_koolddns_basic_time'), a);
					tabSelect('app1')
				}else{
					tabSelect('fuckapp')
				}
			}

			//  url
			var b  = E('_koolddns_basic_url_enable').checked;
			elem.display(PR('_koolddns_basic_url_wan'), b);
			elem.display(PR('_koolddns_basic_url_url'), b);

			return true;
		}
		function tabSelect(obj){
			var tableX = ['app1-tab', 'app2-tab', 'app3-tab'];
			var boxX = ['boxr1','boxr2','boxr3'];
			var appX = ['app1','app2','app3'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app3'){
				elem.display('save-button', false);
				noChange=0;
				setTimeout("get_log();", 200);
			}else{
				elem.display('save-button', true);
				noChange=2001;
			}
			if(obj=='fuckapp'){
				elem.display('koolddns_tabs', false);
				elem.display('koolddns_dm_tab', false);
				elem.display('koolddns_basic_tab', false);
				elem.display('koolddns_log_tab', false);
				elem.display(PR('_koolddns_basic_time'), false);
				E('save-button').style.display = "";
			}
		}
		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}

		function save(){
			setTimeout("tabSelect('app3')", 500);
			status_time = 999999990;
			dbus.koolddns_basic_enable = E('_koolddns_basic_enable').checked ? '1':'0';
			dbus.koolddns_basic_url_enable = E('_koolddns_basic_url_enable').checked ? '1':'0';
			dbus.koolddns_basic_time = E('_koolddns_basic_time').value;
			dbus.koolddns_basic_url_wan = E('_koolddns_basic_url_wan').value;
			dbus.koolddns_basic_url_url = E('_koolddns_basic_url_url').value;
			// collect acl data from acl pannel
			var koolddns_dm_conf = ["koolddns_dm_enable_", "koolddns_dm_api_", "koolddns_dm_wan_", "koolddns_dm_subdomain_", "koolddns_dm_maindomain_", "koolddns_dm_key_", "koolddns_dm_secret_", "koolddns_dm_mode_" ];
			// mark all acl data for delete first
			for ( var i = 1; i <= dbus["koolddns_dm_node_max"]; i++){
				for ( var j = 0; j < koolddns_dm_conf.length; ++j ) {
					dbus[koolddns_dm_conf[j] + i ] = ""
				}
			}
			var data = koolddns_dm.getAllData();
			if(data.length > 0){
				for ( var i = 0; i < data.length; ++i ) {
					for ( var j = 1; j < koolddns_dm_conf.length; ++j ) {
						dbus[koolddns_dm_conf[0] + (i + 1)] = data[i][0];
						dbus[koolddns_dm_conf[j] + (i + 1)] = data[i][j];
					}
				}
				dbus["koolddns_dm_node_max"] = data.length;
			}else{
				dbus["koolddns_dm_node_max"] = "";
			}
			// now post data
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "koolddns_config.sh", "params":[1], "fields": dbus};
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
						if(E('_koolddns_basic_enable').checked){
							showMsg("msg_success","提交成功","<b>成功提交数据</b>");
							$('#msg_warring').hide();
							setTimeout("$('#msg_success').hide()", 500);
							x = 4;
							count_down_switch();
						}else{
							// when shut down ss finished, close the log tab
							$('#msg_warring').hide();
							showMsg("msg_success","提交成功","<b>koolddns成功关闭！</b>");
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

		function manipulate_conf(script, arg){
			var dbus3 = {};
			tabSelect("app3");
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
					if (script == "koolddns_config.sh"){
						setTimeout("tabSelect('app3')", 500);
						setTimeout("window.location.reload()", 800);
					}
				}
			});
		}

		function get_log(){
			$.ajax({
				url: '/_temp/koolddns_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(response) {
					var retArea = E("_koolddns_basic_log");
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
					E("_koolddns_basic_log").value = "获取日志失败！";
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
	</script>
	<div class="box">
		<div class="heading">
			<span id="_koolddns_version"></span>
			<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
			<a href="https://github.com/koolshare/ledesoft/blob/master/koolddns/Changelog.txt" target="_blank" class="btn btn-primary" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">更新日志</a>
		</div>
		<div class="content">
			<span class="col" style="line-height:30px;width:700px">
			koolddns 是利用ali、dnspod等域名服务商API制作的DDNS插件，能够在路由器的公网IP变化时把新的IP地址更新到你的域名解析上。<br />
			域名注册:<a href="https://promotion.aliyun.com/ntms/yunparter/invite.html?userCode=tfc52lbm" target="_blank"> 【阿里】 </a><a href="https://cloud.tencent.com/redirect.php?redirect=1005&cps_key=ff97ebf7f96a9f88c44c7a1f6fb4240f&from=console" target="_blank"> 【DNSPOD】 </a> 获取AccessKey：<a href="https://usercenter.console.aliyun.com/#/manage/ak" target="_blank"> 【阿里】 </a><a href="https://www.dnspod.cn/console/user/security" target="_blank"> 【DNSPIOD】 </a>
		</div>
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">
		</div>
		<div class="content">
			<div id="koolddns_switch_pannel" class="section" style="margin-top: -20px;"></div>
			<script type="text/javascript">
				$('#koolddns_switch_pannel').forms([
					{ title: '开启', name:'koolddns_basic_enable',type:'checkbox',  value: dbus.koolddns_basic_enable == 1 },
					{ title: '更新间隔', multi: [
						{ name:'koolddns_basic_time',type:'select', options:option_time_watch, value: dbus.koolddns_basic_time || '30' },
						{ suffix: '&nbsp;&nbsp;<button id="_update_now" onclick="manipulate_conf(\'koolddns_config.sh\', 2);" class="btn btn-success">手动更新 <i class="icon-cloud"></i></button>' }
					]}
				]);
			</script>
			<hr />
		</div>
	</div>
	<ul id="koolddns_tabs" class="nav nav-tabs">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active"><i class="icon-system"></i> 帐号设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" class="active"><i class="icon-tools"></i> 其它设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab"><i class="icon-hourglass"></i> 查看日志</a></li>	
	</ul>
	<!-- ------------------ 域名列表 --------------------- -->
	<div class="box boxr1" id="koolddns_dm_tab" style="margin-top: 0px;">
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="koolddns_dm_pannel"></table>
			</div>
			<br><hr>
		</div>
	</div>
	<!-- ------------------ 帮助信息 --------------------- -->
	<div class="box boxr1" id="koolddns_help_tab" style="margin-top: 0px;">
		<div class="heading">设置说明 <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
		<div class="section content" id="sesdivnotes" style="display:">
				<li>阿里DNS：校验码1=【AccessKey ID】 校验码2=【Access Key Secret】;</li>
				<li>DNSPOD：校验码1=【ID】校验码2=【Token】;</li>
				<li>CloudXNS：校验码1=【api_key】校验码2=【secret_key】;</li>
				<li>Cloudflare：校验码1=【Email】校验码2=【Key】;</li>
				<li>Godaddy：校验码1=【API production key】校验码2=【API secret】;</li>
				<li>阿里、Dnspod、Cloudflare无需预先在控制台添加要解析的子域名，插件会自动添加;</li>
				<li>其它域名商需要先在控制台添加好子域名再使用插件更新解析;</li>
		</div>
	</div>
	<!-- ------------------ 其它设置 --------------------- -->
	<div class="box boxr2" id="koolddns_basic_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="koolddns_basic_pannel" class="section"></div>
			<script type="text/javascript">
				$('#koolddns_basic_pannel').forms([
					{ title: '自定义url解析配置', name:'koolddns_basic_url_enable',type:'checkbox',  value: dbus.koolddns_basic_url_enable == 1 },
					{ title: '指定解析出口', name:'koolddns_basic_url_wan',type:'text', value:dbus.koolddns_basic_url_wan ||'' ,suffix: '配置错误将导致解析出错，输入eth0、pppoe-wan等接口名称' },
					{ title: '指定解析网址', name:'koolddns_basic_url_url',type:'text', value: dbus.koolddns_basic_url_url||"whatismyip.akamai.com"}
				]);
			</script>
		</div>
	</div>
	<!-- ------------------ 日志 --------------------- -->
	<div class="box boxr3" id="koolddns_log_tab" style="margin-top: 0px;">
		<div id="koolddns_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.45);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#koolddns_log_pannel').append('<textarea class="as-script" name="_koolddns_basic_log" id="_koolddns_basic_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
		</div>
	</div>
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存配置 <i class="icon-check"></i></button>
	<script type="text/javascript">init_koolddns();</script>
</content>
