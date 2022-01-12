//---------------------------- 時計機能--------------------------------------
function set2fig(num) {
   // 桁数が1桁だったら先頭に0を加えて2桁に調整する
   var ret;
   if( num < 10 ) { ret = "0" + num; }
   else { ret = num; }
   return ret;
}
function showClock() {
   var nowTime = new Date();
   var nowHour = set2fig( nowTime.getHours() );
   var nowMin  = set2fig( nowTime.getMinutes() );
   var nowSec  = set2fig( nowTime.getSeconds() );
   var msg = nowHour + ":" + nowMin + ":" + nowSec;
   document.getElementById("RealtimeClockArea").innerHTML = msg;
}
// 1000ミリ秒＝1秒 100ミリ秒＝0.1秒
setInterval('showClock()',100);