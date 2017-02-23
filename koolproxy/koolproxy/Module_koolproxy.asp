<title>KoolProxy</title>
<content>
<script type="text/javascript">
var kprules = [];
var options_type = [];
var ruletmp = '';

$(function () {
$("#koolproxy_open").click(
	function(){
		if(document.getElementById('koolproxy_open').checked){
			nvram.koolproxy_open = 1;
			$('#koolproxy_status').html('<font color="#1bbf35">我运行了</font>');
		}else{
			nvram.koolproxy_open = 0;
			$('#koolproxy_status').html('<font color="#c9ced3">我停止了</font>');
		}
	}
)
})

function tabSelect(obj){
	if(obj=="app1"){
		$('#app1-server1-jb-tab').addClass("active");
		$('#app2-server1-gz-tab').removeClass("active");
		$('#app3-server1-kz-tab').removeClass("active");
		$('#app4-server1-zdy-tab').removeClass("active");
		$('#app5-server1-rz-tab').removeClass("active");
		$('.boxr1').show();
		$('.boxr2').hide();
		$('.boxr3').hide();
		$('.boxr4').hide();
		$('.boxr5').hide();
	}else if(obj=="app2"){
		$('#app1-server1-jb-tab').removeClass("active");
		$('#app2-server1-gz-tab').addClass("active");
		$('#app3-server1-kz-tab').removeClass("active");
		$('#app4-server1-zdy-tab').removeClass("active");
		$('#app5-server1-rz-tab').removeClass("active");
		$('.boxr1').hide();
		$('.boxr2').show();
		$('.boxr3').hide();
		$('.boxr4').hide();
		$('.boxr5').hide();
	}else if(obj=="app3"){
		$('#app1-server1-jb-tab').removeClass("active");
		$('#app2-server1-gz-tab').removeClass("active");
		$('#app3-server1-kz-tab').addClass("active");
		$('#app4-server1-zdy-tab').removeClass("active");
		$('#app5-server1-rz-tab').removeClass("active");
		$('.boxr1').hide();
		$('.boxr2').hide();
		$('.boxr3').show();
		$('.boxr4').hide();
		$('.boxr5').hide();
	}else if(obj=="app4"){
		$('#app1-server1-jb-tab').removeClass("active");
		$('#app2-server1-gz-tab').removeClass("active");
		$('#app3-server1-kz-tab').removeClass("active");
		$('#app4-server1-zdy-tab').addClass("active");
		$('#app5-server1-rz-tab').removeClass("active");
		$('.boxr1').hide();
		$('.boxr2').hide();
		$('.boxr3').hide();
		$('.boxr4').show();
		$('.boxr5').hide();
	}else if(obj=="app5"){
		$('#app1-server1-jb-tab').removeClass("active");
		$('#app2-server1-gz-tab').removeClass("active");
		$('#app3-server1-kz-tab').removeClass("active");
		$('#app4-server1-zdy-tab').removeClass("active");
		$('#app5-server1-rz-tab').addClass("active");
		$('.boxr1').hide();
		$('.boxr2').hide();
		$('.boxr3').hide();
		$('.boxr4').hide();
		$('.boxr5').show();
	}
}
//--------------------------------------------------
$.getJSON("https://koolshare.ngrok.wang/koolproxy/push_rule.json.js"+"?callback=?",
	function(json){
		koolproxy.setup(json);
	});

//--------------------------------------------------
var koolproxyctrl = new TomatoGrid();
koolproxyctrl.exist = function( f, v ) {
var data = this.getAllData();
for ( var i = 0; i < data.length; ++i ) {
if ( data[ i ][ f ] == v ) return true;
}
return false;
}
koolproxyctrl.dataToView = function( data ) {
return [ (data[ 0 ] != '0') ? ' [ <i class="icon-check icon-green"></i> ] ' : ' [ <i class="icon-cancel icon-red"></i> ] ', data[ 1 ], data[ 2 ] ];
}
koolproxyctrl.fieldValuesToData = function( row ) {
var f = fields.getAll( row );
return [ f[ 0 ].checked ? 1 : 0, f[ 1 ].value, f[ 2 ].value ];
}
koolproxyctrl.verifyFields = function( row, quiet ) {
var ok = 1;
return ok;
}
koolproxyctrl.resetNewEditor = function() {
var f;
f = fields.getAll( this.newEditor );
ferror.clearAll( f );
f[ 0 ].checked = 1;
f[ 1 ].value   = '';
f[ 2 ].value   = '';
}
koolproxyctrl.setup = function() {
this.init( 'ctrl-grid', '', 50, [
{ type: 'checkbox' },
{ type: 'text', maxlen: 90 },
{ type: 'text', maxlen: 40 }
] );
this.headerSet( [ '状态', 'IP地址', 'MAC地址' ] );
var s = nvram.koolproxy_ctrlist.split( '>' );
for ( var i = 0; i < s.length; ++i ) {
var t = s[ i ].split( '<' );
if ( t.length == 3 ) this.insertData( -1, t );
}
this.showNewEditor();
this.resetNewEditor();
}

//--------------------------------------------------

var koolproxy = new TomatoGrid();
koolproxy.exist = function( f, v ) {
var data = this.getAllData();
for ( var i = 0; i < data.length; ++i ) {
if ( data[ i ][ f ] == v ) return true;
}
return false;
}
koolproxy.dataToView = function( data ) {
 for(var j=0;j<options_type.length;j++){
	if(data[1]==options_type[j][0]){
		data[1]=options_type[j][1];
	}
 }
return [ (data[ 0 ] != '0') ? ' [ <i class="icon-check icon-green"></i> ]' : ' [ <i class="icon-cancel icon-red"></i> ]', data[ 1 ], data[ 2 ],data[ 3 ] ];
}
koolproxy.fieldValuesToData = function( row ) {
var f = fields.getAll( row );
return [ f[ 0 ].checked ? 1 : 0, f[ 1 ].value , f[ 2 ].value, f[ 3 ].value ];
}
koolproxy.verifyFields = function( row, quiet ) {
var ok = 1;
var f;
f = fields.getAll( row );
if(f[1].value !='-1'){
f[2].value = kprules[f[1].value][1];
f[2].disabled = true;
f[3].value = 'KoolProxy';
f[3].disabled = true;
}else{
f[2].disabled = false;
f[3].disabled = false;
}
return ok;
}
koolproxy.resetNewEditor = function() {
var f;
f = fields.getAll( this.newEditor );
ferror.clearAll( f );
f[ 0 ].checked = 1;
f[ 1 ].value   = '-1';
f[ 2 ].value   = '';
f[ 3 ].value   = '';
}
koolproxy.setup = function(xj) {
var f=xj.rules;
var vmsg = '';
$.each( xj, function(index, content){ 
	if(index.indexOf('hi') == 0 && content !=""){
		vmsg += '<li>'+content+'</li>';
		//alert( "item #" + index + " its value is: " + content ); 
	}
}); 
$('#msg').html(vmsg);

for(var p=0;p<f.length;p++){
	options_type.splice(2,0,[]);
	kprules.splice(2,0,[]);
	if(p==(f.length-1)){
	options_type.splice(2,0,[]);
	kprules.splice(2,0,[]);
	}
	for(var j=0;j<f[p].length;j++){
		if(j==0){
			kprules[p].splice(2,0,f[p][j]);
			options_type[p].splice(2,0,p);
		}else if(j==1){
			options_type[p].splice(2,0,f[p][0]);
			kprules[p].splice(2,0,f[p][j]);
		}else if(j==2){
			kprules[p].splice(2,0,p);
		}else{
			kprules[p].splice(2,0,f[p][j]);
		}
		
		if((p==f.length-1) && (j==3)){
		options_type[p+1].splice(2,0,'-1');
		options_type[p+1].splice(2,0,'自定义规则');
		kprules[p+1].splice(2,0,'自定义规则');
		kprules[p+1].splice(2,0,'');
		kprules[p+1].splice(2,0,'-1');
		kprules[p+1].splice(2,0,'');
		}
	}		
}
this.init( 'koolproxy-grid', '', 50, [
{ type: 'checkbox' },
{ type: 'select',maxlen:20,options:options_type,value:'-1'},
{ type: 'text', maxlen: 90 },
{ type: 'text', maxlen: 40 }
] );
this.headerSet( [ ' 状态', '规则类型','规则地址', '描述' ] );
var s = nvram.koolproxy_blacklist.split( '>' );
for ( var i = 0; i < s.length; ++i ) {
var t = s[ i ].split( '<' );
if ( t.length == 4 ) this.insertData( -1, t );
}
this.showNewEditor();
this.resetNewEditor();
}
function save() {
var data1      = koolproxy.getAllData();
var blacklist = '';
for ( var i = 0; i < data1.length; ++i ) {
	for(var j=0;j<kprules.length;j++){
		if(data1[i][1]==kprules[j][0]){
			data1[i][1] = kprules[j][3];
		}
	}
blacklist += data1[ i ].join( '<' ) + '>';
}
var data2      = koolproxyctrl.getAllData();
var ctrllist = '';
for ( var i = 0; i < data2.length; ++i ) {
ctrllist += data2[ i ].join( '<' ) + '>';
}
nvram.koolproxy_blacklist = blacklist;
nvram.koolproxy_ctrlist = ctrllist;
console.log("nvramdata",nvram);

}
// Initiate on full window load
$( window ).on( 'load', function() {
koolproxy.recolor();
koolproxyctrl.recolor();
verifyFields( null, 1 );
});
// 数据
nvram = {
	'koolproxy_blacklist': '1<-1<http://winhelp2002.mvps.org/hosts.txt<Hello>1<-1<http://adaway.org/hosts.txt<Fuck you>',
	'koolproxy_ctrlist': '1<192.168.1.27<D4:3D:7E:22:42:4E>1<192.168.2.1<3C:E5:A6:23:F5:45>',
	'koolproxy_status':'1',
	'koolproxy_mode':'',
	'koolproxy_update':'',
	'koolproxy_update_time':'',
	'koolproxy_restart':'',
	'koolproxy_restart_time':''
	
	};
	
function verifyFields( focused, quiet ) {
var ok = 1;
var c = E('_koolproxy_update').checked ? '1':'0';
var b = E('_koolproxy_update_time');
var d = E('_koolproxy_mode');
var e = E('_koolproxy_restart').checked ? '1':'0';
var f = E('_koolproxy_restart_time');
if(c =='1'){
PR(b).style.display='';
}else{
PR(b).style.display='none';
}
if(e =='1'){
PR(f).style.display='';
}else{
PR(f).style.display='none';
}
nvram.koolproxy_mode = d.value;
nvram.koolproxy_update = c;
nvram.koolproxy_update_time = b.value;
nvram.koolproxy_restart = e;
nvram.koolproxy_restart_time = f.value;
return ok;
}
</script>
<div class="box">
	<fieldset>
	<div class="heading">KoolProxy 基本设置</div>
	<button onclick="window.history.back();" class="btn backsoftcenter pull-right">返回 <i class="icon-cloud"></i></button>
	</fieldset>
	<div class="content">

		<label class="col-sm-9" style="margin-top:15px;">
			<ul id="msg">
			</ul>
		</label>
		<div class="col-sm-3">
			<p style="float:right;width:220px;">
				<button class="btn btn-success">更新规则 <i class="icon-cloud"></i></button>
				<button class="btn btn-primary">证书下载 <i class="icon-cloud"></i></button>
			</p>	
		</div>
		
	</div>	
</div>
​<ul class="nav nav-tabs">
		<li>
			<a href="javascript:tabSelect('app1');" id="app1-server1-jb-tab" class="active"><i class="icon-system"></i> 基本设置</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app2');" id="app2-server1-gz-tab"><i class="icon-globe"></i> 规则订阅</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app3');" id="app3-server1-kz-tab"><i class="icon-tools"></i> 访问控制</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app4');" id="app4-server1-zdy-tab"><i class="icon-wrench"></i> 自定义规则</a>
		</li>
		<li>
			<a href="javascript:tabSelect('app5');" id="app5-server1-rz-tab"><i class="icon-info"></i> 状态日志</a>
		</li>
	</ul>
		<div class="box boxr1">
			<div class="heading">基本设置</div>
			<div class="content">
				<div class="tabContent">
					<!--app info -->
					<fieldset>
						<label class="col-sm-3 control-left-label">开启Koolproxy</label>
						<div class="col-sm-9">
							<span class='tg-list-item'>
								<input class='tgl tgl-flat' id='koolproxy_open' type='checkbox'>
								<label class='tgl-btn' for='koolproxy_open'></label>
							</span>
						</div>
					</fieldset>
					<fieldset>
						<label class="col-sm-3 control-left-label">运行状态</label>
						<div class="col-sm-9 text-block">
							<span id='koolproxy_status'></span>
						</div>
					</fieldset>	
					<div id="kpsetting"></div><hr>
					<script type="text/javascript">
						$( '#kpsetting' ).forms( [
							{title: '过滤模式', name:'koolproxy_mode',type:'select',options:[['1','全局模式'],['2','IPSET模式']],value:nvram.koolproxy_mode },
							{title: '规则自动更新',name:'koolproxy_update',type:'checkbox',value:nvram.koolproxy_update},
							{title: '&nbsp;',name:'koolproxy_update_time',type:'select',options:[['1','每1小时'],['2','每2小时'],['4','每4小时'],['6','每6小时'],['8','每8小时'],['12','每12小时'],['24','每24小时'],['48','每48小时']],hidden:1,value: nvram.koolproxy_update_time},
							{title: '插件自动重启',name:'koolproxy_restart',type:'checkbox',value:nvram.koolproxy_restart},
							{title: '&nbsp;',name:'koolproxy_restart_time',type:'select',options:[['1','每12小时'],['2','每天']] ,hidden:1,value:nvram.koolproxy_restart_time || '1'}
						] );
					</script>
					</div>
					<!--app info -->
				</div>
			</div>
		</div>
		<div class="box boxr2">
			<div class="heading">规则订阅</div>
			<div class="content">
				<h4>Notes</h4>
				<div class="section" id="sesdiv_notes1">
					<ul>
						<li>订阅第三方规则（例如adblock, adbyby, chinalist, easylist等）会导致兼容性问题，请确保你订阅的第三方规则支持koolproxy！</li>
						<li>规则下拉菜单里提供了一些基础的koolproxy兼容规则，如果你想自己开发并共享为第三方规则，可以参考此规则书写语法。</li>
					</ul>
				</div>
				<br><hr>
				<div class="tabContent">
					<!--app info -->
					<table class="line-table" cellspacing=1 id="koolproxy-grid"></table>
					<!--<script type="text/javascript">koolproxy.setup()</script>-->
					<!--app info -->
				</div>
			</div>
		</div>
		<div class="box boxr3">
			<div class="heading">访问控制</div>
			<div class="content">
				<h4>Notes</h4>
				<div class="section" id="sesdiv_notes2">
					<ul>
						<li>过滤https站点需要为相应设备安装证书，并启用http + https过滤！</li>
						<li>在路由器下的设备，不管是电脑，还是移动设备，都可以在浏览器中输入<i><b>110.110.110.110</b></i>来下载证书。</i></li>
						<li>如果想在多台装有koolroxy的路由设备上使用一个证书，请用winscp软件备份/koolshare/koolproxy/data文件夹，并上传到另一台路由。</li>
					</ul>
				</div>
				<br><hr>
				<div class="tabContent">	
					<!--app info -->
					<table class="line-table" cellspacing=1 id="ctrl-grid"></table>
					<script type="text/javascript">koolproxyctrl.setup()</script>
					<!--app info -->
				</div>
			</div>
		</div>
		<div class="box boxr4">
			<div class="heading">自定义规则</div>
			<div class="content">
				<div class="tabContent">
					<!--app info -->
					<!--app info -->
				</div>
			</div>
		</div>
		<div class="box boxr5">
			<div class="heading">状态日志</div>
			<div class="content">
				<div class="tabContent">
					<!--app info -->
					<!--app info -->
				</div>
			</div>
		</div>
		<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">Save <i class="icon-check"></i></button>
		<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span>
</content>
