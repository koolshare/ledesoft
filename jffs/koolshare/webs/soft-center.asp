<title>软件中心</title>
<content>
<script type="text/javascript">
$("#app1-server1-basic-tab").addClass("active");
//APPS 控制模块
function change1(obj){
	obj.style.backgroundColor='#e1e2e2';
	$(obj).find('button').show();
}
function change2(obj){
	obj.style.backgroundColor='#ffffff';
	var id = $(obj).find('button').attr("id");
	if(id != 'app-update'){
		$(obj).find('button').hide();
	}
}

function tabSelect(obj){
	if(obj=="app1"){
		$('#app1-server1-basic-tab').addClass("active");
		$('#app2-server1-advanced-tab').removeClass("active");
		$('#app3-server1-keys-tab').removeClass("active");
		$('#app4-server1-status-tab').removeClass("active");
		$('.boxr1').show();
		$('.boxr2').hide();
		$('.boxr3').hide();
		$('.boxr4').hide();
		$('.boxr5').hide();
	}else if(obj=="app2"){
		$('#app1-server1-basic-tab').removeClass("active");
		$('#app2-server1-advanced-tab').addClass("active");
		$('#app3-server1-keys-tab').removeClass("active");
		$('#app4-server1-status-tab').removeClass("active");
		$('.boxr1').hide();
		$('.boxr2').show();
		$('.boxr3').hide();
		$('.boxr4').hide();
		$('.boxr5').hide();
	}else if(obj=="app3"){
		$('#app1-server1-basic-tab').removeClass("active");
		$('#app2-server1-advanced-tab').removeClass("active");
		$('#app3-server1-keys-tab').addClass("active");
		$('#app4-server1-status-tab').removeClass("active");
		$('.boxr1').hide();
		$('.boxr2').hide();
		$('.boxr3').show();
		$('.boxr4').show();
		$('.boxr5').hide();
	}else if(obj=="app4"){
		$('#app1-server1-basic-tab').removeClass("active");
		$('#app2-server1-advanced-tab').removeClass("active");
		$('#app3-server1-keys-tab').removeClass("active");
		$('#app4-server1-status-tab').addClass("active");
		$('.boxr1').hide();
		$('.boxr2').hide();
		$('.boxr3').hide();
		$('.boxr4').hide();
		$('.boxr5').show();
	}
}

</script>

<script type="text/javascript">
// 安装信息更新策略:
// 当软件安装的时候,安装进程内部会有超时时间. 超过超时时间 没安装成功,则认为失败.
// 但是路由内部的绝对时间与浏览器上的时间可能不同步,所以无法使用路由器内的时间. 浏览器的策略是,
// 安装的时候会有一个同样的计时,若这个超时时间内,安装状态有变化,则更新安装状态.从而可以实时更新安装进程.
var currState = {"installing": true, "lastChangeTick": 0, "lastStatus": "-1", "module":""};
var softcenterUrl = "https://ttsoft.ngrok.wang";
//var softcenterUrl = "https://koolshare.ngrok.wang";
var TIMEOUT_SECONDS = 18;
var softInfo = {};

//初始化软件中心
notice_show();
softCenterInit();
//推送信息
function notice_show(){
    $.ajax({
        url: softcenterUrl+'/softcenter/push_message1.json.js',
        type: 'GET',
        dataType: 'jsonp',
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
    _formatData(name,'uninstall');
    
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

function _formatData(name,objs){
	$.ajax({
　　	url: softcenterUrl+'/softcenter/app.json.js',
        type: 'GET',
        dataType: 'jsonp',
		async:false,
	}).done(function(data){
　　	soft = data.apps;
		for(var i=0; i < soft.length; i++) {  
			aname = soft[i]["name"];
			if (aname == name){
				title = soft[i]["title"];
				tar_url = soft[i]["tar_url"];
				app_version = soft[i]["version"];
				app_md5 = soft[i]["md5"];			
				xxx = {
					"name":name,
					"md5": app_md5,
					"tar_url": tar_url,
					"version": app_version,
					"title":title
				};
				if(objs=="install"){
					appInstallModule(xxx);
				};
				if(objs=="uninstall"){
				xxx = {"name":name};
					appUninstallModule(xxx);
				};
			}
		};
	});
}

function getSoftCenter(obj){
	$.ajax({  
		url:softcenterUrl+"/softcenter/app.json.js",  
		dataType:'jsonp',  
		method: 'GET', 
		success:function(re) {
			var appObject={};
			var vhtml1 = "";
			var vhtml2 = "";
			var appButton = "";
			soft = re.apps;
			onlineversion = re.version;
			if(obj["softcenter_installing_todo"]==""){
				currState.installing=false;
			};
			locversion = obj["softcenter_version"];
			$("#version").text("本地版本："+locversion+" , 线上版本："+onlineversion);
			var object = $.extend([],obj, soft);
			var j=0;
			for(var name in object){
				if(name.indexOf("name") > 0 ){
					j++;
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
			console.log("All_App_Object",appObject);
			for(var name in appObject){
				if(name.indexOf("name") > 0 ){
					var appname = appObject[name];
					title = appObject["app_"+appname+"_title"];
					version = appObject["app_"+appname+"_version"];
					install = appObject["app_"+appname+"_install"];
					oversion = appObject["app_"+appname+"_oversion"];
					description = appObject["app_"+appname+"_description"];
					if(description=="" && description){
						description="暂无描述";
					};
					if(install=="1" || install=="2"){
						aurl = "#" + appObject["app_"+appname+"_home_url"];
						if(oversion!=version && oversion){
							appButton = '<button style="height:25px;" type="button" value="'+appname+'" onclick="appuninstall(this)" id="app-update" class="btn btn-success btn-sm">更新</button>';
						}else{
							appButton = '<button style="height:25px;display:none;" type="button" value="'+appname+'" onclick="appinstall(this)" id="app-uninstall" class="btn btn-danger btn-sm">卸载</button>';
						}
						appimg = "/res/icon-"+appname+".png";
						vhtml1 += '<div class="apps" onmouseover="change1(this);" onmouseout="change2(this);">'+
							'<a href="'+aurl+'" title="'+description+'">'+
								'<img class="appimg" src="'+appimg+'"/>'+
								'<div class="app-name">'+appname+'</div>'+
								'<p class="desc">'+description+'</p>'+
							'</a>'+
							'<div class="appDesc">'+
							appButton+
							'</div>'+
						'</div>';
					}else{
						aurl = "javascript:void(0)";
						appButton = '<button style="height:25px;display:none;" type="button" value="'+appname+'" onclick="appinstall(this)" id="app-install" class="btn btn-primary btn-sm">安装</button>';
						appimg = softcenterUrl+"/softcenter/softcenter/res/icon-"+appname+".png";
						vhtml2 += '<div class="apps" onmouseover="change1(this);" onmouseout="change2(this);">'+
							'<a href="'+aurl+'" title="'+description+'">'+
								'<img class="appimg" src="'+appimg+'"/>'+
								'<div class="app-name">'+appname+'</div>'+
								'<p class="desc">'+description+'</p>'+
							'</a>'+
							'<div class="appDesc">'+
							appButton+
							'</div>'+
						'</div>';		
					}
				}
			};
			$(".tabContent1").html(vhtml1);
			$(".tabContent2").html(vhtml2);
			vhtml1="";
			vhtml2="";
			appButton="";
			$("#app2-server1-advanced-tab").html('未安装('+object.length+') <i class="icon-globe"></i>');
			$("#app1-server1-basic-tab").html('已安装('+j+') <i class="icon-globe"></i>');
			//软件中心更新 start
			if (onlineversion != locversion){
				$("#update").show();
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
			//软件中心更新 end
		},
		timeout:3000  
	});
}


//安装APP
function appPostScript(moduleInfo, script) {
    if(currState.installing) {
		$('#msg').html('<h5>亲爱的小伙伴</h5> 已经有APP在安装中了， 不要急嘛！等会再试！<a class="close"><i class="icon-cancel"></i></a>');
		$('#msg').show();
		setTimeout("$('#msg').hide()", 5000);
    console.log("current is in installing state");
    return;
    }
    var id = 1 + Math.floor(Math.random() * 6);
	var data = {};
    var applyUrl = "/_api/";
    data["softcenter_home_url"] = softcenterUrl;
    data["softcenter_installing_todo"] = moduleInfo.name;
    if(script == "ks_app_install.sh") {
    data["softcenter_installing_tar_url"] = moduleInfo.tar_url;
    data["softcenter_installing_md5"] = moduleInfo.md5;
    data["softcenter_installing_version"] = moduleInfo.version;
    data[moduleInfo.name + "_title"] = moduleInfo.title;
    }
	currState.installing = true;
	var postData = {"id": id, "method":script, "params":[], "fields": data};
	var success = function(data) {
		console.log("success",data);
		currState.installing = false;
		if(data.result == "ok") {
		//shell执行成功！命令：http_response "postend"
			$('#msg2').html('<h5>安装成功</h5> 配置成功，等待刷新。<a class="close"><i class="icon-cancel"></i></a>');
			$('#msg2').show();
			setTimeout("window.location.reload()", 12000);
		}else{
		//shell执行失败！命令：http_response  "失败原因"
			$('#msg3').html('<h5>错误</h5> 失败原因：'+data.result+' <a class="close"><i class="icon-cancel"></i></a>');
			$('#msg3').show();
			setTimeout("$('#msg3').hide()", 5000);
		}
	};
	var error = function(data) {
		currState.installing = false;
		//请求错误！
		console.log("error",data);
		$('#msg3').html('<h5>失败</h5> 错误原因：'+data.result+'<a class="close"><i class="icon-cancel"></i></a>');
		$('#msg3').show();
		setTimeout("$('#msg3').hide()", 5000);
	};
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData),
	  success: success,
	  error: error,
	  dataType: "json"
	});
}

function softCenterInit(){
var appsInfo;
	$.getJSON("/_api/softcenter_", function(resp) {
		appsInfo=resp.result[0];
		console.log("appsinfo",appsInfo);
		getSoftCenter(appsInfo);
	});
}
</script>
	<div id="msg" class="alert alert-warning icon" style="display:none;">
	</div>
	<div id="msg2" class="alert alert-success icon" style="display:none;">
	</div>
	<div id="msg3" class="alert alert-error icon" style="display:none;">
	</div>
	<div class="box" data-box="soft-center">
		<div class="heading">
			<b>Advanced Tomato Software Center</b>
		</div>
		<div class="content">
			<fieldset>
				<label class="col-sm-3 control-left-label" for="_tomatoanon_answer"><span id="version"><font color="red">网络异常，无法获得线上服务。</font></span></label>
				<div class="col-sm-9">
					<button id="update" style="display:none;" class="btn btn-success pull-right">有新的版本可用 <i class="icon-system"></i></button>
					<span class="help-block"> </span>
				</div>
			</fieldset>
			<fieldset>
				<label class="col-sm-2 control-left-label">
				<span><img src="res/logo.png" alt="" class="img-responsive"></span>
				</label>
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
			<a href="javascript:tabSelect('app1');" id="app1-server1-basic-tab"><i class="icon-system"></i> 已安装</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app2');" id="app2-server1-advanced-tab"><i class="icon-globe"></i> 未安装</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app3');" id="app3-server1-keys-tab"><i class="icon-tools"></i> 离线安装</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app4');" id="app4-server1-status-tab"><i class="icon-info"></i> 状态日志</a>
		</li>
	</ul>
		<div class="box boxr1">
			<div class="heading">已安装软件列表</div>
			<div class="content">
				<div class="tabContent1">
					<!--app info -->
					<!--app info -->
				</div>
			</div>
		</div>
		<div class="box boxr2">
			<div class="heading">未安装软件列表</div>
			<div class="content">
				<div class="tabContent2">
					<!--app info -->
					<!--app info -->
				</div>
			</div>
		</div>
		<div class="box boxr3">
			<div class="heading">插件离线安装界面</div>
			<div class="content">
				<div class="tabContent3">
					<ul>
						<li>此页面功能需要在7.0及其以上的固件才能使用。</li>
						<li>通过本页面，你可以上传插件的离线安装包来安装插件；</li>
						<li>离线安装会自动解压tar.gz后缀的压缩包，识别压缩包一级目录下的install.sh文件并执行；</li>
						<li>建议开发者将插件版本号，md5等信息在install.sh文件内进行写入；</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="box boxr4">
			<div class="heading">离线安装</div>
			<div class="content">
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
							<form name="form_upgrade" method="post" action="" encType="multipart/form-data">
								<input type="file" name="file" size="50"> <button type="button" value="Upgrade" id="afu-upgrade-button" class="btn btn-danger">Up & Install <i class="icon-cloud"></i></button>
							</form>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
		<div class="box boxr5">
			<div class="heading">状态日志</div>
			<div class="content">
				<div class="tabContent4">
					<!--app info -->
					<!--app info -->
				</div>
			</div>
		</div>
</content>
