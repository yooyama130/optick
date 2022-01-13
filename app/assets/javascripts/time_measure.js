function set2fig(num) {
   // 桁数が1桁だったら先頭に0を加えて2桁に調整する
   var ret;
   if( num < 10 ) { ret = "0" + num; }
   else { ret = num; }
   return ret;
}

function msgYearMonthDateTime() {
   var nowYMDT = new Date();
   var nowYear = nowYMDT.getFullYear();
   var nowMonth = nowYMDT.getMonth() + 1;
   var nowDate = nowYMDT.getDate();
   var nowHour = set2fig( nowYMDT.getHours() );
   var nowMin  = set2fig( nowYMDT.getMinutes() );
   var nowSec  = set2fig( nowYMDT.getSeconds() );
   var msg = nowYear + '年'+ nowMonth + '月'+ nowDate + '日'+ nowHour + "時" + nowMin + "分" + nowSec + "秒";
   return msg;
}

//------------- 開始ボタン
document.getElementById("start_button").onclick = function() {
   var msg = msgYearMonthDateTime();
   // 日付時間を、sessionStorageにセット
   sessionStorage.setItem('start_date', new Date());
   var start = msg +'に開始しました';
   document.getElementById("msgTimeMeasure").innerHTML = start;
//    .ajax({
//     url: '/games/new',
//     type: 'GET',
//     dataType: 'html',
//     async: true,
//     data: {
//       start_time: time,
//     },
//  });
};

//------------- 終了ボタン
document.getElementById("end_button").onclick = function() {
   var msg = msgYearMonthDateTime();
   // 日付時間を、sessionStorageにセット
   sessionStorage.setItem('end_date', new Date());
   var end = msg +'に終了しました';
   document.getElementById("msgTimeMeasure").innerHTML = end;
//    .ajax({
//     url: '/games/new',
//     type: 'GET',
//     dataType: 'html',
//     async: true,
//     data: {
//       start_time: time,
//     },
//  });
};