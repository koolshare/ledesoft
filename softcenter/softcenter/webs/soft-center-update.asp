<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>软件中心升级中</title>
<link rel="shortcut icon" href="favicon.ico">
<style type="text/css">
@-webkit-keyframes title{0%{opacity:0;right:130px;}48%{opacity:0;right:130px;}52%{opacity:1;right:30px;}70%{opacity:1;right:30px;}100%{opacity:0;right:30px;}}@-moz-keyframes title{0%{opacity:0;right:130px;}48%{opacity:0;right:130px;}52%{opacity:1;right:30px;}70%{opacity:1;right:30px;}100%{opacity:0;right:30px;}}@-webkit-keyframes fade{0%{opacity:1;}100%{opacity:0;}}@-moz-keyframes fade{0%{opacity:1;}100%{opacity:0;}}@-webkit-keyframes bg{0%{background-color:#306f99;}50%{background-color:#19470f;}90%{background-color:#734a10;}}@-moz-keyframes bg{0%{background-color:#306f99;}50%{background-color:#19470f;}90%{background-color:#734a10;}}@-webkit-keyframes blink{0%{opacity:0;}5%{opacity:1;}10%{opacity:0;}15%{opacity:1;}20%{opacity:0;}25%{opacity:1;}30%{opacity:0;}35%{opacity:1;}40%{opacity:0;right:-21px;}45%{opacity:1;right:80px;}50%{opacity:0;right:-21px;}51%{right:-21px;}55%{opacity:1;}60%{opacity:0;}65%{opacity:1;}70%{opacity:0;}75%{opacity:1;}80%{opacity:0;}85%{opacity:1;}90%{opacity:0;right:-21px;}95%{opacity:1;right:80px;}96%{right:-21px;}100%{opacity:0;right:-21px;}}@-moz-keyframes blink{0%{opacity:0;}5%{opacity:1;}10%{opacity:0;}15%{opacity:1;}20%{opacity:0;}25%{opacity:1;}30%{opacity:0;}35%{opacity:1;}40%{opacity:0;right:-21px;}45%{opacity:1;right:80px;}50%{opacity:0;right:-21px;}51%{right:-21px;}55%{opacity:1;}60%{opacity:0;}65%{opacity:1;}70%{opacity:0;}75%{opacity:1;}80%{opacity:0;}85%{opacity:1;}90%{opacity:0;right:-21px;}95%{opacity:1;right:80px;}96%{right:-21px;}100%{opacity:0;right:-21px;}}body{font-family:arial;background:black;color:#eaf7ff;}.wrap{position:absolute;top:50%;left:50%;margin-left:-80px;margin-top:-40px;}.bg{padding:30px 30px 30px 0;background:#306f99;-moz-animation:bg 1.5s linear infinite;-webkit-animation:bg 1.5s linear infinite;animation:bg 1.5s linear infinite;-moz-box-shadow:inset 0 0 45px 30px black;-webkit-box-shadow:inset 0 0 45px 30px black;box-shadow:inset 0 0 45px 30px black;}.loading{position:relative;text-align:right;text-shadow:0 0 6px #bce4ff;height:20px;width:200px;}.loading span{display:block;text-transform:uppercase;position:absolute;right:30px;height:20px;width:200px;line-height:20px;}.loading span:after{content:"";display:block;position:absolute;top:-2px;right:-21px;height:20px;width:16px;background:#eaf7ff;-moz-box-shadow:0 0 15px #bce4ff;-webkit-box-shadow:0 0 15px #bce4ff;box-shadow:0 0 15px #bce4ff;-moz-animation:blink 3.4s infinite;-webkit-animation:blink 3.4s infinite;animation:blink 3.4s infinite;}.loading span.title{-moz-animation:title 3.4s linear infinite;-webkit-animation:title 3.4s linear infinite;animation:title 3.4s linear infinite;}.loading span.text{-moz-animation:title 3.4s linear 1.7s infinite;-webkit-animation:title 3.4s linear 1.7s infinite;animation:title 3.4s linear 1.7s infinite;opacity:0;}
</style>
</head>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript">
Countdown();
var timer =0;
function Countdown() {
    if (timer <= 60) {
        timer++;
		$('.text').html('loading '+Math.round(timer/60*100.00)+'%');
    }
	if(timer==61){
		window.history.go(-1);  
	}
	setTimeout(function() {
            Countdown();
        }, 1000);
}
</script>
<body>
<div class="wrap">
  <div class="bg">
    <div class="loading">
      <span class="title">soft updating</span>
	  <span class="text"></span>
    </div>
  </div>
</div>
<div style="text-align:center;clear:both;">
</div>
</body>
</html>
