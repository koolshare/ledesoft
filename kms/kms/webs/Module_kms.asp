<title>软件中心 - KMS</title>
<content>
<style type="text/css">
	.c-checkbox {
		margin-left:-10px;
	}
</style>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<script type="text/javascript">
	var Apps;
	var softcenter = 0;
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
	
	function get_run_status(){
		var id = parseInt(Math.random() * 100000000);
		var postData = {"id": id, "method": "kms_status.sh", "params":[], "fields": ""};
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
				document.getElementById("_kms_status").innerHTML = response.result;
				setTimeout("get_run_status();", 5000);
			},
			error: function(){
				if(softcenter == 1){
					return false;
				}
				document.getElementById("_kms_status").innerHTML = "获取运行状态失败！";
				setTimeout("get_run_status();", 5000);
			}
		});
	}
	
	function verifyFields(focused, quiet){
		return true;
	}
	
	function save(){
		Apps.kms_enable = E('_kms_enable').checked ? '1':'0';
		Apps.kms_firewall = E('_kms_firewall').checked ? '1':'0';
		var id = 1 + Math.floor(Math.random() * 6);
		var postData = {"id": id, "method":'kms_config.sh', "params":["start"], "fields": Apps};
		var success = function(data) {
			$('#footer-msg').text(data.result);
			$('#footer-msg').show();
			setTimeout("window.location.reload()", 2000);
		};
		$('#footer-msg').text('保存中,请耐心等待……');
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
	<div class="heading">
		<a style="margin-left:-4px" href="https://github.com/koolshare/ledesoft/blob/master/kms/Changelog.txt" target="_blank"><font color="#0099FF">KMS windows全家桶激活工具</font></a>
		<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a>
	</div>
	<br><hr>
	<div class="content">
		<div id="kms-fields"></div>
		<script type="text/javascript">
			$('#kms-fields').forms([
			{ title: '开启', name: 'kms_enable', type: 'checkbox', value: ((Apps.kms_enable == '1')? 1:0)},
			{ title: '防火墙开关（1688端口外网访问）', name: 'kms_firewall', type: 'checkbox', value: ((Apps.kms_firewall == '1')? 1:0)},
			{ title: 'kms运行状态', text: '<font id="_kms_status" name=kms_status color="#1bbf35">正在获取运行状态...</font>' },
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
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">get_run_status();</script>
</content>