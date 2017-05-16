<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

For use with Tomato Firmware only.
No part of this file may be used without permission.
-->
<title>软件中心 - swap</title>
<content>
	<script type="text/javascript">
		var dbus = [];
		var refresh = 1;
		function init_swap(){
			disk.setup();
			get_usb_status();
		}
		
		function get_usb_status(){
			if (refresh == 0){
				return false;
			}
			var id = parseInt(Math.random() * 100000000);
			var postData1 = {"id": id, "method": "swap_status.sh", "params":[], "fields": ""};
			$.ajax({
				type: "POST",
				url: "/_api/",
				data: JSON.stringify(postData1),
				dataType: "json",
				success: function(response){
					get_local_data();
					document.getElementById("_swap_status").innerHTML = response.result;
					setTimeout("get_usb_status();", 10000);
				}
			});
		}
		function get_local_data(){
			$.getJSON("/_api/swap", function(res) {
				dbus=res.result[0];
				disk.removeAllData();
				disk.populate();
				disk.resort();
				$("#_swap_on_disk").find('option').remove().end();
				for ( var i = 1; i <= dbus["swap_disk_nu"]; ++i ) {
					if (dbus["swap_disk_type_" + i] == "ext2" || dbus["swap_disk_type_" + i] == "ext3" || dbus["swap_disk_type_" + i] == "ext4" ){
						$("#_swap_on_disk").append("<option value='" + dbus["swap_disk_moon_" + i] + "'>" + dbus["swap_disk_moon_" + i] + "</option>");
					}
				}
				(dbus["swap_on_disk"]) && $("#_swap_on_disk").val(dbus["swap_on_disk"]);
				$("#_swap_on_size").val(dbus["swap_on_size"] || "2");
				verifyFields();
			});
		}

		var disk = new TomatoGrid();
		
		disk.populate = function(){
			for ( var i = 1; i <= dbus["swap_disk_nu"]; ++i ) {
				this.insertData( -1, [
				dbus["swap_disk_name_" + i] || "", 
				dbus["swap_disk_type_" + i] || "", 
				dbus["swap_disk_size_" + i] || "", 
				dbus["swap_disk_used_" + i] || "", 
				dbus["swap_disk_aval_" + i] || "", 
				dbus["swap_disk_useP_" + i] || "", 
				dbus["swap_disk_moon_" + i] || ""
				] );
			}
		}
		disk.setup = function() {
			this.init( 'disk-grid', 'sort' );
			this.populate();
			this.headerSet( [ '文件系统', '磁盘格式', '磁盘大小', '已用大小', '可用空间', '使用率', '挂载点' ] );
			this.sort( 1 );
		};

		function verifyFields(){
			var a = (dbus["swap_on_loaded"] == '0'); //有磁盘有ext但是没swapfile
			var b = (dbus["swap_on_loaded"] == '1'); //有磁盘有ext有tt_swapfile
			var c = (dbus["swap_on_loaded"] == '2'); //没有磁盘
			var d = (dbus["swap_on_loaded"] == '3'); //有磁盘但是没有ext
			elem.display(PR('_creat_now'), a);
			elem.display(PR('_ext4_readme'), a||d);
			elem.display('_USB_LISTS', !c);
			
			elem.display(PR('_delete_now'), b);
		}

		function creat_swap_now(o){
			refresh = 0;
			elem.display('_log', true);
			setTimeout("get_log();", 500);
			dbus
			dbus["swap_on_disk"] = E('_swap_on_disk').value;
			dbus["swap_on_size"] = E('_swap_on_size').value;
			// post data
			var id = parseInt(Math.random() * 100000000);
			var postData = {"id": id, "method": 'swap_config.sh', "params":[o], "fields": dbus};
			$.ajax({
				url: "/_api/",
				type: "POST",
				dataType: "json",
				data: JSON.stringify(postData),
				success: function(response){
					if(response.result == id){
						window.location.reload();
					}
				}
			});
		}
		var _responseLen;
		var noChange = 0;
		var Scorll = 1;
		function get_log(){
			$.ajax({
				url: '/_temp/swap_log.txt',
				type: 'GET',
				dataType: 'text',
				success: function(response) {
					var retArea = E("_log");
					if (response.search("XU6J03M6") != -1) {
						retArea.value = response.replace("XU6J03M6", " ");
						retArea.scrollTop = retArea.scrollHeight;
						window.location.reload();
						return true;
					}
					if (_responseLen == response.length) {
						noChange++;
					} else {
						noChange = 0;
					}
					if (noChange > 10000) {
						return false;
					} else {
						setTimeout("get_log();", 1000); //100 is radical but smooth!
					}
					retArea.value = response;
					if (Scorll == '1'){
						retArea.scrollTop = retArea.scrollHeight;
						_responseLen = response.length;
					}
				},
				error: function() {
					E("_log").value = "获取日志失败！";
				}
			});
		}
		function Scroll(s){
			Scorll = s;
		}
		
	</script>
	<div class="box">
		<div class="heading">虚拟内存 for tomato<a href="/#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
		<div class="content">
			<span id="msg" class="col-sm-9" style="margin-top:10px;width:800px"><li>挂载虚拟内存（swap），需要你准备一个文件格式为ext2/ext3/ext4的USB磁盘；</li><br/><li>当需要路由器进行下载或者运行一些Go语言的程序时，虚拟内存就能派上用场。</li></span>
		</div>	
	</div>
	<div class="box" id="_USB_LISTS" data-box="routing-table">
		<div class="heading">USB储存列表</div>
		<div class="section content">
			<table class="line-table" id="disk-grid"></table>
		</div>
	</div>
	<div class="box" style="margin-top: 0px;">
		<div class="heading">基本设置</div>
		<div class="content">
			<div id="identification" class="section"></div>
			<script type="text/javascript">
				$('#identification').forms([
					{ title: '磁盘状态', suffix: '<font id="_swap_status" name=_swap_status color="#1bbf35">正在获取运行状态...</font>' },
					{ title: '创建虚拟内存（swap）', hidden:true, multi: [
						{ name: 'swap_on_disk',type: 'select', options:[], value: dbus.swap_on_disk || "1", suffix: ' &nbsp; &nbsp;' },
						{ name: 'swap_on_size',type: 'select', options:[['1', '256MB'], ['2', '512MB'], ['3', '1GB']], value: dbus.swap_size || "2", suffix: '推荐512MB' },
						{ suffix: ' <button id="_creat_now" onclick="creat_swap_now(1);" class="btn btn-danger">创建</button>' }
					]},
					{ title: '删除虚拟内存（swap）', hidden:true, text: ' <button id="_delete_now" onclick="creat_swap_now(2);" class="btn btn-danger">删除</button>' },
					{ title: '格式化ext4磁盘简易教程', hidden:true, text: ' <span id="_ext4_readme"><li>1. 插上你的U盘后，进入webshell，输入<b>df -h</b> 命令；</li><li>2. 找到你的磁盘那行，记下<b>Filesystem</b>和<b>Mounted on</b>两个参数；</li><li>3. 比如我的分别是<b>/dev/sda1</b>和<b>/tmp/mnt/sda1</b>；</li><li>4. 输入<b>umount /tmp/mnt/sda1</b>，卸载该磁盘；</li><li>5. 输入<b>mkfs.ext4 /dev/sda1</b>，将磁盘格式化为ext4格式；</li><li>6. 先 <b>mkdir -p /tmp/mnt/sda1</b>，创建挂载点文件夹；</li><li>7. 再 <b>mount /dev/sda1 /tmp/mnt/sda1</b>，重新完成磁盘挂载。</li></span>' }
				]);
			</script>
			<div id="log_pannel" class="content">
				<div class="section content">
					<script type="text/javascript">
						y = Math.floor(docu.getViewSize().height * 0.1);
						s = 'height:' + ((y > 300) ? y : 300) + 'px;display:none';
						$('#log_pannel').append('<textarea class="as-script" name="_log" id="_log" onmouseover="Scroll(0);" onmouseout="Scroll(1);" readonly wrap="off" style="max-width:100%; min-width: 100%; margin: 0; ' + s + '" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"></textarea>');
					</script>
				</div>
			</div>
		</div>
		
	</div>
	<script type="text/javascript">init_swap();</script>
</content>
