<title>软件中心 - 腾讯云存储</title>
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
setTimeout("get_run_status();", 1000);
toggleVisibility('notes')
var dbus;
var softcenter = 0;
function init_kdisk(){
	getAppData();
	verifyFields(null, 1);
}

function getAppData(){
var dbusInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/kdisk_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	dbus = data.result[0];
		}
	});
}

function get_run_status(){
	var id1 = parseInt(Math.random() * 100000000);
	var postData1 = {"id": id1, "method": "kdisk_status.sh", "params":[], "fields": ""};
	$.ajax({
		type: "POST",
		cache:false,
		url: "/_api/",
		data: JSON.stringify(postData1),
		dataType: "json",
		success: function(response){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("kdisk_status").innerHTML = response.result;
			setTimeout("get_run_status();", 10000);
		},
		error: function(){
			if(softcenter == 1){
				return false;
			}
			document.getElementById("kdisk_status").innerHTML = "获取运行状态失败！";
			setTimeout("get_run_status();", 5000);
		}
	});
}	

function verifyFields(focused, quiet){
	if (dbus.kdisk_step == 4){
		elem.display(PR('kdisk_now1'), false);
		elem.display(PR('kdisk_now2'), false);
		elem.display(PR('kdisk_now3'), false);
	}
	if (dbus.kdisk_step == 0){
		elem.display(PR('kdisk_now2'), false);
		elem.display(PR('kdisk_now3'), false);
	}
	if (!dbus.kdisk_step){
		elem.display(PR('kdisk_now2'), false);
		elem.display(PR('kdisk_now3'), false);
	}
	if (dbus.kdisk_step == 1){
		elem.display(PR('kdisk_now1'), false);
		elem.display(PR('kdisk_now3'), false);
	}
	if (dbus.kdisk_step == 2){
		elem.display(PR('kdisk_now1'), false);
		elem.display(PR('kdisk_now2'), false);
	}
	return 1;
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
		
function kdisk_now(o){
	softcenter = 0;
	dbus.kdisk_fs = E('_kdisk_fs').value;
	var id2 = parseInt(Math.random() * 100000000);
	var postData2 = {"id": id2, "method": 'kdisk_config.sh', "params":[o], "fields": dbus};
	var success2 = function(data2) {
		$('#footer-msg').text(data2.result);
		$('#footer-msg').show();
		setTimeout("window.location.reload()", 3000);
	};
	var error2 = function(data2) {
	};
	$('#footer-msg').text('运行中……');
	$('#footer-msg').show();
	$('button').addClass('disabled');
	$('button').prop('disabled', true);
	$.ajax({
	  type: "POST",
	  url: "/_api/",
	  data: JSON.stringify(postData2),
	  success: success2,
	  error: error2,
	  dataType: "json"
	});
}

</script>
<div class="box">
<div class="heading">硬盘助手<a href="#/soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<div class="content">
	<span class="col" style="line-height:30px;width:700px">
	软路由的安装盘基本都有大量的空余空间，硬盘助手可以方便的帮你把剩余的空间挂载起来。<br />
</div>
</div>

<div class="box">
<br><hr>
<div class="content">
<div id="kdisk-fields"></div>
<script type="text/javascript">
var option_fs = [['f2fs', 'F2FS'],['ext4', 'EXT4'],['ext2', 'EXT2'],['ext3', 'EXT3']];
$('#kdisk-fields').forms([
{ title: '助手建议', text: '<font id="kdisk_status" name=kdisk_status color="#1bbf35">正在获取运行状态...</font>' },
{ title: '第一步：', name:'kdisk_1', text: '<button id="kdisk_now1" onclick="kdisk_now(1);" class="btn btn-primary">一键自动分区</button>' },
{ title: '第二步：', name:'kdisk_2', text: '<button id="kdisk_now2" onclick="kdisk_now(2);" class="btn btn-primary">重启路由器</button>' },
{ title: '第三步：', multi: [ 
	{ name:'kdisk_fs',type: 'select', options: option_fs, value: dbus.kdisk_fs ,suffix: '分区文件格式&nbsp;&nbsp;' },
	{ suffix: ' <button id="kdisk_now3" onclick="kdisk_now(3);" class="btn btn-primary">开始格式化并自动挂载</button>' }
]},	
]);
</script>
</div>
</div>
<div class="box">
	<div class="heading">插件说明： <a class="pull-right" data-toggle="tooltip" title="Hide/Show Notes" href="javascript:toggleVisibility('notes');"><span id="sesdivnotesshowhide"><i class="icon-chevron-up"></i></span></a></div>
	<div class="section content" id="sesdivnotes" style="display:none">
			<li>第一步完成必须在插件页面重启路由器</li>
			<li>安装盘是SSD建议格式化成F2FS格式</li>
			<li>普通机械硬盘建议格式化成EXT4格式</li>
	</div>
</div>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">刷新页面 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">init_kdisk();</script>
</content>
