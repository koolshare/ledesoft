<title>软件中心-Aria2</title>
<content>
  <script type="text/javascript">
    getAppData();
    var Apps;
    function getAppData() {
      var appsInfo;
      $.ajax({
        type: "GET",
        url: "/_api/aria2_",
        dataType: "json",
        async: false,
        success: function (data) {
          Apps = data.result[0];
        }
      });
    }

    //console.log('Apps',Apps);
    //数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
    function verifyFields(focused, quiet) {
      var id = 1 + Math.floor(Math.random() * 6);
      var postData = { "id": id, "method": 'aria2_config.sh', "params": [1], "fields": Apps };
      var success = function (data) {
        //
        //$('#footer-msg').text(data.result);
        //$('#footer-msg').show();
        //setTimeout("window.location.reload()", 3000);

        //  do someting here.
        //
      };
      var error = function (data) {
        //
        //  do someting here.
        //
      };
      $.ajax({
        type: "POST",
        url: "/_api/",
        data: JSON.stringify(postData),
        success: success,
        error: error,
        dataType: "json"
      });
      //return 1;
    }
    function save() {
      Apps.aria2_enable = E('_aria2_enable').checked ? '1' : '0';
      //Apps.aria2_version = E('_aria2_version').value;
      Apps.aria2_dir = E('_aria2_dir').value;
      Apps.aria2_rpc_listen_port = E('_aria2_rpc_listen_port').value;
      Apps.aria2_sleep = E('_aria2_sleep').value;
      Apps.aria2_max_concurrent_downloads = E('_aria2_max_concurrent_downloads').value;
      Apps.aria2_input_file = "/jffs/koolshare/aria2/aria2.session";
      Apps.aria2_save_session = "/jffs/koolshare/aria2/aria2.session";
      Apps.aria2_enable_http_pipelining = "true";
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
      //Apps.aria2_ttl = E('_aria2_ttl').value;
      //Apps.aria2_enable_dht = E('_aria2_enable_dht').value;
      Apps.aria2_listen_port = E('_aria2_listen_port').value;
      Apps.aria2_bt_max_peers = E('_aria2_bt_max_peers').value;
      Apps.aria2_bt_tracker = E('_aria2_bt_tracker').value;
      //Apps.aria2_sleep = E('_aria2_sleep').value;

      //-------------- post Apps to dbus ---------------
      var id = 1 + Math.floor(Math.random() * 6);
      var postData = { "id": id, "method": 'aria2_config.sh', "params": [], "fields": Apps };
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
  <div class="box" >
    <div class="heading">aria2 <a href="javascript:history.back()" class="btn" style="float:right;border-radius:3px;">返回</a></div>
    <hr>
    <br>
    <div class="content">
      <div id="aria2-fields"></div>
      <script type="text/javascript">
        var paths=new Array();
        var dir_mode=new Array();
        var dir_value=new Array();
        //alert(Apps.aria2_dir_str)
        paths=Apps.aria2_dir_str.split(" ");
        for (i=0;i<paths.length;i++)
        {
          dir_value=paths[i].split("(");
          dir_mode[i]=[dir_value[0],paths[i]];
        }
        //dht_mode=[['true','是'],['false','否']];
        $('#aria2-fields').forms([
          { title: '开启aria2', name: 'aria2_enable', type: 'checkbox', value: ((Apps.aria2_enable == '1')? 1:0)},
          { title: 'Aria2版本', name: 'aria2_version', text: Apps.aria2_version || '1.29' },
          //{ title: '下载存储目录', name: 'aria2_dir', type: 'text', maxlen: 34, size: 34, value: Apps.aria2_dir ||"/mnt"},
          { title: '下载存储目录', name: 'aria2_dir',  type: 'select', options:dir_mode,value:Apps.aria2_dir},
          { title: 'RPC监听端口', name: 'aria2_rpc_listen_port', type: 'text', maxlen: 5, size: 5, value: Apps.aria2_rpc_listen_port || '6800' },
          { title: '启动延时', name: 'aria2_sleep', type: 'text', maxlen: 2, size: 2, value: Apps.aria2_sleep || '2', suffix: '秒钟' },
          { title: '同时进行任务数', name: 'aria2_max_concurrent_downloads', type: 'text', maxlen: 1, size: 1, value: Apps.aria2_max_concurrent_downloads || '3'},
          { title: 'RPC访问密钥', name: 'aria2_rpc_secret', type: 'text', maxlen: 32, size: 34, value: Apps.aria2_rpc_secret },
          { title: 'WEB控制台', name: 'aria2_curl', text: '<a style="font-size: 14px;" href="http://www.nasdiy.net/AriaNg/" target="_blank"><u>AriaNg控制台</u></a> | <a style="font-size: 14px; "Lucida Grande", "Trebuchet MS", Verdana, sans-serif;" href="http://www.nasdiy.net/yaaw/" target="_blank"><u>yaaw控制台</u></a> | <a style="font-size: 14px; "Lucida Grande", "Trebuchet MS", Verdana, sans-serif;" href="http://www.nasdiy.net/aria2/" target="_blank"><u>aria2-webui控制台</u></a>' },
          { title: 'BT设置' },
          //{ title: '开启DHT', name: 'aria2_enable_dht',  type: 'select', options:dht_mode,value:Apps.aria2_enable_dht},      
          { title: 'BT监听端口', name: 'aria2_listen_port', type: 'text', maxlen: 5, size: 5, value: Apps.aria2_listen_port || '6888' },
          { title: '单个种子最大连接数', name: 'aria2_bt_max_peers', type: 'text', maxlen: 3, size: 3, value: Apps.aria2_bt_max_peers || '55' },
          { title: '添加tracker', name: 'aria2_bt_tracker', type: 'text', maxlen: 500, size: 500, value: Apps.aria2_bt_tracker || 'udp://tracker1.wasabii.com.tw:6969/announce,udp://tracker2.wasabii.com.tw:6969/announce,http://mgtracker.org:6969/announce,http://tracker.mg64.net:6881/announce,http://share.camoe.cn:8080/announce,udp://tracker.opentrackr.org:1337/announce' },

          //{ title: 'TTL', name: 'aria2_ttl', type: 'text', maxlen: 5, size: 5, value: Apps.aria2_ttl || '600' ,suffix: ' <small> (范围: 1~86400; 默认: 600)</small>'},
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