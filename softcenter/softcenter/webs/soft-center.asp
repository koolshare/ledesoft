<title>软件中心</title>
<content>
<link rel="stylesheet" href="css/animate.min.css" />
<style type="text/css">
::-webkit-scrollbar-track{-webkit-box-shadow:inset 0 0 6px rgba(0,0,0,0.3);border-radius:10px;background-color:#F5F5F5;}::-webkit-scrollbar{width:8px;background-color:#F5F5F5;}::-webkit-scrollbar-thumb{border-radius:10px;-webkit-box-shadow:inset 0 0 6px rgba(0,0,0,.3);background-color:#555;}.box .content{padding:0 15px 15px;display:block;}.popover{font-size:14px;color:#63B8FF;}.apps a:link{color:#fff}.apps a:visited{color:#fff}.apps a:hover{color:#fff}.apps a:active{color:#fff}.apps{color:#fff;width:250px;height:100px;text-align:left;float:left;margin:5px;border-radius:5px;filter:"progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale')";-moz-background-size:100% 100%;background-size:100% 100%;cursor:pointer;}.infos{width:80px;height:100px;float:left;}.appimg{width:60px;margin:20px 10px 20px 10px;pointer-events:none;}.app-name{padding:11px 0 11px 0;height:100px;width:170px;float:left;}.app-name p{text-overflow:ellipsis;overflow:hidden;white-space:nowrap;text-shadow:#444 0 1px 0;pointer-events:none;}.appDesc{margin:0 auto;width:40px;height:100px;float:left;display:none;}.appDesc button.btn{width:35px;height:100px;font-family:"Segoe UI","Roboto",sans-serif;font-weight:400!important;vertical-align:middle;outline:0;outline-style:none;font-size:14px;padding:0 3px 0 3px;border-radius:0px;}.boxr1{background: #f9fbfb;}.boxr2{display:none;background: #f9fbfb;}.boxr3{display:none;background: #f9fbfb;}.boxr4{display:none;background: #f9fbfb;}.boxr5{display:none;background: #f9fbfb;}#push_content3{display:none;}#push_content4{display:none;}.backsoftcenter{margin-right:20px;margin-top:-30px;}.soft_log{margin-top:50px;margin-left:15px;}.loader{width:65px;height:5px;margin-top:8px;float:left;border:0px solid #3498db;box-sizing:border-box;display:flex;align-items:center;justify-content:center;}@-webkit-keyframes loading-2{0%{transform:scaleY(1);-moz-transform:scaleY(1);-webkit-transform:scaleY(1);}50%{transform:scaleY(.4);-moz-transform:scaleY(.4);-webkit-transform:scaleY(.4);}100%{transform:scaleY(1);-moz-transform:scaleY(1);-webkit-transform:scaleY(1);}}.loading-2 i{display:inline-block;width:4px;height:12px;border-radius:2px;background:#3498db;margin:0 2px;}.loading-2 i:nth-child(1){-webkit-animation:loading-2 1s ease-in .1s infinite;-moz-animation:loading-2 1s ease-in .1s infinite;animation:loading-2 1s ease-in .1s infinite;}.loading-2 i:nth-child(2){-webkit-animation:loading-2 1s ease-in .2s infinite;-moz-animation:loading-2 1s ease-in .2s infinite;animation:loading-2 1s ease-in .2s infinite;}.loading-2 i:nth-child(3){-webkit-animation:loading-2 1s ease-in .3s infinite;-moz-animation:loading-2 1s ease-in .3s infinite;animation:loading-2 1s ease-in .3s infinite;}.loading-2 i:nth-child(4){-webkit-animation:loading-2 1s ease-in .4s infinite;-moz-animation:loading-2 1s ease-in .4s infinite;animation:loading-2 1s ease-in .4s infinite;}.loading-2 i:nth-child(5){-webkit-animation:loading-2 1s ease-in .5s infinite;-moz-animation:loading-2 1s ease-in .5s infinite;animation:loading-2 1s ease-in .5s infinite;}
</style>
<script type="text/javascript">
//APPS 控制模块
var anmstatus=null;
function change1(obj){
	x = $(anmstatus).find('.app-name').width();
	if(x == '170px'){
		anmstatus = null;
	}
	if(anmstatus != obj){
		anmstatus = obj;
		$(obj).stop().removeClass('animated flipInY').addClass('animated flipInY').one('animationend webkitAnimationEnd oAnimationEnd', function(){
			$(obj).removeClass('animated flipInY');
    	});	
	}
	$(obj).find('.appDesc').show();
	$(obj).find('.app-name').width('130px');
}
function change2(obj){
	var id = $(obj).find('button').attr("id");
	if(id != 'app-update'){
		$(obj).find('.appDesc').hide();
		$(obj).find('.app-name').width('170px');
	}else{
		$(obj).find('.app-name').width('130px');
	}
}
function tabSelect(obj){
	var tableX = ['app1-server1-basic-tab','app2-server1-advanced-tab','app3-server1-keys-tab','app4-server1-status-tab'];
	var boxX = ['boxr1','boxr2','boxr3','boxr4'];
	var appX = ['app1','app2','app3','app4'];
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
</script>
<script type="text/javascript">
// 安装信息更新策略:
// 当软件安装的时候,安装进程内部会有超时时间. 超过超时时间 没安装成功,则认为失败.
// 但是路由内部的绝对时间与浏览器上的时间可能不同步,所以无法使用路由器内的时间. 浏览器的策略是,
// 安装的时候会有一个同样的计时,若这个超时时间内,安装状态有变化,则更新安装状态.从而可以实时更新安装进程.
var currState = {"installing": false, "lastChangeTick": 0, "lastStatus": "-1", "module":""};
var softcenterUrl = "https://ttsoft.ngrok.wang";
var dataTypeX = "jsonp";
var softInfo = {};
var TimeOut = 0;
var Msginfos = [
            "操作失败",
            "已安装",
            "初始化中...",
            "正在下载...",
            "正在安装中...",
            "安装成功！请等待浏览器跳转！",
            "卸载中......",
            "卸载成功！请等待浏览器跳转",
            "没有检测到在线版本号！",
            "正在下载更新......",
            "正在安装更新...",
            "安装更新成功，请等待浏览器跳转！ ",
            "下载文件校验不一致！",
            "然而并没有更新！",
            "正在检查是否有更新~",
            "检测更新错误！"
       		 ];
//检查并切换服务器
$.ajax({
	url: "https://ttsoft.ngrok.wang/softcenter/switch_server.json.js",
    type: "GET",
    dataType:'jsonp',
    success: function() {
        $('#server').html('服务器：TTSoft');
		notice_show();
		softCenterInit();	
    },
    error: function() {
        $('#server').html('服务器：访问故障');
		notice_show();
		softCenterInit();
    },timeout:1000
});
//推送信息
function notice_show(){
    $.ajax({
        url: softcenterUrl+'/softcenter/push_message.json.js',
        type: 'GET',
        dataType: dataTypeX,
        success: function(res) {
			$("#push_titile").html(res.title);
			$("#push_content1").html(res.content1);
			$("#push_content2").html(res.content2);
			if(res.content3){
				$("#push_content3").show();
				$("#push_content3").html(res.content3);
			}
			if(res.content4){
				$("#push_content3").show();
				$("#push_content4").html(res.content4);
			}
        }
    });
}
//类
function appinstall(obj){
    var name = obj.value;
	_formatData(name,'install');
}
function appuninstall(obj){
    var name = obj.value;
    var xxx = {"name":name};
	appUninstallModule(xxx);
}
function appupdata(obj){
    var name = obj.value;
    _formatData(name,'install');
}
function appInstallModule(moduleInfo) {
    appPostScript(moduleInfo, "ks_app_install.sh");
}
function appUninstallModule(moduleInfo) {
    if (!window.confirm('确定卸载吗')) {
        return;
    }
    appPostScript(moduleInfo, "ks_app_remove.sh");
}
function _formatData(name,mod){
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	for(var aname in softInfo){
		if(aname.indexOf(name) > 0 ){
			app_name = softInfo[aname];
			if(mod=="install" && name == app_name){
				var xxx = {
					"name":app_name,
					"md5": softInfo['app_'+app_name+'_md5'],
					"tar_url": softInfo['app_'+app_name+'_tar_url'],
					"version": softInfo['app_'+app_name+'_oversion'],
					"title":softInfo['app_'+app_name+'_title']
				};
				appInstallModule(xxx);
				return;
			}			
		}
	};
}
function CheckImgExists(imgurl) {  
  var ImgObj = new Image(); //判断图片是否存在  
  ImgObj.src = imgurl;  
  //没有图片，则返回-1  
  if (ImgObj.fileSize > 0 || (ImgObj.width > 0 && ImgObj.height > 0)) {  
    return true;  
  } else {  
    return false;
  }  
}
function getSoftCenter(obj){
	$.ajax({  
		url:softcenterUrl+"/softcenter/app.json.js",  
		dataType:dataTypeX,  
		method: 'GET', 
		success:function(re) {
			var appObject={};
			var vhtml1 = "";
			var vhtml2 = "";
			var appButton = "";
			soft = re.apps;
			onlineversion = re.version;
			locversion = obj["softcenter_version"];
			$("#loading").hide();
			$(".loader").show();
			if(locversion != onlineversion){
				$("#update").show();
			}
			$("#version").html("当前版本："+locversion+" , 线上版本：" + onlineversion + '&nbsp;&nbsp;&nbsp;&nbsp;【问题反馈:<a href="https://github.com/koolshare/ttsoft" target="_blank">&nbsp;&nbsp;<u>github</u></a><a href="http://koolshare.cn/forum-102-1.html" target="_blank">&nbsp;&nbsp;&nbsp;<u>koolshare</u></a>】');

			
			var object = $.extend([],obj, soft);
			var j=0;
			var x=0;
			for(var name in object){
				if(name.indexOf("name") > 0 ){
					app_name = object[name];
					appObject["app_"+app_name+"_name"] = object['softcenter_module_'+app_name+'_name'];
					appObject["app_"+app_name+"_title"] = object['softcenter_module_'+app_name+'_title'];
					appObject["app_"+app_name+"_home_url"] = object['softcenter_module_'+app_name+'_home_url'];
					appObject["app_"+app_name+"_version"] = object['softcenter_module_'+app_name+'_version'];
					appObject["app_"+app_name+"_description"] = object['softcenter_module_'+app_name+'_description'];
					appObject["app_"+app_name+"_install"] = object['softcenter_module_'+app_name+'_install'];
				}
			};
			for(var i=0; i < object.length; i++) {  
				o_name = object[i]["name"];				//内部软件名
				o_title = object[i]["title"];			//显示软件名
				o_home_url = object[i]["home_url"];			//调用网页地址
				o_tar_url = object[i]["tar_url"];		//tar包相对地址  aria2/aria2.tar.gz
				o_version = object[i]["version"];	//app版本号
				o_md5 = object[i]["md5"];			//app MD5
				o_description = object[i]["description"];//描述
				if(o_description==""){
					o_description="暂无描述";
				};
				appObject["app_"+o_name+"_name"] = o_name;
				appObject["app_"+o_name+"_title"] = o_title;
				appObject["app_"+o_name+"_home_url"] = o_home_url;
				appObject["app_"+o_name+"_tar_url"] = o_tar_url;
				appObject["app_"+o_name+"_oversion"] = o_version;
				appObject["app_"+o_name+"_description"] = o_description;
				appObject["app_"+o_name+"_md5"] = o_md5;
			};
			//console.log("All_App_Object",appObject);
			softInfo = appObject;
			//console.log("All_App_Object",softInfo);
			for(var name in appObject){
				if(name.indexOf("name") > 0 ){
					var appname = appObject[name];
					title = appObject["app_"+appname+"_title"];
					version = appObject["app_"+appname+"_version"];
					install = appObject["app_"+appname+"_install"];
					oversion = appObject["app_"+appname+"_oversion"];
					description = appObject["app_"+appname+"_description"];
					if(!title){
						title = appname;
					}
					if(description=="" || !description){
						description="暂无描述";
					};
					if(install=="1" || install=="2"){
						j++;
						aurl = "#Module_" +appname+".asp";
						if(oversion!=version && oversion){
							appButton = '<button value="'+appname+'" onclick="appupdata(this)" id="app-update" class="btn btn-success">更新</button>';
						}else{
							appButton = '<button type="button" value="'+appname+'" onclick="appuninstall(this)" class="btn btn-danger">卸载</button>';
						}
						appimg = softcenterUrl+"/softcenter/softcenter/res/icon-"+appname+".png";
						bgimg = softcenterUrl+"/softcenter/softcenter/res/icon-"+appname+"-bg.png";
						if(!CheckImgExists(bgimg)){
							bgimg = '/res/icon-'+appname+'-bg.png';
						}
						if(!CheckImgExists(appimg)){
							appimg = '/res/icon-'+appname+'.png';
						}
						vhtml1 += '<div class="apps" style="background:url('+bgimg+');" onmouseover="change1(this);" onmouseout="change2(this);">'+
						'<a href="'+aurl+'" title="'+title+'\n'+description+'">'+
							'<div class="infos">'+
								'<img class="appimg" src="'+appimg+'"/></div>'+
								'<div class="app-name"><p>'+title+'</p><p>'+description+'</p></div>'+
							'</a>'+
							'<div class="appDesc">'+
							appButton+
							'</div>'+
						'</div>';
						appButton="";
					}else{
						x++;
						appimg = softcenterUrl+"/softcenter/softcenter/res/icon-"+appname+".png";
						bgimg = softcenterUrl+"/softcenter/softcenter/res/icon-"+appname+"-bg.png";
						appButton = '<button type="button" value="'+appname+'" onclick="appinstall(this)" class="btn btn-primary">安装</button>';
						vhtml2 += '<div title="'+title+'\n'+description+'" class="apps" style="background:url('+bgimg+');" onmouseover="change1(this);" onmouseout="change2(this);">'+
							'<div class="infos">'+
								'<img class="appimg" src="'+appimg+'"/></div>'+
								'<div class="app-name"><p>'+title+'</p>'+
								'<p>'+description+'</p></div>'+
							'<div class="appDesc">'+
							appButton+
							'</div>'+
						'</div>';
						appButton="";
					}
				}
			};
			$(".tabContent1").html(vhtml1);
			$(".tabContent2").html(vhtml2);
			vhtml1="";
			vhtml2="";
			$("#app1-server1-basic-tab").html('<i class="icon-system"></i> 已安装（'+j+'）');
			$("#app2-server1-advanced-tab").html('<i class="icon-globe"></i> 未安装（'+x+'）');
			//软件中心更新 start
			if (onlineversion != locversion){
				$("#update").click(function () {
					var moduleInfo = {
						"name":"softcenter",
						"md5": re.md5,
						"tar_url": re.tar_url,
						"version": re.version
					};
					appPostScript(moduleInfo, "ks_app_install.sh");
				});
			}
			// filp all software icon once and remain update style
			if(($('.btn.btn-success'))){
				var update_soft = $('.btn.btn-success').parent('DIV.appDesc').parent();
				change1(update_soft);
			}
			var normal_soft = $('.btn.btn-danger').parent('DIV.appDesc').parent();
			change1(normal_soft);
			change2(normal_soft);
			//软件中心更新 end
		},
		error :function(data){
			$("#loading").hide();
			$('#server').html('网络异常！');
			$("#version").html("<font color='#FF6A6A'>X 线上服务器超时 , 请稍后重试……</font>");
			getLocalApp(obj)
			//console.log("network error",data);
			
		},
		timeout:1000
	});
}
function getLocalApp(obj){
	var vhtml1 ="";
	var j=0;
	for(var p in obj) {
		//console.log(p);  //获取到元素
		if(p.indexOf("name") > 0 ){  
			j++;
			var appButton="";
			name = obj[p];
			aurl = "#Module_" + name+".asp";
			description = "本地版本："+obj["softcenter_module_"+name+"_version"];
			appimg = "/res/icon-"+name+".png";
			bgimg = "/res/icon-"+name+"-bg.png";
			appButton = '<button type="button" value="'+name+'" onclick="appuninstall(this)" class="btn btn-danger">卸载</button>';
			vhtml1 += '<div class="apps" style="background:url('+bgimg+');" onmouseover="change1(this);" onmouseout="change2(this);"><a href="'+aurl+'" title="'+name+'\n'+description+'"><div class="infos"><img class="appimg" src="'+appimg+'"/></div><div class="app-name"><p>'+name+'</p><p>'+description+'</p></div></a><div class="appDesc">'+appButton+'</div></div>';
		}  						
	}
	$("#app1-server1-basic-tab").html('<i class="icon-system"></i> 已安装（'+j+'）');
	$(".tabContent1").html(vhtml1);
}
//安装APP
function appPostScript(moduleInfo, script) {
    var id = 1 + Math.floor(Math.random() * 6);
	var data = {};
    var applyUrl = "/_api/";
	if(script =="ks_tar_install.sh"){
	data["soft_name"] = moduleInfo.name;
	data["soft_install_version"] = moduleInfo.version;
	}else{
	data["softcenter_home_url"] = softcenterUrl;
	data["softcenter_installing_todo"] = moduleInfo.name;
	}
    
    if(script == "ks_app_install.sh") {
    data["softcenter_installing_tar_url"] = moduleInfo.tar_url;
    data["softcenter_installing_md5"] = moduleInfo.md5;
    data["softcenter_installing_version"] = moduleInfo.version;
    data[moduleInfo.name + "_title"] = moduleInfo.title;
    }
	
	var postData = {"id": id, "method":script, "params":[], "fields": data};
	
	var success = function(data) {
		//console.log("success",data);
		$('.popover').html(data.result);
	};
	var error = function(data) {
		//请求错误！
		$('.popover').html('<font color=red>软件中心异常！</font>');
	};
	if(script =="ks_tar_install.sh"){
		CheckZ();
	}else{
		CheckX();
	}
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  error: error,
	  dataType: "json"
	});
}
function changeButton(obj){
	if(obj){
		$('button').addClass('disabled');
		$('button').prop('disabled', true);
	}else{
		$('button').removeClass('disabled');
		$('button').prop('disabled', false);
	}
}
function checkInstallStatus(){
var appsInfo;
	$.getJSON("/_api/softcenter_installing_", function(resp) {
		appsInfo=resp.result[0];
		var installing  = appsInfo["softcenter_installing_status"];
		var name = appsInfo["softcenter_installing_todo"];
		if( name== "softcenter"){
			window.location.href='/soft-center-update.asp';
			return;
		}
		if(!installing || installing=="0"){
			currState.installing = false;
			clearTimeout(TimeOut);
			setTimeout("window.location.reload()", 3000);
		}else{
			currState.installing = true;
			changeButton(true);
		$('.popover').html(Msginfos[installing]);
		}
	});
}
function CheckX(){
	$('.popover').html('请稍后……');
	changeButton(true);
	TimeOut = window.setInterval(checkInstallStatus, 1000); 
}
function CheckZ(){
	TimeOut = window.setInterval(get_log, 1000); 
}
function softCenterInit(){
	$.getJSON("/_api/softcenter_", function(resp) {
		appsInfo=resp.result[0];
		//console.log("appsinfo",appsInfo);
		getSoftCenter(appsInfo);
		if(resp.softcenter_installing_status != '0' && resp.softcenter_installing_status){
			CheckX();
		}
	});
}
function uploadApp(){
	var filename = $("#file").val();
	filename = filename.split('\\');
	filename = filename[filename.length-1];
	var filelast = filename.split('.');
	filelast = filelast[filelast.length-1];
	var appversion = $('#_app_version').val();
	if(filelast !='gz'){
		alert('插件压缩包格式不正确！');
		return false;
	}
	if(appversion==""){
		alert('版本号未填写！');
		return false;
	}
	var formData = new FormData();
	formData.append(filename, $('#file')[0].files[0]);
	$('.popover').html('正在安装，请稍后……');
	changeButton(true);
	$.ajax({
		url: '/_upload',
		type: 'POST',
		cache: false,
		data: formData,
		processData: false,
		contentType: false,
		complete:function(res){
			if(res.status==200){
				var moduleInfo = {
						"name":filename,
						"version": appversion
					};
				appPostScript(moduleInfo,'ks_tar_install.sh');
			}
		}
	});
}
function get_log(){
var _temp;
	$.ajax({
		url: '/_temp/soft_log.txt',
		type: 'GET',
		dataType: 'text',
		async:false,
		success: function(result) {
            if(result.length>0 && result.indexOf('jobdown')<0 && _temp != result) {
                $("#soft_log").val(result);
				_temp = result;
            }else {
				$('.popover').html('安装成功！页面即将跳转！');
				clearTimeout(TimeOut);
				setTimeout("window.location.reload()", 3000);
            }
        },
        error: function(xhr, status, error) {
			$('.popover').html('服务器出错，请稍候再试！');
			changeButton(false);
        },
        cache:false
	});
}
</script>
	<div class="col">
		<div class="heading">
			<div id="loading"><br><b>正在连接服务器...</b> <div class="spinner"></div></div>
			<div class="loader" style="display:none;">
				<div class="loading-2">
					<i></i>
					<i></i>
					<i></i>
					<i></i>
					<i></i>
				</div>
			</div>
			<span id="server" style="color:#FF6A6A;font-size:13px;margin-right:10px;"></span>
			<span id="version" style="color:#FF6A6A;font-size:13px;"></span>
			<button id="update" style="display:none;float:right;" class="btn btn-success pull-right">有新的版本可用 <i class="icon-system"></i></button>
		</div>
		<br>
		<div class="content">
			<fieldset>
				<div class="col-sm-2" style="width:140px;">
					<img class="pull-left" src="/res/github.png">
				</div>
				<div class="col-sm-10">
					<ul class="pullmsg">
						<li id="push_titile">
							欢迎
						</li>
						<li id="push_content1">
							欢迎来到插件中心，目前正在紧张开发中，各种插件酝酿中！
						</li>
						<li id="push_content2">
							如果你想加入我们的工作，在 <a href="http://www.koolshare.cn" target="_blank"> <i><u>www.koolshare.cn</u></i> </a>联系我们！
						</li>
						<li id="push_content3"></li>
						<li id="push_content4"></li>
					</ul>
				</div>
			</fieldset>
		</div>
	</div>
	​<ul class="nav nav-tabs">
		<li>
			<a href="javascript:tabSelect('app1');" id="app1-server1-basic-tab" class="active"><i class="icon-system"></i> 已安装</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app2');" id="app2-server1-advanced-tab"><i class="icon-globe"></i> 未安装</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app3');" id="app3-server1-keys-tab"><i class="icon-tools"></i> 离线安装</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app4');" id="app4-server1-status-tab"><i class="icon-info"></i> 关于我们</a>
		</li>
	</ul>
	
		<div class="box boxr1">
			<div class="heading">已安装软件列表&nbsp;&nbsp;&nbsp;<span class="popover"></span></div>
			<div class="content">
				<div class="tabContent1">
					<!--app info -->
					<!--app info -->
				</div>
			</div>
		</div>
		<div class="box boxr2">
			<div class="heading">未安装软件列表&nbsp;&nbsp;&nbsp;<span class="popover"></span></div>
			<div class="content">
				<div class="tabContent2">
					<!--app info -->
					<!--app info -->
				</div>
			</div>
		</div>
		<div class="box boxr3">
			<div class="heading">插件离线安装界面&nbsp;&nbsp;&nbsp;<span class="popover"></span></div>
			<div class="content">
				<div class="tabContent3">
					<ul>
						<li>此页面功能需要在7.0及其以上的固件才能使用。</li>
						<li>通过本页面，你可以上传插件的离线安装包来安装插件；</li>
						<li>离线安装会自动解压tar.gz后缀的压缩包，识别压缩包一级目录下的install.sh文件并执行；</li>
						<li>建议开发者将插件版本号，md5等信息在install.sh文件内进行写入；</li>
					</ul>
					<br/>
					<div id="identification" class="section">
						<fieldset>
							<label class="col-sm-3 control-left-label" for="_app_version">安装版本号</label>
							<div class="col-sm-9">
								<input type="text" name="app_version" maxlength="32" size="34" id="_app_version" title="">
							</div>
						</fieldset>
						<fieldset>
							<label class="control-left-label col-sm-3">选择安装包</label>
							<div class="col-sm-9">
								
									<input type="file" id="file" size="50">
									<button id="upload" type="button"  onclick="uploadApp();" class="btn btn-danger">上传并安装 <i class="icon-cloud"></i></button>
								
							</div>
						</fieldset>
						<fieldset>
							<label class="control-left-label col-sm-3">安装日志</label>
							<div class="col soft_log">
								<script type="text/javascript">
									s = 'height:200px;display:block';
									$('.col.soft_log').append('<textarea class="as-script" name="soft_log" id="soft_log" wrap="off" style="max-width:100%; min-width: 80%;' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false" disabled></textarea>');
								
								</script>
							</div>
						</fieldset>
					</div>
				</div>
			</div>
		</div>
		<div class="box boxr4">
			<div class="heading">关于我们</div>
			<div class="content">
				<div class="tabContent4">
					<!--app info -->
					<ul>
						<li>我们是一群致力于服务大众的个人自发的群体，来自全国各地都聚集在 <a href="http://koolshare.cn" target="_blank"><font color="#FF6347"> KoolShare </font></a>论坛。</li>
						<li><font color="#8470FF">参与开发的人员：@小宝、@RT-AC68U-sadog、@HOUZI(｡◕‿&nbsp;&nbsp;◕｡)、@JSmonkey、KoolShare开发组、以及其他人员。</font></li>
						<li><font color="#1E90FF">本软件中心属于开源项目，任何组织或个人均可自由开发。</font></li>
						<li>软件中心目前处于测试阶段，如在使用中出现问题请至 <a href="http://koolshare.cn/forum-102-1.html" target="_blank"><font color="#FF6347">KoolShare Tomato</font></a> 版块反馈。</li>
					</ul>
					<!--app info -->
				</div>
			</div>
		</div>
</content>
