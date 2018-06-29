<title>软件中心 - NAT类型配置</title>
<content>
<style type="text/css">
input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<script type="text/javascript">
getAppData();
setTimeout("get_run_status();", 1000);
toggleVisibility('notes')
var dbus;
var softcenter = 0;
function init_nat1(){
	getAppData();
	verifyFields(null, 1);
}

function getAppData(){
var dbusInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/nat1_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	dbus = data.result[0];
		}
	});
}

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
		//============================================
function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "nat1_status.sh", "params":[], "fields": ""};
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
			document.getElementById("nat1_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("nat1_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

function verifyFields(focused, quiet){
	var dnsenable = E('_nat1_enable').checked ? '1':'0';
	var a = E('_nat1_clients').value =='2';
	elem.display(PR('_nat1_ip_list'), a);
	if(dnsenable == 0){
		$('input').prop('disabled', true);
		$(E('_nat1_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
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
		
function save(){
	dbus.nat1_enable = E('_nat1_enable').checked ? '1':'0';
	dbus.nat1_clients = E('_nat1_clients').value;
			// data need base64 encode
			var paras_base64 = ["nat1_ip_list"];
			for (var i = 0; i < paras_base64.length; i++) {
				if (typeof(E('_' + paras_base64[i] ).value) == "undefined"){
					dbus[paras_base64[i]] = "";
				}else{
					dbus[paras_base64[i]] = Base64.encode(E('_' + paras_base64[i]).value);
				}
			}
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'nat1_config.sh', "params":[], "fields": dbus};
	var success = function(data) {
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);
	};
	var error = function(data) {
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
}

</script>
<div class="box">
<div class="heading">Full cone NAT<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	为WAN口防火墙去掉IP动态伪装，将内网一些或者全部设备仅做单纯的地址转换，不对进出的封包设限。<br />
	适用于对网络类型有特殊要求的网络游戏或设备。
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="nat1-fields"></div>
<script type="text/javascript">
var option_clients = [['1', '全部设备'], ['2', '指定IP']];
$('#nat1-fields').forms([
{ title: '开启', name: 'nat1_enable', type: 'checkbox', value: ((dbus.nat1_enable == '1')? 1:0)},
{ title: '运行状态', text: '<font id="nat1_status" name=nat1_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '设备配置', name:'nat1_clients',type:'select', maxlen: 3, size: 3, options:option_clients ,value: dbus.nat1_clients || '1' },
{ title: '指定IP', name:'nat1_ip_list',type:'textarea', maxlen: 200, size: 200, value: Base64.decode(dbus.nat1_ip_list)||"", style: 'width: 100%; height:150px;',suffix: '在上面的输入需要指定full cone nat的内网ip地址，一行一个，例如：</br>192.168.1.200</br>192.168.1.201</font>'},
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">插件说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>Full cone NAT还需要运营商、设备防火配置的支持，本插件只能确保路由器不会成为瓶颈。</li>
			<li>Full cone NAT的设备可能会有安全隐患。</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_nat1();</script>
</content>
