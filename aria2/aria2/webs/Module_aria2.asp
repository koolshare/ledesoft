<title>软件中心-Aria2</title>
<content>
<style type="text/css">
input[disabled]:hover{
    cursor:not-allowed;
}
textarea {
    height: 10em;
}
</style>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<script type="text/javascript">
getAppData();
setTimeout("get_run_status();", 1000);
var Apps;
var softcenter = 0;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/aria2_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}


function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "aria2_status.sh", "params":[], "fields": ""};
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
			document.getElementById("aria2_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("aria2_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

function verifyFields(focused, quiet){
	var c = (E('_aria2_rpc_enable').checked);
	elem.display(PR('_aria2_rpc_secret'), c);	
	var aria2enable = E('_aria2_enable').checked ? '1':'0';
	if(aria2enable == 0){
		$('input').prop('disabled', true);
		$(E('_aria2_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
}

function save() {
      Apps.aria2_enable = E('_aria2_enable').checked ? '1' : '0';
      Apps.aria2_rpc_enable = E('_aria2_rpc_enable').checked ? '1' : '0';
      Apps.aria2_enable_dht = E('_aria2_enable_dht').checked ? '1' : '0';
      Apps.aria2_dir = E('_aria2_dir').value;
      Apps.aria2_rpc_listen_port = E('_aria2_rpc_listen_port').value;
      Apps.aria2_sleep = E('_aria2_sleep').value;
      Apps.aria2_max_concurrent_downloads = E('_aria2_max_concurrent_downloads').value;
      Apps.aria2_input_file = "/koolshare/aria2/aria2.session";
      Apps.aria2_save_session = "/koolshare/aria2/aria2.session";
      Apps.aria2_enable_http_pipelining = "false";
      Apps.aria2_max_connection_per_server = "10";
      Apps.aria2_min_split_size = "10M";
      Apps.aria2_split = "10";
      Apps.aria2_continue = "true";
      Apps.aria2_check_certificate="false";
      Apps.aria2_max_overall_download_limit = "0";
      Apps.aria2_max_overall_upload_limit = "1K";
      Apps.aria2_enable_rpc = "true";
      Apps.aria2_rpc_listen_all = "true";
      Apps.aria2_rpc_allow_origin_all = "true";
      Apps.aria2_follow_torrent = "true";
      Apps.aria2_rpc_secret = E('_aria2_rpc_secret').value;
      Apps.aria2_listen_port = E('_aria2_listen_port').value;
      Apps.aria2_bt_max_peers = E('_aria2_bt_max_peers').value;
      Apps.aria2_custom = E('_aria2_custom').value;
      Apps.aria2_bt_tracker = E('_aria2_bt_tracker').value;

      //-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'aria2_config.sh', "params":["restart"], "fields": Apps};
	var success = function(data) {
		//
		$('#footer-msg').text(data.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);

		//  do someting here.
		//
	};
	var error = function(data) {
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
  <div class="box" >
    <div class="heading">Aria2<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
 <div class="content">
	<span class="col" style="line-height:30px;width:700px">
	支持多线程多协议( HTTP / HTTPS，FTP，SFTP，BitTorrent和Metalink)的下载工具<br />
	<a style="font-size: 14px;" href="http://www.nasdiy.net/AriaNg/" target="_blank"><u>AriaNg控制台</u></a> | <a style="font-size: 14px; "Lucida Grande", "Trebuchet MS", Verdana, sans-serif;" href="http://www.nasdiy.net/yaaw/" target="_blank"><u>yaaw控制台</u></a> | <a style="font-size: 14px; "Lucida Grande", "Trebuchet MS", Verdana, sans-serif;" href="http://www.nasdiy.net/aria2/" target="_blank"><u>aria2-webui控制台</u></a>
</div>
</div>
<div class="box">
    <div class="content">
      <div id="aria2-fields">
	  </div>
      <script type="text/javascript">
		var option_count = [['5', '5'], ['15', '15'], ['30', '30'], ['60', '60'], ['90', '90'], ['120', '120']];
		$('#aria2-fields').forms([
          { title: '开启aria2', name: 'aria2_enable', type: 'checkbox', value: ((Apps.aria2_enable == '1')? 1:0)},
          { title: '运行状态', text: '<font id="aria2_status" name=aria2_status color="#1bbf35">正在检查运行状态...</font>' },
          { title: '下载存储目录', name: 'aria2_dir', type: 'text', maxlen: 60, size: 60, value: Apps.aria2_dir ||"/mnt/sdb1/downloads"},
          //{ title: '下载存储目录', name: 'aria2_dir',  type: 'select', options:dir_mode,value:Apps.aria2_dir, suffix: '设置好下载盘挂载点后运行一次获取下载目录'},
          { title: 'RPC监听端口', name: 'aria2_rpc_listen_port', type: 'text', maxlen: 5, size: 5, value: Apps.aria2_rpc_listen_port || '6800' },
          { title: '启动延时', name: 'aria2_sleep', type: 'select', options:option_count , value: Apps.aria2_sleep || '30', suffix: '秒钟' },
          { title: '同时进行任务数', name: 'aria2_max_concurrent_downloads', type: 'text', maxlen: 2, size: 2, value: Apps.aria2_max_concurrent_downloads || '3'},
          { title: '开启DHT', name: 'aria2_enable_dht', type: 'checkbox', value: ((Apps.aria2_enable_dht == '1')? 1:0)},
          { title: '开启RPC访问密钥', name: 'aria2_rpc_enable', type: 'checkbox', value: ((Apps.aria2_rpc_enable == '1')? 1:0)},
          { title: 'RPC访问密钥', name: 'aria2_rpc_secret', type: 'text', maxlen: 80, size: 60, value: Apps.aria2_rpc_secret },
          { title: 'BT监听端口', name: 'aria2_listen_port', type: 'text', maxlen: 5, size: 5, value: Apps.aria2_listen_port || '6888' },
          { title: '单个种子最大连接数', name: 'aria2_bt_max_peers', type: 'text', maxlen: 3, size: 3, value: Apps.aria2_bt_max_peers || '60' },
          { title: '添加tracker', name: 'aria2_bt_tracker', type: 'textarea', maxlen: 20000, size: 20000, value: Apps.aria2_bt_tracker || 'udp://tracker1.wasabii.com.tw:6969/announce,udp://tracker2.wasabii.com.tw:6969/announce,http://mgtracker.org:6969/announce,http://tracker.mg64.net:6881/announce,http://share.camoe.cn:8080/announce,udp://tracker.opentrackr.org:1337/announce,udp://9.rarbg.com:2710/announce,udp://11.rarbg.me:80/announce,http://tracker.tfile.me/announce,http://tracker3.torrentino.com/announce' , suffix: '如下载速度慢，可以尝试增加更多tracker服务器，多个服务器以小写逗号,分隔'},
          { title: '自定义配置项', name: 'aria2_custom', type: 'textarea', maxlen: 20000, size: 20000, value: Apps.aria2_custom || 'user-agent=uTorrent/2210(25130),peer-id-prefix=-UT2210-', suffix: '多条配置以小写逗号,分隔'},
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
