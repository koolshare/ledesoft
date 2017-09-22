<title>shadowsocks</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
	.box {
		min-width:1110px;
	}
	.c-checkbox {
		margin-left:-10px;
	}
	/*Switch Icon Start*/
	.switch_field{
		width: 65px;
	}
	.switch_container{
		width: 50px;
		height: 30px;
		border: 1px solid transparent;
		margin-left: 20px;
	}
	.switch_bar{
		width: 43px;
		height: 16px;
		background-color: #717171;
		margin:7px auto 0;
		border-radius: 10px;
	}
	.switch_circle{
		width: 26px;
		height: 26px;
		border-radius: 16px;
		background-color: #FFF;
		margin-top: -21px;
		box-shadow: 0px 1px 4px 1px #444;
	}
	/*Icon*/
	.switch_circle > div{
		width: 16px;
		height: 16px;
		position: absolute;
		margin: 5px 0 0 5px;
	}
	/*background color of bar while checked*/
	.switch:checked ~.switch_container > .switch_bar{
		background-color: #279FD9;
	}

	/*control icon style while checked*/
	.switch:checked ~.switch_container > .switch_bar + .switch_circle > div{
		background-image: url("data:image/svg+xml;charset=US-ASCII,%3C%3Fxml%20version%3D%221.0%22%20encoding%3D%22iso-8859-1%22%3F%3E%0A%3Csvg%20version%3D%221.1%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20xmlns%3Axlink%3D%22http%3A%2F%2Fwww.w3.org%2F1999%2Fxlink%22%20x%3D%220px%22%20y%3D%220px%22%20viewBox%3D%220%200%2016.9%2016.9%22%20style%3D%22enable-background%3Anew%200%200%2016.9%2016.9%3B%22%20xml%3Aspace%3D%22preserve%22%3E%0A%3Cg%20style%3D%22fill%3A%23279FD9%22%3E%0A%09%3Cpolygon%20points%3D%226.8%2C14.9%200%2C8.8%202.2%2C6.4%206.6%2C10.5%2014.5%2C1.9%2016.8%2C3.9%20%09%22%2F%3E%0A%3C%2Fg%3E%0A%3C%2Fsvg%3E%0A");
		background-repeat: no-repeat;
	}
	.switch:checked ~.switch_container > .switch_circle{
		margin-left: 23px;
	}
	#table-row-panel a.delete-row, #table-row-panel a.move-down-row, #table-row-panel a.move-row, #table-row-panel a.move-up-row {
		float:left;
		font-size:10pt;
		text-align:center;
		padding:13px 15px;
		padding:6px 8px;
		margin-right:5px;
		line-height:1;
		color:#fff;
		background:#585858;
		z-index:1;
		-webkit-transition:background-color 80ms ease;
		transition:background-color 80ms ease
	}
	#table-row-panel a.delete-row:hover, #table-row-panel a.move-down-row:hover, #table-row-panel a.move-row:hover, #table-row-panel a.move-up-row:hover {
		z-index:10;
		background:#434343
	}
	#table-row-panel a.delete-row {
		background:#F76D6A
	}
	#table-row-panel a.delete-row:hover {
		background:#eb4d4a
	}
	#table-row-panel a.apply-row, #table-row-panel a.move-down-row, #table-row-panel a.move-row, #table-row-panel a.move-up-row {
		float:left;
		font-size:10pt;
		text-align:center;
		padding:13px 15px;
		padding:6px 8px;
		line-height:1;
		color:#fff;
		background:#585858;
		z-index:1;
		-webkit-transition:background-color 80ms ease;
		transition:background-color 80ms ease
	}
	#table-row-panel a.apply-row:hover, #table-row-panel a.move-down-row:hover, #table-row-panel a.move-row:hover, #table-row-panel a.move-up-row:hover {
		z-index:10;
		background:#434343
	}
	#table-row-panel a.apply-row {
		background:#99FF66
	}
	#table-row-panel a.apply-row:hover {
		background:#99FF00
	}

	table.line-table tr:nth-child(even) {
		background:rgba(0, 0, 0, 0.04)
	}	
	#ss_node-grid > tbody > tr.even.use,
	#ssr_node-grid > tbody > tr.even.use {
		background:rgba(128, 255, 255, 0.3)
	}
	#ss_node-grid > tbody > tr.odd.use,
	#ssr_node-grid > tbody > tr.odd.use {
		background:rgba(128, 255, 255, 0.3)
	}
</style>
	<script type="text/javascript">
		var dbus;
		get_dbus_data();
		get_arp_list();
		var _responseLen;
		var noChange = 0;
		var x = 4;
		var node_ss;
		var node_ssr;
		var status_time = 1;
		var status_refresh_rate = parseInt(dbus["ss_basic_refreshrate"]);
		var option_mode = [['1', 'gfwlist模式'], ['2', '大陆白名单模式'], ['3', '游戏模式'], ['4', '全局模式']];
		var option_mode_name = ['', 'gfwlist模式', '大陆白名单模式', '游戏模式', '全局模式'];
		var option_acl_mode = [['0', '不通过SS'], ['1', 'gfwlist模式'], ['2', '大陆白名单模式'], ['3', '游戏模式'], ['4', '全局模式']];
		var option_acl_mode_name = ['不通过SS', 'gfwlist模式', '大陆白名单模式', '游戏模式', '全局模式'];
		var option_acl_port = [['80,443', '80,443'], ['22,80,443', '22,80,443'], ['all', 'all']];
		var option_acl_port_name = ['80,443', '22,80,443', 'all'];
		var option_method = [['none', 'none'],['rc4', 'rc4'], ['rc4-md5', 'rc4-md5'], ['rc4-md5-6', 'rc4-md5-6'], ['aes-128-gcm', 'aes-128-gcm'], ['aes-192-gcm', 'aes-192-gcm'], ['aes-256-gcm', 'aes-256-gcm'], ['aes-128-cfb', 'aes-128-cfb'], ['aes-192-cfb', 'aes-192-cfb'], ['aes-256-cfb', 'aes-256-cfb'], ['aes-128-ctr', 'aes-128-ctr'], ['aes-192-ctr', 'aes-192-ctr'], ['aes-256-ctr', 'aes-256-ctr'], ['camellia-128-cfb', 'camellia-128-cfb'], ['camellia-192-cfb', 'camellia-192-cfb'], ['camellia-256-cfb', 'camellia-256-cfb'], ['bf-cfb', 'bf-cfb'], ['cast5-cfb', 'cast5-cfb'], ['idea-cfb', 'idea-cfb'], ['rc2-cfb', 'rc2-cfb'], ['seed-cfb', 'seed-cfb'], ['salsa20', 'salsa20'], ['chacha20', 'chacha20'], ['chacha20-ietf', 'chacha20-ietf'], ['chacha20-ietf-poly1305', 'chacha20-ietf-poly1305']];
		var option_ssr_protocal = [['origin','origin'],['verify_simple','verify_simple'],['verify_sha1','verify_sha1'],['auth_sha1','auth_sha1'],['auth_sha1_v2','auth_sha1_v2'],['auth_sha1_v4','auth_sha1_v4'],['auth_aes128_md5','auth_aes128_md5'],['auth_aes128_sha1','auth_aes128_sha1'],['auth_chain_a','auth_chain_a'],['auth_chain_b','auth_chain_b'],['auth_chain_c','auth_chain_c'],['auth_chain_d','auth_chain_d']];
		var option_ssr_obfs = [['plain','plain'],['http_simple','http_simple'],['http_post','http_post'],['tls1.2_ticket_auth','tls1.2_ticket_auth']];
		var option_dns_china = [['1', '运营商DNS【自动获取】'],  ['2', '阿里DNS1【223.5.5.5】'],  ['3', '阿里DNS2【223.6.6.6】'],  ['4', '114DNS1【114.114.114.114】'],  ['5', '114DNS1【114.114.115.115】'],  ['6', 'cnnic DNS【1.2.4.8】'],  ['7', 'cnnic DNS【210.2.4.8】'],  ['8', 'oneDNS1【112.124.47.27】'],  ['9', 'oneDNS2【114.215.126.16】'],  ['10', '百度DNS【180.76.76.76】'],  ['11', 'DNSpod DNS【119.29.29.29】'],  ['12', '自定义']];
		var option_dns_foreign = [['1', 'dns2socks'], ['2', 'ss-tunnel'], ['3', 'dnscrypt-proxy'], ['4', 'pdnsd'], ['5', 'ChinaDNS'], ['6', 'Pcap_DNSProxy']];
		var option_ss_sstunnel = [['2', 'google dns\[8.8.8.8\]'], ['3', 'google dns\[8.8.4.4\]'], ['1', 'OpenDNS\[208.67.220.220\]'], ['4', '自定义']];
		var option_ChinaDNS_china = [['1', '阿里DNS1【223.5.5.5】'], ['2', '阿里DNS2【223.6.6.6】'], ['3', '114DNS1【114.114.114.114】'], ['4', '114DNS1【114.114.115.115】'], ['5', 'cnnic DNS【1.2.4.8】'], ['6', 'cnnic DNS【210.2.4.8】'], ['7', 'oneDNS1【112.124.47.27】'], ['8', 'oneDNS2【114.215.126.16】'], ['9', '百度DNS【180.76.76.76】'], ['10', 'DNSpod DNS【119.29.29.29】'], ['11', '自定义']];
		var option_opendns = [['adguard-dns-family-ns1','Adguard DNS Family Protection 1'], ['adguard-dns-family-ns2','Adguard DNS Family Protection 2'], ['adguard-dns-ns1','Adguard DNS 1'], ['adguard-dns-ns2','Adguard DNS 2'], ['cisco','Cisco OpenDNS'], ['cisco-familyshield','Cisco OpenDNS with FamilyShield'], ['cisco-ipv6','Cisco OpenDNS over IPv6'], ['cisco-port53','Cisco OpenDNS backward compatibility port 53'], ['cloudns-syd','CloudNS Sydney'], ['cs-cawest','CS Canada west DNSCrypt server'], ['cs-cfi','CS cryptofree France DNSCrypt server'], ['cs-cfii','CS secondary cryptofree France DNSCrypt server'], ['cs-ch','CS Switzerland DNSCrypt server'], ['cs-de','CS Germany DNSCrypt server'], ['cs-fr2','CS secondary France DNSCrypt server'], ['cs-rome','CS Italy DNSCrypt server'], ['cs-useast','CS New York City NY US DNSCrypt server'], ['cs-usnorth','CS Chicago IL US DNSCrypt server'], ['cs-ussouth','CS Dallas TX US DNSCrypt server'], ['cs-ussouth2','CS Atlanta GA US DNSCrypt server'], ['cs-uswest','CS Seattle WA US DNSCrypt server'], ['cs-uswest2','CS Las Vegas NV US DNSCrypt server'], ['d0wn-au-ns1','OpenNIC Resolver Australia 01 - d0wn'], ['d0wn-bg-ns1','OpenNIC Resolver Bulgaria 01 - d0wn'], ['d0wn-cy-ns1','OpenNIC Resolver Cyprus 01 - d0wn'], ['d0wn-de-ns1','OpenNIC Resolver Germany 01 - d0wn'], ['d0wn-de-ns2','OpenNIC Resolver Germany 02 - d0wn'], ['d0wn-dk-ns1','OpenNIC Resolver Denmark 01 - d0wn'], ['d0wn-fr-ns2','OpenNIC Resolver France 02 - d0wn'], ['d0wn-es-ns1','OpenNIC Resolver Spain 01- d0wn'], ['d0wn-gr-ns1','OpenNIC Resolver Greece 01 - d0wn'], ['d0wn-hk-ns1','OpenNIC Resolver Hong Kong 01 - d0wn'], ['d0wn-is-ns1','OpenNIC Resolver Iceland 01 - d0wn'], ['d0wn-lu-ns1','OpenNIC Resolver Luxembourg 01 - d0wn'], ['d0wn-lu-ns1-ipv6','OpenNIC Resolver Luxembourg 01 over IPv6 - d0wn'], ['d0wn-lv-ns1','OpenNIC Resolver Latvia 01 - d0wn'], ['d0wn-lv-ns2','OpenNIC Resolver Latvia 02 - d0wn'], ['d0wn-lv-ns2-ipv6','OpenNIC Resolver Latvia 01 over IPv6 - d0wn'], ['d0wn-nl-ns3','OpenNIC Resolver Netherlands 03 - d0wn'], ['d0wn-nl-ns3-ipv6','OpenNIC Resolver Netherlands 03 over IPv6 - d0wn'], ['d0wn-random-ns1','OpenNIC Resolver Moldova 01 - d0wn'], ['d0wn-random-ns2','OpenNIC Resolver Netherlands 02 - d0wn'], ['d0wn-ro-ns1','OpenNIC Resolver Romania 01 - d0wn'], ['d0wn-ro-ns1-ipv6','OpenNIC Resolver Romania 01 over IPv6 - d0wn'], ['d0wn-ru-ns1','OpenNIC Resolver Russia 01 - d0wn'], ['d0wn-se-ns1','OpenNIC Resolver Sweden 01 - d0wn'], ['d0wn-se-ns1-ipv6','OpenNIC Resolver Sweden 01 over IPv6 - d0wn'], ['d0wn-sg-ns1','OpenNIC Resolver Singapore 01 - d0wn'], ['d0wn-sg-ns2','OpenNIC Resolver Singapore 02 - d0wn'], ['d0wn-sg-ns2-ipv6','OpenNIC Resolver Singapore 01 over IPv6 - d0wn'], ['d0wn-tz-ns1','OpenNIC Resolver Tanzania 01 - d0wn'], ['d0wn-ua-ns1','OpenNIC Resolver Ukraine 01 - d0wn'], ['d0wn-ua-ns1-ipv6','OpenNIC Resolver Ukraine 01 over IPv6 - d0wn'], ['d0wn-uk-ns1','OpenNIC Resolver United Kingdom 01 - d0wn'], ['d0wn-uk-ns1-ipv6','OpenNIC Resolver United Kingdom 01 over IPv6 - d0wn'], ['d0wn-us-ns1','OpenNIC Resolver United States of America 01 - d0wn'], ['d0wn-us-ns1-ipv6','OpenNIC Resolver United States of America 01 over IPv6 - d0wn'], ['d0wn-us-ns2','OpenNIC Resolver United States of America 02 - d0wn'], ['d0wn-us-ns2-ipv6','OpenNIC Resolver United States of America 02 over IPv6 - d0wn'], ['dns-freedom','DNS Freedom'], ['dnscrypt.eu-dk','DNSCrypt.eu Denmark'], ['dnscrypt.eu-dk-ipv6','DNSCrypt.eu Denmark over IPv6'], ['dnscrypt.eu-nl','DNSCrypt.eu Holland'], ['dnscrypt.eu-nl-ipv6','DNSCrypt.eu Holland over IPv6'], ['dnscrypt.org-fr','DNSCrypt.org France'], ['fvz-anyone','Primary OpenNIC Anycast DNS Resolver'], ['fvz-anyone-ipv6','Primary OpenNIC Anycast DNS IPv6 Resolver'], ['fvz-anytwo','Secondary OpenNIC Anycast DNS Resolver'], ['fvz-anytwo-ipv6','Secondary OpenNIC Anycast DNS IPv6 Resolver'], ['ipredator','Ipredator.se Server'], ['ns0.dnscrypt.is','ns0.dnscrypt.is in Reykjav铆k, Iceland'], ['okturtles','okTurtles'], ['opennic-tumabox','TumaBox'], ['ovpnse','OVPN.se Integritet AB'], ['soltysiak','Soltysiak'], ['soltysiak-ipv6','Soltysiak over IPv6'], ['ventricle.us','Anatomical DNS'], ['yandex','Yandex']];
		var option_status_inter = [['0', '不更新'], ['5', '5s'], ['10', '10s'], ['15', '15s'], ['30', '30s'], ['60', '60s']];
		var option_sleep = [['0', '0s'], ['5', '5s'], ['10', '10s'], ['15', '15s'], ['30', '30s'], ['60', '60s']];
		var option_ss_obfs = [['0','关闭'],['tls','tls'],['http','http']];
		var option_lb_policy = [['1', '负载均衡'], ['2', '主用节点'], ['3', '备用节点']];
		var option_lb_policy_name = ['', '负载均衡', '主用节点', '备用节点'];
		var ssbasic = ["mode", "server", "port", "password", "method", "ss_obfs", "ss_obfs_host" ];
		var ssrbasic = ["mode", "server", "port", "password", "method", "rss_protocal", "rss_protocal_para", "rss_obfs", "rss_obfs_para"];
		var ssconf = ["ssconf_basic_mode_", "ssconf_basic_name_", "ssconf_basic_server_", "ssconf_basic_port_", "ssconf_basic_password_", "ssconf_basic_method_", "ssconf_basic_ss_obfs_", "ssconf_basic_ss_obfs_host_" ];
		var ssrconf = ["ssrconf_basic_mode_", "ssrconf_basic_name_", "ssrconf_basic_server_", "ssrconf_basic_port_", "ssrconf_basic_password_", "ssrconf_basic_method_", "ssrconf_basic_rss_protocal_", "ssrconf_basic_rss_protocal_para_", "ssrconf_basic_rss_obfs_", "ssrconf_basic_rss_obfs_para_"];
		var option_kcp_mode = [['manual', 'manual'], ['normal', 'normal'], ['fast', 'fast'], ['fast2', 'fast2'], ['fast3', 'fast3']];
		var option_kcp_crypt =[['aes', 'aes'], ['aes-128', 'aes-128'], ['aes-192', 'aes-192'], ['salsa20', 'salsa20'], ['blowfish', 'blowfish'], ['twofish', 'twofish'], ['cast5', 'cast5'], ['3des', '3des'], ['tea', 'tea'], ['xtea', 'xtea'], ['xor', 'xor'], ['none', 'none']];
		var option_arp_list = [];
		var option_arp_local = [];
		var option_arp_web = [];
		var option_hour_time = [];
		var option_node_name = [];
		var option_node_addr = [];
		var wans =[];
		var wans2 = [];
		var ss_lb_nodes =[];
		var ssr_lb_nodes =[];
		var wans_value =[];
		var wans_name =[];
		var kcp_diff = 0;
		var ss_node_diff = 0;
		var softcenter = 0;
		var select_style="min-width:182px;max-width:182px";
		
		for(var i = 0; i < 24; i++){
			option_hour_time[i] = [i, i + "点"];
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
									output += '<textarea ' + (f.style ? (' style="' + f.style + '" ') : '') + name + common + (f.wrap ? (' wrap=' + f.wrap) : '') + '>' + escapeHTML(UT(f.value)) + '</textarea>';
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
		var ss_node = new TomatoGrid();
		ss_node.dataToView = function(data) {
			return [ data[0], option_mode_name[data[1]], data[2] || "节点" + data.length, data[3], data[4], "******", data[6], (data[7] == 0 ? "" : data[7]), data[8], data[9]];
		}
		ss_node.verifyFields = function( row, quiet ) {
			E('_ss_node-grid_1').disabled = true;
			E('_ss_node-grid_1').style.display = "none";
			E('_ss_node-grid_10').disabled = true;
			E('_ss_node-grid_10').style.display = "none";
			var f = fields.getAll( row );
			return v_iptaddr( f[3], quiet ) && v_port( f[4], quiet );
		}
		ss_node.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value   = '';
			f[ 1 ].selectedIndex   = '';
			f[ 2 ].value   = '';
			f[ 3 ].value   = '';
			f[ 4 ].value   = '';
			f[ 5 ].value   = '';
			f[ 6 ].selectedIndex   = '';
			f[ 7 ].selectedIndex   = '';
			f[ 8 ].value   = '';
			f[ 9 ].value   = '';
		}
		ss_node.onDelete = function() {
			this.removeEditor();
			var del_ss_node = parseInt(this.source.cells[0].innerHTML);
			var cur_sel_node = parseInt(dbus["ss_basic_node"]);
			var cur_kcp_node = parseInt(dbus["ss_kcp_node"]);
			if (del_ss_node == cur_sel_node){
				alert("该节点正在使用！\n删除节点保存后帐号设置界面显示的节点会显示成下一个！\n删除后除非重新提交，之前的节点仍然在后台使用！");
			}
			if (del_ss_node < cur_sel_node){
				++ss_node_diff
			}
			if (del_ss_node == cur_kcp_node){
				alert("请注意，你删除的节点是KCP加速节点！\n删除后请注意设置KCP加速");
				dbus["ss_kcp_node"] = "";
			}
			if (del_ss_node < cur_kcp_node){
				++kcp_diff
			}
			elem.remove(this.source);
			this.source = null;
			this.disableNewEditor(false);
			dbus["ssconf_basic_node_max"] = this.tb.rows.length - 3 //addby sadog
			dbus["ssconf_basic_max_node"] = parseInt(this.tb.rows[this.tb.rows.length -3].cells[0].innerHTML) //addby sadog
		}
		ss_node.rpDel = function(e) {
			e = PR(e);
			var del_ss_node = parseInt(e.cells[0].innerHTML);
			var cur_sel_node = parseInt(dbus["ss_basic_node"]);
			var cur_kcp_node = parseInt(dbus["ss_kcp_node"]);
			if (del_ss_node == cur_sel_node){
				alert("该节点正在使用！\n不能被删除！\n需要删除，请关闭ss或者切换到其它节点删除！");
				return false;
			}
			if (del_ss_node < cur_sel_node){
				++ss_node_diff
			}
			if (del_ss_node == cur_kcp_node){
				alert("请注意，你删除的节点是KCP加速节点，删除后请注意设置KCP加速");
				dbus["ss_kcp_node"] = "";
			}
			if (del_ss_node < cur_kcp_node){
				++kcp_diff
			}
			TGO(e).moving = null;
			e.parentNode.removeChild(e);
			this.recolor();
			this.rpHide();
			dbus["ssconf_basic_node_max"] = this.tb.rows.length - 3 //addby sadog
			dbus["ssconf_basic_max_node"] = parseInt(this.tb.rows[this.tb.rows.length -3].cells[0].innerHTML) //addby sadog
		}
		ss_node.rpMouIn = function(evt) {
			var e, x, ofs, me, s, n;
			if ((evt = checkEvent(evt)) == null || evt.target.nodeName == 'A' || evt.target.nodeName == 'I') return;
			me = TGO(evt.target);
			if (me.isEditing()) return;
			if (me.moving) return;
			if (evt.target.id != 'table-row-panel') {
				me.rpHide();
			}
			e = document.createElement('div');
			e.tgo = me;
			e.ref = evt.target;
			e.setAttribute('id', 'table-row-panel');
			n = 0;
			s = '';
			if (me.canDelete) {
				s += '<a class="delete-row" href="#" onclick="this.parentNode.tgo.rpDel(this.parentNode.ref); return false;" title="删除"><i class="icon-cancel"></i></a>';
				s += '<a class="apply-row" href="#" onclick="this.parentNode.tgo.rpApply(this.parentNode.ref); return false;" title="应用"><i class="icon-check"></i></a>';
				++n;
			}
			x = PR(evt.target);
			x = x.cells[x.cells.length - 1];
			ofs = elem.getOffset(x);
			n *= 18;
			e.innerHTML = s;
			this.appendChild(e);
		}
		ss_node.rpApply = function(e) {
			e = PR(e);
			var apply_ss_node = parseInt(e.cells[0].innerHTML);
			console.log(apply_ss_node);
			//dbus["ss_basic_node"] = apply_ss_node //addby sadog
			E("_ss_basic_node").value = apply_ss_node;
			if (confirm("确定要应用此节点?")) {
				auto_node_sel();
				verifyFields();
				//tabSelect('app1');
				//setTimeout("save();", 200);
				save();
			} else {
				return false;
			}
		}
		ss_node.onAdd = function() {
			var data;
			this.moving = null;
			this.rpHide();
			if (!this.verifyFields(this.newEditor, false)) return;
			data = this.fieldValuesToData(this.newEditor); 
			data[0] = String(parseInt(this.tb.rows[this.tb.rows.length - 3].cells[0].innerHTML) + 1 || 0 + 1); //addby sadog
			this.insertData(-1, data);
			this.disableNewEditor(false);
			this.resetNewEditor();
			dbus["ssconf_basic_node_max"] = this.tb.rows.length -3 //addby sadog
			dbus["ssconf_basic_max_node"] = parseInt(this.tb.rows[this.tb.rows.length -3].cells[0].innerHTML) //addby sadog
		}
		ss_node.insert = function(at, data, cells, escCells) {
			var e, i;
			if ((this.footer) && (at == -1)) at = this.footer.rowIndex;
			e = this._insert(at, cells, escCells);
			e.className = (e.rowIndex & 1) ? 'even' : 'odd';
			if ((parseInt(dbus["ss_basic_node"]) == parseInt(e.cells[0].innerHTML)) && dbus["ss_basic_enable"] == 1){
				e.className = (e.rowIndex & 1) ? 'even use' : 'odd use';
			}
			for (i = 0; i < e.cells.length; ++i) {
				e.cells[i].onclick = function() {
					return TGO(this).onClick(this);
				};
			}
			e._data = data;
			e.getRowData = function() {
				return this._data;
			}
			e.setRowData = function(data) {
				this._data = data;
			}
			if ((this.canMove) || (this.canEdit) || (this.canDelete)) {
				e.onmouseover = this.rpMouIn;
				e.onmouseout = this.rpMouOut;
				if (this.canEdit) e.title = '点击编辑';
				$(e).css('cursor', 'text');
			}
			return e;
		}
		ss_node.createEditor = function(which, rowIndex, source) {
			var values;
			if (which == 'edit') values = this.dataToFieldValues(source.getRowData());
			var row = this.tb.insertRow(rowIndex);
			row.className = 'editor';
			var common = ' onkeypress="return TGO(this).onKey(\'' + which + '\', event)" onchange="TGO(this).onChange(\'' + which + '\', this)"';
			var common_b = ' onclick="return TGO(this).onKey(\'' + which + '\', event)" onchange="TGO(this).onChange(\'' + which + '\', this)"';
			var vi = 0;
			for (var i = 0; i < this.editorFields.length; ++i) {
				var s = '';
				var ef = this.editorFields[i].multi;
				if (!ef) ef = [this.editorFields[i]];
				for (var j = 0; j < ef.length; ++j) {
					var f = ef[j];
					if (f.prefix) s += f.prefix;
					var attrib = ' class="fi' + (vi + 1) + ' ' + (f['class'] ? f['class'] : '') + '" ' + (f.attrib || '');
					var id = (this.tb ? ('_' + this.tb.id + '_' + (vi + 1)) : null);
					if (id) attrib += ' id="' + id + '"';
					switch (f.type) {
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
							attrib += ' autocomplete="off"';
							if (f.peekaboo && id) attrib += ' onfocus=\'peekaboo("' + id + '",1)\'';
							// drop
						case 'text':
							s += '<input type="' + f.type + '" maxlength=' + f.maxlen + common + attrib;
							if (which == 'edit') s += ' value="' + escapeHTML('' + values[vi]) + '">';
							else s += '>';
							break;
						case 'select':
							s += '<select' + common + attrib + '>';
							for (var k = 0; k < f.options.length; ++k) {
								a = f.options[k];
								if (which == 'edit') {
									s += '<option value="' + a[0] + '"' + ((a[0] == values[vi]) ? ' selected>' : '>') + a[1] + '</option>';
								} else {
									s += '<option value="' + a[0] + '">' + a[1] + '</option>';
								}
							}
							s += '</select>';
							break;
						case 'checkbox':
							s += '<div class="checkbox c-checkbox"><label><input type="checkbox"' + common + attrib;
							if ((which == 'edit') && (values[vi])) s += ' checked';
							s += '><span></span> </label></div>';
							break;
						case 'textarea':
							if (which == 'edit') {
								document.getElementById(f.proxy).value = values[vi];
							}
							break;
						default:
							s += f.custom.replace(/\$which\$/g, which);
					}
					if (f.suffix) s += f.suffix;
					++vi;
				}
				var c = row.insertCell(i);
				c.innerHTML = s;
				// Added verticalAlignment, this fixes the incorrect vertical positioning of inputs in the editorRow
				if (this.editorFields[i].vtop) {
					c.vAlign = 'top';
					c.style.verticalAlign = "top";
				}
			}
			return row;
		}
		ss_node.setup = function() {
			this.init( 'ss_node-grid', '', 500, [
				{ type: 'text', maxlen: 5 },
				{ type: 'select', options:option_mode,value:'' },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'select', options:option_method,value:''},
				{ type: 'select', options:option_ss_obfs,value:''},
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 }
			] );
			this.headerSet( [ '序号',  '模式', '节点名称', '服务器地址', '端口', '密码', '加密方式', '混淆(AEAD)', '混淆主机名', 'ping' ] );
			for ( var i = 1; i <= dbus["ssconf_basic_node_max"]; i++){
				var t1 = [
					String(i),
					dbus["ssconf_basic_mode_" + i ],
					dbus["ssconf_basic_name_" + i ],
					dbus["ssconf_basic_server_" + i ],
					dbus["ssconf_basic_port_" + i ],
					dbus["ssconf_basic_password_" + i ],
					dbus["ssconf_basic_method_" + i ],
					dbus["ssconf_basic_ss_obfs_" + i ] || "关闭",
					dbus["ssconf_basic_ss_obfs_host_" + i ] || " ",
					" "
					]
				if ( t1.length == 10 ) this.insertData( -1, t1 );
			}
			this.showNewEditor();
			this.resetNewEditor();
			E('_ss_node-grid_1').disabled = true;
			E('_ss_node-grid_1').style.display = "none";
			E('_ss_node-grid_10').disabled = true;
			E('_ss_node-grid_10').style.display = "none";
		}
		//============================================
		var ssr_node = new TomatoGrid();
		ssr_node.dataToView = function(data) {
			return [ data[0], option_mode_name[data[1]], data[2], data[3], data[4], "******", data[6], data[7], (data[8].length > 1 ? "******" : ""), data[9], data[10], data[11]];
		}
		ssr_node.verifyFields = function( row, quiet ) {
			E('_ssr_node-grid_1').disabled = true;
			E('_ssr_node-grid_1').style.display = "none";
			E('_ssr_node-grid_12').disabled = true;
			E('_ssr_node-grid_12').style.display = "none";
			var f = fields.getAll( row );
			return v_iptaddr( f[3], quiet ) && v_port( f[4], quiet ) && v_domain( f[10], quiet );
		}
		ssr_node.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value   = '';
			f[ 1 ].selectedIndex   = '';
			f[ 2 ].value   = '';
			f[ 3 ].value   = '';
			f[ 4 ].value   = '';
			f[ 5 ].value   = '';
			f[ 6 ].selectedIndex   = '';
			f[ 7 ].selectedIndex   = '';
			f[ 8 ].value   = '';
			f[ 9 ].selectedIndex   = '';
			f[ 10 ].value   = '';
			f[ 11 ].value   = '';
		}
		ssr_node.onDelete = function() {
			this.removeEditor();
			var del_ssr_node = parseInt(this.source.cells[0].innerHTML);
			var cur_sel_node = parseInt(dbus["ss_basic_node"]);
			var cur_kcp_node = parseInt(dbus["ss_kcp_node"]);
			if (del_ssr_node == (cur_sel_node - node_ss)){
				alert("该节点正在使用！\n删除节点保存后帐号设置界面显示的节点会显示成下一个！\n删除后除非重新提交，之前的节点仍然在后台使用！");
			}
			if (del_ssr_node < (cur_sel_node - node_ss)){
				++ss_node_diff
			}
			if (del_ssr_node == (cur_kcp_node - node_ss)){
				alert("请注意，你删除的节点是KCP加速节点！\n删除后请注意设置KCP加速");
				dbus["ss_kcp_node"] = "";
			}
			if (del_ssr_node < (cur_kcp_node - node_ss)){
				++kcp_diff
			}
			elem.remove(this.source);
			this.source = null;
			this.disableNewEditor(false);
			dbus["ssrconf_basic_node_max"] = this.tb.rows.length - 3 //addby sadog
			dbus["ssrconf_basic_max_node"] = parseInt(this.tb.rows[this.tb.rows.length -3].cells[0].innerHTML) //addby sadog
		}
		ssr_node.rpDel = function(e) {
			e = PR(e);
			var del_ssr_node = parseInt(e.cells[0].innerHTML);
			var cur_sel_node = parseInt(dbus["ss_basic_node"]);
			var cur_kcp_node = parseInt(dbus["ss_kcp_node"]);
			if (del_ssr_node == (cur_sel_node - node_ss)){
				alert("该节点正在使用！\n不能被删除！\n需要删除，请关闭ss或者切换到其它节点删除！");
				return false;
			}
			if (del_ssr_node < (cur_sel_node - node_ss)){
				++ss_node_diff
			}
			if (del_ssr_node == (cur_kcp_node - node_ss)){
				alert("请注意，你删除的节点是KCP加速节点，删除后请注意设置KCP加速");
				dbus["ss_kcp_node"] = "";
			}
			if (del_ssr_node < (cur_kcp_node - node_ss)){
				++kcp_diff
			}
			TGO(e).moving = null;
			e.parentNode.removeChild(e);
			this.recolor();
			this.rpHide();
			dbus["ssrconf_basic_node_max"] = this.tb.rows.length - 3 //addby sadog
			dbus["ssrconf_basic_max_node"] = parseInt(this.tb.rows[this.tb.rows.length -3].cells[0].innerHTML) //addby sadog
		}
		ssr_node.rpMouIn = function(evt) {
			var e, x, ofs, me, s, n;
			if ((evt = checkEvent(evt)) == null || evt.target.nodeName == 'A' || evt.target.nodeName == 'I') return;
			me = TGO(evt.target);
			if (me.isEditing()) return;
			if (me.moving) return;
			if (evt.target.id != 'table-row-panel') {
				me.rpHide();
			}
			e = document.createElement('div');
			e.tgo = me;
			e.ref = evt.target;
			e.setAttribute('id', 'table-row-panel');
			n = 0;
			s = '';
			if (me.canDelete) {
				s += '<a class="delete-row" href="#" onclick="this.parentNode.tgo.rpDel(this.parentNode.ref); return false;" title="删除"><i class="icon-cancel"></i></a>';
				s += '<a class="apply-row" href="#" onclick="this.parentNode.tgo.rpApply(this.parentNode.ref); return false;" title="应用"><i class="icon-check"></i></a>';
				++n;
			}
			x = PR(evt.target);
			x = x.cells[x.cells.length - 1];
			ofs = elem.getOffset(x);
			n *= 18;
			e.innerHTML = s;
			this.appendChild(e);
		}
		ssr_node.rpApply = function(e) {
			e = PR(e);
			var apply_ss_node = parseInt(e.cells[0].innerHTML);
			//dbus["ss_basic_node"] = apply_ss_node //addby sadog
			E("_ss_basic_node").value = apply_ss_node + node_ss;
			if (confirm("确定要应用此节点?")) {
				auto_node_sel();
				verifyFields();
				save();
			} else {
				return false;
			}
		}
		ssr_node.onAdd = function() {
			var data;
			this.moving = null;
			this.rpHide();
			if (!this.verifyFields(this.newEditor, false)) return;
			data = this.fieldValuesToData(this.newEditor); 
			data[0] = String(parseInt(this.tb.rows[this.tb.rows.length - 3].cells[0].innerHTML) +1 || 0 + 1); //addby sadog
			this.insertData(-1, data);
			this.disableNewEditor(false);
			this.resetNewEditor();
			dbus["ssrconf_basic_node_max"] = this.tb.rows.length -3 //addby sadog
			dbus["ssrconf_basic_max_node"] = parseInt(this.tb.rows[this.tb.rows.length -3].cells[0].innerHTML) //addby sadog
		}
		ssr_node.insert = function(at, data, cells, escCells) {
			var e, i;
			if ((this.footer) && (at == -1)) at = this.footer.rowIndex;
			e = this._insert(at, cells, escCells);
			e.className = (e.rowIndex & 1) ? 'even' : 'odd';
			if ((parseInt(dbus["ss_basic_node"]) == parseInt(e.cells[0].innerHTML) + node_ss) && dbus["ss_basic_enable"] == 1){
				e.className = (e.rowIndex & 1) ? 'even use' : 'odd use';
			}
			for (i = 0; i < e.cells.length; ++i) {
				e.cells[i].onclick = function() {
					return TGO(this).onClick(this);
				};
			}
			e._data = data;
			e.getRowData = function() {
				return this._data;
			}
			e.setRowData = function(data) {
				this._data = data;
			}
			if ((this.canMove) || (this.canEdit) || (this.canDelete)) {
				e.onmouseover = this.rpMouIn;
				e.onmouseout = this.rpMouOut;
				if (this.canEdit) e.title = '点击编辑';
				$(e).css('cursor', 'text');
			}
			return e;
		}
		ssr_node.createEditor = function(which, rowIndex, source) {
			var values;
			if (which == 'edit') values = this.dataToFieldValues(source.getRowData());
			var row = this.tb.insertRow(rowIndex);
			row.className = 'editor';
			var common = ' onkeypress="return TGO(this).onKey(\'' + which + '\', event)" onchange="TGO(this).onChange(\'' + which + '\', this)"';
			var vi = 0;
			for (var i = 0; i < this.editorFields.length; ++i) {
				var s = '';
				var ef = this.editorFields[i].multi;
				if (!ef) ef = [this.editorFields[i]];
				for (var j = 0; j < ef.length; ++j) {
					var f = ef[j];
					if (f.prefix) s += f.prefix;
					var attrib = ' class="fi' + (vi + 1) + ' ' + (f['class'] ? f['class'] : '') + '" ' + (f.attrib || '');
					var id = (this.tb ? ('_' + this.tb.id + '_' + (vi + 1)) : null);
					if (id) attrib += ' id="' + id + '"';
					switch (f.type) {
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
							attrib += ' autocomplete="off"';
							if (f.peekaboo && id) attrib += ' onfocus=\'peekaboo("' + id + '",1)\'';
							// drop
						case 'text':
							s += '<input type="' + f.type + '" maxlength=' + f.maxlen + common + attrib;
							if (which == 'edit') s += ' value="' + escapeHTML('' + values[vi]) + '">';
							else s += '>';
							break;
						case 'select':
							s += '<select' + common + attrib + '>';
							for (var k = 0; k < f.options.length; ++k) {
								a = f.options[k];
								if (which == 'edit') {
									s += '<option value="' + a[0] + '"' + ((a[0] == values[vi]) ? ' selected>' : '>') + a[1] + '</option>';
								} else {
									s += '<option value="' + a[0] + '">' + a[1] + '</option>';
								}
							}
							s += '</select>';
							break;
						case 'checkbox':
							s += '<div class="checkbox c-checkbox"><label><input type="checkbox"' + common + attrib;
							if ((which == 'edit') && (values[vi])) s += ' checked';
							s += '><span></span> </label></div>';
							break;
						case 'textarea':
							if (which == 'edit') {
								document.getElementById(f.proxy).value = values[vi];
							}
							break;
						default:
							s += f.custom.replace(/\$which\$/g, which);
					}
					if (f.suffix) s += f.suffix;
					++vi;
				}
				var c = row.insertCell(i);
				c.innerHTML = s;
				// Added verticalAlignment, this fixes the incorrect vertical positioning of inputs in the editorRow
				if (this.editorFields[i].vtop) {
					c.vAlign = 'top';
					c.style.verticalAlign = "top";
				}
			}
			return row;
		}
		ssr_node.setup = function() {
			this.init( 'ssr_node-grid', '', 500, [
				{ type: 'text', maxlen: 5 },
				{ type: 'select',maxlen:20,options:option_mode,value:'' },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'select',maxlen:40,options:option_method,value:''},
				{ type: 'select',maxlen:40,options:option_ssr_protocal,value:''},
				{ type: 'text', maxlen: 50 },
				{ type: 'select',maxlen:40,options:option_ssr_obfs,value:''},
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 }
			] );
			this.headerSet( [ '序号', '模式', '节点名称', '服务器地址', '端口', '密码', '加密方式', '协议', '协议参数', '混淆', '混淆参数', 'ping' ] );

			for ( var i = 1; i <= dbus["ssrconf_basic_node_max"]; i++){
				var t2 = [
						String(i),
						dbus["ssrconf_basic_mode_" + i ], 
						dbus["ssrconf_basic_name_" + i ], 
						dbus["ssrconf_basic_server_" + i ], 
						dbus["ssrconf_basic_port_" + i ], 
						dbus["ssrconf_basic_password_" + i ], 
						dbus["ssrconf_basic_method_" + i ],
						dbus["ssrconf_basic_rss_protocal_" + i ],
						dbus["ssrconf_basic_rss_protocal_para_" + i ] || "",
						dbus["ssrconf_basic_rss_obfs_" + i ],
						dbus["ssrconf_basic_rss_obfs_para_" + i ] || "",
						" "
						]  
				if ( t2.length == 12 ) this.insertData( -1, t2 );
			}
			this.showNewEditor();
			this.resetNewEditor();
			E('_ssr_node-grid_1').disabled = true;
			E('_ssr_node-grid_1').style.display = "none";
			E('_ssr_node-grid_12').disabled = true;
			E('_ssr_node-grid_12').style.display = "none";
		}
		//============================================
		var lb = new TomatoGrid();

		lb.dataToView = function(data) {
			return [ data[0], data[1], data[2], data[3], data[4], data[5], data[6], option_lb_policy_name[data[7]] ];
		}
		lb.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return v_iptaddr( f[2], quiet ) && v_port( f[3], quiet );
		}
		lb.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[0].value   = '';
			f[1].value   = '';
			f[2].value   = '';
			f[3].value   = '';
			f[4].selectedIndex   = '';
			f[5].value   = '';
			f[6].value   = '';
		}
		lb.onAdd = function() {
			var data;
			this.moving = null;
			this.rpHide();
			if (!this.verifyFields(this.newEditor, false)) return;
			data = this.fieldValuesToData(this.newEditor);
			this.insertData(-1, data);
			this.disableNewEditor(false);
			this.resetNewEditor();
		}
		lb.rpDel = function(e) {
			if (this.tb.rows.length == 2){
				dbus["ss_lb_type"] = ""
			}
			//$("#_ss_lb_node").append("<option value='" + deleted_value + "'>" + deleted_name[1] + "</option>");
			e = PR(e);
			TGO(e).moving = null;
			e.parentNode.removeChild(e);
			this.recolor();
			this.rpHide();
		}
		lb.init = function(tb, options, maxAdd, editorFields) {
			if (tb) {
				this.tb = E(tb);
				this.tb.gridObj = this;
			} else {
				this.tb = null;
			}
			if (!options) options = '';
			this.header = null;
			this.footer = null;
			this.editor = null;
			this.canSort = options.indexOf('sort') != -1;
			this.canMove = options.indexOf('move') != -1;
			this.maxAdd = maxAdd || 500;
			this.canEdit = false; //modified by sadog
			this.canDelete = true; //modified by sadog
			this.editorFields = editorFields;
			this.sortColumn = -1;
			//this.sortAscending = true;
		}

		lb.setup = function(lb_node, lb_type) {
			//get_dbus_data();
			if ($("#lb-grid > tbody > tr > td.header.co1").length == 0){
				this.init( 'lb-grid' );
				this.headerSet( ['节点名称', '节点序号', '服务器地址', '端口', '加密方式', '多wan出口', '权重', '属性' ] );
			}
			//ss set up on click
			if (lb_type == 1){
				var html ='<select name="ssconf_basic_lb_dest_' + lb_node + '" onchange="verifyFields(this, 1)" id="_ssconf_basic_lb_dest_' + lb_node + '"></select>'
				var t = [
						"【SS】" + dbus["ssconf_basic_name_" + lb_node ], 
						lb_node, 
						dbus["ssconf_basic_server_" + lb_node ], 
						dbus["ssconf_basic_port_" + lb_node ], 
						dbus["ssconf_basic_method_" + lb_node ], 
						//dbus["ssconf_basic_lb_dest_" + lb_node ] || wans[0][0],
						html,
						dbus["ssconf_basic_lb_weight_" + lb_node ],
						dbus["ssconf_basic_lb_policy_" + lb_node ]
						]
					dbus["ss_lb_node_ex"] = lb_node;
				if ( t.length == 8 ) this.insertData( -1, t );
				for ( var j = 0; j < wans.length; ++j ) {
					$("#_ssconf_basic_lb_dest_" + lb_node).append("<option value='"  + wans[j][0] + "'>" + wans[j][1] + "</option>");
				}
				E("_ssconf_basic_lb_dest_" + lb_node).value = dbus["ssconf_basic_lb_dest_" + lb_node] || 0;
			//ssr set up on click
			}else if (lb_type == 2){
				var html ='<select name="ssrconf_basic_lb_dest_' + lb_node + '" onchange="verifyFields(this, 1)" id="_ssrconf_basic_lb_dest_' + lb_node + '"></select>'
				var t = [
						"【SSR】" + dbus["ssrconf_basic_name_" + lb_node ], 
						lb_node, 
						dbus["ssrconf_basic_server_" + lb_node ], 
						dbus["ssrconf_basic_port_" + lb_node ], 
						dbus["ssrconf_basic_method_" + lb_node ],
						//dbus["ssrconf_basic_lb_dest_" + lb_node ] || wans[0][0],
						html,
						dbus["ssrconf_basic_lb_weight_" + lb_node ],
						dbus["ssrconf_basic_lb_policy_" + lb_node ]
						]
					dbus["ss_lb_node_ex"] = lb_node;
				if ( t.length == 8 ) this.insertData( -1, t );
				for ( var j = 0; j < wans.length; ++j ) {
					$("#_ssrconf_basic_lb_dest_" + lb_node).append("<option value='"  + wans[j][0] + "'>" + wans[j][1] + "</option>");
				}
				E("_ssrconf_basic_lb_dest_" + lb_node).value = dbus["ssrconf_basic_lb_dest_" + lb_node] || 0;
			}else{
				//ss set up on pageload
				for ( var i = 1; i <= dbus["ssconf_basic_node_max"]; i++){
					var html ='<select name="ssconf_basic_lb_dest_' + i + '" onchange="verifyFields(this, 1)" id="_ssconf_basic_lb_dest_' + i + '"></select>'
					if (dbus["ssconf_basic_lb_enable_" + i ] == 1){
						var t = ["【SS】" + dbus["ssconf_basic_name_" + i ], 
								String(i),
								dbus["ssconf_basic_server_" + i ], 
								dbus["ssconf_basic_port_" + i ], 
								dbus["ssconf_basic_method_" + i ],
								//dbus["ssconf_basic_lb_dest_" + i ] || wans[0][0],
								html,
								dbus["ssconf_basic_lb_weight_" + i ] || "50",
								dbus["ssconf_basic_lb_policy_" + i ] || "1"
								]
						if ( t.length == 8 ) this.insertData( -1, t );
						ss_lb_nodes.push(i);
						dbus["ss_lb_node_ex"] = i;
						dbus["ss_lb_type"] = 1;
					}
				}
				//ssr set up on pageload
				for ( var i = 1; i <= dbus["ssrconf_basic_node_max"]; i++){
					if (dbus["ssrconf_basic_lb_enable_" + i ] == 1){
						var html ='<select name="ssrconf_basic_lb_dest_' + i + '" onchange="verifyFields(this, 1)" id="_ssrconf_basic_lb_dest_' + i + '">'
						for ( var j = 0; j < wans.length; ++j ) {
							html +='<option value=' + wans[j][0] + '>' + wans[j][1] + '</option>'
						}
						html +='</select>'
						var t = ["【SSR】" + dbus["ssrconf_basic_name_" + i ], 
								String(i),
								dbus["ssrconf_basic_server_" + i ], 
								dbus["ssrconf_basic_port_" + i ], 
								dbus["ssrconf_basic_method_" + i ],
								html,
								dbus["ssrconf_basic_lb_weight_" + i ] || "50", 
								dbus["ssrconf_basic_lb_policy_" + i ] || "1"
								]
						if ( t.length == 8 ) this.insertData( -1, t );
						ssr_lb_nodes.push(i);
						dbus["ss_lb_node_ex"] = i;
						dbus["ss_lb_type"] = 2;
					}
				}
			}
		}
		
		function add_lb_node(){
			lb_node_sel = E('_ss_lb_node').value || 1;
			if (dbus["ssrconf_basic_rss_protocal_" + (lb_node_sel - node_ss)]){ // using ssr
				if (!dbus["ss_lb_type"] || dbus["ss_lb_type"] == 2){
					dbus["ssrconf_basic_lb_enable_" + (lb_node_sel - node_ss) ] = "1";
					dbus["ssrconf_basic_lb_weight_" + (lb_node_sel - node_ss) ] = E("_ss_lb_weight").value;
					dbus["ssrconf_basic_lb_policy_" + (lb_node_sel - node_ss) ] = E("_ss_lb_policy").value;
					dbus["ssrconf_basic_lb_dest_" + (lb_node_sel - node_ss) ] = E("_ss_lb_dest").value;
					dbus["ss_lb_type"] = 2;
					lb_type=2;
					lb_node = String(lb_node_sel - node_ss);
				}else{
					alert("SS节点和SSR节点之间不能负载均衡！")
					return false;
				}
			}else{ //ss
				if (!dbus["ss_lb_type"] || dbus["ss_lb_type"] == 1){
					dbus["ssconf_basic_lb_enable_" + lb_node_sel ] = "1";
					dbus["ssconf_basic_lb_weight_" + lb_node_sel ] = E("_ss_lb_weight").value;
					dbus["ssconf_basic_lb_policy_" + lb_node_sel ] = E("_ss_lb_policy").value;
					dbus["ssconf_basic_lb_dest_" + lb_node_sel ] = E("_ss_lb_dest").value;
					dbus["ss_lb_type"] = 1;
					lb_type=1;
					lb_node=lb_node_sel;
				}else{
					alert("SS节点和SSR节点之间不能负载均衡！")
					return false;
				}
			}
			lb.setup(lb_node, lb_type);
			//$("#_ss_lb_node option[value='" + lb_node_sel +"']").remove();
			$("#_ss_lb_node").val(parseInt(lb_node_sel) + 1);
		}

		//============================================
		var ss_acl = new TomatoGrid();
		ss_acl.dataToView = function( data ) {
			if (data[0]){
				return [ "【" + data[0] + "】", data[1], data[2], option_acl_mode_name[data[3]], data[4] ];
			}else{
				if (data[1]){
					return [ "【" + data[1] + "】", data[1], data[2], option_acl_mode_name[data[3]], data[4] ];
				}else{
					if (data[2]){
						return [ "【" + data[2] + "】", data[1], data[2], option_acl_mode_name[data[3]], data[4] ];
					}
				}
			}
		}
		ss_acl.fieldValuesToData = function( row ) {
			var f = fields.getAll( row );
			if (f[0].value){
				return [ f[0].value, f[1].value, f[2].value, f[3].value, f[4].value ];
			}else{
				if (f[1].value){
					return [ f[1].value, f[1].value, f[2].value, f[3].value, f[4].value ];
				}else{
					if (f[2].value){
						return [ f[2].value, f[1].value, f[2].value, f[3].value, f[4].value ];
					}
				}
			}
		}
    	ss_acl.onChange = function(which, cell) {
    	    return this.verifyFields((which == 'new') ? this.newEditor: this.editor, true, cell);
    	}
		ss_acl.verifyFields = function( row, quiet,cell ) {
			var f = fields.getAll( row );
			// fill the ip and mac when chose the name
			if ( $(cell).attr("id") == "_[object HTMLTableElement]_1" ) {
				if (f[0].value){
					f[1].value = option_arp_list[f[0].selectedIndex][2];
					f[2].value = option_arp_list[f[0].selectedIndex][3];
				}
			}
			// fill the port when chose the mode
			if ( $(cell).attr("id") == "_[object HTMLTableElement]_4" ) {
				if (f[3].selectedIndex == 0){
					f[4].selectedIndex = 2;
				}else if(f[3].selectedIndex == 1){
					f[4].selectedIndex = 0;
				}else if(f[3].selectedIndex == 2){
					f[4].selectedIndex = 1;
				}else if(f[3].selectedIndex == 3){
					f[4].selectedIndex = 2;
				}else if(f[3].selectedIndex == 4){
					f[4].selectedIndex = 0;
				}
			}
			//check if ip and mac column correct
			if (f[1].value && !f[2].value){
				return v_ip( f[1], quiet );
			}
			if (!f[1].value && f[2].value){
				return v_mac( f[2], quiet );
			}
			if (f[1].value && f[2].value){
				return v_ip( f[1], quiet ) || v_mac( f[2], quiet );
			}
		}
		ss_acl.alter_txt = function() {
			if (this.tb.rows.length == "4"){
				$('#footer_ip').html("<i>全部主机 - ip</i>")
				$('#footer_mac').html("<i>全部主机 - mac</i>")
			}else{
				$('#footer_ip').html("<i>其它主机 - ip</i>")
				$('#footer_mac').html("<i>其它主机 - mac</i>")
			}
		}
		ss_acl.onAdd = function() {
			var data;
			this.moving = null;
			this.rpHide();
			if (!this.verifyFields(this.newEditor, false)) return;
			data = this.fieldValuesToData(this.newEditor);
			this.insertData(1, data);
			this.disableNewEditor(false);
			this.resetNewEditor();
			this.alter_txt(); // added by sadog
		}
		ss_acl.rpDel = function(b) {
			b = PR(b);
			TGO(b).moving = null;
			b.parentNode.removeChild(b);
			this.recolor();
			this.rpHide()
			this.alter_txt(); // added by sadog
		}
		ss_acl.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].value = '';
			f[ 1 ].value   = '';
			f[ 2 ].value   = '';
			f[ 3 ].value   = '1';
			f[ 4 ].value   = '80,443';
		}
		ss_acl.footerSet = function(c, b) {
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
		ss_acl.dataToFieldValues = function (data) {
			return [data[0], data[1], data[2], data[3], data[4]];
		}
		ss_acl.setup = function() {
			this.init( 'ss_acl_pannel', '', 254, [
			{ type: 'select',maxlen:20,options:option_arp_list},	//name
			{ type: 'text',maxlen:20},	//name
			{ type: 'text',maxlen:20},	//name
			{ type: 'select',maxlen:20,options:option_acl_mode},	//control
			{ type: 'select',maxlen:20,options:option_acl_port}	//port
			] );
			this.headerSet( [ '主机别名', '主机IP地址', 'MAC地址', '访问控制' , '目标端口' ] );
			if (typeof(dbus["ss_acl_node_max"]) == "undefined"){
				this.footerSet( [ '<small id="footer_name" style="color:#1bbf35"><i>缺省规则</i></small>','<small id="footer_ip" style="color:#1bbf35"><i>全部主机 - ip</i></small>','<small id="footer_mac" style="color:#1bbf35"><i>全部主机 - mac</small></i>','<select id="_ss_acl_default_mode" name="ss_acl_default_mode" style="border: 0px solid #222;background: transparent;margin-left:-4px;padding:-0 -0;height:16px;"><option value="0">不通过SS</option><option value="1">gfwlist模式</option><option value="2">大陆白名单模式</option><option value="3">游戏模式</option><option value="4">全局模式</option></select>','<select id="_ss_acl_default_port" name="ss_acl_default_port" style="border: 0px solid #222;background: transparent;margin-left:-4px;padding:-0 -0;height:16px;"><option value="80,443">80,443</option><option value="22,80,443">22,80,443</option><option value="all">all</option></select>']);
			}else{
				this.footerSet( [ '<small id="footer_name" style="color:#1bbf35"><i>缺省规则</i></small>','<small id="footer_ip" style="color:#1bbf35"><i>其它主机 - ip</i></small>','<small id="footer_mac" style="color:#1bbf35"><i>其它主机 - mac</small></i>','<select id="_ss_acl_default_mode" name="ss_acl_default_mode" style="border: 0px solid #222;background: transparent;margin-left:-4px;padding:-0 -0;height:16px;"><option value="0">不通过SS</option><option value="1">gfwlist模式</option><option value="2">大陆白名单模式</option><option value="3">游戏模式</option><option value="4">全局模式</option></select>','<select id="_ss_acl_default_port" name="ss_acl_default_port" style="border: 0px solid #222;background: transparent;margin-left:-4px;padding:-0 -0;height:16px;"><option value="80,443">80,443</option><option value="22,80,443">22,80,443</option><option value="all">all</option></select>']);
			}
			if(typeof(dbus["ss_acl_default_mode"]) != "undefined" ){
				E("_ss_acl_default_mode").value = dbus["ss_acl_default_mode"];
			}else{
				E("_ss_acl_default_mode").value = dbus["ss_basic_mode"] || 2;
			}
			if(typeof(dbus["ss_acl_default_port"]) != "undefined" ){
				E("_ss_acl_default_port").value = dbus["ss_acl_default_port"];
			}else{
				E("_ss_acl_default_port").value = "all";
			}
			for ( var i = 1; i <= dbus["ss_acl_node_max"]; i++){
				var t = [dbus["ss_acl_name_" + i ], 
						dbus["ss_acl_ip_" + i ]  || "",
						dbus["ss_acl_mac_" + i ]  || "",
						dbus["ss_acl_mode_" + i ],
						dbus["ss_acl_port_" + i ]]
				if ( t.length == 5 ) this.insertData( -1, t );
			}
			this.recolor();
			this.showNewEditor();
			this.resetNewEditor();
			if (E("_ss_acl_default_mode").value != "0"){
				E("_ss_acl_default_mode").value = E("_ss_basic_mode").value || "1";
			}
		}
		//============================================
		function init_ss(){
			tabSelect('app1');
			ss_node.setup();
			ssr_node.setup();
			get_wans_list();
			//get_wans_list2();
			verifyFields();
			auto_node_sel();
			hook_event();
			ping_node();
			setTimeout("get_run_status();", 1000);
		}
   		function ping_node(){
	   		$(window).scrollTop(25);
	   		E("ping_botton").disabled=true;
			if(softcenter == 1){
				return false;
			}
			if (!dbus["ssconf_basic_node_max"] && !dbus["ssrconf_basic_node_max"]){
				return false;
			}
			// refill
			var pings = document.getElementsByClassName('co4');
			for(var i = 0; i<pings.length; i++)	{
				if (pings[i].innerHTML.indexOf("\.") != -1){
					if (pings[i].parentNode.getElementsByClassName('co12').length == 1){ //ssr
						pings[i].parentNode.getElementsByClassName('co12')[0].innerHTML = "测试中..."
					}else{ //ss
						pings[i].parentNode.getElementsByClassName('co10')[0].innerHTML = "测试中..."
					}
				}
			}
			
			var dbus4 = {};
			dbus4["ss_basic_ping_method"] = E("_ss_basic_ping_method").value;
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "ss_ping.sh", "params":[], "fields": dbus4};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function(response){
					var ps=eval(Base64.decode(response.result));
					//console.log(ps);
					//var pings = document.getElementsByClassName('co4');
					for(var i = 0; i<ps.length; i++){
						var nu = parseInt(ps[i][0]) + 1;
						var type = ps[i][1];
						var ping = parseInt(ps[i][2]);
						var loss = ps[i][3];
						if (!ping){
							if(E("_ss_basic_ping_method").value == 1){
								test_result = '<font color="#990000">failed</font>';
							}else{
								test_result = '<font color="#990000">failed / ' + loss + '</font>';
							}
						}else{
							if(E("_ss_basic_ping_method").value == 1){
								$('#ss_node-grid > tbody > tr:nth-child(1) > td.header.co10')[0].innerHTML = "ping"
								$('#ssr_node-grid > tbody > tr:nth-child(1) > td.header.co12')[0].innerHTML = "ping"
								if (ping < 50){
									test_result = '<font color="#1bbf35">' + parseFloat(ping).toPrecision(3) +'  ms</font>';
								}else if (ping > 50 && ping <= 100) {
									test_result = '<font color="#3399FF">' + parseFloat(ping).toPrecision(3) +'  ms</font>';
								}else{
									test_result = '<font color="#f36c21">' + parseFloat(ping).toPrecision(3) +'  ms</font>';
								}
							}else{
								$('#ss_node-grid > tbody > tr:nth-child(1) > td.header.co10')[0].innerHTML = "ping / 丢包"
								$('#ssr_node-grid > tbody > tr:nth-child(1) > td.header.co12')[0].innerHTML = "ping / 丢包"
								if (ping <= 50){
									test_result = '<font color="#1bbf35">' + parseFloat(ping).toPrecision(3) +'  ms / ' + loss + '</font>';
								}else if (ping > 50 && ping <= 100) {
									test_result = '<font color="#3399FF">' + parseFloat(ping).toPrecision(3) +'  ms / ' + loss + '</font>';
								}else{
									test_result = '<font color="#f36c21">' + parseFloat(ping).toPrecision(3) +'  ms / ' + loss + '</font>';
								}
							}
						}
						if (type == "ssr"){
							$('#ssr_node-grid > tbody > tr:nth-child(' + nu + ') > td.co12')[0].innerHTML = test_result
						}else if (type == "ss"){
							$('#ss_node-grid > tbody > tr:nth-child(' + nu + ') > td.co10')[0].innerHTML = test_result
						}
					}
	   				E("ping_botton").disabled=false;
				},
				error:function(){
					console.log("23333");
				}
			});
		}

		function hook_event(){
			// when click log content, stop scrolling
			$("#_ss_basic_log").click(
				function() {
				x = 10000000;
			});
		}
		function join_node(){
			if (typeof(dbus["ssconf_basic_node_max"]) == "undefined" && typeof(dbus["ssrconf_basic_node_max"]) == "undefined"){
				node_ss = 1;
			}else if (typeof(dbus["ssconf_basic_node_max"]) == "undefined"){
				node_ss = 0;
			}else{
				node_ss = parseInt(dbus["ssconf_basic_node_max"]);
			}
			node_ssr = parseInt(dbus["ssrconf_basic_node_max"]) || 0;
			
			if (dbus["ss_lb_enable"] == 1){
				if (dbus["ss_lb_type"] == 1 && dbus["ss_lb_node_max"]){
					option_node_name[0] = ["0", "【SS】负载均衡"];
					option_node_addr[0] = ["0", "0"];
				}else if (dbus["ss_lb_type"] == 2 && dbus["ss_lb_node_max"]){
					option_node_name[0] = ["0", "【SSR】负载均衡"];
					option_node_addr[0] = ["0", "0"];
				}else{
					option_node_name[0] = ["0", "负载均衡(尚未定义节点)"];
					option_node_addr[0] = ["0", "0"];
				}
				
				for ( var i = 1; i <= node_ss; i++){
					option_node_name[i] = [ i, "【SS】" + dbus["ssconf_basic_name_" + i]];
					option_node_addr[i] = [ dbus["ssconf_basic_server_" + i], "【SS】" + dbus["ssconf_basic_name_" + i]];
				}
				for ( var i = node_ss + 1; i <= (node_ss + node_ssr); i++){
					option_node_name[i] = [ i, "【SSR】" + dbus["ssrconf_basic_name_" + ( i - node_ss)]];
					option_node_addr[i] = [ dbus["ssrconf_basic_server_" + ( i - node_ss)], "【SSR】" + dbus["ssrconf_basic_name_" + ( i - node_ss)]];
				}
				
			}else{
				for ( var i = 0; i < node_ss; i++){
					option_node_name[i] = [ ( i + 1), "【SS】" + dbus["ssconf_basic_name_" + ( i + 1)]];
					option_node_addr[i] = [ dbus["ssconf_basic_server_" + ( i + 1)], "【SS】" + dbus["ssconf_basic_name_" + ( i + 1)]];
				}
				for ( var i = node_ss; i < (node_ss + node_ssr); i++){
					option_node_name[i] = [ ( i + 1), "【SSR】" + dbus["ssrconf_basic_name_" + ( i + 1 - node_ss)]];
					option_node_addr[i] = [ dbus["ssrconf_basic_server_" + (i + 1 - node_ss)], "【SSR】" + dbus["ssrconf_basic_name_" + ( i + 1 - node_ss)]];
				}
			}
		}
		function get_dbus_data(){
			$.ajax({
			  	type: "GET",
			 	url: "/_api/ss",
			  	dataType: "json",
			  	async:false,
			 	success: function(data){
			 	 	dbus = data.result[0];
					$('#_ss_version').html( '<a style="margin-left:-4px" href="https://github.com/koolshare/ledesoft/blob/master/shadowsocks/Changelog.txt" target="_blank"><font color="#0099FF">shadowsocks for LEDE  ' + (dbus["ss_basic_version"]  || "") + '</font></a>' );
			  	}
			});
		}
		
		function get_run_status(){
			if (status_time > 999999){
				return false;
			}
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "ss_status.sh", "params":[2], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async: true,
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					var ss_status = response.result.split("@@");
					//console.log(ss_status)
					if(softcenter == 1){
						return false;
					}
					++status_time;
					if (response.result == '-2'){
						E("_ss_basic_status_foreign").innerHTML = "获取运行状态失败！";
						E("_ss_basic_status_china").innerHTML = "获取运行状态失败！";
						setTimeout("get_run_status();", (status_refresh_rate * 1000));
					}else{
						if(dbus["ss_basic_enable"] == "0"){
							E("_ss_basic_status_foreign").innerHTML = "国外链接 - 尚未提交，暂停获取状态！";
							E("_ss_basic_status_china").innerHTML = "国内链接 - 尚未提交，暂停获取状态！";
						}else{
							E("_ss_basic_status_foreign").innerHTML = ss_status[0];
							E("_ss_basic_status_china").innerHTML = ss_status[1];
							if (ss_status[2]){
								$("#_ss_basic_kcp_status").parent().show();
								$("#_ss_basic_kcp_status").html(ss_status[2])
								$("#ss_status_title").css("padding", "25.5px 10px");
							}else{
								$("#_ss_basic_kcp_status").parent().hide();
							}
							if (ss_status[3]){
								$("#_ss_basic_lb_status").parent().show();
								$("#_ss_basic_lb_status").html(ss_status[3])
								$("#ss_status_title").css("padding", "25.5px 10px");
							}else{
								$("#_ss_basic_lb_status").parent().hide();
							}
						}
						setTimeout("get_run_status();", (status_refresh_rate * 1000));
					}
				},
				error: function(){
					if(softcenter == 1){
						return false;
					}
					E("_ss_basic_status_foreign").innerHTML = "获取运行状态失败！";
					E("_ss_basic_status_china").innerHTML = "获取运行状态失败！";
					setTimeout("get_run_status();", (status_refresh_rate * 1000));
				}
			});
		}

		function mwan_set(){
			lb.setup();
			for ( var i = 0; i < wans.length; ++i ) {
				$("#_ss_mwan_ping_dst").append("<option value='"  + wans[i][0] + "'>" + wans[i][1] + "</option>");
				$("#_ss_mwan_china_dns_dst").append("<option value='"  + wans[i][0] + "'>" + wans[i][1] + "</option>");
				$("#_ss_mwan_vps_ip_dst").append("<option value='"  + wans[i][0] + "'>" + wans[i][1] + "</option>");
				$("#_ss_lb_dest").append("<option value='"  + wans[i][0] + "'>" + wans[i][1] + "</option>");
			}
			// fill the 3 input
			if(wans.length > 1){
				E("_ss_mwan_ping_dst").value = dbus["ss_mwan_ping_dst"] || "0";
				E("_ss_mwan_china_dns_dst").value = dbus["ss_mwan_china_dns_dst"] || "0";
				E("_ss_mwan_vps_ip_dst").value = dbus["ss_mwan_vps_ip_dst"] || "0";
				E("_ss_lb_dest").value = dbus["ss_lb_dst"] || "0";
			}else if (wans.length == 0){
				E("_ss_mwan_ping_dst").value = "0";
				E("_ss_mwan_china_dns_dst").value = "0";
				E("_ss_mwan_vps_ip_dst").value = "0";
				E("_ss_lb_dest").value = "0";
			}else{
				E("_ss_mwan_ping_dst").value = wans[0][0];
				E("_ss_mwan_china_dns_dst").value = wans[0][0];
				E("_ss_mwan_vps_ip_dst").value = wans[0][0];
				E("_ss_lb_dest").value = wans[0][0];
			}
			for ( var i = 0; i < wans.length; ++i ) {
				wans_value[i] = wans[i][0];
			}
			// now fill the dest in lb table
			if (dbus["ss_lb_type"] == "1"){
				if(ss_lb_nodes.length > 0){
					for ( var i = 0; i < ss_lb_nodes.length; ++i ) {
						if(wans.length > 1){
							var a = wans_value.indexOf(dbus["ssconf_basic_lb_dest_" + ss_lb_nodes[i]]);
							if(a != -1){
								$("#_ssconf_basic_lb_dest_" + ss_lb_nodes[i]).val(dbus["ssconf_basic_lb_dest_" + ss_lb_nodes[i]]);
							}else{
								// the user defined iface is offline
								$("#_ssconf_basic_lb_dest_" + ss_lb_nodes[i]).val("0");
							}
						}else if (wans.length == 0){
							$("#_ssconf_basic_lb_dest_" + ss_lb_nodes[i]).val("0");
						}else{
							$("#_ssconf_basic_lb_dest_" + ss_lb_nodes[i]).val(wans[0][0]);
						}
					}
				}
			}else{
				if(ssr_lb_nodes.length > 0){
					for ( var i = 0; i < ssr_lb_nodes.length; ++i ) {
						if(wans.length > 1){
							var a = wans_value.indexOf(dbus["ssrconf_basic_lb_dest_" + ssr_lb_nodes[i]]);
							if(a != -1){
								$("#_ssrconf_basic_lb_dest_" + ssr_lb_nodes[i]).val(dbus["ssrconf_basic_lb_dest_" + ssr_lb_nodes[i]]);
							}else{
								// the user defined iface is offline
								$("#_ssrconf_basic_lb_dest_" + ssr_lb_nodes[i]).val("0");
							}
						}else if (wans.length == 0){
							$("#_ssrconf_basic_lb_dest_" + ssr_lb_nodes[i]).val("0");
						}else{
							$("#_ssrconf_basic_lb_dest_" + ssr_lb_nodes[i]).val(wans[0][0]);
						}
					}
				}
			}
		}
		function get_wans_list(){
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "ss_getwans.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				async:true,
				cache:false,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function(response){
					if (response.result != "-1"){
						wans = eval(Base64.decode(response.result));
						wans  = wans.sort();
						if(wans.length > 1){
							wans.unshift(["0","不指定"]);
						}else if (wans.length == 0){
							wans = [["0","不指定"]];
						}
						console.log("当前接口信息(主用)：", wans);
						mwan_set()
					}
				},
				error:function(){
					get_wans_list2();
				},
				timeout:1000
			});
		}
		
		function get_wans_list2(){
			XHR.get('/cgi-bin/luci/admin/network/mwan/overview/interface_status', null,
				function(x, mArray){
					if (mArray.wans){
						for ( var i = 0; i < mArray.wans.length; i++ ){
							if(mArray.wans[i].status == "online"){
								var wans2_temp = [];
								wans2_temp[0] = mArray.wans[i].ifname
								wans2_temp[1] = mArray.wans[i].name
								wans2.push(wans2_temp);
							}
						}
						wans2 = wans2.sort();
                        if(wans2.length > 1){
                            wans2.unshift(["0","不指定"]);
                        }else if (wans2.length == 0){
                            wans2 = [["0","不指定"]];
                        }
                        console.log("当前接口信息(备用)：", wans2);
                        wans = wans2;
                        mwan_set();
					}else{
						statusDiv.innerHTML = '<strong>没有找到 MWAN 接口</strong>';
						alert("没有找到任何可用的wan接口！\n 请检查你的网络接口设置！")
					}
				}
			);
		}
		
		function get_arp_list(){
			var id5 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id5, "method": "ss_getarp.sh", "params":[], "fields": ""};
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
							option_arp_local[i] = [s2[ i ].split( '<' )[0], "【" + s2[ i ].split( '<' )[0] + "】", s2[ i ].split( '<' )[1], s2[ i ].split( '<' )[2]];
						}
						var node_acl = parseInt(dbus["ss_acl_node_max"]) || 0;
						for ( var i = 0; i < node_acl; ++i ) {
							option_arp_web[i] = [dbus["ss_acl_name_" + (i + 1)], "【" + dbus["ss_acl_name_" + (i + 1)] + "】", dbus["ss_acl_ip_" + (i + 1)], dbus["ss_acl_mac_" + (i + 1)]];
						}			
						option_arp_list = unique_array(option_arp_local.concat( option_arp_web ));
						ss_acl.setup();
					}
				},
				error:function(){
					ss_acl.setup();
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
		function auto_node_sel(){
			node_sel = E('_ss_basic_node').value || 1;
			if (node_sel == 0){
				if (dbus["ss_lb_enable"] == 1 && dbus["ss_lb_node_max"]){
					if (dbus["ss_lb_type"] == 1){ //ss
						dbus["ss_basic_type"] = "0";
						E('_ss_basic_rss_protocal').value = ""
						E('_ss_basic_rss_protocal_para').value = ""
						E('_ss_basic_rss_obfs').value = ""
						E('_ss_basic_rss_obfs_para').value = ""

						last_lb_node=parseInt(dbus["ss_lb_node_ex"]);
						for (var i = 0; i < ssbasic.length; i++) {
							if (typeof (dbus["ssconf_basic_" + ssbasic[i] + "_" + last_lb_node]) == "undefined"){
								E('_ss_basic_' + ssbasic[i] ).value = ""
							}else{
								E('_ss_basic_' + ssbasic[i] ).value = dbus["ssconf_basic_" + ssbasic[i] + "_" + last_lb_node] || "";
							}
						}
						elem.display(PR('_ss_basic_rss_protocal'), PR('_ss_basic_rss_protocal_para'), false);
						elem.display(PR('_ss_basic_rss_obfs'), PR('_ss_basic_rss_obfs_para'), false);
						var a = (E('_ss_basic_ss_obfs').value == '0');
						elem.display(PR('_ss_basic_ss_obfs'), PR('_ss_basic_ss_obfs_host'), !a);
						elem.display(PR('_ss_basic_mode'), true);
						E('_ss_basic_server').value = "127.0.0.1";
						E('_ss_basic_port').value = dbus["ss_lb_port"];
						E('_ss_basic_mode').value = dbus["ss_basic_mode"];
					}else if (dbus["ss_lb_type"] == 2){ //ssr
						dbus["ss_basic_type"] = "1";
						last_lb_node=parseInt(dbus["ss_lb_node_ex"]);
						for (var i = 0; i < ssrbasic.length; i++) {
							if (typeof (dbus["ssrconf_basic_" + ssrbasic[i] + "_" + last_lb_node]) == "undefined"){
								E('_ss_basic_' + ssrbasic[i] ).value = ""
							}else{
								E('_ss_basic_' + ssrbasic[i] ).value = dbus["ssrconf_basic_" + ssrbasic[i] + "_" + last_lb_node] || "";
							}
						}
						elem.display(PR('_ss_basic_rss_protocal'), true);
						elem.display(PR('_ss_basic_rss_protocal_para'), (E('_ss_basic_rss_protocal_para').value.length > 1));
						elem.display(PR('_ss_basic_rss_obfs'), PR('_ss_basic_rss_obfs_para'), true);
						elem.display(PR('_ss_basic_ss_obfs'), PR('_ss_basic_ss_obfs_host'), false);
						elem.display(PR('_ss_basic_mode'), true);
						E('_ss_basic_server').value = "127.0.0.1";
						E('_ss_basic_port').value = dbus["ss_lb_port"];
						E('_ss_basic_mode').value = dbus["ss_basic_mode"];
					}else{
						alert("尚未定义需要负载均衡的节点！");
						return false;
					}
				}else{
					alert("未启用负载均衡");
					return false;
				}
			}else{ //not lb
				if (dbus["ssrconf_basic_rss_protocal_" + (node_sel - node_ss)]){ // using ssr
					dbus["ss_basic_type"] = "1";
					for (var i = 0; i < ssrbasic.length; i++) {
						if (typeof (dbus["ssrconf_basic_" + ssrbasic[i] + "_" + (node_sel - node_ss)]) == "undefined"){
							E('_ss_basic_' + ssrbasic[i] ).value = ""
						}else{
							E('_ss_basic_' + ssrbasic[i] ).value = dbus["ssrconf_basic_" + ssrbasic[i] + "_" + (node_sel - node_ss)] || "";
						}
					}
					elem.display(PR('_ss_basic_rss_protocal'), true);
					elem.display(PR('_ss_basic_rss_protocal_para'), (E('_ss_basic_rss_protocal_para').value.length > 1));
					elem.display(PR('_ss_basic_rss_obfs_para'), (E('_ss_basic_rss_obfs_para').value.length > 1));
					elem.display(PR('_ss_basic_rss_obfs'), true);
					elem.display(PR('_ss_basic_ss_obfs'), PR('_ss_basic_ss_obfs_host'), false);
					elem.display(PR('_ss_basic_mode'), true);
				}else{ //using ss
					dbus["ss_basic_type"] = "0";
					E('_ss_basic_rss_protocal').value = ""
					E('_ss_basic_rss_protocal_para').value = ""
					E('_ss_basic_rss_obfs').value = ""
					E('_ss_basic_rss_obfs_para').value = ""
					for (var i = 0; i < ssbasic.length; i++) {
						if (typeof (dbus["ssconf_basic_" + ssbasic[i] + "_" + node_sel]) == "undefined"){
							E('_ss_basic_' + ssbasic[i] ).value = ""
						}else{
							E('_ss_basic_' + ssbasic[i] ).value = dbus["ssconf_basic_" + ssbasic[i] + "_" + node_sel];
						}
					}
					var s = E('_ss_basic_ss_obfs').value == 0;
					elem.display(PR('_ss_basic_rss_protocal'), PR('_ss_basic_rss_protocal_para'), false);
					elem.display(PR('_ss_basic_rss_obfs'), PR('_ss_basic_rss_obfs_para'), false);
					elem.display(PR('_ss_basic_ss_obfs'), PR('_ss_basic_ss_obfs_host'), !s);
					elem.display(PR('_ss_basic_mode'), true);
				}
			}
		}

		function verifyFields(r){
			// pannel1: when node changed, the main pannel element and other element should be changed, too.
			if ( $(r).attr("id") == "_ss_basic_node" ) {
				auto_node_sel();
			}
			// pannel1: when check/uncheck ss_switch
			var a  = E('_ss_basic_enable').checked;
			if ( $(r).attr("id") == "_ss_basic_enable" ) {
				if(a){
					elem.display('ss_status_pannel', a);
					elem.display('ss_tabs', a);
					if (!dbus["ssconf_basic_node_max"] && !dbus["ssrconf_basic_node_max"]){
						tabSelect('app2');
						//alert("还没有任何节点，请先在节点管理面板添加你的节点！");
					}else{
						tabSelect('app1');
					}
				}else{
					tabSelect('fuckapp');
				}
			}
			// pannel1: when change mode, the default acl mode should be also changed
			if ( $(r).attr("id") == "_ss_basic_mode" ) {
				if (E("_ss_acl_default_mode").value != "0"){
					E("_ss_acl_default_mode").value = E("_ss_basic_mode").value;
				}
			}
			// pannel kcp: hide kcp panel when kcp not enable
			var t  = E('_ss_kcp_enable').checked;
			elem.display('app9-tab', !t);
			// pannel kcp: hide kcp parameter panel when kcp not enable
			if ( $(r).attr("id") == "_ss_kcp_enable" ) {
				elem.display('ss_kcp_tab_2', t);
			}
			// pannel lb: hide kcp pannel when lb enabled
			var s = E('_ss_lb_enable').checked;
			elem.display('app10-tab', !s);
			// pannel dns: display the description for ss dns plan
			if (E("_ss_dns_plan").value == "1"){
				$('#_ss_dns_plan_txt').html("国外dns解析gfwlist名单内的国外域名，剩下的所有域名用国内dns解析。")
			}else{
				$('#_ss_dns_plan_txt').html("国内dns解析cdn名单内的国内域名用，剩下的所有域名用国外dns解析。")
			}
			// pannel dns:
			if (E("_ss_dns_foreign").value == "5"){
				elem.display(PR('_ss_dns_china'), false);
				elem.display(PR('_ss_isp_website_web'), false);
				elem.display(PR('_ss_dns_china_chinadns_txt'), true);
				elem.display(PR('_ss_cdn_chinadns_txt'), true);
				elem.display(PR('_ss_dns_china_pcap_txt'), false);
				elem.display(PR('_ss_cdn_pcap_txt'), false);
			}else if (E("_ss_dns_foreign").value == "6"){
				elem.display(PR('_ss_dns_china'), false);
				elem.display(PR('_ss_isp_website_web'), false);
				elem.display(PR('_ss_dns_china_chinadns_txt'), false);
				elem.display(PR('_ss_cdn_chinadns_txt'), false);
				elem.display(PR('_ss_dns_china_pcap_txt'), true);
				elem.display(PR('_ss_cdn_pcap_txt'), true);
			}else{
				elem.display(PR('_ss_dns_china'), true);
				elem.display(PR('_ss_isp_website_web'), true);
				elem.display(PR('_ss_dns_china_chinadns_txt'), false);
				elem.display(PR('_ss_dns_china_pcap_txt'), false);
				elem.display(PR('_ss_cdn_chinadns_txt'), false);
				elem.display(PR('_ss_cdn_pcap_txt'), false);
			}
			var c  = E('_ss_dns_china').value == '12';
			var d1 = E('_ss_dns_foreign').value == '1'; // dns2socks
			var d2 = E('_ss_dns_foreign').value == '2'; // ss-tunnel
			var d3 = E('_ss_dns_foreign').value == '3'; // dnscrypt-proxy
			var d4 = E('_ss_dns_foreign').value == '4'; // pndsd
			var d5 = E('_ss_dns_foreign').value == '5'; // ChinaDNS
			var d6 = E('_ss_dns_foreign').value == '6'; // ChinaDNS
			var e  = E('_ss_sstunnel').value == '4'; // ss_sstunnel user
			var f1 = E('_ss_pdnsd_method').value == '1'; // pdnsd udp
			var f2 = E('_ss_pdnsd_method').value == '2'; // pdnsd tcp
			var g1 = E('_ss_pdnsd_udp_server').value == '1'; // pdnsd dns2socks
			var g2 = E('_ss_pdnsd_udp_server').value == '2'; // pdnsd dnscrypt-proxy
			var g3 = E('_ss_pdnsd_udp_server').value == '3'; // pdnsd ss_tunnel
			var h  = E('_ss_pdnsd_udp_server_ss_tunnel').value == '4'; // pdnsd ss_tunnel = 4
			var i  = E('_ss_chinadns_china').value == '11'; // ChinaDNS china user
			var j1 = E('_ss_chinadns_foreign_method').value == '1'; // ChinaDNS dns2socks
			var j2 = E('_ss_chinadns_foreign_method').value == '2'; // ChinaDNS dnscrypt-proxy
			var j3 = E('_ss_chinadns_foreign_method').value == '3'; // ChinaDNS ss_tunnel
			var j4 = E('_ss_chinadns_foreign_method').value == '4'; // ChinaDNS user
			var k  = E('_ss_chinadns_foreign_sstunnel').value == '4'; // ChinaDNS user
			var n  = E('_ss_chinadns_foreign_dns2socks').value == '4'; // ChinaDNS user
			// DNS
			elem.display('_ss_dns_china_user', c);
			elem.display('_ss_dns2socks_user', d1);
			elem.display('_ss_sstunnel', d2);
			elem.display('_ss_sstunnel_user', d2 && e);
			elem.display('_ss_opendns', d3);
			// pdnsd method
			elem.display(PR('_ss_pdnsd_method'), d4);
			// pdnsd udp
			elem.display(PR('_ss_pdnsd_udp_server'), d4 && f1);
			elem.display('_ss_pdnsd_udp_server_dns2socks', d4 && f1 && g1);
			elem.display('_ss_pdnsd_udp_server_dnscrypt', d4 && f1 && g2);
			elem.display('_ss_pdnsd_udp_server_ss_tunnel', d4 && f1 && g3);
			elem.display('_ss_pdnsd_udp_server_ss_tunnel_user', d4 && f1 && g3 && h);
			// pdnsd tcp
			elem.display(PR('_ss_pdnsd_server_ip'), PR('_ss_pdnsd_server_port'), d4 && f2);
			// pndsd cache
			elem.display(PR('_ss_pdnsd_server_cache_min'), PR('_ss_pdnsd_server_cache_max'), d4);
			//ChinaDNS
			elem.display(PR('_ss_chinadns_china'), d5);
			elem.display('_ss_chinadns_china_user', d5 && i);
			elem.display(PR('_ss_chinadns_foreign_method'), d5);
			elem.display('_ss_chinadns_foreign_dns2socks', d5 && j1);
			elem.display('_ss_chinadns_foreign_dns2socks_user', d5 && j1 && n);
			elem.display('_ss_chinadns_foreign_dnscrypt', d5 && j2);
			elem.display('_ss_chinadns_foreign_sstunnel', d5 && j3);
			elem.display('_ss_chinadns_foreign_sstunnel_user', d5 && j3 && k);
			elem.display('_ss_chinadns_foreign_method_user', d5 && j4);
			elem.display('_ss_chinadns_foreign_method_user_txt', d5 && j4);
			var l  = E('_ss_basic_rule_update').value == '1'; // ChinaDNS user
			elem.display('_ss_basic_rule_update_time', l);
			elem.display(elem.parentElem('_ss_basic_gfwlist_update', 'DIV'), l);
			elem.display('_ss_basic_gfwlist_update_txt', l);
			elem.display(elem.parentElem('_ss_basic_chnroute_update', 'DIV'), l);
			elem.display('_ss_basic_chnroute_update_txt', l);
			elem.display(elem.parentElem('_ss_basic_cdn_update', 'DIV'), l);
			elem.display('_ss_basic_cdn_update_txt', l);
			elem.display('_update_rules_now', l);
			var m  = E('_ss_basic_dnslookup').value == '1';
			elem.display('_ss_basic_dnslookup_server', m);
			elem.display('_ss_basic_dnslookup_txt', m);
			var p1 = E('_ssr_subscribe_obfspara').value == '1';
			var p2 = E('_ssr_subscribe_obfspara').value == '2';
			elem.display('_ssr_subscribe_obfspara_text', p1);
			elem.display('_ssr_subscribe_obfspara_val', p2);

			calculate_max_node();
		}
		function calculate_max_node(){
			var all_names_ss = [];
			var all_names_ssr = [];
			var all_names_sslb = [];
			var all_names_ssrlb = [];
			var all_nodes_of_ss = [];
			var all_nodes_of_ssr = [];
			var all_nodes_of_sslb = [];
			var all_nodes_of_ssrlb = [];
			//--------------------------------------
			// count node in ss
			for (var field in dbus) {
				names_ss = field.split("ssconf_basic_port_");
				all_names_ss.push(names_ss)
			}
			
			for ( var i = 0; i < all_names_ss.length; i++){
				if (all_names_ss[i][0] == ""){
					all_nodes_of_ss.push(all_names_ss[i][1]);
				}
			}
			if(all_nodes_of_ss.length > 0){
				dbus["ssconf_basic_max_node"] = Math.max.apply(null, all_nodes_of_ss);
			}else{
				dbus["ssconf_basic_max_node"] = "";
			}
			dbus["ssconf_basic_node_max"] = all_nodes_of_ss.length;
			//--------------------------------------
			// count node in ssr
			for (var field in dbus) {
				names_ssr = field.split("ssrconf_basic_port_");
				all_names_ssr.push(names_ssr)
			}	
			
			for ( var i = 0; i < all_names_ssr.length; i++){
				if (all_names_ssr[i][0] == ""){
					all_nodes_of_ssr.push(all_names_ssr[i][1]);
				}
			}
			if(all_nodes_of_ssr.length > 0){
				dbus["ssrconf_basic_max_node"] = Math.max.apply(null, all_nodes_of_ssr);
			}else{
				dbus["ssrconf_basic_max_node"] = "";
			}
			dbus["ssrconf_basic_node_max"] = all_nodes_of_ssr.length;
		}
		function tabSelect(obj){
			var tableX = ['app1-tab','app2-tab','app9-tab', 'app10-tab', 'app11-tab', 'app3-tab','app4-tab','app5-tab','app6-tab','app7-tab','app8-tab'];
			var boxX = ['boxr1','boxr2','boxr9','boxr10', 'boxr11', 'boxr3','boxr4', 'boxr5', 'boxr6', 'boxr7', 'boxr8'];
			var appX = ['app1','app2','app9','app10', 'app11', 'app3','app4','app5','app6','app7','app8'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			// here defined pannel level element hide/show
			// show hide ss basic pannel when ss loaded
			if(obj =='app1'){ // 节点
				var b  = E('_ss_basic_enable').checked;
				elem.display('ss_status_pannel', b);
				elem.display('ss_tabs', b);
				elem.display('ss_basic_tab', b);
			}
			// show hide some button and pannel when cliec tab
			if(obj =='app2'){ // 节点
				E('save-button').style.display = "none";
				E('save-node').style.display = "";
				E('save-lb').style.display = "none";
				E('save-kcp').style.display = "none";
				elem.display('ss_kcp_tab_2', false);
			}else if(obj=='app9'){ // 负载均衡
				E('save-button').style.display = "none";
				E('save-node').style.display = "none";
				E('save-lb').style.display = "";
				E('save-kcp').style.display = "none";
				elem.display('ss_kcp_tab_2', false);
			}else if(obj=='app10'){ // kcp
				var a = E('_ss_kcp_enable').checked;
				E('save-button').style.display = "none";
				E('save-node').style.display = "none";
				E('save-lb').style.display = "none";
				E('save-kcp').style.display = "";
				// hide kcp parameter pannel when kcp not enabled
				elem.display('ss_kcp_tab_2', a);
			}else if(obj=='app8'){ //日志
				elem.display('save-button', false);
				elem.display('save-node', false);
				elem.display('save-lb', false);
				elem.display('save-kcp', false);
				elem.display('cancel-button', false);
				elem.display('ss_kcp_tab_2', false);
				noChange=0;
				setTimeout("get_log();", 200);
			}else if(obj=='fuckapp'){
				elem.display('ss_status_pannel', false);
				elem.display('ss_tabs', false);
				elem.display('ss_basic_tab', false);
				elem.display('ss_node_tab', false);
				elem.display('ssr_node_tab', false);
				elem.display('ss_dns_tab', false);
				elem.display('ss_wblist_tab', false);
				elem.display('ss_rule_tab', false);
				elem.display('ss_acl_tab', false);
				elem.display('ss_acl_tab_readme', false);
				elem.display('ss_addon_tab', false);
				elem.display('ss_log_tab', false);
				elem.display('ss_lb_tab', false);
				elem.display('lb_list', false);
				elem.display('ss_lb_tab_readme', false);
				elem.display('ss_kcp_tab_readme', false);
				elem.display('ss_kcp_tab_1', false);
				elem.display('ss_kcp_tab_2', false);
				//elem.display('ss_socks5_tab', false);
				E('save-button').style.display = "";
				E('save-node').style.display = "none";
				E('save-lb').style.display = "none";
				E('save-kcp').style.display = "none";
			}else{
				E('save-button').style.display = "";
				E('save-node').style.display = "none";
				E('save-lb').style.display = "none";
				E('save-kcp').style.display = "none";
				elem.display('ss_kcp_tab_2', false);
				elem.display('cancel-button', true);
				noChange=2001;
			}
		}
		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}
		function save_node(){
			XHR.halt();
			status_time = 999999990;
			// ss: collect node data from ss pannel
			var skipd;
			$.ajax({
			  	type: "GET",
			 	url: "/_api/ss",
			  	dataType: "json",
			  	async:true,
			 	success: function(data){
			 	 	skipd = data.result[0];
					var data = ss_node.getAllData();
					if(data.length > 0){
						// ss: rewrite ss node data
						for ( var i = 0; i < data.length; ++i ) {
							for ( var j = 0; j < ssconf.length; ++j ) {
								dbus[ssconf[j] + (i + 1)] = data[i][j + 1] || "";
								dbus["ssconf_basic_mode_1"] = data[0][1];
							}
							dbus["ssconf_basic_lb_enable_" +  (i + 1)] = dbus["ssconf_basic_lb_enable_" + data[i][0]] || "";
							dbus["ssconf_basic_lb_policy_" +  (i + 1)] = dbus["ssconf_basic_lb_policy_" + data[i][0]] || "";
							dbus["ssconf_basic_lb_weight_" +  (i + 1)] = dbus["ssconf_basic_lb_weight_" + data[i][0]] || "";
							dbus["ssconf_basic_server_ip_" +  (i + 1)] = dbus["ssconf_basic_server_ip_" + data[i][0]] || "";
						}
						// ss: now clean data after node_max
						for ( var i = data.length; i < parseInt(dbus["ssconf_basic_max_node"]); ++i ) {
							for ( var j = 0; j < ssconf.length; ++j ) {
								dbus[ssconf[j] + (i + 1)] =  "";
							}
							dbus["ssconf_basic_lb_enable_" +  (i + 1)] = "";
							dbus["ssconf_basic_lb_policy_" +  (i + 1)] = "";
							dbus["ssconf_basic_lb_weight_" +  (i + 1)] = "";
							dbus["ssconf_basic_server_ip_" +  (i + 1)] = "";
						}
					}else{
						// ss: mark all node data for delete first
						for ( var i = 1; i <= skipd["ssconf_basic_node_max"]; i++){
							for ( var j = 0; j < ssconf.length; ++j ) {
								dbus[ssconf[j] + i ] = ""
							}
						}
						dbus["ssconf_basic_max_node"] = "";
						dbus["ssconf_basic_node_max"] = "";
					}
					
					// ssr: collect node data from ssr pannel
					var data = ssr_node.getAllData();
					if(data.length > 0){
						kcp_node_nu = parseInt(skipd["ss_kcp_node"])
						// ss: rewrite ssr node data
						for ( var i = 0; i < data.length; ++i ) {
							for ( var j = 0; j < ssrconf.length; ++j ) {
								dbus[ssrconf[j] + (i + 1)] = data[i][j + 1] || "";
							}
							dbus["ssrconf_basic_group_" +  (i + 1)] = dbus["ssrconf_basic_group_" + data[i][0]] || "";
							dbus["ssrconf_basic_lb_enable_" +  (i + 1)] = dbus["ssrconf_basic_lb_enable_" + data[i][0]] || "";
							dbus["ssrconf_basic_lb_policy_" +  (i + 1)] = dbus["ssrconf_basic_lb_policy_" + data[i][0]] || "";
							dbus["ssrconf_basic_lb_weight_" +  (i + 1)] = dbus["ssrconf_basic_lb_weight_" + data[i][0]] || "";
							dbus["ssrconf_basic_server_ip_" +  (i + 1)] = dbus["ssrconf_basic_server_ip_" + data[i][0]] || "";
						}
						// ss: now clean data after node_max
						for ( var i = data.length; i < parseInt(dbus["ssrconf_basic_max_node"]); ++i ) {
							for ( var j = 0; j < ssrconf.length; ++j ) {
								dbus[ssrconf[j] + (i + 1)] =  "";
							}
							dbus["ssrconf_basic_group_" +  (i + 1)] = "";
							dbus["ssrconf_basic_lb_enable_" +  (i + 1)] = "";
							dbus["ssrconf_basic_lb_policy_" +  (i + 1)] = "";
							dbus["ssrconf_basic_lb_weight_" +  (i + 1)] = "";
							dbus["ssrconf_basic_server_ip_" +  (i + 1)] = "";
						}
					}else{
						// ssr: mark all node data for delete first
						for ( var i = 1; i <= skipd["ssrconf_basic_node_max"]; i++){
							for ( var j = 0; j < ssrconf.length; ++j ) {
								dbus[ssrconf[j] + i ] = ""
							}
						}
						dbus["ssrconf_basic_max_node"] = "";
						dbus["ssrconf_basic_node_max"] = "";
					}
					// now change kcp node number
					if (kcp_diff != 0){
						dbus["ss_kcp_node"] = parseInt(dbus["ss_kcp_node"]) - kcp_diff;
					}
					// now change ss node nubmer
					if (ss_node_diff){
						dbus["ss_basic_node"] = parseInt(dbus["ss_basic_node"]) - ss_node_diff;
					}

					//now post data
					var id4 = parseInt(Math.random() * 100000000);
					var postData3 = {"id": id4, "method": "ss_conf.sh", "params":[9], "fields": dbus};
					showMsg("msg_warring","保存节点信息！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
					$.ajax({
						url: "/_api/",
						type: "POST",
						async:true,
						cache:false,
						dataType: "json",
						data: JSON.stringify(postData3),
						success: function(response){
							if (response.result == id4){
								$('#msg_warring').hide();
								showMsg("msg_success","保存成功","<b>请稍候，页面将自动刷新...</b>");
								x = 4;
								count_down_switch();
							}else{
								$('#msg_warring').hide();
								showMsg("msg_error","提交失败","<b>提交节点数据失败！错误代码：" + response.result + "</b>");
								return false;
							}
						},
						error: function(){
							showMsg("msg_error","失败","<b>当前系统存在异常查看系统日志！</b>");
						}
					});
			  	}
			});
		}
		function save(){
			status_time = 999999990;
			setTimeout("tabSelect('app8')", 500);
			E("_ss_basic_status_foreign").innerHTML = "国外链接 - 提交中...暂停获取状态！";
			E("_ss_basic_status_china").innerHTML = "国内链接 - 提交中...暂停获取状态！";
			E("_ss_basic_kcp_status").innerHTML = "KCP状态 - 提交中...暂停获取状态！";
			E("_ss_basic_lb_status").innerHTML = "负载均衡 - 提交中...暂停获取状态！";
			var paras_chk = ["enable", "gfwlist_update", "chnroute_update", "cdn_update", "chromecast"];
			var paras_inp = ["ss_basic_node", "ss_basic_mode", "ss_basic_server", "ss_basic_port", "ss_basic_password", "ss_basic_method", "ss_basic_ss_obfs", "ss_basic_ss_obfs_host", "ss_basic_rss_protocal", "ss_basic_rss_protocal_para", "ss_basic_rss_obfs", "ss_basic_rss_obfs_para", "ss_dns_plan", "ss_dns_china", "ss_dns_china_user", "ss_dns_foreign", "ss_dns2socks_user", "ss_sstunnel", "ss_sstunnel_user", "ss_opendns", "ss_pdnsd_method", "ss_pdnsd_udp_server", "ss_pdnsd_udp_server_dns2socks", "ss_pdnsd_udp_server_dnscrypt", "ss_pdnsd_udp_server_ss_tunnel", "ss_pdnsd_udp_server_ss_tunnel_user", "ss_pdnsd_server_ip", "ss_pdnsd_server_port", "ss_pdnsd_server_cache_min", "ss_pdnsd_server_cache_max", "ss_chinadns_china", "ss_chinadns_china_user", "ss_chinadns_foreign_method", "ss_chinadns_foreign_dns2socks", "ss_chinadns_foreign_dnscrypt", "ss_chinadns_foreign_sstunnel", "ss_chinadns_foreign_sstunnel_user", "ss_chinadns_foreign_method_user", "ss_basic_rule_update", "ss_basic_rule_update_time", "ss_basic_refreshrate", "ss_basic_dnslookup", "ss_basic_dnslookup_server", "ss_acl_default_mode", "ss_acl_default_port", "ssr_subscribe_link", "ssr_subscribe_mode", "ssr_subscribe_obfspara", "ssr_subscribe_obfspara_val", "ss_mwan_ping_dst", "ss_mwan_china_dns_dst", "ss_mwan_vps_ip_dst" ];
			// collect data from checkbox
			for (var i = 0; i < paras_chk.length; i++) {
				dbus["ss_basic_" + paras_chk[i]] = E('_ss_basic_' + paras_chk[i] ).checked ? '1':'0';
			}
			// data from other element
			for (var i = 0; i < paras_inp.length; i++) {
				if (typeof(E('_' + paras_inp[i] ).value) == "undefined"){
					dbus[paras_inp[i]] = "";
				}else{
					dbus[paras_inp[i]] = E('_' + paras_inp[i]).value;
				}
			}
			// data need base64 encode
			var paras_base64 = ["ss_wan_white_ip", "ss_wan_white_domain", "ss_wan_black_ip", "ss_wan_black_domain", "ss_isp_website_web", "ss_dnsmasq",];
			for (var i = 0; i < paras_base64.length; i++) {
				if (typeof(E('_' + paras_base64[i] ).value) == "undefined"){
					dbus[paras_base64[i]] = "";
				}else{
					dbus[paras_base64[i]] = Base64.encode(E('_' + paras_base64[i]).value);
				}
			}
			// collect node data under using from the main pannel incase of data change
			node_sel = E('_ss_basic_node').value || 1;
			if (node_sel != 0){
				if (dbus["ssrconf_basic_rss_protocal_" + (node_sel - node_ss)]){ // using ssr
					for ( var i = 0; i < ssrbasic.length; i++){
						if (typeof (E('_ss_basic_' + ssrbasic[i] ).value) == "undefined"){
							dbus["ssrconf_basic_" + ssrbasic[i] + "_" + (node_sel - node_ss) ] = ""
						}else{
							dbus["ssrconf_basic_" + ssrbasic[i] + "_" + (node_sel - node_ss) ] = E('_ss_basic_' + ssrbasic[i] ).value;
						}
					}
				}else{ //ss
					for ( var i = 0; i < ssbasic.length; i++){
						if (typeof (E('_ss_basic_' + ssbasic[i] ).value) == "undefined"){
							dbus["ssconf_basic_" + ssbasic[i] + "_" + node_sel ] = ""
						}else{
							dbus["ssconf_basic_" + ssbasic[i] + "_" + node_sel ] = E('_ss_basic_' + ssbasic[i] ).value;
						}
					}
					// define ss node max when no node
					if (typeof(dbus["ssconf_basic_node_max"]) == "undefined" && typeof(dbus["ssrconf_basic_node_max"]) == "undefined"){
						dbus["ssconf_basic_node_max"] = "1"
						dbus["ssconf_basic_name_1"] = "节点1"
					}
				}
			}
			// collect acl data from acl pannel
			var ss_acl_conf = ["ss_acl_name_", "ss_acl_ip_", "ss_acl_mac_", "ss_acl_mode_", "ss_acl_port_" ];
			// mark all acl data for delete first
			for ( var i = 1; i <= dbus["ss_acl_node_max"]; i++){
				for ( var j = 0; j < ss_acl_conf.length; ++j ) {
					dbus[ss_acl_conf[j] + i ] = ""
				}
			}
			var data4 = ss_acl.getAllData();
			if(data4.length > 0){
				for ( var i = 0; i < data4.length; ++i ) {
					for ( var j = 1; j < ss_acl_conf.length; ++j ) {
						//dbus[ss_acl_conf[0] + (i + 1)] = data4[i][0] || "未命名主机 - " + (i + 1);
						dbus[ss_acl_conf[0] + (i + 1)] = data4[i][0];
						dbus[ss_acl_conf[j] + (i + 1)] = data4[i][j];
					}
				}
				dbus["ss_acl_node_max"] = data4.length;
			}else{
				dbus["ss_acl_node_max"] = "";
			}
			// now post data
			var id3 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id3, "method": "ss_config.sh", "params":[1], "fields": dbus};
			showMsg("msg_warring","正在提交数据！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				type: "POST",
				async:true,
				cache:false,
				dataType: "json",
				data: JSON.stringify(postData3),
				success: function(response){
					if (response.result == id3){
						if(E('_ss_basic_enable').checked){
							// show script running status
							showMsg("msg_success","提交成功","<b>成功提交数据</b>");
							$('#msg_warring').hide();
							setTimeout("$('#msg_success').hide()", 500);
							x = 4;
							count_down_switch();
						}else{
							// when shut down ss finished, close the log tab
							$('#msg_warring').hide();
							showMsg("msg_success","提交成功","<b>shadowsocks成功关闭！</b>");
							setTimeout("$('#msg_success').hide()", 4000);
							setTimeout("tabSelect('fuckapp')", 4000);
						}
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

		function save_lb(){
			status_time = 999999990;
			setTimeout("tabSelect('app8')", 500);
			var lb_chk = ["ss_lb_enable", "ss_lb_heartbeat"];
			var lb_inp = ["ss_lb_account", "ss_lb_password", "ss_lb_port", "ss_lb_up", "ss_lb_down", "ss_lb_interval" ];
			// collect data from checkbox
			for (var i = 0; i < lb_chk.length; i++) {
				dbus[lb_chk[i]] = E('_' + lb_chk[i] ).checked ? '1':'0';
			}
			// data from other element
			for (var i = 0; i < lb_inp.length; i++) {
				if (typeof(E('_' + lb_inp[i] ).value) == "undefined"){
					dbus[lb_inp[i]] = "";
				}else{
					dbus[lb_inp[i]] = E('_' + lb_inp[i]).value;
				}
			}

			// mark all lb value in node date for delete first
			for ( var i = 1; i <= dbus["ssconf_basic_max_node"]; i++){
				dbus["ssconf_basic_lb_enable_" + i ] = ""
				dbus["ssconf_basic_lb_policy_" + i ] = ""
				dbus["ssconf_basic_lb_weight_" + i ] = ""
				dbus["ssconf_basic_lb_dest_" + i ] = ""
			}
			for ( var i = 1; i <= dbus["ssrconf_basic_max_node"]; i++){
				dbus["ssrconf_basic_lb_enable_" + i ] = ""
				dbus["ssrconf_basic_lb_policy_" + i ] = ""
				dbus["ssrconf_basic_lb_weight_" + i ] = ""
				dbus["ssrconf_basic_lb_dest_" + i ] = ""
			}

			// now store lb value in node data
			if (dbus["ss_lb_type"] == "1"){
				var data = lb.getAllData();
				if(data.length > 0){
					for ( var i = 0; i < data.length; ++i ) {
						dbus["ssconf_basic_lb_enable_" + data[i][1] ] = 1;
						dbus["ssconf_basic_lb_policy_" + data[i][1] ] = data[i][7];
						dbus["ssconf_basic_lb_weight_" + data[i][1] ] = data[i][6];
						//dbus["ssconf_basic_lb_dest_" + data[i][1] ] = data[i][5];
						id = $(data[i][5]).attr("id");
						name = $(data[i][5]).attr("name");
						dbus[name] = $("#" + id).val();
					}
					dbus["ss_lb_node_max"] = data.length;
					dbus["ss_basic_type"] = 0;
				}else{
					dbus["ss_lb_node_max"] = "";
					dbus["ss_lb_node_ex"] = "";
				}
			}else{
				var data = lb.getAllData();
				if(data.length > 0){
					for ( var i = 0; i < data.length; ++i ) {
						dbus["ssrconf_basic_lb_enable_" + data[i][1] ] = 1;
						dbus["ssrconf_basic_lb_policy_" + data[i][1] ] = data[i][7];
						dbus["ssrconf_basic_lb_weight_" + data[i][1] ] = data[i][6];
						//dbus["ssrconf_basic_lb_dest_" + data[i][1] ] = data[i][5];
						id = $(data[i][5]).attr("id");
						name = $(data[i][5]).attr("name");
						dbus[name] = $("#" + id).val();
					}
					dbus["ss_lb_node_max"] = data.length;
					dbus["ss_basic_type"] = 1;
				}else{
					dbus["ss_lb_node_max"] = "";
					dbus["ss_lb_node_ex"] = "";
				}
			}
			// now post data
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "ss_config.sh", "params":[2], "fields": dbus};
			showMsg("msg_warring","保存节点信息！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				type: "POST",
				async:true,
				cache:false,
				dataType: "json",
				data: JSON.stringify(postData),
				success: function(response){
					if (response.result == id){
						if(E('_ss_basic_node').value == 0 && E('_ss_basic_enable').checked){
							save();
						}else{
							window.location.reload();
						}
					}else{
						$('#msg_warring').hide();
						showMsg("msg_error","提交失败","<b>提交节点数据失败！错误代码：" + response.result + "</b>");
					}
				},
				error: function(){
					showMsg("msg_error","失败","<b>当前系统存在异常查看系统日志！</b>");
				}
			});
		}

		function save_kcp(){
			if(!E('_ss_kcp_node').value){
				alert("请选择KCP服务器");
				return false;
			}
			status_time = 999999990;
			setTimeout("tabSelect('app8')", 500);
			var kcp_chk = ["ss_kcp_enable", "ss_kcp_compon"];
			var kcp_inp = ["ss_kcp_node", "ss_kcp_port", "ss_kcp_password", "ss_kcp_mode", "ss_kcp_crypt", "ss_kcp_mtu", "ss_kcp_sndwnd", "ss_kcp_rcvwnd", "ss_kcp_conn", "ss_kcp_config" ];
			// collect data from checkbox
			for (var i = 0; i < kcp_chk.length; i++) {
				dbus[kcp_chk[i]] = E('_' + kcp_chk[i] ).checked ? '1':'0';
			}
			// data from other element
			for (var i = 0; i < kcp_inp.length; i++) {
				if (!E('_' + kcp_inp[i] ).value){
					dbus[kcp_inp[i]] = "";
				}else{
					dbus[kcp_inp[i]] = E('_' + kcp_inp[i]).value;
				}
			}
			// store kcp_para
			var kcp_node_sel=E('_ss_kcp_node').value;
			if (dbus["ssrconf_basic_rss_protocal_" + (kcp_node_sel - node_ss)]){ //ssr
				dbus["ss_kcp_server"] = dbus["ssrconf_basic_server_" + (kcp_node_sel - node_ss)];
				if (dbus["ssrconf_basic_server_ip_" + (kcp_node_sel - node_ss)]){
					dbus["ss_kcp_server"] = dbus["ssrconf_basic_server_ip_" + (kcp_node_sel - node_ss)];
				}
			}else{ //ss
				dbus["ss_kcp_server"] = dbus["ssconf_basic_server_" + kcp_node_sel];
			}
			// now post data
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": "ss_config.sh", "params":[2], "fields": dbus};
			showMsg("msg_warring","保存节点信息！","<b>等待后台运行完毕，请不要刷新本页面！</b>");
			$.ajax({
				url: "/_api/",
				type: "POST",
				async:true,
				cache:false,
				dataType: "json",
				data: JSON.stringify(postData),
				success: function(response){
					if (response.result == id){
						if(dbus["ss_basic_node"] == dbus["ss_kcp_node"] ){
							if(E('_ss_kcp_enable').checked){
								save();
							}else{
								window.location.reload();
							}
						}else{
							if(E('_ss_kcp_enable').checked){
								alert("成功保存了kcp设定！\n你还需要在帐号设置面板里切换到kcp加速的节点才能成功使用kcp！");
							}
							window.location.reload();
						}
					}else{
						$('#msg_warring').hide();
						showMsg("msg_error","提交失败","<b>提交kcp数据失败！错误代码：" + response.result + "</b>");
					}
				},
				error: function(){
					showMsg("msg_error","失败","<b>当前系统存在异常查看系统日志！</b>");
				}
			});
		}

		function get_log(){
			$.ajax({
				url: '/_temp/ss_log.txt',
				type: 'GET',
				dataType: 'html',
				async: true,
				cache:false,
				success: function(response) {
					var retArea = E("_ss_basic_log");
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
					if (noChange > 8000) {
						//tabSelect("app1");
						return false;
					} else {
						setTimeout("get_log();", 200); //100 is radical but smooth!
					}
					retArea.value = response;
					retArea.scrollTop = retArea.scrollHeight;
					_responseLen = response.length;
				},
				error: function() {
					E("_ss_basic_log").value = "获取日志失败！";
				}
			});
		}
		function count_down_switch() {
			if (x == "0") {
				//tabSelect("app1");
				setTimeout("window.location.reload()", 500);
			}
			if (x < 0) {
				return false;
			}
				--x;
			setTimeout("count_down_switch();", 500);
		}
		function toggleVisibility(whichone) {
			if(E('sesdiv' + whichone).style.display=='') {
				E('sesdiv' + whichone).style.display='none';
				E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-up"></i>';
				cookie.set('ss_' + whichone + '_vis', 0);
			} else {
				E('sesdiv' + whichone).style.display='';
				E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-down"></i>';
				cookie.set('ss_' + whichone + '_vis', 1);
			}
		}
		function update_rules_now(arg){
			if (arg == 5){
				shellscript = 'ss_rule_update.sh';
			}else if (arg == 6){
				shellscript = 'ss_pcap_update.sh';
			}
				var id6 = parseInt(Math.random() * 100000000);
				var postData = {"id": id6, "method": shellscript, "params":[], "fields": ""};
				$.ajax({
					type: "POST",
					url: "/_api/",
					async: true,
					cache:false,
					data: JSON.stringify(postData),
					dataType: "json",
					success: function(response){
						if(response){
							setTimeout("window.location.reload()", 500);
							return true;
						}
					}
				});
				tabSelect("app8");
		}

		function manipulate_conf(script, arg){
			var dbus3 = {};
			if(arg == 1 || arg == 3 || arg == 5 || arg == 6 ){
				tabSelect("app8");
				dbus3 = [];
			}else if(arg == 2){
				tabSelect("app8");
				dbus3["ss_kcp_enable"] = "0";
				dbus3["ss_lb_enable"] = "0";
			}else if(arg == 4){
				dbus3 = [];
			}else if(arg == 7){
				tabSelect("app8");
				dbus3["ssr_subscribe_link"] = E("_ssr_subscribe_link").value;
				dbus3["ssr_subscribe_mode"] = E("_ssr_subscribe_mode").value;
				dbus3["ssr_subscribe_obfspara"] = E("_ssr_subscribe_obfspara").value;
				dbus3["ssr_subscribe_obfspara_val"] = E("_ssr_subscribe_obfspara_val").value;
			}else if(arg == 9){
				dbus3["ss_mwan_ping_dst"] = E("_ss_mwan_ping_dst").value;
				dbus3["ss_mwan_china_dns_dst"] = E("_ss_mwan_china_dns_dst").value;
				dbus3["ss_mwan_vps_ip_dst"] = E("_ss_mwan_vps_ip_dst").value;
			}else if(arg == 8){
				var r=0; //记录没有group信息的节点
				var data = ssr_node.getAllData();
				//先根据节点列表整理下dbus里的节点信息
				if(data.length > 0){
					// 如果用户已经手动删除或者增加过节点还没有保存，可能会出现gap，那么先储一次，调节节点的顺序
					for ( var i = 0; i < data.length; ++i ) {
						for ( var j = 0; j < ssrconf.length; ++j ) {
							dbus[ssrconf[j] + (i + 1)] = data[i][j + 1] || "";
						}
						dbus["ssrconf_basic_group_" +  (i + 1)] = dbus["ssrconf_basic_group_" + data[i][0]] || "";
						dbus["ssrconf_basic_lb_enable_" +  (i + 1)] = dbus["ssrconf_basic_lb_enable_" + data[i][0]] || "";
						dbus["ssrconf_basic_lb_policy_" +  (i + 1)] = dbus["ssrconf_basic_lb_policy_" + data[i][0]] || "";
						dbus["ssrconf_basic_lb_weight_" +  (i + 1)] = dbus["ssrconf_basic_lb_weight_" + data[i][0]] || "";
						dbus["ssrconf_basic_lb_dest_" +  (i + 1)] = dbus["ssrconf_basic_lb_dest_" + data[i][0]] || "";
						dbus["ssrconf_basic_server_ip_" +  (i + 1)] = dbus["ssrconf_basic_server_ip_" + data[i][0]] || "";
					}
					// 调节顺序后把最后多余的节点删除
					for ( var i = data.length; i < parseInt(dbus["ssrconf_basic_max_node"]); ++i ) {
						for ( var j = 0; j < ssrconf.length; ++j ) {
							dbus[ssrconf[j] + (i + 1)] =  "";
						}
						dbus["ssrconf_basic_group_" +  (i + 1)] = "";
						dbus["ssrconf_basic_lb_enable_" +  (i + 1)] = "";
						dbus["ssrconf_basic_lb_policy_" +  (i + 1)] = "";
						dbus["ssrconf_basic_lb_weight_" +  (i + 1)] = "";
						dbus["ssrconf_basic_lb_dest_" +  (i + 1)] = "";
						dbus["ssrconf_basic_server_ip_" +  (i + 1)] = "";
					}
				}else{
					//用户已经在web里吧节点删完了...虽然不是存储节点按钮，还是帮忙储存下
					// 因为节点列表节点数量为0，从第一个节点到最大节点每个都标记为删除
					for ( var i = 0; i < parseInt(dbus["ssrconf_basic_max_node"]); ++i ) {
						for ( var j = 0; j < ssrconf.length; ++j ) {
							dbus[ssrconf[j] + (i + 1)] =  "";
						}
						dbus["ssrconf_basic_group_" +  (i + 1)] = "";
						dbus["ssrconf_basic_lb_enable_" +  (i + 1)] = "";
						dbus["ssrconf_basic_lb_policy_" +  (i + 1)] = "";
						dbus["ssrconf_basic_lb_weight_" +  (i + 1)] = "";
						dbus["ssrconf_basic_lb_dest_" +  (i + 1)] = "";
						dbus["ssrconf_basic_server_ip_" +  (i + 1)] = "";
					}
					dbus["ssrconf_basic_max_node"] = "";
					dbus["ssrconf_basic_node_max"] = "";
				}
				////现在开始删除订阅节点
				if(data.length > 0){
					// 不从web拿信息，而是从dbus里拿信息，从第一个节点到最大节点开始扫描，凡是有group信息的节点都给删掉
					for ( var i = 0; i < parseInt(dbus["ssrconf_basic_max_node"]); ++i ) {
						if (dbus["ssrconf_basic_group_" +  (i + 1)]){
							for ( var j = 0; j < ssrconf.length; ++j ) {
								dbus[ssrconf[j] + (i + 1)] =  "";
							}
							dbus["ssrconf_basic_group_" +  (i + 1)] = "";
							dbus["ssrconf_basic_lb_enable_" +  (i + 1)] = "";
							dbus["ssrconf_basic_lb_policy_" +  (i + 1)] = "";
							dbus["ssrconf_basic_lb_weight_" +  (i + 1)] = "";
							dbus["ssrconf_basic_lb_dest_" +  (i + 1)] = "";
							dbus["ssrconf_basic_server_ip_" +  (i + 1)] = "";
						}else{
							++r;
							//剩下没有group信息的节点，重新排序并储存
							for ( var j = 0; j < ssrconf.length; ++j ) {
								//dbus[ssrconf[j] + r] = data[i][j + 1] || "";
								dbus[ssrconf[j] + r] = dbus[ssrconf[j] + (i + 1)] || "";
							}
							dbus["ssrconf_basic_group_" + r] = dbus["ssrconf_basic_group_" + (i + 1)] || "";
							dbus["ssrconf_basic_lb_enable_" + r] = dbus["ssrconf_basic_lb_enable_" + (i + 1)] || "";
							dbus["ssrconf_basic_lb_policy_" + r] = dbus["ssrconf_basic_lb_policy_" + (i + 1)] || "";
							dbus["ssrconf_basic_lb_weight_" + r] = dbus["ssrconf_basic_lb_weight_" + (i + 1)] || "";
							dbus["ssrconf_basic_lb_dest_" + r] = dbus["ssrconf_basic_lb_dest_" + (i + 1)] || "";
							dbus["ssrconf_basic_server_ip_" + r] = dbus["ssrconf_basic_server_ip_" + (i + 1)] || "";
						}
					}
					dbus["ssrconf_basic_max_node"] = r;
					dbus["ssrconf_basic_node_max"] = r;
				}else{
					alert("当前节点列表没有节点！");
					return false;
				}
				dbus3=dbus;
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
					if (script == "ss_conf.sh"){
						if(arg == 1 || arg == 2 || arg == 3 || arg == 7 || arg == 8 || arg == 9){
							setTimeout("window.location.reload()", 500);
						}else if (arg == 5){
							setTimeout("window.location.reload()", 1000);
						}else if (arg == 4){
							var a = document.createElement('A');
							a.href = "/files/ss_conf_backup.sh";
							a.download = 'ss_conf_backup.sh';
							document.body.appendChild(a);
							a.click();
							document.body.removeChild(a);
						}else if (arg == 6){
							var b = document.createElement('A')
							b.href = "/files/shadowsocks.tar.gz"
							b.download = 'shadowsocks_' + dbus["ss_basic_version"] + '.tar.gz'
							document.body.appendChild(b);
							b.click();
							document.body.removeChild(b);
							x=10;
							count_down_switch();
						}
					}
				}
			});
		}
		function restore_conf(){
			var filename = $("#file").val();
			filename = filename.split('\\');
			filename = filename[filename.length-1];
			var filelast = filename.split('.');
			filelast = filelast[filelast.length-1];
			if(filelast !='sh'){
				alert('配置文件格式不正确！');
				return false;
			}
			var formData = new FormData();
			formData.append('ss_conf_backup.sh', $('#file')[0].files[0]);
			$('.popover').html('正在恢复，请稍后……');
			//changeButton(true);
			$.ajax({
				url: '/_upload',
				type: 'POST',
				async: true,
				cache:false,
				data: formData,
				processData: false,
				contentType: false,
				complete:function(res){
					if(res.status==200){
						manipulate_conf('ss_conf.sh', 5);
					}
				}
			});
		}
		
	</script>
	<div class="box" style="margin-top: 0px;min-width:1110px;">
		<div class="heading">
			<span id="_ss_version"><font color="#1bbf35"></font></span>
			<a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
		</div>
		<div class="content">
			<div id="ss_switch_pannel" class="section">
				<fieldset>
					<label class="col-sm-3 control-left-label" for="_undefined">shadowsocks开关</label>
						<div class="switch_field" style="display:table-cell;float: left;">
							<label for="_ss_basic_enable">
								<input type="checkbox" class="switch" name="ss_basic_enable" onclick="verifyFields(this, 1)" onchange="verifyFields(this, 1)" id="_ss_basic_enable" style="display: none;"/>
								<div class="switch_container" >
									<div class="switch_bar"></div>
									<div class="switch_circle transition_style">
										<div></div>
									</div>
								</div>
							</label>
						</div>
				</fieldset>
			</div>
			<script type="text/javascript">
				E("_ss_basic_enable").checked = dbus["ss_basic_enable"] == 1 ? true : false
			</script>
			<hr />
			<fieldset id="ss_status_pannel">
				<label class="col-sm-3 control-left-label" id="ss_status_title">shadowsocks运行状态</label>
				<div class="col-sm-9">
					<font id="_ss_basic_status_foreign" name="ss_basic_status_foreign" color="#1bbf35">国外链接: waiting...</font>
				</div>
				<div class="col-sm-9" style="margin-top:2px">
					<font id="_ss_basic_status_china" name="ss_basic_status_china" color="#1bbf35">国内链接: waiting...</font>
				</div>
				<div class="col-sm-9" style="margin-top:2px;display:none;">
					<font id="_ss_basic_kcp_status" name="ss_basic_kcp_status" color="#1bbf35">KCP状态: waiting...</font>
				</div>
				<div class="col-sm-9" style="margin-top:2px;display:none;">
					<font id="_ss_basic_lb_status" name="ss_basic_lb_status" color="#1bbf35">负载均衡: waiting...</font>
				</div>
			</fieldset>
		</div>
	</div>
	<ul id="ss_tabs" class="nav nav-tabs" style="min-width:1110px;">
		<li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-tab" class="active" style="width:100px"><i class="icon-system"></i> 帐号设置</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-tab" style="width:100px"><i class="icon-globe"></i> 节点管理</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app3');" id="app3-tab" style="width:100px"><i class="icon-tools"></i> DNS设定</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app11');" id="app11-tab" style="width:100px"><i class="icon-hammer" style="margin-left:-5px"></i> 多wan设定</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app9');" id="app9-tab" style="width:100px"><i class="icon-cloud"></i> 负载均衡</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app10');" id="app10-tab" style="width:100px"><i class="icon-graphs"></i> KCP加速</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app4');" id="app4-tab" style="width:100px"><i class="icon-toggle-nav"></i> 黑白名单</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app5');" id="app5-tab" style="width:100px"><i class="icon-cmd"></i> 规则管理</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app6');" id="app6-tab" style="width:100px"><i class="icon-lock"></i> 访问控制</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app7');" id="app7-tab" style="width:100px"><i class="icon-wake"></i> 附加功能</a></li>
		<li><a href="javascript:void(0);" onclick="tabSelect('app8');" id="app8-tab" style="width:100px"><i class="icon-hourglass"></i> 查看日志</a></li>	
	</ul>
	<div class="box boxr1" id="ss_basic_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="ss_basic_pannel" class="section"></div>
			<script type="text/javascript">
				join_node();
				if (!dbus["ssconf_basic_node_max"] && !dbus["ssrconf_basic_node_max"]){
					$('#ss_basic_pannel').forms([
						{ title: '节点选择', name:'ss_basic_node',type:'select',style:select_style,options:[['1', '节点1']], value: "1"}
					]);
				}else{
					if (dbus["ss_basic_double"] != 1){
						$('#ss_basic_pannel').forms([
							{ title: '节点选择', name:'ss_basic_node',type:'select',style:select_style,options:option_node_name, value: dbus.ss_basic_node || "1"}
						]);
					}else{
						$('#ss_basic_pannel').forms([
							{ title: '节点选择', multi: [
								{ title: '节点选择', name:'ss_basic_node',type:'select',style:select_style,options:option_node_name, value: dbus.ss_basic_node || "1", suffix: ' &nbsp;&nbsp;'},
								{ title: '节点选择', name:'ss_basic_node_1',type:'select',style:select_style,options:option_node_name, value: dbus.ss_basic_node || "1"}
							]},
						]);
					}
				}
				if (dbus["ss_basic_double"] != 1){
					$('#ss_basic_pannel').forms([
						{ title: '模式',  name:'ss_basic_mode',type:'select',style:select_style,options:option_mode,value: "" || "1" },
						{ title: '服务器地址', name:'ss_basic_server',type:'text',size:22,value:dbus.ss_basic_server,help: '尽管支持域名格式，但是仍然建议首先使用IP地址。' },
						{ title: '服务器端口', name:'ss_basic_port',type:'text',size:22,maxlen:5,value:"" },
						{ title: '密码', name:'ss_basic_password',type:'password',size:22,maxlen:64,value:"",help: '如果你的密码内有特殊字符，可能会导致密码参数不能正确的传给ss，导致启动后不能使用ss。',peekaboo: 1  },
						{ title: '加密方式', name:'ss_basic_method',type:'select',style:select_style,options:option_method,value: dbus.ss_basic_method || "aes-256-cfb" },
						{ title: '混淆(AEAD)', name:'ss_basic_ss_obfs',type:'select',style:select_style,options:option_ss_obfs,value: dbus.ss_basic_ss_obfs || "0" },
						{ title: '混淆主机名', name:'ss_basic_ss_obfs_host',type:'text',size:22,value:dbus.ss_basic_ss_obfs_host || "" },
						{ title: '协议 (protocal)', name:'ss_basic_rss_protocal',type:'select',style:select_style,options:option_ssr_protocal,value: dbus.ss_basic_rss_protocal || "auth_sha1_v4" },
						{ title: '协议参数 (SSR特性)', name:'ss_basic_rss_protocal_para',type:'text',size:22,value:dbus.ss_basic_rss_protocal_para, help: '协议参数是SSR单端口多用户（端口复用）配置的必选项，如果你的SSR帐号没有启用端口复用，可以将此处留空。' },
						{ title: '混淆方式 (obfs)', name:'ss_basic_rss_obfs',type:'select',style:select_style,options:option_ssr_obfs,value:dbus.ss_basic_rss_obfs || "tls1.2_ticket_auth" },
						{ title: '混淆参数 (SSR特性)', name:'ss_basic_rss_obfs_para',type:'text',size:22,value: dbus.ss_basic_rss_obfs_para }
					]);
				}else{
					$('#ss_basic_pannel').forms([
						{ title: '模式', multi: [
							{ name:'ss_basic_mode',type:'select',style:select_style,options:option_mode,value: "" || "1", suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_mode_1',type:'select',style:select_style,options:option_mode,value: "" || "1" }
						]},
						{ title: '服务器地址', multi: [
							{ name:'ss_basic_server',type:'text',size:22,value:dbus.ss_basic_server,help: '尽管支持域名格式，但是仍然建议首先使用IP地址。', suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_server_1',type:'text',size:22,value:dbus.ss_basic_server,help: '尽管支持域名格式，但是仍然建议首先使用IP地址。' }
						]},
						{ title: '服务器端口', multi: [
							{ name:'ss_basic_port',type:'text',size:22,maxlen:5,value:"", suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_port_1',type:'text',size:22,maxlen:5,value:dbus.ss_basic_port }
						]},
						{ title: '密码', multi: [
							{ name:'ss_basic_password',type:'password',size:22,maxlen:64,value:"",help: '如果你的密码内有特殊字符，可能会导致密码参数不能正确的传给ss，导致启动后不能使用ss。',peekaboo: 1, suffix: ' &nbsp;&nbsp;'  },
							{ name:'ss_basic_password_1',type:'password',size:22,maxlen:64,value:dbus.ss_basic_password,help: '如果你的密码内有特殊字符，可能会导致密码参数不能正确的传给ss，导致启动后不能使用ss。',peekaboo: 1  }
						]},
						{ title: '加密方式', multi: [
							{ name:'ss_basic_method',type:'select',style:select_style,options:option_method,value: dbus.ss_basic_method || "aes-256-cfb", suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_method_1',type:'select',style:select_style,options:option_method,value: dbus.ss_basic_method || "aes-256-cfb" }
						]},
						{ title: '混淆(AEAD)', multi: [
							{ name:'ss_basic_ss_obfs',type:'select',style:select_style,options:option_ss_obfs,value: dbus.ss_basic_ss_obfs || "0", suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_ss_obfs_1',type:'select',style:select_style,options:option_ss_obfs,value: dbus.ss_basic_ss_obfs || "0" }
						]},
						{ title: '混淆主机名', multi: [
							{ name:'ss_basic_ss_obfs_host',type:'text',size:22,value:dbus.ss_basic_ss_obfs_host || "", suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_ss_obfs_host_1',type:'text',size:22,value:dbus.ss_basic_ss_obfs_host || "" }
						]},
						{ title: '协议 (protocal)', multi: [
							{ name:'ss_basic_rss_protocal',type:'select',style:select_style,options:option_ssr_protocal,value: dbus.ss_basic_rss_protocal || "auth_sha1_v4", suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_rss_protocal_1',type:'select',style:select_style,options:option_ssr_protocal,value: dbus.ss_basic_rss_protocal || "auth_sha1_v4" }
						]},
						{ title: '协议参数 (SSR特性)', multi: [
							{ name:'ss_basic_rss_protocal_para',type:'text',size:22,value:dbus.ss_basic_rss_protocal_para, help: '协议参数是SSR单端口多用户（端口复用）配置的必选项，如果你的SSR帐号没有启用端口复用，可以将此处留空。', suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_rss_protocal_para_1',type:'text',size:22,value:dbus.ss_basic_rss_protocal_para, help: '协议参数是SSR单端口多用户（端口复用）配置的必选项，如果你的SSR帐号没有启用端口复用，可以将此处留空。' }
						]},
						{ title: '混淆方式 (obfs)', multi: [
							{ name:'ss_basic_rss_obfs',type:'select',style:select_style,options:option_ssr_obfs,value:dbus.ss_basic_rss_obfs || "tls1.2_ticket_auth", suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_rss_obfs_1',type:'select',style:select_style,options:option_ssr_obfs,value:dbus.ss_basic_rss_obfs || "tls1.2_ticket_auth" }
						]},
						{ title: '混淆参数 (SSR特性)', multi: [
							{ name:'ss_basic_rss_obfs_para',type:'text',size:22,value: dbus.ss_basic_rss_obfs_para, suffix: ' &nbsp;&nbsp;' },
							{ name:'ss_basic_rss_obfs_para_1',type:'text',size:22,value: dbus.ss_basic_rss_obfs_para }
						]},
					]);
				}
				var node_kcp=dbus["ss_kcp_node"];
				if (node_kcp && (dbus["ssconf_basic_max_node"] || dbus["ssrconf_basic_max_node"])){
					var node_html=$("#_ss_basic_node option[value='" + node_kcp +"']")[0].innerHTML;
					if (dbus["ss_kcp_enable"] == 1){
						if (node_html.indexOf("SSR") != -1){
							$("#_ss_basic_node option[value='" + node_kcp + "']").html(node_html.replace(/SSR/g, "KCP+SSR"));
						}else{
							$("#_ss_basic_node option[value='" + node_kcp + "']").html(node_html.replace(/SS/g, "KCP+SS"));
						}
					}
				}
			</script>
		</div>
	</div>
	<div class="box boxr2" id="ss_node_tab" style="margin-top: 0px;">
		<div class="heading">节点管理-SS节点</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="ss_node-grid">
				</table>
			</div>
		</div>
	</div>
	<div class="box boxr2" id="ssr_node_tab" style="margin-top: 0px;">
		<div class="heading">节点管理-SSR节点</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="ssr_node-grid">
				</table>
			</div>
		</div>
	</div>
	
	<div class="box boxr9" id="ss_lb_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content">
			<div id="ss_lb_panel" class="tabContent">
			<script type="text/javascript">
				$('#ss_lb_panel').forms([
					{ title: '负载均衡开关', name:'ss_lb_enable',type:'checkbox',  value: dbus.ss_lb_enable == 1 },  // ==1 means default close; !=0 means default open
					{ title: 'haproxy控制台', rid:'haproxy_console', text:'<a id="haproxy_console1" href="" target="_blank"></a>'},
					{ title: 'haproxy登录', multi: [
						{ name: 'ss_lb_account',type:'text', size: 4, value: dbus.ss_lb_account || "admin", prefix: '登录帐号：', suffix: ' &nbsp;&nbsp;' },
						{ name:'ss_lb_password',type:'password',size: 4,value:dbus.ss_lb_password, peekaboo: 1, prefix: '登录密码：',  }
					]},
					{ title: 'haproxy端口(用于ss监听)', name:'ss_lb_port',type:'text', maxlen:5, size: 2,value:dbus.ss_lb_port||"8118" },
					{ title: 'Haproxy故障检测心跳', multi: [
						{ name: 'ss_lb_heartbeat',type:'checkbox', value: dbus.ss_lb_heartbeat == 1, suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_lb_up', type: 'text', size: 1, value: dbus.ss_lb_up || "2", suffix: '<lable>次</lable>&nbsp;&nbsp;&nbsp;&nbsp;', prefix: '<span class="help-block"><lable>成功：</lable></span>' },
						{ name: 'ss_lb_down', type: 'text', size: 1, value: dbus.ss_lb_down || "3", suffix: '<lable>次</lable>&nbsp;&nbsp;&nbsp;&nbsp;', prefix: '<span class="help-block"><lable>失败：</lable></span>' },
						{ name: 'ss_lb_interval', type: 'text', size: 2, value: dbus.ss_lb_interval || "4000", suffix: '<lable>ms</lable>', prefix: '<span class="help-block"><lable>心跳间隔：</lable></span>' }
					]},
					{ title: '服务器添加', multi: [
						{ name: 'ss_lb_node',type:'select',style:select_style,options:option_node_name, value: dbus.ss_lb_node || "", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_lb_weight', type: 'text', size: 1, value: dbus.ss_lb_weight || "50", suffix: ' &nbsp;&nbsp;', prefix: '<span class="help-block"><lable>权重：</lable></span>' },
						{ name: 'ss_lb_policy', type: 'select', options:option_lb_policy, value: dbus.ss_lb_policy || "1", suffix: ' &nbsp;&nbsp;',prefix: '<span class="help-block"><lable>属性：</lable></span>' },
						{ name: 'ss_lb_dest', type: 'select', options:[], suffix: ' &nbsp;&nbsp;',prefix: '<span class="help-block"><lable>出口：</lable></span>' },
						{ suffix: ' <button id="add_lbnode" onclick="add_lb_node();" class="btn btn-danger">添加<i class="icon-plus"></i></button>' }
					]}
				]);
				document.getElementById("haproxy_console1").href = "http://"+location.hostname+":1188";
				document.getElementById("haproxy_console1").innerHTML = "<i><u>http://"+location.hostname+":1188</i></u>";
				$("#_ss_lb_node option[value='0']").remove();
				$("#_ss_lb_node").val(1);
			</script>
			</div>
			<br><hr>
		</div>
	</div>
	<div class="box boxr9" id="lb_list" style="margin-top: 0px;">
		<div class="heading">负载均衡服务器列表</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="lb-grid">
				</table>
			</div>
			<br><hr>
		</div>
	</div>
	<div id="ss_lb_tab_readme" class="box boxr9">
		<div class="heading">负载均衡操作手册： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('lb');"><span id="sesdivlbshowhide"><i class="icon-chevron-up"></i></span></a></div>
		<div class="section content" id="sesdivlb" style="display:none">
			<li>在此页面可以设置多个shadowsocks或者shadowsocksR帐号负载均衡，同时具有故障转移、自动恢复的功能；</li>
			<li>注意：设置负载均衡的节点需要加密方式、密码、混淆等需要完全一致！SS、SSR之间不支持设置负载均衡；</li>
			<li>提交设置后会开启haproxy，并在ss节点配置中增加一个服务器IP为127.0.0.1，端口为负载均衡服务器端口的帐号；</li>
			<li>负载均衡模式下不支持udp转发：不能使用游戏模式，不能使用ss-tunnel作为国外dns方案;</li>
			<li>强烈建议需要负载均衡的ss节点使用ip格式，使用域名会使haproxy进程加载过慢！</li>
		</div>
		<script>
			var cc;
			if(!cookie.get('ss_lb_vis')){
				cookie.set('ss_lb_vis', 1);
			}
			if (((cc = cookie.get('ss_lb_vis')) != null) && (cc == '1')) {
				toggleVisibility("lb");
			}
		</script>
	</div>
	<div class="box boxr10" id="ss_kcp_tab_1" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content">
			<div id="ss_kcp_panel_1" class="tabContent">
			<script type="text/javascript">
				$('#ss_kcp_panel_1').forms([
					{ title: 'KCP加速开关', name:'ss_kcp_enable', type:'checkbox',  value: dbus.ss_kcp_enable == 1 },  // ==1 means default close; !=0 means default open
					{ title: '当前KCP版本', rid:'ss_kcp_version', text:'<font id="_ss_kcp_version" color="#1bbf35">20170904</font>'},
				]);
			</script>
			</div>
		</div>
	</div>
	<div class="box boxr10" id="ss_kcp_tab_2" style="margin-top: 0px;">
		<div class="heading">KCP服务器设置</div>
		<div class="content">
			<div id="ss_kcp_panel_2" class="tabContent">
			<script type="text/javascript">
				$('#ss_kcp_panel_2').forms([
					{ title: 'KCP加速的服务器地址', name: 'ss_kcp_node', type:'select', style:select_style, options:option_node_name, value: dbus.ss_kcp_node || "1" },
					{ title: '服务器端口', name:'ss_kcp_port',type:'text',size: 22, maxlen:5, value:dbus.ss_kcp_port||"1099" },
					{ title: '服务器密码 (--key)', name:'ss_kcp_password',type:'password', maxlen:64, size: 22,value:dbus.ss_kcp_password, peekaboo:1 },
					{ title: '速度模式 (--mode)', name:'ss_kcp_mode',type:'select', style:select_style, options:option_kcp_mode,value:dbus.ss_kcp_mode||"fast" },
					{ title: '加密方式 (--crypt)', name:'ss_kcp_crypt',type:'select', style:select_style, options:option_kcp_crypt,value:dbus.ss_kcp_crypt||"aes" },
					{ title: 'MTU (--mtu)', name:'ss_kcp_mtu',type:'text',size: 22, maxlen:4, value:dbus.ss_kcp_mtu||"1350" },
					{ title: '发送窗口 (--sndwnd)', name:'ss_kcp_sndwnd',type:'text',size: 22, maxlen:5, value:dbus.ss_kcp_sndwnd||"128" },
					{ title: '接收窗口 (--rcvwnd)', name:'ss_kcp_rcvwnd',type:'text',size: 22, maxlen:5, value:dbus.ss_kcp_rcvwnd||"1024" },
					{ title: '链接数 (--conn)', name:'ss_kcp_conn',type:'text',size: 22, maxlen:4, value:dbus.ss_kcp_conn||"1" },
					{ title: '关闭数据压缩 (--nocomp)', name:'ss_kcp_compon',type:'checkbox',size: 22, maxlen:4, value:dbus.ss_kcp_compon == 1 },
					{ title: '其它配置项', name:'ss_kcp_config',type:'text',style:"width:85%", value:dbus.ss_kcp_config }
				]);
				
				E('_ss_kcp_config').placeholder = "请将速度模式为manual的参数和其它参数依次填写进来";
				document.getElementById("_ss_kcp_version").innerHTML = dbus["ss_kcp_version"] || "20170904";
				$("#_ss_kcp_node option[value='0']").remove();
			</script>
			</div>
			<br><hr>
		</div>
	</div>
	<div id="ss_kcp_tab_readme" class="box boxr10">
		<div class="heading">KCP加速使用说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('kcp');"><span id="sesdivkcpshowhide"><i class="icon-chevron-up"></i></span></a></div>
		<div class="section content" id="sesdivkcp" style="display:none">
			<li>正确填写kcp参数后，点击保存KCP设置，如果kcp节点和ss节点一致，会自动重启ss；如果不一致，仅仅保存配置，待在主面板选在kcp加速的节点后才能生效；</li>
			<li>kcp加速仅针对你再kcp加速页面选择的节点，如果在主面板切换到了其它节点，虽然此时kcp开关是启用状态，但是并不会启动kcp加速；</li>
			<li>因为kcp协议仅支持tcp，所以在使用kcp加速的时候请勿在国外DNS选项中的任何一个选项里使用ss-tunnel作为DNS解析方案；</li>
			<li>因为kcp加速只针对单个节点，所以kcp不能和负载均衡混用！kcp启用后负载均衡标签页会暂时隐藏，负载均衡启用后，kcp标签页会暂时隐藏;</li>
		</div>
		<script>
			var cc;
			if(!cookie.get('ss_kcp_vis')){
				cookie.set('ss_kcp_vis', 1);
			}
			if (((cc = cookie.get('ss_kcp_vis')) != null) && (cc == '1')) {
				toggleVisibility("kcp");
			}
		</script>
	</div>
	<div class="box boxr3" id="ss_dns_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="ss_dns_pannel" class="section"></div>
			<script type="text/javascript">
				$('#ss_dns_pannel').forms([
					{ title: 'DNS解析偏好', name:'ss_dns_plan',type:'select',options:[['1', '国内优先'], ['2', '国外优先']], value: dbus.ss_dns_plan || "2", suffix: '<lable id="_ss_dns_plan_txt"></lable>'},
					{ title: '选择国内DNS', multi: [
						{ name: 'ss_dns_china',type:'select', options:option_dns_china, value: dbus.ss_dns_china || "1", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_dns_china_user', type: 'text', value: dbus.ss_dns_china_user }
					]},
					// dns foreign chinadns
					{ title: '选择国内DNS', suffix: '<lable id="_ss_dns_china_chinadns_txt">ChinaDNS方案自带国内cdn加速，无需定义国内DNS </lable>' },
					// dns foreign pcap
					{ title: '选择国内DNS', suffix: '<lable id="_ss_dns_china_pcap_txt">Pcap_DNSProxy方案自带国内cdn加速，无需定义国内DNS </lable>'},
					{ title: '选择国外DNS', multi: [
						{ name: 'ss_dns_foreign',type: 'select', options:option_dns_foreign, value: dbus.ss_dns_foreign || "1", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_dns2socks_user', type: 'text', value: dbus.ss_dns2socks_user || "8.8.8.8:53" },
						{ name: 'ss_sstunnel',type: 'select', options:option_ss_sstunnel, value: dbus.ss_sstunnel || "2", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_sstunnel_user', type: 'text', value: dbus.ss_sstunnel_user || "" },
						{ name: 'ss_opendns',type: 'select', options:option_opendns, value: dbus.ss_opendns || "cisco", suffix: ' &nbsp;&nbsp;' }
					]},
					//pdnsd
					{ title: '<font color="#1bbf35">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd查询方式</font>', name:'ss_pdnsd_method',type:'select',options:[['1', '仅udp查询'], ['2', '仅tcp查询']], value: dbus.ss_pdnsd_method || "1" },

					{ title: '<font color="#1bbf35">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（UDP）</font>', multi: [
						{ name: 'ss_pdnsd_udp_server',type:'select',options:[['1', 'dns2socks'], ['2', 'dnscrypt-proxy'], ['3', 'ss-tunnel']], value: dbus.ss_pdnsd_udp_server || "1", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_pdnsd_udp_server_dns2socks', type: 'text', value: dbus.ss_pdnsd_udp_server_dns2socks || "8.8.8.8:53" },
						{ name: 'ss_pdnsd_udp_server_dnscrypt',type: 'select', options:option_opendns, value: dbus.ss_pdnsd_udp_server_dns2socks || "1" },
						{ name: 'ss_pdnsd_udp_server_ss_tunnel',type: 'select', options:option_ss_sstunnel, value: dbus.ss_pdnsd_udp_server_ss_tunnel || "2", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_pdnsd_udp_server_ss_tunnel_user', type: 'text', value: dbus.ss_pdnsd_udp_server_ss_tunnel }
					]},

					{ title: '<font color="#1bbf35">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd上游服务器（TCP）</font>', multi: [
						{ name: 'ss_pdnsd_server_ip', type: 'text', value: dbus.ss_pdnsd_server_ip },
						{ suffix: ' ：' },
						{ name: 'ss_pdnsd_server_port', type: 'text', value: dbus.ss_pdnsd_server_ip }
					]},
					{ title: '<font color="#1bbf35">&nbsp;&nbsp;&nbsp;&nbsp;*pdnsd缓存设置</font>', multi: [
						{ name: 'ss_pdnsd_server_cache_min', type: 'text', size: '1', value: dbus.ss_pdnsd_server_cache_min || "24h" },
						{ suffix: ' → ' },
						{ name: 'ss_pdnsd_server_cache_max', type: 'text', size: '1', value: dbus.ss_pdnsd_server_cache_max || "1w" }
					]},
					//ChinaDNS
					{ title: '<font color="#1bbf35">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国内DNS</font>', multi: [
						{ name: 'ss_chinadns_china',type:'select', options:option_ChinaDNS_china, value: dbus.ss_chinadns_china || "1", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_chinadns_china_user', type: 'text', value: dbus.ss_chinadns_china_user }
					]},
					{ title: '<font color="#1bbf35">&nbsp;&nbsp;&nbsp;&nbsp;*ChinaDNS国外DNS</font>', multi: [
						{ name: 'ss_chinadns_foreign_method',type:'select',options:[['1', 'dns2socks'], ['2', 'dnscrypt-proxy'], ['3', 'ss-tunnel'],['4', '自定义']], value: dbus.ss_chinadns_foreign_method || "1", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_chinadns_foreign_dns2socks', type: 'select', options:option_ss_sstunnel, value: dbus.ss_chinadns_foreign_dns2socks || "2", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_chinadns_foreign_dns2socks_user', type: 'text', value: dbus.ss_chinadns_foreign_dns2socks_user || "8.8.8.8:53" },
						{ name: 'ss_chinadns_foreign_dnscrypt',type: 'select', options:option_opendns, value: dbus.ss_chinadns_foreign_dnscrypt || "1" },
						{ name: 'ss_chinadns_foreign_sstunnel',type: 'select', options:option_ss_sstunnel, value: dbus.ss_chinadns_foreign_sstunnel || "2", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_chinadns_foreign_sstunnel_user', type: 'text', value: dbus.ss_chinadns_foreign_sstunnel_user },
						{ name: 'ss_chinadns_foreign_method_user', type: 'text', value: dbus.ss_chinadns_foreign_method_user, suffix: '<lable id="_ss_chinadns_foreign_method_user_txt">自定义直连的chinaDNS国外dns。</lable>' },
					]},
					{ title: 'SS服务器地址解析', multi: [
						{ name: 'ss_basic_dnslookup',type:'select',options:[['0', 'resolveip方式'], ['1', 'nslookup方式']], value: dbus.ss_basic_dnslookup || "1", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_basic_dnslookup_server', type: 'text', value: dbus.ss_basic_dnslookup_server || "119.29.29.29", suffix: '<lable id="_ss_basic_dnslookup_txt">当服务器地址是域名的时候会用此设定解析。</lable>' }
					]},
					{ title: 'chromecast支持 (接管局域网DNS解析)',  name:'ss_basic_chromecast',type:'checkbox', value: dbus.ss_basic_chromecast != 0 },
					{ title: '<b>自定义CDN加速名单</b></br></br><font color="#B2B2B2">强制用国内DNS解析的域名，一行一个，如：</br>koolshare.cn</br>baidu.com</font>', name: 'ss_isp_website_web', type: 'textarea', value: Base64.decode(dbus.ss_isp_website_web)||"",	style: 'width: 100%; height:150px;' },
					// dns foreign chinadns
					{ title: '自定义需要CDN加速名单', suffix: '<lable id="_ss_cdn_chinadns_txt">ChinaDNS方案自带国内cdn加速，无需定义cdn加速名单 </lable>' },
					// dns foreign pcap
					{ title: '自定义需要CDN加速名单', suffix: '<lable id="_ss_cdn_pcap_txt">Pcap_DNSProxy方案自带国内cdn加速，无需定义cdn加速名单 </lable>'},
					{ title: '<b>自定义dnsmasq</b></br></br><font color="#B2B2B2">一行一个，错误的格式会导致dnsmasq不能启动，格式：</br>address=/koolshare.cn/2.2.2.2</br>bogus-nxdomain=220.250.64.18</br>conf-file=/jffs/mydnsmasq.conf</font>', name: 'ss_dnsmasq', type: 'textarea', value: Base64.decode(dbus.ss_dnsmasq)||"", style: 'width: 100%; height:150px;' }
				]);
					$('#_ss_dns_china_chinadns_txt').parent().css("margin-top","9px");
					$('#_ss_cdn_chinadns_txt').parent().css("margin-top","9px");
					$('#_ss_dns_china_pcap_txt').parent().css("margin-top","9px");
					$('#_ss_cdn_pcap_txt').parent().css("margin-top","9px");
			</script>
		</div>
	</div>
	<div class="box boxr4" id="ss_wblist_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="ss_wblist_pannel" class="section"></div>
			<script type="text/javascript">
				$('#ss_wblist_pannel').forms([
					{ title: '<b>IP/CIDR白名单</b></br></br><font color="#B2B2B2">不走SS的外网ip/cidr地址，一行一个，例如：</br>2.2.2.2</br>3.3.0.0/16</font>', name: 'ss_wan_white_ip', type: 'textarea', value: Base64.decode(dbus.ss_wan_white_ip)||"", style: 'width: 100%; height:150px;' },
					{ title: '<b>域名白名单</b></br></br><font color="#B2B2B2">不走SS的域名，例如：</br>google.com</br>facebook.com</font>', name: 'ss_wan_white_domain', type: 'textarea', value: Base64.decode(dbus.ss_wan_white_domain)||"", style: 'width: 100%; height:150px;' },
					{ title: '<b>IP/CIDR黑名单</b></br></br><font color="#B2B2B2">强制走SS的外网ip/cidr地址，一行一个，例如：</br>4.4.4.4</br>5.0.0.0/8</font>', name: 'ss_wan_black_ip', type: 'textarea', value: Base64.decode(dbus.ss_wan_black_ip)||"", style: 'width: 100%; height:150px;' },
					{ title: '<b>域名黑名单</b></br></br><font color="#B2B2B2">强制走SS的域名,例如：</br>baidu.com</br>koolshare.cn</font>', name: 'ss_wan_black_domain', type: 'textarea', value: Base64.decode(dbus.ss_wan_black_domain)||"", style: 'width: 100%; height:150px;' }
				]);
			</script>
		</div>
	</div>
	<div class="box boxr11" id="ss_mwan_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="ss_mwan_pannel" class="section"></div>
			<script type="text/javascript">
				$('#ss_mwan_pannel').forms([
					{ title: '节点ping测试出口', name:'ss_mwan_ping_dst',type:'select',options:[], value: dbus.ss_mwan_ping_dst},
					{ title: '国内DNS指定解析出口', name:'ss_mwan_china_dns_dst',type:'select',options:[], value: dbus.ss_mwan_china_dns_dst},
					{ title: 'SS服务器指定出口', name:'ss_mwan_vps_ip_dst',type:'select',options:[], value: dbus.ss_mwan_china_dns_dst}
				]);
			</script>
			<button type="button" value="Save" id="dele-subscribe-node" onclick="manipulate_conf('ss_conf.sh', 9)" class="btn btn-primary" style="float:left;">应用出口设定 <i class="icon-check"></i></button>
		</div>
	</div>
	<div id="ss_mwan_readme" class="box boxr11">
		<div class="heading">出口设定须知： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('mwan3');"><span id="sesdivmwan3showhide"><i class="icon-chevron-up"></i></span></a></div>
		<div class="section content" id="sesdivmwan3" style="display:none">
			<li>当你的LEDE配置了多个wan的时候，你可以通过本页面为一些ip地址设定指定的出口；</li>
			<li>你可以选择指定出口或者不指定，不指定出口的时候，将会由路由器本身随机选择出口；</li>
			<li>当启用了负载均衡后，SS服务器指定出口将会无效，但是你可以在负载均衡节点表格内指定每个负载均衡节点的出口；</li>
			<li>如果你指定了某个出口，在路由器使用期间某个接口离线后，将会由路由器本身随机选择出口，接口上线后将会恢复。</li>
		</div>
		<script>
			var cc;
			if(!cookie.get('ss_mwan3_vis')){
				cookie.set('ss_mwan3_vis', 1);
			}
			if (((cc = cookie.get('ss_mwan3_vis')) != null) && (cc == '1')) {
				toggleVisibility("mwan3");
			}
		</script>
	</div>	
	
	<div class="box boxr5" id="ss_rule_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="ss_rule_pannel" class="section">
				
			</div>
			<script type="text/javascript">
				$('#ss_rule_pannel').forms([
					{ title: 'gfwlist域名数量', rid:'gfw_number_1', text:'<a id="gfw_number" href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/gfwlist.conf" target="_blank"></a>'},
					{ title: '大陆白名单IP段数量', rid:'chn_number_1', text:'<a id="chn_number" href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/chnroute.txt" target="_blank"></a>'},
					{ title: '国内域名数量（cdn名单）', rid:'cdn_number_1', text:'<a id="cdn_number" href="https://github.com/koolshare/koolshare.github.io/blob/acelan_softcenter_ui/maintain_files/cdn.txt" target="_blank"></a>'},
					{ title: 'shadowsocks规则自动更新', multi: [
						{ name: 'ss_basic_rule_update',type: 'select', options:[['0', '禁用'], ['1', '开启']], value: dbus.ss_basic_rule_update || "1", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_basic_rule_update_time', type: 'select', options:option_hour_time, value: dbus.ss_basic_rule_update_time || "3",suffix: ' &nbsp;&nbsp;', prefix:'每天' },
						{ name:'ss_basic_gfwlist_update',type:'checkbox',value: dbus.ss_basic_gfwlist_update != 0, suffix: '<lable id="_ss_basic_gfwlist_update_txt">gfwlist</lable>&nbsp;&nbsp;' },
						{ name:'ss_basic_chnroute_update',type:'checkbox',value: dbus.ss_basic_chnroute_update != 0, suffix: '<lable id="_ss_basic_chnroute_update_txt">chnroute</lable>&nbsp;&nbsp;' },
						{ name:'ss_basic_cdn_update',type:'checkbox',value: dbus.ss_basic_cdn_update != 0, suffix: '<lable id="_ss_basic_cdn_update_txt">cdn_list</lable>&nbsp;&nbsp;' },
						{ suffix: ' <button id="_update_rules_now" onclick="update_rules_now(5);" class="btn btn-success">手动更新<i class="icon-cloud"></i></button>' }
					]},
					{ title: 'Host和WhiteList（Pcap_DNSProxy）', suffix: ' <button id="_update_rules_now" onclick="update_rules_now(6);" class="btn btn-success">手动更新<i class="icon-cloud"></i></button>' }
				]);
				$('#gfw_number').html(dbus.ss_gfw_status || "未初始化");
				$('#chn_number').html(dbus.ss_chn_status || "未初始化");
				$('#cdn_number').html(dbus.ss_cdn_status || "未初始化");
			</script>
		</div>
	</div>
	<div class="box boxr6" id="ss_acl_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="ss_acl_pannel"></table>
			</div>
			<br><hr>
		</div>
	</div>
	<div id="ss_acl_tab_readme" class="box boxr6">
		<div class="heading">访问控制操作手册： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('acl');"><span id="sesdivaclshowhide"><i class="icon-chevron-up"></i></span></a></div>
		<div class="section content" id="sesdivacl" style="display:none">
				<li><b>1：</b> 你可以在这里轻松的定义你需要的主机走SS的模式，或者你可以什么都不做，使用缺省规则，代表全部主机都默认走【帐号设置】内的模式；</li>
				<li><b>2：</b> 主机别名、主机IP地址、MAC地址已经在系统的arp列表里获取了，在LEDE路由下的设备均能被选择，选择后相应设备的ip和mac地址会自动填写；</li>
				<li><b>3：</b> 如果你需要的设备在列表里不能选择，可以不选择主机别名列表，然后填选好其他地方，添加后保存，插件会自动为你的这个设备分配一个名字；</li>
				<li><b>4：</b> 请按照格式填写ip和mac地址，ip和mac地址至少一个不能为空！</li>
				<li><b>5：</b> 插件为每个模式推荐了相应的端口，当你选择相应访问控制模式的时候，端口会自动变化，你也可以不用推荐的设置，自己选择想要的端口；</li>
				<li><b>6：</b> 当访问控制模式不为：不通过ss的时候，在【帐号设置】面板里更改模式，这里的缺省规则模式会自动发生变化，否则不发生变化。</li>
		</div>
		<script>
			var cc;
			if(!cookie.get('ss_acl_vis')){
				cookie.set('ss_acl_vis', 1);
			}
			if (((cc = cookie.get('ss_acl_vis')) != null) && (cc == '1')) {
				toggleVisibility("acl");
			}
		</script>
	</div>
	<div class="box boxr7" id="ss_addon_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="ss_addon_pannel" class="section"></div>
			<script type="text/javascript">
				$('#ss_addon_pannel').forms([
					{ title: '状态更新间隔', name:'ss_basic_refreshrate',type:'select',options:option_status_inter, value: dbus.ss_basic_refreshrate || "5"},
					{ title: 'SS数据清除', suffix: '<button onclick="manipulate_conf(\'ss_conf.sh\', 1);" class="btn btn-success">清除所有SS数据</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="manipulate_conf(\'ss_conf.sh\', 2);" class="btn btn-success">清除SS节点数据</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="manipulate_conf(\'ss_conf.sh\', 3);" class="btn btn-success">清除访问控制数据</button>' },
					{ title: 'SS数据备份', suffix: '<button onclick="manipulate_conf(\'ss_conf.sh\', 4);" class="btn btn-download">备份所有SS数据</button>' },
					{ title: 'SS数据恢复', suffix: '<input type="file" id="file" size="50">&nbsp;&nbsp;<button id="upload1" type="button"  onclick="restore_conf();" class="btn btn-danger">上传并恢复 <i class="icon-cloud"></i></button>' },
					{ title: 'SS插件备份', suffix: '<button onclick="manipulate_conf(\'ss_conf.sh\', 6);" class="btn btn-download">打包SS插件</button>' }
				]);
			</script>
		</div>
	</div>
	<div class="box boxr8" id="ss_log_tab" style="margin-top: 0px;">
		<div id="ss_log_pannel" class="content">
			<div class="section content">
				<script type="text/javascript">
					y = Math.floor(docu.getViewSize().height * 0.55);
					s = 'height:' + ((y > 300) ? y : 300) + 'px;display:block';
					$('#ss_log_pannel').append('<textarea class="as-script" name="_ss_basic_log" id="_ss_basic_log" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
				</script>
			</div>
		</div>
	</div>
	<div id="msg_warring" class="alert alert-warning icon" style="display:none;"></div>
	<div id="msg_success" class="alert alert-success icon" style="display:none;"></div>
	<div id="msg_error" class="alert alert-error icon" style="display:none;"></div>
	<button type="button" value="Save" id="save-lb" onclick="save_lb()" class="btn btn-primary">保存负载均衡设置 <i class="icon-check"></i></button>
	<button type="button" value="Save" id="save-kcp" onclick="save_kcp()" class="btn btn-primary">保存kcp设置 <i class="icon-check"></i></button>
	<button type="button" value="Save" id="save-node" onclick="save_node()" class="btn btn-primary">保存节点 <i class="icon-check"></i></button>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">提交 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
	<div class="box boxr2" id="ssr_ping_tab" style="margin-top: 30px;">
		<div class="heading">ping测试</div>
		<div class="content">
			<div id="ss_ping_panel" class="tabContent">
				<script type="text/javascript">
					$('#ss_ping_panel').forms([
						{ title: '节点ping测试', multi: [
							{ name:'ss_basic_ping_method',type:'select',options:[["1", "ping 1次"], ["2", "10次ping平均 + 丢包率"], ["3", "20次ping平均 + 丢包率"] ], value: dbus.ss_basic_ping_method || "1", prefix:'ping测试方式：', suffix: ' &nbsp;&nbsp;'},
							//{ name:'ss_basic_ping_refresh',type:'select',options:[["1", "不显示（人工测试）"], ["0", "仅显示一次（不刷新）"], ["5", "5秒刷新一次"], ["15", "15秒刷新一次"], ["30", "30秒刷新一次"] ], value: dbus.ss_basic_ping_refresh || "0", prefix:'ping刷新间隔：', suffix: ' &nbsp;&nbsp;'},
							{ suffix: '<button id="ping_botton" onclick="ping_node();" class="btn btn-primary">手动测试ping <i class="icon-check"></i></button>' }
						]},
					]);
				</script>
			</div>
			<br><hr>
		</div>
	</div>
	<div class="box boxr2" id="ssr_node_subscribe" style="margin-top: 30px;">
		<div class="heading">SSR节点订阅</div>
		<div class="content">
			<div id="ssr_node_subscribe_pannel" class="section"></div>
			<script type="text/javascript">
				$('#ssr_node_subscribe_pannel').forms([
					{ title: 'SSR节点订阅地址', name:'ssr_subscribe_link',type:'text',size: 70, value:dbus.ssr_subscribe_link },
					{ title: '订阅节点模式设定',  name:'ssr_subscribe_mode',type:'select',options:option_mode,value:dbus.ssr_subscribe_mode || "2", suffix: '<lable id="_ssr_subscribe_mode_text">订阅后的服务器默认使用该模式。</lable>' },
					{ title: '订阅节点混淆参数设定', multi: [
						{ name: 'ssr_subscribe_obfspara',type:'select',options:[['0', '留空'], ['1', '使用订阅设定'], ['2', '自定义']], value: dbus.ssr_subscribe_obfspara || "2", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ssr_subscribe_obfspara_val', type: 'text', value: dbus.ssr_subscribe_obfspara_val || "www.baidu.com", suffix: '<lable id="_ssr_subscribe_obfspara_text">有的订阅服务器不包含混淆参数，你可以在此处统一设定。</lable>' }
					]}
				]);
			</script>
			<button type="button" value="Save" id="dele-subscribe-node" onclick="manipulate_conf('ss_conf.sh', 8)" class="btn" style="float:right;">删除订阅节点 <i class="icon-cancel"></i></button>
			<button type="button" value="Save" id="save-subscribe-node" onclick="manipulate_conf('ss_conf.sh', 7)" class="btn btn-primary" style="float:right;margin-right:20px;">获取/更新订阅 <i class="icon-check"></i></button>
		</div>
	</div>
	<script type="text/javascript">init_ss();</script>
</content>