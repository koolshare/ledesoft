<title>软件中心 - 迅雷快鸟</title>
<content>
<script type="text/javascript">
//数据 -  绘制界面用 - 直接 声明一个 nvram 然后 post 到 sh 然后 由 sh 执行 存到 dbus
nvram = {
	'kuainiao_open':'1',
	'kuainiao_user':'admin@admin.com',
	'kuainiao_pass':'897hj6sd4f89e4thw5',
	'kuainiao_status':'2016-02-22 08:00:00',
	'kuainiao_speed':'100M',
	'kuainiao_onstart':'1',
	'kuainiao_waittime':'1',
	'kuainiao_nwan':'1'
};

function verifyFields(focused, quiet){
	return 1;
}
function save(){
	nvram.kuainiao_open = E('_aliddns_open').checked ? '1':'0';
	nvram.kuainiao_user = E('_aliddns_key').value;
	nvram.kuainiao_pass = E('_kuainiao_pass').value;
	nvram.kuainiao_onstart = E('_kuainiao_onstart').checked ? '1':'0';
	nvram.kuainiao_waittime = E('_kuainiao_waittime').value;
	nvram.kuainiao_nwan = E('_kuainiao_nwan').value;
}
</script>
<div class="box">
<div class="heading">迅雷快鸟加速</div>
<div class="content">
<div id="aliddns-fields"></div><hr>
<script type="text/javascript">
$('#aliddns-fields').forms([
{ title: '开启快鸟加速', name: 'kuainiao_open', type: 'checkbox', value: nvram.kuainiao_open ,suffix: nvram.kuainiao_version},
{ title: '迅雷账号', name: 'kuainiao_user', type: 'text', maxlen: 30, size: 30, value: nvram.kuainiao_user },
{ title: '密码', name: 'kuainiao_pass', type: 'password', maxlen: 30, size: 30, value: nvram.kuainiao_pass },
{ title: '运行状态', name: 'kuainiao_status', text: nvram.kuainiao_status },
{ title: '提速状态', name: 'kuainiao_speed', text: nvram.kuainiao_speed },
{ title: '开机启动', name: 'kuainiao_onstart', type: 'checkbox', value: nvram.kuainiao_onstart },
{ title: '启动延时', name: 'kuainiao_waittime', type: 'select', options:[['1','1S'],['5','5S'],['10','10S']], value: nvram.kuainiao_waittime || '1'},
{ title: '双WAN设置', name: 'kuainiao_nwan', type: 'select',options:[['1','WAN1'],['2','WAN2']],  value: nvram.kuainiao_nwan || '1' },
]);
</script>
<h4>Notes</h4>
<ul>
<li>Not all models support these options</li>
</ul>
</div>
</div>
<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">Save <i class="icon-check"></i></button>
<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">Cancel <i class="icon-cancel"></i></button>
<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span>
</form>
<script type="text/javascript">verifyFields(null, 1);</script>
</content>
