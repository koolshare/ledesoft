<title>Shellinabox</title>
<content>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<script language="javascript">
var current_url = window.location.href;
//console.log(current_url.indexOf("ddns.to"));
sub_domain = current_url.split("/")[2].split(".")[0];
if(current_url.indexOf("ddns.to") != -1){
	$("#shell").attr("src","https://" + sub_domain + "-cmd.ddns.to/");
}else{
	$("#shell").attr("src","http://" + location.hostname + ":4200/");
}
</script>
<div class="box">
	<div class="heading">Shellinabox<a href="#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
	<div class="content">
		<span class="col" style="margin-top:10px;width:700px">Shellinabox 是一个基于 Web 浏览器的远程终端模拟器，不需要开启 ssh服务，通过 Web 浏览器就可以对远程主机进行操作</span>
	</div>	
</div>
<div class="box">
	<div class="heading"></div>
	<div class="content">
	<div class="tabContent">
	<iframe allowtransparency="true" style="background-color=transparent" id="shell" frameborder="0" width="100%" height="600px;" scrolling="no"></iframe>
	</div>
	</div>
</div>
</content>
