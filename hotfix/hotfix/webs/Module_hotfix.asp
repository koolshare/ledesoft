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
			<li> 1.修复koolss状态检测的问题</font>；</li>
			<br />
			<li> 2.针对2.1, 2.2固件修复SSR节点订阅。</li>
			<br />
			<li> ....</li>
	</div>
</div>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
</content>
