<title>软件中心 - hotfix</title>
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
toggleVisibility('notes')
//console.log("111", document.location.hash)
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/hotfix_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
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
</script>
<div class="box">
<div class="heading">hotfix <a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	hotfix是快速修复当前版本固件中一些小bug的插件。安装后可以卸载，但为了第一时间获取后续更新建议保持安装状态。<br />
</div>
</div>
<div class="box">
<br><hr>
<div class="content">
<div id="hotfix-fields"></div>
<script type="text/javascript">
$('#hotfix-fields').forms([
{ title: '当前插件版本', name: 'hotfix_version', text: Apps.hotfix_version || '--' }
]);
</script>
</div>
</div>

<div class="box">
<br><hr>
<div class="box">
	<div class="heading">修复内容简要： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li> 1.修复2.0固件中koolss状态检测的问题；</li>
			<br />
			<li> 2.针对2.1, 2.2固件修复SSR节点订阅脚本，2.1固件还需要运行 opkg update && opkg install coreutils-base64 coreutils-shuf 才能修复。</li>
			<br />
			<li> 3.【紧急】所有安装了插件版本ss，并且版本号低于1.7.3的，修复因为ss插件造成的其他插件丢失开机启动文件的问题。（2017年9月13日）</li>
			<br />
			<li> 4. 针对2.1, 2.2固件，修复路由重启后软件中心界面空白的问题。（2017年9月14日 ）</li>
			<br />
			<li> 5. 针对2.14（不包含2.14）以下固件，修复flock缺失的问题。（2018年4月23日 ）</li>
			<br />
			<li> ....</li>
	</div>
</div>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
</content>
