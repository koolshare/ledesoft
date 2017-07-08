<title>软件中心 - kuainiao</title>
<content>

	<script type="text/javascript" src="/res/rsa.js"></script>
	<script type="text/javascript" src="/res/md5.js"></script>
	<script type="text/javascript" src="/res/sha1.js"></script>
	<script type="text/javascript">
		getAppData();
		var Apps;
		function getAppData() {
			var appsInfo;
			$.ajax({
				type: "GET",
				url: "/_api/kuainiao_",
				dataType: "json",
				async: false,
				success: function (data) {
					Apps = data.result[0];
				}
			});
		}
		//function init() {
			////双wan开始判断
			//var lb_mode = '<% nvram get wans_mode; %>';
			//if (lb_mode !== "lb") {
			//	document.getElementById('double_wan_set').style.display = "none";
			//	document.getElementById('select_wan').style.display = "none";
			//	document.form.kuainiao_config_wan.value = 0;
			//} else {
			//	check_selected("kuainiao_config_wan", db_kuainiao_.kuainiao_config_wan);
			//}
			////conf2obj();
			////var conf_ajax = setInterval("conf2obj();", 60000);
			//version_show();
			//write_kuainiao_install_status();
			//check_selected("kuainiao_start", db_kuainiao_.kuainiao_start);
			//check_selected("kuainiao_time", db_kuainiao_.kuainiao_time);
		//}
		//生成设备id
		var wan_mac = '<% nvram get wan_hwaddr; %>';
		//var wan_mac = '00:0C:29:21:24:78';
		var fake_device_id = md5(wan_mac);
		var device_sign = "div100."+fake_device_id+md5(hex_sha1(fake_device_id+"com.xunlei.vip.swjsq68700d1872b772946a6940e4b51827e8af"));

		var kn = '00AC69F5CCC8BDE47CD3D371603748378C9CFAD2938A6B021E0E191013975AD683F5CBF9ADE8BD7D46B4D2EC2D78AF146F1DD2D50DC51446BB8880B8CE88D476694DFC60594393BEEFAA16F5DBCEBE22F89D640F5336E42F587DC4AFEDEFEAC36CF007009CCCE5C1ACB4FF06FBA69802A8085C2C54BADD0597FC83E6870F1E36FD';
		var ke = '010001';

		var rsa = new RSAKey();

		rsa.setPublic(kn, ke);

		//console.log('Apps',Apps);
		//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
		function verifyFields(focused, quiet) {
    		//if(Apps.kuainiao_vcodeimg_url == ''){
        	//	$(E('_kuainiao_config_verifyCode')).prop('disabled', true);
    		//}else{
        	//	$(E('_kuainiao_config_verifyCode')).prop('disabled', false);
    		//}
			return 1;
		}
		function save() {
			Apps.kuainiao_enable = E('_kuainiao_enable').checked ? '1' : '0';
			Apps.kuainiao_upenable = E('_kuainiao_upenable').checked ? '1' : '0';
			Apps.kuainiao_config_uname = E('_kuainiao_config_uname').value;
			Apps.kuainiao_config_old_pwd = E('_kuainiao_config_old_pwd').value;
			Apps.kuainiao_start = E('_kuainiao_start').value;
			Apps.kuainiao_time = E('_kuainiao_time').value;
			Apps.kuainiao_config_wan = E('_kuainiao_config_wan').value;
			Apps.kuainiao_device_sign = device_sign;
			//Apps.kuainiao_config_verifyCode = E('_kuainiao_config_verifyCode').value;
			//Apps.kuainiao_curl = E('_kuainiao_curl').value;
			//Apps.kuainiao_ttl = E('_kuainiao_ttl').value;
			var encrypted_pwd = rsa.encrypt(md5(Apps.kuainiao_config_old_pwd));
			Apps.kuainiao_config_pwd=encrypted_pwd.toUpperCase();
			//-------------- post Apps to dbus ---------------
			var id = 1 + Math.floor(Math.random() * 6);
			var postData = { "id": id, "method": 'kuainiao_config.sh', "params": [], "fields": Apps };
			var success = function (data) {
				//
				$('#footer-msg').text(data.result);
				$('#footer-msg').show();
				setTimeout("window.location.reload()", 3000);

				//  do someting here.
				//
			};
			var error = function (data) {
				//
				//  do someting here.
				//
			};
			$('#footer-msg').text('保存中……');
			$('#footer-msg').show();
			$('button').addClass('disabled');
			$('button').prop('disabled', true);
			$.ajax({
				type: "POST",
				url: "/_api/",
				data: JSON.stringify(postData),
				success: success,
				error: error,
				dataType: "json"
			});

			//-------------- post Apps to dbus ---------------
		}

	</script>
	<div class="box">
		<div class="heading">kuainiao <a href="javascript:history.back()" class="btn" style="float:right;border-radius:3px;">返回</a></div>
		<br>
		<hr>
		<div class="content">
			<div id="kuainiao-fields"></div>
			<script type="text/javascript">
				var upoption_mode = [['1', '开'], ['2', '关']];
				var option_mode = [['1', 'WAN'], ['2', 'WAN2'], ['3', 'WAN3'], ['4', 'WAN4']];
				$('#kuainiao-fields').forms([
					{ title: '开启下行加速', name: 'kuainiao_enable', type: 'checkbox', value: ((Apps.kuainiao_enable == '1') ? 1 : 0) },
					{ title: '开启上行加速', name: 'kuainiao_upenable', type: 'checkbox', value: ((Apps.kuainiao_upenable == '1') ? 1 : 0) },
					{ title: '运行状态', name: 'kuainiao_last_act', text: Apps.kuainiao_last_act || '--' },
					//{ title: '上行运行状态', name: 'kuainiao_uplast_act', text: Apps.kuainiao_uplast_act || '--' },
					{ title: '迅雷用户名', name: 'kuainiao_config_uname', type: 'text', maxlen: 34, size: 34, value: Apps.kuainiao_config_uname },
					{ title: '迅雷密码', name: 'kuainiao_config_old_pwd', type: 'password', maxlen: 34, size: 34, value: Apps.kuainiao_config_old_pwd },
					//{ title: '验证码', name: 'kuainiao_config_verifyCode', type: 'text', maxlen: 4, size: 4, value: Apps.kuainiao_config_verifyCode,suffix:"<img src="+Apps.kuainiao_vcodeimg_url+">"},
					{ title: '下行提速状态', name: 'kuainiao_down_state', text: Apps.kuainiao_down_state || '--' },
					{ title: '上行提速状态', name: 'kuainiao_up_state', text: Apps.kuainiao_up_state || '--' },
					{ title: '开机自启', name: 'kuainiao_start', type: 'select', options: upoption_mode, value: Apps.kuainiao_start || '1' },
					{ title: '启动延时', name: 'kuainiao_time', type: 'text', maxlen: 5, size: 5, value: Apps.kuainiao_time || '1', suffix: '秒'},
					//{ title: '域名', name: 'kuainiao_domain', type: 'text', maxlen: 32, size: 34, value: Apps.kuainiao_domain || 'ex.example.com'},
					//{ title: 'DNS服务器', name: 'kuainiao_dns', type: 'text', maxlen: 15, size: 15, value: Apps.kuainiao_dns ||'223.5.5.5',suffix:'<small>查询域名当前IP时使用的DNS解析服务器，默认为阿里云DNS</small>'},
					{ title: '加速WAN口', name: 'kuainiao_config_wan', type: 'select', options: option_mode, value: Apps.kuainiao_config_wan || '1' },
					//{ title: 'TTL', name: 'kuainiao_ttl', type: 'text', maxlen: 5, size: 5, value: Apps.kuainiao_ttl || '600' ,suffix: ' <small> (范围: 1~86400; 默认: 600)</small>'},
				]);

			</script>
		</div>
	</div>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
	<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
	<script type="text/javascript">
		verifyFields(null, 1);
	</script>
</content>