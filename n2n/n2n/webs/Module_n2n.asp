<title>软件中心 - N2N V2</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<script type="text/javascript">
	getAppData();
	setTimeout("get_run_status();", 1000);
	toggleVisibility('notes')
	var dbus;
	var softcenter = 0;
	var option_backup_hour = [];
	for(var i = 0; i < 24; i++){
		option_backup_hour[i] = [i, i + "时"];
	}

	function init_n2n(){
		getAppData();
		verifyFields();
	}

	function getAppData(){
		$.ajax({
			type: "GET",
			url: "/_api/n2n_",
			dataType: "json",
			async:false,
			success: function(data){
				dbus = data.result[0];
			}
		});
	}

	
	function get_run_status(){
		var id1 = parseInt(Math.random() * 100000000);
		var postData1 = {"id": id1, "method": "n2n_status.sh", "params":[2], "fields": ""};
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
			document.getElementById("n2n_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
			},
			error: function(){
				if(softcenter == 1){
					return false;
				}
			document.getElementById("n2n_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
			}
		});
	}	

	function verifyFields(){
		var dnsenable = E('_n2n_enable').checked ? '1':'0';
		if(dnsenable == 0){
			$('input').prop('disabled', true);
			$(E('_n2n_enable')).prop('disabled', false);
			$(E('_n2n_supernode_enable')).prop('disabled', false);
			$(E('_n2n_supernode_port')).prop('disabled', false);
			$("#save-button").html("停止运行")
		}else{
			$('input').prop('disabled', false);
			$("#save-button").html("开始运行")
		}
		var a = (E('_n2n_edge_mode').value == '2');
		elem.display(PR('_n2n_edge_ip'), a);
		elem.display(PR('_n2n_edge_netmask'), a);
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
		
	function save(){
		verifyFields();
		E('save-button').disabled = true;
		// collect basic data
		var para_chk = ["n2n_enable", "n2n_supernode_enable", "n2n_edge_route"];
		var para_inp = ["n2n_edge_server", "n2n_edge_port", "n2n_edge_key", "n2n_edge_community", "n2n_edge_mode", "n2n_edge_ip", "n2n_edge_netmask", "n2n_supernode_port"];
		// collect data from checkbox
		for (var i = 0; i < para_chk.length; i++) {
			dbus[para_chk[i]] = E('_' + para_chk[i] ).checked ? '1':'0';
		}
		// data from other element
		for (var i = 0; i < para_inp.length; i++) {
			if (!E('_' + para_inp[i] ).value){
				dbus[para_inp[i]] = "";
			}else{
				dbus[para_inp[i]] = E('_' + para_inp[i]).value;
			}
		}
			// post data
		var id = 1 + Math.floor(Math.random() * 6);
		var postData = {"id": id, "method":'n2n_config.sh', "params":[], "fields": dbus};
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
<div class="heading">N2N V2<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	N2N是一个开源（GPLv3）软件，它允许你在用户间构建一个加密的 2/3 层点对点 VPN，它拥有在反向通信方向（如从外部到内部）穿越NAT和防火墙的能力。
</div>
</div>
<div class="box">
<br><hr>
<div class="content">
<div id="n2n-fields"></div>
<script type="text/javascript">
	var option_local = [['1', 'DHCP'],['2', '静态地址']];
	$('#n2n-fields').forms([
		{ title: '开启', name: 'n2n_enable', type: 'checkbox', value: ((dbus.n2n_enable == '1')? 1:0)},
		{ title: '云盘运行状态', text: '<font id="n2n_status" name=n2n_status color="#1bbf35">正在获取运行状态...</font>' },
		{ title: '超级节点地址', name: 'n2n_edge_server', type: 'text', size: 20, value: dbus.n2n_edge_server || '127.0.0.1' },
		{ title: '超级节点端口', name: 'n2n_edge_port', type: 'text', size: 5, value: dbus.n2n_edge_port || '4234' },
		{ title: '认证密码', name: 'n2n_edge_key', type: 'password', size: 20, value: dbus.n2n_edge_key  || 'koolshare' ,peekaboo: 1 },
		{ title: 'MTU', name: 'n2n_edge_mtu', type: 'text', size: 5, value: dbus.n2n_edge_mtu || '1400' },
		{ title: '虚拟局域网名称', name: 'n2n_edge_community', type: 'text', size: 50, value: dbus.n2n_edge_community || 'koolshare' },
		{ title: '虚拟局域网IP获取方式', name: 'n2n_edge_mode', type: 'select', options: option_local, value: dbus.n2n_edge_mode || '2'  },
		{ title: '虚拟局域网IP', name: 'n2n_edge_ip', type: 'text', size: 20, value: dbus.n2n_edge_ip || '10.2.0.100' },
		{ title: '虚拟局域网子网掩码', name: 'n2n_edge_netmask', type: 'text', size: 20, value: dbus.n2n_edge_netmask || '255.255.255.0' },
		{ title: '开启通过虚拟局域网转发数据包', name: 'n2n_edge_route', type: 'checkbox', value: ((dbus.n2n_edge_route == '1')? 1:0)},
		{ title: '● 超级节点' },
		{ title: '开启超级节点', multi: [ 
			{ name:'n2n_supernode_enable',type: 'checkbox', value: ((dbus.n2n_supernode_enable == '1')? 1:0), suffix: '&nbsp;&nbsp;超级节点端口：' },
			{ name:'n2n_supernode_port', type:'text', size: 5,value: dbus.n2n_supernode_port || '4234' }
		]},	
	]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">插件说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>超级节点需要拥有一个可以公共访问的IP地址，它将会帮助NAT后方的边缘节点进行初始通信。</li>
			<li>想要在用户中创建一个P2P VPN的话，我们需要至少一个超级节点。</li>
			<li>边缘节点需要能够ping通超级节点的IP地址。</li>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_n2n();</script>
</content>
