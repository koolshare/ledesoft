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
<div class="heading">KMS <a href="/#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<br><hr>
<div class="content">
<div id="kms-fields"></div>
<script type="text/javascript">
$('#kms-fields').forms([
{ title: '开启', name: 'kms_enable', type: 'checkbox', value: ((Apps.kms_enable == '1')? 1:0)}
]);
</script>
<hr>
<h4>说明</h4>
<h5>以管理员身份运行CMD输入以下命令，红色字体代表变量不是固定的，请参照自己的计算机修改。</h5>
<h5>【1】 奥菲斯鸡或</h5>
<p> CD <font color="red">X</font>:\Program Files<font color="red">(X86)</font>\Microsoft Office\Office<font color="red">14</font></p>
<p>cscript ospp.vbs /sethst:<font color="red">192.168.0.1</font></p>
<p>cscript ospp.vbs /act</p>
<p>cscript ospp.vbs /dstatus</p>
<h5>【2】 操作系统鸡或</h5>
<p>slmgr /ipk <font color="red">MHF9N-XY6XB-WVXMC-BTDCT-MKKG7</font></p>
<p>slmgr /skms <font color="red">192.168.0.1</font></p>
<p>slmgr /ato </p>
<h5>申明：本工具来自国外互联网 <a href="https://forums.mydigitallife.info/threads/50234-Emulated-KMS-Servers-on-non-Windows-platforms" target="_blank">点我跳转</a></h5>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
