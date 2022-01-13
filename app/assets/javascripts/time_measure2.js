(function(){

const call_function_each = 100 //時刻を計算するメソッド呼び出すミリ秒を指定（0.1秒ごとに呼び出し）

let state = 0; //ボタンの状態を表す。初期は0。スタートを押すと1にする。ストップを押すと2になる。リセットを押さない限り1と2でループ。

let total_time = 0;//今までの累積時間

let started_at = 0; //startを押したときのDate型のデータ
let ended_at = 0; //startを押したときのDate型のデータ


//秒分時の値をそれぞれ格納
let hour_time = 0;
let min_time = 0;
let sec_time = 0;


//localStorageにどちらの値もない場合は処理する必要ないので始めに条件分岐
if(localStorage.getItem('started_at')){
  //ページ読み込みされたときに自動で行われる処理
  //window.addEventListener("load",function()へ変更。window.onload = function()から
  window.addEventListener("load",function(){
    state = 1;
    toggle();
  })
}

if(localStorage.getItem('working_on') && !localStorage.getItem('started_at')){
  window.addEventListener("load",function(){
    state = 2;
    //以下のコードで経過時刻を取得
    total_time  = Number(localStorage.getItem('working_on'));

    //時分秒に治す
    hour_time = Math.floor(total_time/3600);
    min_time  = Math.floor((total_time%3600)/60);
    sec_time  = Math.floor((total_time%3600)%60);

    //以下のコードで経過時刻を表示
    display();
    //ボタンの切り替え
    toggle();
  })
}

//新しいスタートストップの切り替え
swich.click(function(){
  if(state === 0){
    state = 1; //スタート押したのでボタンきりかえる
    started_at = new Date(); //現在時刻
    localStorage.setItem('started_at', started_at);
    count = setInterval(counter, call_function_each);
    lap_count = setInterval(lapcounter, call_function_each);
    toggle();
  }else if(state === 1){
    state = 2;
    working_on += (new Date() - started_at)/1000; //まえのwarkin_onと更新した時間を足す
    localStorage.setItem('working_on', working_on);
    localStorage.removeItem('started_at');
    clearInterval(count);
    clearInterval(lap_count);
    toggle();
  }else{
    state = 1; //
    started_at = new Date(); //現在時刻
    localStorage.setItem('started_at', started_at);
    count = setInterval(counter, call_function_each);
    lap_count = setInterval(lapcounter, call_function_each);
    toggle();
  }
})

//resetボタンが押された時の処理
reset.click(function(){
  state = 0; //ボタンを初期化
  toggle();
  //lap機能の初期化
  $('#lap-field').text('');//これでは１度リセットを押すと、再読み込みをしない限りlapが表示されなくなる
  lap_number = 1;
  lap_time = 0;
  lap_time_ago = 0;
  working_on = 0;
  //lap_counterも初期化
  $('#lap_hour').html("00");
  $('#lap_min').html("00");
  $('#lap_sec').html("00");


  localStorage.clear(); //localStorageの値をすべて初期化

  hour_time = 0;
  min_time = 0;
  $('#hour').html("00");
  $('#min').html("00");
  $('#sec').html("00");

});

//lapボタンが押されたときの処理
lap.click(function(){
  //ここにラップの処理
  //time = hour_time*3600 + min_time*60 + sec_time //計測時間を小数点を除いて時分秒を秒に変換！
  lap_time = total_time - lap_time_ago;//lapの算出.
  lap_calculate();
  $('#lap-field').append(`<p>Lap No.${lap_number}-----${("0" + Math.floor(lap_hour)).slice(-2)} : ${("0" + Math.floor(lap_min)).slice(-2)} : ${("0" + Math.floor(lap_sec)).slice(-2)}</p>`);
  lap_time_ago = lap_time + lap_time_ago;
  lap_number ++;
  $('#look-state').append(`<p>total_time:${total_time},lap_time:${lap_time},lap_hour:${lap_hour},lap_min:${lap_min},lap_sec:${lap_sec}</p>`);

})

//時刻計算新しいばーしょん
function lap_calculate(){
  lap_hour = lap_time /3600;
  lap_min  = (lap_time %3600)/60;
  lap_sec  = ((lap_time %3600)%60);
}


function lapcounter(){
  if(localStorage.getItem('started_at')){
    var now2 = localStorage.getItem('started_at');
    started_at = Date.parse(now2);
  }

  if(localStorage.getItem('working_on')){
    var mid2 = localStorage.getItem('working_on');
    working_on = Number(mid2);
  }

  //合計計測時間を算出
  lap_total_time = working_on + ((new Date() - started_at)/1000) - lap_time_ago;//秒単位で計算
  //時分秒に治す
  lap_hour_time = Math.floor(lap_total_time/3600);
  lap_min_time  = Math.floor((lap_total_time%3600)/60);
  lap_sec_time  = Math.floor((lap_total_time%3600)%60);

  //上で計算した値を関数に用いて時刻の表示
  $('#lap_sec').text(("00" + lap_sec_time).slice(-2));
  $('#lap_min').text(("00" + lap_min_time).slice(-2));
  $('#lap_hour').text(("00" + lap_hour_time).slice(-2));

}




//時間の計算
function counter(){
  if(localStorage.getItem('started_at')){
    var now2 = localStorage.getItem('started_at');
    started_at = Date.parse(now2);
  }

  if(localStorage.getItem('working_on')){
    var mid2 = localStorage.getItem('working_on');
    working_on = Number(mid2);
  }

  //合計計測時間を算出
  total_time = working_on + ((new Date() - started_at)/1000);//秒単位で計算
  //時分秒に治す
  hour_time = Math.floor(total_time/3600);
  min_time  = Math.floor((total_time%3600)/60);
  sec_time  = Math.floor((total_time%3600)%60);

  //上で計算した値を関数に用いて時刻の表示
  display();

}

//時刻の表示
function display(){
  $('#sec').text(("00" + sec_time).slice(-2));
  $('#min').text(("00" + min_time).slice(-2));
  $('#hour').text(("00" + hour_time).slice(-2));
}

//ボタンの切り替え　新しいバージョン
function toggle(){
  if(state === 0){
    reset.prop("disabled",true);
    swich.prop("disabled",false);
    lap.prop("disabled",true);
    swich.prop("value","Start");
  }else if(state === 1){
    reset.prop("disabled",true);
    swich.prop("disabled",false);
    lap.prop("disabled",false);
    swich.prop("value","Stop");
  }else{
    reset.prop("disabled",false);
    swich.prop("disabled",false);
    lap.prop("disabled",false);
    swich.prop("value","Start");
  }
}


})();