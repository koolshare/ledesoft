<title>shadowsocks</title>
<content>
<style type="text/css">
.box {
	min-width:830px;
}
</style>
	<script type="text/javascript">
		var dbus;
		get_arp_list();
		get_dbus_data();
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
		var option_method = [['none', 'none'],['rc4', 'rc4'], ['rc4-md5', 'rc4-md5'], ['rc4-md5-6', 'rc4-md5-6'], ['aes-128-cfb', 'aes-128-cfb'], ['aes-192-cfb', 'aes-192-cfb'], ['aes-256-cfb', 'aes-256-cfb'], ['aes-128-ctr', 'aes-128-ctr'], ['aes-192-ctr', 'aes-192-ctr'], ['aes-256-ctr', 'aes-256-ctr'], ['camellia-128-cfb', 'camellia-128-cfb'], ['camellia-192-cfb', 'camellia-192-cfb'], ['camellia-256-cfb', 'camellia-256-cfb'], ['bf-cfb', 'bf-cfb'], ['cast5-cfb', 'cast5-cfb'], ['idea-cfb', 'idea-cfb'], ['rc2-cfb', 'rc2-cfb'], ['seed-cfb', 'seed-cfb'], ['salsa20', 'salsa20'], ['chacha20', 'chacha20'], ['chacha20-ietf', 'chacha20-ietf']];
		var option_ssr_protocal = [['origin','origin'],['verify_simple','verify_simple'],['verify_sha1','verify_sha1'],['auth_sha1','auth_sha1'],['auth_sha1_v2','auth_sha1_v2'],['auth_sha1_v4','auth_sha1_v4'],['auth_aes128_md5','auth_aes128_md5'],['auth_aes128_sha1','auth_aes128_sha1'],['auth_chain_a','auth_chain_a']];
		var option_ssr_obfs = [['plain','plain'],['http_simple','http_simple'],['http_post','http_post'],['tls1.2_ticket_auth','tls1.2_ticket_auth']];
		var option_dns_china = [['1', '运营商DNS【自动获取】'],  ['2', '阿里DNS1【223.5.5.5】'],  ['3', '阿里DNS2【223.6.6.6】'],  ['4', '114DNS1【114.114.114.114】'],  ['5', '114DNS1【114.114.115.115】'],  ['6', 'cnnic DNS【1.2.4.8】'],  ['7', 'cnnic DNS【210.2.4.8】'],  ['8', 'oneDNS1【112.124.47.27】'],  ['9', 'oneDNS2【114.215.126.16】'],  ['10', '百度DNS【180.76.76.76】'],  ['11', 'DNSpod DNS【119.29.29.29】'],  ['12', '自定义']];
		var option_dns_foreign = [['1', 'dns2socks'], ['2', 'ss-tunnel'], ['3', 'dnscrypt-proxy'], ['4', 'pdnsd'], ['5', 'ChinaDNS'], ['6', 'Pcap_DNSProxy']];
		var option_ss_sstunnel = [['2', 'google dns\[8.8.8.8\]'], ['3', 'google dns\[8.8.4.4\]'], ['1', 'OpenDNS\[208.67.220.220\]'], ['4', '自定义']];
		var option_ChinaDNS_china = [['1', '阿里DNS1【223.5.5.5】'], ['2', '阿里DNS2【223.6.6.6】'], ['3', '114DNS1【114.114.114.114】'], ['4', '114DNS1【114.114.115.115】'], ['5', 'cnnic DNS【1.2.4.8】'], ['6', 'cnnic DNS【210.2.4.8】'], ['7', 'oneDNS1【112.124.47.27】'], ['8', 'oneDNS2【114.215.126.16】'], ['9', '百度DNS【180.76.76.76】'], ['10', 'DNSpod DNS【119.29.29.29】'], ['11', '自定义']];
		var option_opendns = [['adguard-dns-family-ns1','Adguard DNS Family Protection 1'], ['adguard-dns-family-ns2','Adguard DNS Family Protection 2'], ['adguard-dns-ns1','Adguard DNS 1'], ['adguard-dns-ns2','Adguard DNS 2'], ['cisco','Cisco OpenDNS'], ['cisco-familyshield','Cisco OpenDNS with FamilyShield'], ['cisco-ipv6','Cisco OpenDNS over IPv6'], ['cisco-port53','Cisco OpenDNS backward compatibility port 53'], ['cloudns-syd','CloudNS Sydney'], ['cs-cawest','CS Canada west DNSCrypt server'], ['cs-cfi','CS cryptofree France DNSCrypt server'], ['cs-cfii','CS secondary cryptofree France DNSCrypt server'], ['cs-ch','CS Switzerland DNSCrypt server'], ['cs-de','CS Germany DNSCrypt server'], ['cs-fr2','CS secondary France DNSCrypt server'], ['cs-rome','CS Italy DNSCrypt server'], ['cs-useast','CS New York City NY US DNSCrypt server'], ['cs-usnorth','CS Chicago IL US DNSCrypt server'], ['cs-ussouth','CS Dallas TX US DNSCrypt server'], ['cs-ussouth2','CS Atlanta GA US DNSCrypt server'], ['cs-uswest','CS Seattle WA US DNSCrypt server'], ['cs-uswest2','CS Las Vegas NV US DNSCrypt server'], ['d0wn-au-ns1','OpenNIC Resolver Australia 01 - d0wn'], ['d0wn-bg-ns1','OpenNIC Resolver Bulgaria 01 - d0wn'], ['d0wn-cy-ns1','OpenNIC Resolver Cyprus 01 - d0wn'], ['d0wn-de-ns1','OpenNIC Resolver Germany 01 - d0wn'], ['d0wn-de-ns2','OpenNIC Resolver Germany 02 - d0wn'], ['d0wn-dk-ns1','OpenNIC Resolver Denmark 01 - d0wn'], ['d0wn-fr-ns2','OpenNIC Resolver France 02 - d0wn'], ['d0wn-es-ns1','OpenNIC Resolver Spain 01- d0wn'], ['d0wn-gr-ns1','OpenNIC Resolver Greece 01 - d0wn'], ['d0wn-hk-ns1','OpenNIC Resolver Hong Kong 01 - d0wn'], ['d0wn-is-ns1','OpenNIC Resolver Iceland 01 - d0wn'], ['d0wn-lu-ns1','OpenNIC Resolver Luxembourg 01 - d0wn'], ['d0wn-lu-ns1-ipv6','OpenNIC Resolver Luxembourg 01 over IPv6 - d0wn'], ['d0wn-lv-ns1','OpenNIC Resolver Latvia 01 - d0wn'], ['d0wn-lv-ns2','OpenNIC Resolver Latvia 02 - d0wn'], ['d0wn-lv-ns2-ipv6','OpenNIC Resolver Latvia 01 over IPv6 - d0wn'], ['d0wn-nl-ns3','OpenNIC Resolver Netherlands 03 - d0wn'], ['d0wn-nl-ns3-ipv6','OpenNIC Resolver Netherlands 03 over IPv6 - d0wn'], ['d0wn-random-ns1','OpenNIC Resolver Moldova 01 - d0wn'], ['d0wn-random-ns2','OpenNIC Resolver Netherlands 02 - d0wn'], ['d0wn-ro-ns1','OpenNIC Resolver Romania 01 - d0wn'], ['d0wn-ro-ns1-ipv6','OpenNIC Resolver Romania 01 over IPv6 - d0wn'], ['d0wn-ru-ns1','OpenNIC Resolver Russia 01 - d0wn'], ['d0wn-se-ns1','OpenNIC Resolver Sweden 01 - d0wn'], ['d0wn-se-ns1-ipv6','OpenNIC Resolver Sweden 01 over IPv6 - d0wn'], ['d0wn-sg-ns1','OpenNIC Resolver Singapore 01 - d0wn'], ['d0wn-sg-ns2','OpenNIC Resolver Singapore 02 - d0wn'], ['d0wn-sg-ns2-ipv6','OpenNIC Resolver Singapore 01 over IPv6 - d0wn'], ['d0wn-tz-ns1','OpenNIC Resolver Tanzania 01 - d0wn'], ['d0wn-ua-ns1','OpenNIC Resolver Ukraine 01 - d0wn'], ['d0wn-ua-ns1-ipv6','OpenNIC Resolver Ukraine 01 over IPv6 - d0wn'], ['d0wn-uk-ns1','OpenNIC Resolver United Kingdom 01 - d0wn'], ['d0wn-uk-ns1-ipv6','OpenNIC Resolver United Kingdom 01 over IPv6 - d0wn'], ['d0wn-us-ns1','OpenNIC Resolver United States of America 01 - d0wn'], ['d0wn-us-ns1-ipv6','OpenNIC Resolver United States of America 01 over IPv6 - d0wn'], ['d0wn-us-ns2','OpenNIC Resolver United States of America 02 - d0wn'], ['d0wn-us-ns2-ipv6','OpenNIC Resolver United States of America 02 over IPv6 - d0wn'], ['dns-freedom','DNS Freedom'], ['dnscrypt.eu-dk','DNSCrypt.eu Denmark'], ['dnscrypt.eu-dk-ipv6','DNSCrypt.eu Denmark over IPv6'], ['dnscrypt.eu-nl','DNSCrypt.eu Holland'], ['dnscrypt.eu-nl-ipv6','DNSCrypt.eu Holland over IPv6'], ['dnscrypt.org-fr','DNSCrypt.org France'], ['fvz-anyone','Primary OpenNIC Anycast DNS Resolver'], ['fvz-anyone-ipv6','Primary OpenNIC Anycast DNS IPv6 Resolver'], ['fvz-anytwo','Secondary OpenNIC Anycast DNS Resolver'], ['fvz-anytwo-ipv6','Secondary OpenNIC Anycast DNS IPv6 Resolver'], ['ipredator','Ipredator.se Server'], ['ns0.dnscrypt.is','ns0.dnscrypt.is in Reykjav铆k, Iceland'], ['okturtles','okTurtles'], ['opennic-tumabox','TumaBox'], ['ovpnse','OVPN.se Integritet AB'], ['soltysiak','Soltysiak'], ['soltysiak-ipv6','Soltysiak over IPv6'], ['ventricle.us','Anatomical DNS'], ['yandex','Yandex']];
		var option_status_inter = [['0', '不更新'], ['5', '5s'], ['10', '10s'], ['15', '15s'], ['30', '30s'], ['60', '60s']];
		var option_sleep = [['0', '0s'], ['5', '5s'], ['10', '10s'], ['15', '15s'], ['30', '30s'], ['60', '60s']];
		var ssbasic = ["mode", "server", "port", "password", "method" ];
		var ssrbasic = ["mode", "server", "port", "password", "method", "rss_protocal", "rss_protocal_para", "rss_obfs", "rss_obfs_para"];
		var option_arp_list = [];
		var option_arp_local = [];
		var option_arp_new = [];
		var option_hour_time = [];
		var option_node_name = [];
		for(var i = 0; i < 24; i++){
			option_hour_time[i] = [i, i + "时"];
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
		var ss_node = new TomatoGrid();
		ss_node.dataToView = function(data) {
			return [ option_mode_name[data[0]], data[1] || "节点" + data.length, data[2], data[3], "******", data[5]];
		}
		ss_node.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return v_iptaddr( f[2], quiet ) && v_port( f[3], quiet );
		}
		ss_node.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].selectedIndex   = '';
			f[ 1 ].value   = '';
			f[ 2 ].value   = '';
			f[ 3 ].value   = '';
			f[ 4 ].value   = '';
			f[ 5 ].selectedIndex   = '';
		}
		ss_node.setup = function() {
			this.init( 'ss_node-grid', '', 50, [
				{ type: 'select',maxlen:20,options:option_mode,value:'' },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'select',maxlen:20,options:option_method,value:''}
			] );
			this.headerSet( [ '模式', '节点名称', '服务器地址', '端口', '密码', '加密方式' ] );
			for ( var i = 1; i <= dbus["ssconf_basic_node_max"]; i++){
				var t1 = [dbus["ssconf_basic_mode_" + i ], 
						dbus["ssconf_basic_name_" + i ], 
						dbus["ssconf_basic_server_" + i ], 
						dbus["ssconf_basic_port_" + i ], 
						dbus["ssconf_basic_password_" + i ], 
						dbus["ssconf_basic_method_" + i ]]
				if ( t1.length == 6 ) this.insertData( -1, t1 );
			}
			//console.log("t1", t1);
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		var ssr_node = new TomatoGrid();
		ssr_node.dataToView = function(data) {
			return [ option_mode_name[data[0]],	data[1], data[2], data[3], "******", data[5], data[6], "******", data[8], data[9]];
		}
		ssr_node.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			return v_iptaddr( f[2], quiet ) && v_port( f[3], quiet ) && v_domain( f[9], quiet );
		}
		ssr_node.resetNewEditor = function() {
			var f;
			f = fields.getAll( this.newEditor );
			ferror.clearAll( f );
			f[ 0 ].selectedIndex   = '';
			f[ 1 ].value   = '';
			f[ 2 ].value   = '';
			f[ 3 ].value   = '';
			f[ 4 ].value   = '';
			f[ 5 ].selectedIndex   = '';
			f[ 6 ].selectedIndex   = '';
			f[ 7 ].value   = '';
			f[ 8 ].selectedIndex   = '';
			f[ 9 ].value   = '';
		}
		ssr_node.setup = function() {
			this.init( 'ssr_node-grid', '', 50, [
				{ type: 'select',maxlen:20,options:option_mode,value:'' },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'text', maxlen: 50 },
				{ type: 'select',maxlen:40,options:option_method,value:''},
				{ type: 'select',maxlen:40,options:option_ssr_protocal,value:''},
				{ type: 'text', maxlen: 50 },
				{ type: 'select',maxlen:40,options:option_ssr_obfs,value:''},
				{ type: 'text', maxlen: 50 }
			] );
			this.headerSet( [ '模式', '节点名称', '服务器地址', '端口', '密码', '加密方式', '协议', '协议参数', '混淆', '混淆参数' ] );
			for ( var i = 1; i <= dbus["ssrconf_basic_node_max"]; i++){
				var t2 = [dbus["ssrconf_basic_mode_" + i ], 
						dbus["ssrconf_basic_name_" + i ], 
						dbus["ssrconf_basic_server_" + i ], 
						dbus["ssrconf_basic_port_" + i ], 
						dbus["ssrconf_basic_password_" + i ], 
						dbus["ssrconf_basic_method_" + i ],
						dbus["ssrconf_basic_rss_protocal_" + i ],
						dbus["ssrconf_basic_rss_protocal_para_" + i ] || " ",
						dbus["ssrconf_basic_rss_obfs_" + i ],
						dbus["ssrconf_basic_rss_obfs_para_" + i ] || " "]  
				if ( t2.length == 10 ) this.insertData( -1, t2 );
			}
			//console.log("t2", t2);
			this.showNewEditor();
			this.resetNewEditor();
		}
		//============================================
		var ss_acl = new TomatoGrid();
		ss_acl.dataToView = function( data ) {
			return [ data[0] || "未命名主机", data[1], data[2], option_acl_mode_name[data[3]], data[4] ];
		}
		ss_acl.fieldValuesToData = function( row ) {
			var f = fields.getAll( row );
			return [ f[0].value, f[1].value, f[2].value, f[3].value, f[4].value ];
		}
		ss_acl.verifyFields = function( row, quiet ) {
			var f = fields.getAll( row );
			// fill the ip and mac when chose the name
			if (f[0].value){
				f[1].value = option_arp_list[f[0].selectedIndex][2];
				f[2].value = option_arp_list[f[0].selectedIndex][3];
			}
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
			return v_ip( f[ 1 ], quiet ) || v_mac( f[ 2 ], quiet );
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
			this.init( 'ss_acl_pannel', '', 50, [
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
				var t = [dbus["ss_acl_name_" + i ] || "未命名主机 - " + i, 
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
			verifyFields();
			ss_node.setup();
			ssr_node.setup();
			$("#_ss_basic_log").click(
				function() {
					x = 10000000;
			});
			auto_node_sel();
			
			$('#_ss_version').html( '<a style="margin-left:-4px" href="https://github.com/koolshare/ttsoft/blob/master/shadowsocks/Changelog.txt" target="_blank"><font color="#0099FF">shadowsocks for tomato  ' + (dbus["ss_basic_version"]  || "") + '</font></a>' );
			setTimeout("get_run_status();", 1000);
			setTimeout("get_dns_status();", 1100);
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
			for ( var i = 0; i < node_ss; i++){
				option_node_name[i] = [ ( i + 1), "【SS】" + dbus["ssconf_basic_name_" + ( i + 1)]];
			}
			for ( var i = node_ss; i < (node_ss + node_ssr); i++){
				option_node_name[i] = [ ( i + 1), "【SSR】" + dbus["ssrconf_basic_name_" + ( i + 1 - node_ss)]];
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
			  	}
			});
		}
		
		function get_run_status(){
			if (status_time > 99999999){
				return false;
			}
			var id1 = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id1, "method": "ss_status.sh", "params":[2], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					++status_time;
					//console.log("status check time:", status_time);
					if (response.result == '-2'){
						E("_ss_basic_status_foreign").innerHTML = "获取运行状态失败！";
						E("_ss_basic_status_china").innerHTML = "获取运行状态失败！";
						setTimeout("get_run_status();", (status_refresh_rate * 1000));
					}else{
						if(dbus["ss_basic_enable"] == "0"){
							E("_ss_basic_status_foreign").innerHTML = "国外链接 - 尚未提交，暂停获取状态！";
							E("_ss_basic_status_china").innerHTML = "国内链接 - 尚未提交，暂停获取状态！";
						}else{
							E("_ss_basic_status_foreign").innerHTML = response.result.split("@@")[0];
							E("_ss_basic_status_china").innerHTML = response.result.split("@@")[1];
						}
						setTimeout("get_run_status();", (status_refresh_rate * 1000));

					}
				},
				error: function(){
					E("_ss_basic_status_foreign").innerHTML = "获取运行状态失败！";
					E("_ss_basic_status_china").innerHTML = "获取运行状态失败！";
					setTimeout("get_run_status();", (status_refresh_rate * 1000));
				}
			});
		}
		function get_dns_status(){
			if(dbus["ss_basic_dns_success"] == "1"){
				$('#_ss_basic_dnslookup_txt').html("服务器IP地址解析正常！")
			}else{
				$('#_ss_basic_dnslookup_txt').html("！！！服务器IP地址解析异常！！！")
			}
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
						//console.log("s2", s2);
						for ( var i = 0; i < s2.length; ++i ) {
							option_arp_local[i] = [s2[ i ].split( '<' )[0], s2[ i ].split( '<' )[0],s2[ i ].split( '<' )[1],s2[ i ].split( '<' )[2]];
						}
						var node_acl = parseInt(dbus["ss_acl_node_max"]) || 0;
						for ( var i = 0; i < node_acl; ++i ) {
							option_arp_new[i] = [dbus["ss_acl_name_" + (i + 1)], dbus["ss_acl_name_" + (i + 1)], dbus["ss_acl_ip_" + (i + 1)], dbus["ss_acl_mac_" + (i + 1)]];
						}			
						option_arp_list = $.extend([],option_arp_local, option_arp_new);
						//console.log("option_arp_list", option_arp_list);
						ss_acl.setup();
					}
				},
				error:function(){
					ss_acl.setup();
				},
				timeout:1000
			});
		}
		function auto_node_sel(){
			node_sel = E('_ss_basic_node').value || 1;
			//console.log("using_node:", node_sel);
			//console.log("node_ss_nu:", node_ss);
			//console.log("node_ssr_nu:", node_ssr);
			if (dbus["ssrconf_basic_rss_protocal_" + (node_sel - node_ss)]){ // using ssr
				//console.log("node_status:", "using ssr");
				dbus["ss_basic_type"] = "1";
				var o1  = E('_ss_basic_rss_protocal').value == 'auth_aes128_md5'; 
				var o2  = E('_ss_basic_rss_protocal').value == 'auth_aes128_sha1'; 
				elem.display(PR('_ss_basic_rss_protocal_para'), o1 || o2);
				elem.display(PR('_ss_basic_rss_protocal'), true);
				elem.display(PR('_ss_basic_rss_obfs'), PR('_ss_basic_rss_obfs_para'), true);
				elem.display(PR('_ss_basic_mode'), true);
				for (var i = 0; i < ssrbasic.length; i++) {
					if (typeof (dbus["ssrconf_basic_" + ssrbasic[i] + "_" + (node_sel - node_ss)]) == "undefined"){
						E('_ss_basic_' + ssrbasic[i] ).value = ""
					}else{
						E('_ss_basic_' + ssrbasic[i] ).value = dbus["ssrconf_basic_" + ssrbasic[i] + "_" + (node_sel - node_ss)] || "";
					}
				}
			}else{ //using ss
				//console.log("node_status:", "using ss");
				dbus["ss_basic_type"] = "0";
				E('_ss_basic_rss_protocal').value = ""
				E('_ss_basic_rss_protocal_para').value = ""
				E('_ss_basic_rss_obfs').value = ""
				E('_ss_basic_rss_obfs_para').value = ""
				elem.display(PR('_ss_basic_rss_protocal'), PR('_ss_basic_rss_protocal_para'), false);
				elem.display(PR('_ss_basic_rss_obfs'), PR('_ss_basic_rss_obfs_para'), false);
				elem.display(PR('_ss_basic_mode'), true);
				for (var i = 0; i < ssbasic.length; i++) {
					if (typeof (dbus["ssconf_basic_" + ssbasic[i] + "_" + node_sel]) == "undefined"){
						E('_ss_basic_' + ssbasic[i] ).value = ""
					}else{
						E('_ss_basic_' + ssbasic[i] ).value = dbus["ssconf_basic_" + ssbasic[i] + "_" + node_sel];
					}
				}
			}
			// when web loaded, hide some element when ss not enabled
			var a  = E('_ss_basic_enable').checked;
			elem.display('ss_status_pannel', a);
			elem.display('ss_tabs', a);
			elem.display('ss_basic_tab', a);
		}

		function verifyFields(r){
			node_sel = E('_ss_basic_node').value || 1;
			// when node changed, the main pannel element and other element should be changed, too.
			if ( $(r).attr("id") == "_ss_basic_node" ) {
				auto_node_sel();
			}
			// when check/uncheck ss_switch
			var a  = E('_ss_basic_enable').checked;
			if ( $(r).attr("id") == "_ss_basic_enable" ) {
				if(a){
					elem.display('ss_status_pannel', a);
					elem.display('ss_tabs', a);
					tabSelect('app1')
				}else{
					tabSelect('fuckapp')
				}
			}
			// when change mode, the default acl mode should be also changed
			if ( $(r).attr("id") == "_ss_basic_mode" ) {
				if (E("_ss_acl_default_mode").value != "0"){
					E("_ss_acl_default_mode").value = E("_ss_basic_mode").value;
				}
			}
			//if ( $(r).attr("id") == "_ss_dns_plan" ) {
				if (E("_ss_dns_plan").value == "1"){
					$('#_ss_dns_plan_txt').html("国内dns解析cdn名单内的国内域名用，剩下的域名用国外dns解析。 ")
				}else{
					$('#_ss_dns_plan_txt').html("国外dns解析gfwlist名单内的国外域名，剩下的域名用国内dns解析。 ")
				}
			//}
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
			var a  = E('_ss_basic_enable').checked;
			var b1 = (E('_ss_basic_mode').value == '1');
			var b2 = (E('_ss_basic_mode').value == '2');
			var b3 = (E('_ss_basic_mode').value == '3');
			var b4 = (E('_ss_basic_mode').value == '4');
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
			
			elem.display('_ss_dns_china_user', c);
			elem.display('_ss_dns2socks_user', d1);
			elem.display('_ss_sstunnel', d2);
			elem.display('_ss_sstunnel_user', d2 && e);
			elem.display('_ss_opendns', d3);
			//pdnsd method
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
			var o1  = E('_ss_basic_rss_protocal').value == 'auth_aes128_md5'; 
			var o2  = E('_ss_basic_rss_protocal').value == 'auth_aes128_sha1'; 
			elem.display(PR('_ss_basic_rss_protocal_para'), o1 || o2);
		}
		function tabSelect(obj){
			var tableX = ['app1-tab','app2-tab','app3-tab','app4-tab','app5-tab','app6-tab','app7-tab','app8-tab'];
			var boxX = ['boxr1','boxr2','boxr3','boxr4','boxr5','boxr6','boxr7','boxr8'];
			var appX = ['app1','app2','app3','app4','app5','app6','app7','app8'];
			for (var i = 0; i < tableX.length; i++){
				if(obj == appX[i]){
					$('#'+tableX[i]).addClass('active');
					$('.'+boxX[i]).show();
				}else{
					$('#'+tableX[i]).removeClass('active');
					$('.'+boxX[i]).hide();
				}
			}
			if(obj=='app2'){
				E('save-button').style.display = "none";
				E('save-node').style.display = "";
			}else{
				E('save-button').style.display = "";
				E('save-node').style.display = "none";
			}
			if(obj=='app8'){
				elem.display('save-button', false);
				elem.display('save-node', false);
				elem.display('cancel-button', false);
				setTimeout("get_log();", 100);
			}
			if(obj=='fuckapp'){
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
				E('save-button').style.display = "";
				E('save-node').style.display = "none";
			}
		}
		function showMsg(Outtype, title, msg){
			$('#'+Outtype).html('<h5>'+title+'</h5>'+msg+'<a class="close"><i class="icon-cancel"></i></a>');
			$('#'+Outtype).show();
		}
		function save_node(){
			// data from ss_node & ssr_node
			var ssconf = ["ssconf_basic_mode_", "ssconf_basic_name_", "ssconf_basic_server_", "ssconf_basic_port_", "ssconf_basic_password_", "ssconf_basic_method_" ];
			var ssrconf = ["ssrconf_basic_mode_", "ssrconf_basic_name_", "ssrconf_basic_server_", "ssrconf_basic_port_", "ssrconf_basic_password_", "ssrconf_basic_method_", "ssrconf_basic_rss_protocal_", "ssrconf_basic_rss_protocal_para_", "ssrconf_basic_rss_obfs_", "ssrconf_basic_rss_obfs_para_"];
			// ss: mark all node data for delete first
			for ( var i = 1; i <= dbus["ssconf_basic_node_max"]; i++){
				for ( var j = 0; j < ssconf.length; ++j ) {
					dbus[ssconf[j] + i ] = ""
				}
			}
			// ssr: mark all node data for delete first
			for ( var i = 1; i <= dbus["ssrconf_basic_node_max"]; i++){
				for ( var j = 0; j < ssrconf.length; ++j ) {
					dbus[ssrconf[j] + i ] = ""
				}
			}
			// ss: collect node data from rule pannel
			var data1 = ss_node.getAllData();
			//console.log("data1", data1)
			if(data1.length > 0){
				for ( var i = 0; i < data1.length; ++i ) {
					for ( var j = 0; j < ssconf.length; ++j ) {
						dbus[ssconf[j] + (i + 1)] = data1[i][j];
					}
				}
				dbus["ssconf_basic_node_max"] = data1.length;
			}else{
				dbus["ssconf_basic_node_max"] = "";
			}
			// ssr: collect node data from rule pannel
			var data2 = ssr_node.getAllData();
			if(data2.length > 0){
				for ( var i = 0; i < data2.length; ++i ) {
					for ( var j = 0; j < ssrconf.length; ++j ) {
						dbus[ssrconf[j] + (i + 1)] = data2[i][j];
					}
				}
				dbus["ssrconf_basic_node_max"] = data2.length;
			}else{
				dbus["ssrconf_basic_node_max"] = "";
			}
			// now post data
			var id4 = parseInt(Math.random() * 100000000);
			var postData3 = {"id": id4, "method": "ss_config.sh", "params":[10], "fields": dbus};
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
						window.location.reload();
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
		function save(){
			setTimeout("tabSelect('app8')", 500);
			status_time = 999999990;
			get_run_status();
			E("_ss_basic_status_foreign").innerHTML = "国外链接 - 提交中...暂停获取状态！";
			E("_ss_basic_status_china").innerHTML = "国内链接 - 提交中...暂停获取状态！";
			var paras_chk = ["enable", "gfwlist_update", "chnroute_update", "cdn_update", "chromecast"];
			var paras_inp = ["ss_basic_node", "ss_basic_mode", "ss_basic_server", "ss_basic_port", "ss_basic_password", "ss_basic_method", "ss_basic_rss_protocal", "ss_basic_rss_protocal_para", "ss_basic_rss_obfs", "ss_basic_rss_obfs_para", "ss_dns_plan", "ss_dns_china", "ss_dns_china_user", "ss_dns_foreign", "ss_dns2socks_user", "ss_sstunnel", "ss_sstunnel_user", "ss_opendns", "ss_pdnsd_method", "ss_pdnsd_udp_server", "ss_pdnsd_udp_server_dns2socks", "ss_pdnsd_udp_server_dnscrypt", "ss_pdnsd_udp_server_ss_tunnel", "ss_pdnsd_udp_server_ss_tunnel_user", "ss_pdnsd_server_ip", "ss_pdnsd_server_port", "ss_pdnsd_server_cache_min", "ss_pdnsd_server_cache_max", "ss_chinadns_china", "ss_chinadns_china_user", "ss_chinadns_foreign_method", "ss_chinadns_foreign_dns2socks", "ss_chinadns_foreign_dnscrypt", "ss_chinadns_foreign_sstunnel", "ss_chinadns_foreign_sstunnel_user", "ss_chinadns_foreign_method_user", "ss_basic_rule_update", "ss_basic_rule_update_time", "ss_basic_refreshrate", "ss_basic_dnslookup", "ss_basic_dnslookup_server", "ss_acl_default_mode", "ss_acl_default_port" ];
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
						dbus[ss_acl_conf[0] + (i + 1)] = data4[i][0] || "未命名主机 - " + (i + 1);
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
							// start to check ss status
							status_time = 1;
							setTimeout("get_run_status();", 2000);
							// switch to tab1 if the log area not clicked
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
					if (noChange > 2000) {
						tabSelect("app1");
						return false;
					} else {
						setTimeout("get_log();", 100); //100 is radical but smooth!
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
				tabSelect("app1");
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
				cookie.set('adv_dhcpdns_' + whichone + '_vis', 0);
			} else {
				E('sesdiv' + whichone).style.display='';
				E('sesdiv' + whichone + 'showhide').innerHTML='<i class="icon-chevron-down"></i>';
				cookie.set('adv_dhcpdns_' + whichone + '_vis', 1);
			}
		}

		function update_rules_now(arg){
			if (arg == 5){
				shellscript = 'ss_rule_update.sh';
			}else{
				shellscript = 'pcap_update_list.sh';
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
						x = 4;
						count_down_switch();
					}
				});
				tabSelect("app8");
		}
		function manipulate_conf(script, arg){
			if(arg == 1 || arg == 2 || arg == 3 || arg == 5 || arg == 6){
				tabSelect("app8");
			}
			var id7 = parseInt(Math.random() * 100000000);
			var postData = {"id": id7, "method": script, "params":[arg], "fields": [] };
			$.ajax({
				type: "POST",
				url: "/_api/",
				async: true,
				cache:false,
				data: JSON.stringify(postData),
				dataType: "json",
				success: function(response){
					if (script == "ss_conf.sh"){
						if(arg == 1 || arg == 2 || arg == 3){
							setTimeout("window.location.reload()", 500);
						}else if (arg == 5){
							setTimeout("window.location.reload()", 1000);
						}else if (arg == 4){
							var a = document.createElement('A');
							a.href = "/_root/files/ss_conf_backup.sh";
							a.download = 'ss_conf_backup.sh';
							document.body.appendChild(a);
							a.click();
							document.body.removeChild(a);
						}else if (arg == 6){
							var b = document.createElement('A')
							b.href = "/_root/files/shadowsocks.tar.gz"
							b.download = 'shadowsocks.tar.gz'
							document.body.appendChild(b)
							b.click()
							document.body.removeChild(b)
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
	<div class="box" style="margin-top: 0px;min-width:830px;">
		<div class="heading">
			<span id="_ss_version"><font color="#1bbf35">shadowsocks for toamto</font></span>
			<a href="/#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
		</div>
		<div class="content">
			<div id="ss_switch_pannel" class="section"></div>
			<script type="text/javascript">
				$('#ss_switch_pannel').forms([
					{ title: 'shadowsocks开关', name:'ss_basic_enable',type:'checkbox',  value: dbus.ss_basic_enable == 1 }  // ==1 means default close; !=0 means default open
				]);
			</script>
			<hr />
			<fieldset id="ss_status_pannel">
				<label class="col-sm-3 control-left-label" for="_undefined">shadowsocks运行状态</label>
				<div class="col-sm-9">
					<font id="_ss_basic_status_foreign" name="ss_basic_status_foreign" color="#1bbf35">国外链接: waiting...</font>
				</div>
				<div class="col-sm-9" style="margin-top:2px">
					<font id="_ss_basic_status_china" name="ss_basic_status_china" color="#1bbf35">国内链接: waiting...</font>
				</div>
			</fieldset>
		</div>
	</div>
	<ul id="ss_tabs" class="nav nav-tabs" style="min-width:830px;">
		<li><a href="javascript:tabSelect('app1');" id="app1-tab" class="active"><i class="icon-system"></i> 帐号设置</a></li>
		<li><a href="javascript:tabSelect('app2');" id="app2-tab"><i class="icon-globe"></i> 节点管理</a></li>
		<li><a href="javascript:tabSelect('app3');" id="app3-tab"><i class="icon-tools"></i> DNS设定</a></li>
		<li><a href="javascript:tabSelect('app4');" id="app4-tab"><i class="icon-warning"></i> 黑白名单</a></li>
		<li><a href="javascript:tabSelect('app5');" id="app5-tab"><i class="icon-cmd"></i> 规则管理</a></li>
		<li><a href="javascript:tabSelect('app6');" id="app6-tab"><i class="icon-lock"></i> 访问控制</a></li>
		<li><a href="javascript:tabSelect('app7');" id="app7-tab"><i class="icon-wake"></i> 附加功能</a></li>
		<li><a href="javascript:tabSelect('app8');" id="app8-tab"><i class="icon-hourglass"></i> 查看日志</a></li>	
</ul>
	<div class="box boxr1" id="ss_basic_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="ss_basic_pannel" class="section"></div>
			<script type="text/javascript">
				join_node();
				if (typeof(dbus["ssconf_basic_node_max"]) == "undefined" && typeof(dbus["ssrconf_basic_node_max"]) == "undefined"){
					$('#ss_basic_pannel').forms([
						{ title: '节点选择', name:'ss_basic_node',type:'select',options:[['1', '节点1']], value: "1"}
					]);
				}else{
					$('#ss_basic_pannel').forms([
						{ title: '节点选择', name:'ss_basic_node',type:'select',options:option_node_name, value: dbus.ss_basic_node || "1"}
					]);
				}
				$('#ss_basic_pannel').forms([
					{ title: '模式',  name:'ss_basic_mode',type:'select',options:option_mode,value: "" || "1" },
					{ title: '服务器地址', name:'ss_basic_server',type:'text',size: 20,value:dbus.ss_basic_server,help: '尽管支持域名格式，但是仍然建议首先使用IP地址。' },
					{ title: '服务器端口', name:'ss_basic_port',type:'text',size: 20,value:"" },
					{ title: '密码', name:'ss_basic_password',type:'password',size: 20,value:"",help: '如果你的密码内有特殊字符，可能会导致密码参数不能正确的传给ss，导致启动后不能使用ss。'  },
					{ title: '加密方式', name:'ss_basic_method',type:'select',options:option_method,value: dbus.ss_basic_method || "aes-256-cfb" },
					{ title: '协议 (protocal)', name:'ss_basic_rss_protocal',type:'select',options:option_ssr_protocal,value: dbus.ss_basic_rss_protocal || "auth_sha1_v4" },
					{ title: '协议参数 (SSR特性)', name:'ss_basic_rss_protocal_para',type:'text',size: 20, value:dbus.ss_basic_rss_protocal_para, help: '协议参数是SSR单端口多用户（端口复用）配置的必选项，如果你的SSR帐号没有启用端口复用，可以将此处留空。' },
					{ title: '混淆方式 (obfs)', name:'ss_basic_rss_obfs',type:'select',options:option_ssr_obfs,value:dbus.ss_basic_rss_obfs || "tls1.2_ticket_auth" },
					{ title: '混淆参数 (SSR特性)', name:'ss_basic_rss_obfs_para',type:'text',size: 20, value: dbus.ss_basic_rss_obfs_para }
				]);
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
			<br><hr>
		</div>
	</div>
	<div class="box boxr2" id="ssr_node_tab" style="margin-top: 0px;">
		<div class="heading">节点管理-SSR节点</div>
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing="1" id="ssr_node-grid">
				</table>
			</div>
			<br><hr>
		</div>
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
						{ name: 'ss_basic_rule_update_time', type: 'select', options:option_hour_time, value: dbus.ss_basic_rule_update_time || "3",suffix: ' &nbsp;&nbsp;' },
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
		<div class="content">
			<div class="tabContent">
				<table class="line-table" cellspacing=1 id="ss_acl_pannel"></table>
			</div>
			<br><hr>
		</div>
	</div>
	<div id="ss_acl_tab_readme" class="box boxr6">
		<div class="heading">访问控制操作手册： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
		<div class="section content" id="sesdivnotes" style="display:none">
				<li><b>1：</b> 你可以在这里轻松的定义你需要的主机走SS的模式，或者你可以什么都不做，使用缺省规则，代表全部主机都默认走【帐号设置】内的模式；</li>
				<li><b>2：</b> 主机别名、主机IP地址、MAC地址已经在系统的arp列表里获取了，在tomato路由下的设备均能被选择，选择后相应设备的ip和mac地址会自动填写；</li>
				<li><b>3：</b> 如果你需要的设备在列表里不能选择，可以不选择主机别名列表，然后填选好其他地方，添加后保存，插件会自动为你的这个设备分配一个名字；</li>
				<li><b>4：</b> 请按照格式填写ip和mac地址，ip和mac地址至少一个不能为空！</li>
				<li><b>5：</b> 插件为每个模式推荐了相应的端口，当你选择相应访问控制模式的时候，端口会自动变化，你也可以不用推荐的设置，自己选择想要的端口；</li>
				<li><b>6：</b> 当访问控制模式不为：不通过ss的时候，在【帐号设置】面板里更改模式，这里的缺省规则模式会自动发生变化，否则不发生变化。</li>
		</div>
	</div>
	<div class="box boxr7" id="ss_addon_tab" style="margin-top: 0px;">
		<div class="heading"></div>
		<div class="content" style="margin-top: -20px;">
			<div id="ss_addon_pannel" class="section"></div>
			<script type="text/javascript">
				$('#ss_addon_pannel').forms([
					{ title: '状态更新间隔', name:'ss_basic_refreshrate',type:'select',options:option_status_inter, value: dbus.ss_basic_refreshrate || "5"},
					{ title: 'chromecast支持',  name:'ss_basic_chromecast',type:'checkbox', value: dbus.ss_basic_chromecast != 0 },
					//{ title: '开机延迟启动', name:'ss_basic_sleep',type:'select',options:option_sleep, value:dbus.ss_basic_sleep || "0" },
					{ title: 'SS服务器地址解析', multi: [
						{ name: 'ss_basic_dnslookup',type:'select',options:[['0', 'resolveip方式'], ['1', 'nslookup方式']], value: dbus.ss_basic_dnslookup || "1", suffix: ' &nbsp;&nbsp;' },
						{ name: 'ss_basic_dnslookup_server', type: 'text', value: dbus.ss_basic_dnslookup_server || "119.29.29.29", suffix: '<lable id="_ss_basic_dnslookup_txt"></lable>' }
					]},
					{ title: 'SS数据清除', text: '<button onclick="manipulate_conf(\'ss_conf.sh\', 1);" class="btn btn-success">清除所有SS数据</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="manipulate_conf(\'ss_conf.sh\', 2);" class="btn btn-success">清除SS节点数据</button>&nbsp;&nbsp;&nbsp;&nbsp;<button onclick="manipulate_conf(\'ss_conf.sh\', 3);" class="btn btn-success">清除访问控制数据</button>' },
					{ title: 'SS数据备份', text: '<button onclick="manipulate_conf(\'ss_conf.sh\', 4);" class="btn btn-download">备份所有SS数据</button>' },
					{ title: 'SS数据恢复', text: '<input type="file" id="file" size="50">&nbsp;&nbsp;<button id="upload1" type="button"  onclick="restore_conf();" class="btn btn-danger">上传并恢复 <i class="icon-cloud"></i></button>' },
					{ title: 'SS插件备份', text: '<button onclick="manipulate_conf(\'ss_conf.sh\', 6);" class="btn btn-download">打包SS插件</button>' }
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
	<button type="button" value="Save" id="save-node" onclick="save_node()" class="btn btn-primary">保存节点 <i class="icon-check"></i></button>
	<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">提交 <i class="icon-check"></i></button>
	<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
	<script type="text/javascript">init_ss();</script>
</content>
