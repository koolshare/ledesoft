<title>软件中心 - Syncthing</title>
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
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/syncthing_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}
if (Apps.syncthing_webui == undefined||Apps.syncthing_webui == null){
		Apps.syncthing_webui = '--';
	}
//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	var port =E('_syncthing_port').value ;
    if(port < 1024 || port > 65535){
        alert("端口应设置为1024-65535之间");
    }
	return 1;
}
function save(){
	Apps.syncthing_enable = E('_syncthing_enable').checked ? '1':'0';
	Apps.syncthing_wan_enable = E('_syncthing_wan_enable').checked ? '1':'0';
	Apps.syncthing_port = E('_syncthing_port').value;
	//Apps.syncthing_sk = E('_syncthing_sk').value;
	//left>down>Apps.syncthing_up = E('_syncthing_up').value;
	//left>down>Apps.syncthing_interval = E('_syncthing_interval').value;
	//left>down>Apps.syncthing_domain = E('_syncthing_domain').value;
	//left>down>Apps.syncthing_dns = E('_syncthing_dns').value;
	//left>down>Apps.syncthing_curl = E('_syncthing_curl').value;
	//Apps.syncthing_ttl = E('_syncthing_ttl').value;
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'syncthing_config.sh', "params":[], "fields": Apps};
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
<div class="box">
<div class="heading">Syncthing <a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<br><hr>
<div class="content">
<div id="syncthing-fields"></div>
<script type="text/javascript">
$('#syncthing-fields').forms([
{ title: '开启Syncthing', name: 'syncthing_enable', type: 'checkbox', value: ((Apps.syncthing_enable == '1')? 1:0)},
{ title: '外网访问Web', name: 'syncthing_wan_enable', type: 'checkbox', value: ((Apps.syncthing_wan_enable == '1')? 1:0)},
//{ title: '运行状态', name: 'syncthing_last_act', text: Apps.syncthing_last_act ||'--' },
{ title: 'Web访问端口', name: 'syncthing_port', type: 'text', maxlen: 5, size: 5, value: Apps.syncthing_port || "8384" },
{ title: 'Web控制页面', name: 'syncthing_webui', text: '<a style="font-size: 14px;" href="'+Apps.syncthing_webui+'" target="_blank">'+Apps.syncthing_webui+'</a>' ||'--' },
//{ title: '启动方式', name: 'syncthing_up', type: 'select', options:upoption_mode,value:Apps.syncthing_up || '2'},
//{ title: '检查周期', name: 'syncthing_interval', type: 'text', maxlen: 5, size: 5, value: Apps.syncthing_interval || '5',suffix:'分钟(当启动方式为WAN UP时，此选项无效)'},
]);
</script>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>