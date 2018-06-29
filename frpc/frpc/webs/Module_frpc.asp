<title>软件中心 - Frpc</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<style type="text/css">
  input[disabled]:hover{
    cursor:not-allowed;
}
.c-checkbox {
	margin-left:-10px;
}
</style>
<script type="text/javascript">
getAppData();
setTimeout("get_run_status();", 1000);
var Apps;
var options_switch = [['0', '关闭'], ['1', '开启']];
var options_switch_name = ['关闭', '开启'];
var softcenter = 0;
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
function getAppData(){
var appsInfo;
  $.ajax({
      type: "GET",
     url: "/_api/frpc_",
      dataType: "json",
      async:false,
     success: function(data){
        Apps = data.result[0];
      }
  });
}
function tabSelect(obj){
  var tableX = ['app1-server1-jb-tab','app2-server1-kz-tab'];
  var boxX = ['boxr1','boxr2'];
  var appX = ['app1','app2'];
  for (var i = 0; i < tableX.length; i++){
    if(obj == appX[i]){
      $('#'+tableX[i]).addClass('active');
      $('.'+boxX[i]).show();
    }else{
      $('#'+tableX[i]).removeClass('active');
      $('.'+boxX[i]).hide();
    }
  }
}
function get_run_status(){
  var id = parseInt(Math.random() * 100000000);
  var postData = {"id": id, "method": "frpc_status.sh", "params":[2], "fields": ""};
  $.ajax({
    type: "POST",
    cache:false,
    url: "/_api/",
    data: JSON.stringify(postData),
    dataType: "json",
    success: function(response){
      if(softcenter == 1){
        return false;
      }
      document.getElementById("_frp_status").innerHTML = response.result;
      setTimeout("get_run_status();", 3000);
    },
    error: function(){
      if(softcenter == 1){
        return false;
      }
      document.getElementById("_frp_status").innerHTML = "获取运行状态失败！";
      setTimeout("get_run_status();", 5000);
    }
  });
}
if (Apps.frpc_customize_conf == 1){
  tabSelect("app2");
}else {
  tabSelect("app1");
}

function verifyFields(focused, quiet){
  return true;
}

//==========================================
var frpc = new TomatoGrid();

frpc.exist = function( f, v ) {
  var data = this.getAllData();
  for ( var i = 0; i < data.length; ++i ) {
    if ( data[ i ][ f ] == v ) return true;
  }
  return false;
}
frpc.dataToView = function( data ) {
  return [ data[0],data[1],data[2],data[3],data[4],data[5],options_switch_name[data[6]],options_switch_name[data[7]] ]
}
frpc.fieldValuesToData = function(row) {
  var f = fields.getAll(row);
  return [ f[0].value, f[1].value, f[2].value, f[3].value, f[4].value, f[5].value, f[6].value, f[7].value ]
}

frpc.verifyFields = function( row, quiet ) {
  var f = fields.getAll( row );
  if (f[1].value == "http"){
    f[5].value = Apps.frpc_vhost_http_port||"";
  }
  if (f[1].value == "https"){
    f[5].value = Apps.frpc_vhost_https_port||"";
  }
  if (f[1].value == "tcp" || f[1].value == "udp"){
    f[2].value = "";
  }
  return v_iptaddr( f[3], quiet ) && v_port( f[4], quiet );
}

frpc.resetNewEditor = function() {
  var f = fields.getAll( this.newEditor );
  ferror.clearAll( f );
  f[0].value   = '';
  f[1].value   = 'http';
  f[2].value   = '';
  f[3].value   = '';
  f[4].value   = '';
  f[5].value   = '';
  f[6].value   = '';
  f[7].value   = '';
}
frpc.setup = function() {
  this.init( 'frpc-grid', '', 50, [
  { type: 'text', maxlen: 20 },
  { type: 'select' ,options:[['http','http'],['https','https'],['tcp','tcp'],['udp','udp']]},
  { type: 'text', maxlen: 90 },
  { type: 'text', maxlen: 40 },
  { type: 'text', maxlen: 5 },
  { type: 'text', maxlen: 5 },
  { type: 'select' ,options:options_switch},
  { type: 'select' ,options:options_switch},
  ] );
  this.headerSet( [ '服务名称', '协议类型', '域名', '内网地址' ,'内网端口','远程端口','压缩','加密'] );
  if (Apps.frpc_srlist == undefined||Apps.frpc_srlist == null){
      Apps.frpc_srlist = '';
    }
  var s = Apps.frpc_srlist.split('>');
  for ( var i = 0; i < s.length; ++i ) {
    var t = s[i].split('<');
    if ( t.length == 8 ) this.insertData( -1, t );
  }
  this.showNewEditor();
  this.resetNewEditor();
}
//==========================================
function save(){
  var data      = frpc.getAllData();
  var frpc_srlist = '';
  for ( var i = 0; i < data.length; ++i ) {
    frpc_srlist += data[ i ].join( '<' ) + '>';
  }
  Apps.frpc_enable = E('_frpc_enable').checked ? '1':'0';
  Apps.frpc_vhost_http_port = E('_frpc_vhost_http_port').value;
  Apps.frpc_vhost_https_port = E('_frpc_vhost_https_port').value;
  Apps.frpc_common_server_addr = E('_frpc_common_server_addr').value;
  Apps.frpc_common_server_port = E('_frpc_common_server_port').value;
  Apps.frpc_common_protocol = E('_frpc_common_protocol').value;
  Apps.frpc_common_tcp_mux = E('_frpc_common_tcp_mux').value;
  Apps.frpc_common_login_fail_exit = E('_frpc_common_login_fail_exit').value;
  Apps.frpc_common_user = E('_frpc_common_user').value;
  Apps.frpc_common_log_file = E('_frpc_common_log_file').value;
  Apps.frpc_common_log_level = E('_frpc_common_log_level').value;
  Apps.frpc_common_log_max_days = E('_frpc_common_log_max_days').value;
  Apps.frpc_common_token = E('_frpc_common_token').value;
  Apps.frpc_srlist = frpc_srlist;
  Apps.frpc_customize_conf = E('_frpc_customize_conf').checked ? '1':'0';
  var paras_base64 = ["frpc_customize_config"];
			for (var i = 0; i < paras_base64.length; i++) {
				if (typeof(E('_' + paras_base64[i] ).value) == "undefined"){
					Apps[paras_base64[i]] = "";
				}else{
					Apps[paras_base64[i]] = Base64.encode(E('_' + paras_base64[i]).value);
				}
			}

  //-------------- post Apps to dbus ---------------
  var id = 1 + Math.floor(Math.random() * 6);
  var postData = {"id": id, "method":'frpc_config.sh', "params":["start"], "fields": Apps};
  var success = function(data) {
    $('#footer-msg').text(data.result);
    $('#footer-msg').show();
    setTimeout("window.location.reload()", 3000);
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
    dataType: "json"
  });
}

</script>
<div class="box">
  <div class="heading">frpc内网穿透 <a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
  <div class="content">
    <span class="col" style="line-height:30px;width:700px">
    frp 是一个可用于内网穿透的高性能的反向代理应用，支持 tcp, udp, http, https 协议。<br />
    <a id="gfw_number" href="https://github.com/fatedier/frp" target="_blank"> 【frp开源项目github地址】</a>&nbsp;&nbsp;&nbsp;&nbsp;
    <a id="gfw_number" href="http://koolshare.cn/thread-65379-1-1.html" target="_blank"> 【frp穿透服务器搭建教程】 </a>&nbsp;&nbsp;&nbsp;&nbsp;
    <a id="gfw_number" href="https://github.com/fatedier/frp/blob/master/README_zh.md" target="_blank"> 【frp自定义配置帮助】 </a>
    </span>
  </div>
</div>
<div class="box" style="margin-top: 0px;">
  <div class="heading">frpc配置</div>
  <hr>
  <div class="content">
  <div id="frpc-fields"></div>
  <script type="text/javascript">
    $('#frpc-fields').forms([
    { title: '开启frpc', name: 'frpc_enable', type: 'checkbox', value: ((Apps.frpc_enable == '1')? 1:0)},
    { title: 'frpc运行状态', text: '<font id="_frp_status" name=frp_status color="#1bbf35">正在获取运行状态...</font>' }
    ]);
  </script>
  </div>
</div>
<ul class="nav nav-tabs">
  <li><a href="javascript:void(0);" onclick="tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 简单设置</a></li>
  <li><a href="javascript:void(0);" onclick="tabSelect('app2');" id="app2-server1-kz-tab"><i class="icon-tools"></i> 自定义设置</a></li>
</ul>
<div class="box boxr1" style="margin-top: 0px;">
  <div class="heading">frpc基本配置</div>
  <hr>
  <div class="content">
  <div id="frpc1-fields"></div>
  <script type="text/javascript">
    var time_mode = [['1', '1天'], ['2', '2天'], ['3', '3天']];
    var log_mode = [['debug', 'debug'], ['info', 'info'], ['warn', 'warn'], ['error', 'error']];
    var protocol = [['tcp', 'tcp'], ['kcp', 'kcp']];
    var tcp_mux = [['false', 'false'], ['true', 'true']];
    var login_fail_exit = [['false', '失败后重复连接'], ['true', '失败后退出程序']];
    var log_file = [['/dev/null', '关闭'], ['/tmp/frpc.log', '开启']];
    $('#frpc1-fields').forms([
    { title: '服务器地址', name: 'frpc_common_server_addr', type: 'text', maxlen: 25, size: 25, value: Apps.frpc_common_server_addr ||'0.0.0.0' },
    { title: '服务器端口', name: 'frpc_common_server_port', type: 'text', maxlen: 5, size: 5, value: Apps.frpc_common_server_port ||'7000' },
    { title: '底层通讯协议', name: 'frpc_common_protocol', type: 'select', options:protocol, value: Apps.frpc_common_protocol ||'tcp' },
    { title: 'TCP多路复用', name: 'frpc_common_tcp_mux', type: 'select', options:tcp_mux, value: Apps.frpc_common_tcp_mux ||'false' },
    { title: '连接设置', name: 'frpc_common_login_fail_exit', type: 'select', options:login_fail_exit, value: Apps.frpc_common_login_fail_exit ||'tcp' },
    { title: '连接密码(token)', name: 'frpc_common_token', type: 'password', maxlen: 20, size: 20, value: Apps.frpc_common_token,peekaboo: 1},
    { title: 'HTTP穿透服务端口', name: 'frpc_vhost_http_port', type: 'text', maxlen: 5, size: 5, value: Apps.frpc_vhost_http_port, help: '对应服务器端vhost_http_port' },
    { title: 'HTTPS穿透服务端口', name: 'frpc_vhost_https_port', type: 'text', maxlen: 5, size: 5, value: Apps.frpc_vhost_https_port, help: '对应服务器端vhost_https_port' },
    { title: 'frpc用户名', name: 'frpc_common_user', type: 'text', maxlen: 5, size: 5, value: Apps.frpc_common_user ||'admin' },
    { title: '日志记录', name: 'frpc_common_log_file', type: 'select',  options:log_file, value: Apps.frpc_common_log_file ||'/dev/null' },
    { title: '日志记录等级', name: 'frpc_common_log_level', type: 'select', options:log_mode,value:Apps.frpc_common_log_level || 'info'},
    { title: '日志记录时间', name: 'frpc_common_log_max_days', type: 'select', options:time_mode,value:Apps.frpc_common_log_max_days || '1' ,suffix:'日志保存最长时间'}
    ]);
  </script>
  </div>
</div>
<div class="box boxr1">
  <div class="heading">frpc穿透配置</div>
  <hr>
  <div class="content">
    <table class="line-table" cellspacing=1 id="frpc-grid"></table>
    <script type="text/javascript">frpc.setup();</script>
    <br><hr>
    <h4>配置说明：</h4>
    <div class="section" id="sesdiv_notes2">
        <ul>
          <li>当协议类型为HTTP/HTTPS时，远程端口的设置无效，不需要填写，访问端口为服务端设置的vhost_http_port或vhost_https_port</li>
          <li>当协议类型为TCP/UDP时，域名设置无效，不需要填写</li>
          <li>除以上两项外，其他项都需要正确填写</li>
        </ul>
      </div>
    <br>
    <hr>
  </div>
</div>
<div class="box boxr2" style="margin-top: 0px;">
  <div class="heading">frpc 自定义设置</div>
  <hr>
  <div class="content">
  <div id="frpc2-fields"></div>
  <script type="text/javascript">
    $('#frpc2-fields').forms([
      { title: '启用自定义配置', name: 'frpc_customize_conf', type: 'checkbox', value: Apps.frpc_customize_conf == 1},
      { title: '<b>自定义设置 </b>', name: 'frpc_customize_config', type: 'textarea', value: Base64.decode(Apps.frpc_customize_config)||"", style: 'width: 100%; height:400px;' }
    ]);
  </script>
  </div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
