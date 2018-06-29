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
get_dbus_data();
try_on();

function get_dbus_data(){
	$.ajax({
	  	type: "GET",
	 	url: "/_api/shellinabox",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	dbus = data.result[0];
	  	}
	});
}

function try_on(){
	var id = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id, "method": "shellinabox_config.sh", "params":["check"], "fields": ""};
	$.ajax({
		type: "POST",
		url: "/_api/",
		async:true,
		cache:false,
		data: JSON.stringify(postData1),
		dataType: "json",
	});
}

function save(){
	dbus["shellinabox_style"] = E('_shellinabox_style').checked ? '1':'0';
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": 'shellinabox_config.sh', "params":["restart"], "fields": dbus };
	$.ajax({
		type: "POST",
		url: "/_api/",
		data: JSON.stringify(postData),
		dataType: "json",
		success: function(response){
			if(response.result == id){
				console.log("save ok", dbus)
				window.location.reload();
			}
			
		}
	});
}

function verifyFields(){
	return true;
}

</script>
<div class="box">
	<div class="heading">Shellinabox<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
	<div class="content">
		<span class="col" style="margin-top:10px;width:700px">Shellinabox 是一个基于 Web 浏览器的远程终端模拟器，不需要开启 ssh服务，通过 Web 浏览器就可以对远程主机进行操作</span>
	</div>	
</div>
<div class="box">
	<div class="heading"></div>
	<div class="content">
	<div class="tabContent">
	<iframe allowtransparency="true" style="background-color=transparent" id="shell" frameborder="0" width="100%" height="600px" scrolling="no"></iframe>
	</div>
	</div>
</div>
<div class="box">
	<div class="heading"></div>
	<div class="content">
		<div id="shellinabox_com" class="tabContent"></div>
		<script type="text/javascript">
			$('#shellinabox_com').forms([
				//{ title: '设置命令窗口高度', multi: [
				//	{ prefix: ' 高度' },
				//	{ name: 'shellinabox_rows', type: 'text',size: 1, value: dbus.shellinabox_rows || "600", suffix: ' &nbsp;&nbsp;' }
				//]},
				{ title: '纯白样式', name:'shellinabox_style',type:'checkbox', value: ((dbus.shellinabox_style == '1')? 1:0) },
			]);
		</script>
	</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
</content>
