<title>软件中心 - KMS</title>
<content>
<script type="text/javascript">
getAppData();
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/kms_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}
//console.log('Apps',Apps);
//数据 -  绘制界面用 - 直接 声明一个 Apps 然后 post 到 sh 然后 由 sh 执行 存到 dbus
function verifyFields(focused, quiet){
	return 1;
}
function save(){
	Apps.kms_enable = E('_kms_enable').checked ? '1':'0';
	//-------------- post Apps to dbus ---------------
	var id = 1 + Math.floor(Math.random() * 6);
	var postData = {"id": id, "method":'kms.sh', "params":[], "fields": Apps};
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
<div class="heading">KMS Office激活工具<a href="/#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<br><hr>
<div class="content">
<div id="kms-fields"></div>
<script type="text/javascript">
$('#kms-fields').forms([
{ title: '开启', name: 'kms_enable', type: 'checkbox', value: ((Apps.kms_enable == '1')? 1:0)},
{ title: '运行状态', name: 'kms_status', text: Apps.kms_status || '<font color="red">未运行</font>'},
{ title:'&nbsp;',name:'',text:'本工具仅支持Vol版自动激活'}
]);
</script>
<br>
<div class="note">

<h5>激活Office2016（以64位为例子）</h5>
	<ul>
		<li>cd C:\Program Files\Microsoft Office\Office16</li>
		<li>CSCRIPT OSPP.VBS /SETHST:192.168.31.1</li>
		<li>CSCRIPT OSPP.VBS /ACT</li>
		<li>CSCRIPT OSPP.VBS /DSTATUS</li>
	</ul>
<h5>激活Windows</h5>
	<ul>
		<li>cd C:\Windows\System32</li>
		<li>CSCRIPT /NOLOGO SLMGR.VBS /SKMS 192.168.31.1</li>
		<li>CSCRIPT /NOLOGO SLMGR.VBS /ATO</li>
		<li>CSCRIPT /NOLOGO SLMGR.VBS /XPR</li>
	</ul>
	
</div>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
