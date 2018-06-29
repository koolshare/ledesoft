<title>软件中心 - Ngrok</title>
<content>
<style type="text/css">
input[disabled]:hover{
    cursor:not-allowed;
}
</style>
<script type="text/javascript" src="/js/jquery.min.js"></script>
<script type="text/javascript" src="/js/tomato.js"></script>
<script type="text/javascript" src="/js/advancedtomato.js"></script>
<script>
AdvancedTomato();
getAppData();
var Apps;
function getAppData(){
var appsInfo;
	$.ajax({
	  	type: "GET",
	 	url: "/_api/ngrok_",
	  	dataType: "json",
	  	async:false,
	 	success: function(data){
	 	 	Apps = data.result[0];
	  	}
	});
}
var ngrok = new TomatoGrid();
ngrok.exist = function( f, v ) {
var data = this.getAllData();
for ( var i = 0; i < data.length; ++i ) {
if ( data[ i ][ f ] == v ) return true;
}
return false;
}
ngrok.dataToView = function( data ) {
	for(var i=0;i < data.length; i++){
		if(data[i]==''){
			alert('参数不能为空');
			return false;
		}
	}
return [ data[ 0 ] , data[ 1 ], data[ 2 ],data[3] ,data[4]];
}
ngrok.fieldValuesToData = function( row ) {
var f = fields.getAll( row );
return [ f[ 0 ].value, f[ 1 ].value, f[ 2 ].value ,f[3].value,f[4].value];
}
ngrok.verifyFields = function( row, quiet ) {
var ok = 1;
return ok;
}
ngrok.resetNewEditor = function() {
var f;
f = fields.getAll( this.newEditor );
ferror.clearAll( f );
f[ 0 ].value   = 'http';
f[ 1 ].value   = '';
f[ 2 ].value   = '';
f[ 3 ].value   = '';
f[ 4 ].value   = '';
}
ngrok.setup = function() {
this.init( 'ngrok-grid', '', 50, [
{ type: 'select' ,options:[['http','http'],['https','https'],['tcp','tcp']]},
{ type: 'text', maxlen: 90 },
{ type: 'text', maxlen: 40 },
{ type: 'text', maxlen: 90 },
{ type: 'text', maxlen: 90 }
] );
this.headerSet( [ '协议', '子域名', '内网地址' ,'内网端口','远程端口'] );
var s = Apps.ngrok_srlist.split( '>' );
for ( var i = 0; i < s.length; ++i ) {
	var t = s[ i ].split( '<' );
	if ( t.length == 5 ) this.insertData( -1, t );
}
this.showNewEditor();
this.resetNewEditor();
}

function save() {
var data      = ngrok.getAllData();
var ngrok_srlist = '';
for ( var i = 0; i < data.length; ++i ) {
ngrok_srlist += data[ i ].join( '<' ) + '>';
}
Apps.ngrok_enable = E('_ngrok_enable').checked ? '1':'0';
Apps.ngrok_server = E('_ngrok_server').value;
Apps.ngrok_prot = E('_ngrok_prot').value;
Apps.ngrok_user = E('_ngrok_user').value;
Apps.ngrok_auth = E('_ngrok_auth').value;
var ids = {
	"server":E('_ngrok_server').value,
	"port":parseInt(E('_ngrok_prot').value),
	"user":E('_ngrok_user').value, 
	"auth":E('_ngrok_auth').value
};

ids.tunnels = [];
var obj={};
var s = ngrok_srlist.split( '>' );
for ( var j = 0; j < s.length-1; ++j ) {
	var t = s[ j ].split( '<' );
	obj.proto = t[0];
	obj.subdomain = t[1];
	obj.localhost = t[2];
	obj.localport = parseInt(t[3]);
	obj.remoteport = parseInt(t[4]);
	ids.tunnels.push(obj);
}
Apps.ngrok_txt = JSON.stringify(ids);
Apps.ngrok_srlist = ngrok_srlist;
//-------------- post Apps to dbus ---------------
var id = 1 + Math.floor(Math.random() * 6);
var postData = {"id": id, "method":'ngrok_config.sh', "params":[], "fields": Apps};
var success = function(data) {
		//
	$('#footer-msg').text(data.result);
	$('#footer-msg').show();
	setTimeout("window.location.reload()", 3000);

		//  do someting here.
		//
};
var error = function(data) {
		//
		//  do someting here.
		//
};
$('#footer-msg').text('保存中……');
$('#footer-msg').show();
$('button').addClass('disabled');
$('button').prop('disabled', true);
$.ajax({
	type: "POST",
	url: "/_api/",
	data: JSON.stringify(postData),
	success: success,
	error: error,
	dataType: "json"
});
//-------------- post Apps to dbus ---------------

}

function verifyFields(focused, quiet){
	var ngrokenable = E('_ngrok_enable').checked ? '1':'0';
	if(ngrokenable == 0){
		$('input').prop('disabled', true);
		$(E('_ngrok_enable')).prop('disabled', false);
	}else{
		$('input').prop('disabled', false);
	}
	return 1;
}
</script>
<div class="box">
<div class="heading">内网穿透 Ngrok <a href="/#soft-center.asp" class="btn" style="float:right;border-radius:3px;margin-right:5px;margin-top:0px;">返回</a></div>
<br><hr>
<div class="content">
<div id="ngrok-fields"></div>
<script type="text/javascript">
$('#ngrok-fields').forms([
{ title: '开启Ngrok', name: 'ngrok_enable', type: 'checkbox', value: ((Apps.ngrok_enable == '1')? 1:0)},
{ title: '服务器', name: 'ngrok_server', type:'text', maxlen: 20, size: 20,value: Apps.ngrok_server},
{ title: '端口', name: 'ngrok_prot', type: 'text', maxlen: 5, size: 5, value: Apps.ngrok_prot },
{ title: '用户ID', name: 'ngrok_user', type: 'text', maxlen: 30, size: 30, value: Apps.ngrok_user },
{ title: '认证ID', name: 'ngrok_auth', type: 'text', maxlen: 30, size: 30, value: Apps.ngrok_auth }
]);
</script>
</div>
</div>
<div class="box">
<div class="content">
<h4>穿透主机列表</h4>
<table class="line-table" cellspacing=1 id="ngrok-grid"></table>
<script type="text/javascript">ngrok.setup();</script>
<br><hr>

</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">保存 <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">取消 <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="display: none;"></span>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
