// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require nested_form_fields
//= require_tree .

$(function() {
  $(window).load(function(){
  // initializeでマーカーの無い地図を描画、クリックでマーカーをたてたところの緯度経度を取得し始点にしたい
  // ページを更新しないと地図が表示されないエラーを解決したい
  let startLatLng = [35.712408, 139.776188]; // 始点
  let targetLatLng = [35.710552, 139.777024]; // 終点
  let goalMarkerImg = 'https://82mou.github.io/src/images/marker-on-dummy.png';
  let map;
  
  function initialize() {
    // 地図のオプション、マップ描画時に参照
    let options = {
      zoom: 16,
      center: new google.maps.LatLng(startLatLng[0], startLatLng[1]),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    // 　地図の描画
    map = new google.maps.Map(document.getElementById('map_canvas'), options);
    // 地図描画のオプション、directionsDisplay定義時に参照
    let rendererOptions = {
      map: map, 
      draggable: true,
      preserveViewport: true 
    };
    // DirectionsRendererでルート検索結果表示用のオブジェクトを生成
    let directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);
    let directionsService = new google.maps.DirectionsService();
    directionsDisplay.setMap(map);
    // 経路描画時に参照される　始点と終点の定義
    let request = {
      //  ユーザーが始点を指定するまでは、ピンや経路は非表示にしたい
      //  (root_search===0) の場合、request=null
      // (root_search===1)の場合 、request!=nullにする
      //  フォームで「経路検索」ボタンを押した時、root_searchの値を変更する
      origin: new google.maps.LatLng(startLatLng[0], startLatLng[1]),
      destination: new google.maps.LatLng(targetLatLng[0], targetLatLng[1]), 
      travelMode: google.maps.DirectionsTravelMode.WALKING, 
    };
    // 経路描画　
    directionsService.route(request, function(response,status) {
      // response = 検索結果,status = 検索可否　google.maps.DirectionsStatus.OK = 検索成功
      if (status === google.maps.DirectionsStatus.OK) {
        new google.maps.DirectionsRenderer({
          map: map,
          directions: response,
          suppressMarkers: false 
        });
        let leg = response.routes[0].legs[0];
        makeMarker(leg.end_location, markers.goalMarker, map);
        setTimeout(function() {
          map.setZoom(16); 
        });
      }
    });
  }
  
  
  initialize();
  
  function makeMarker(position, icon, map) {
    let marker = new google.maps.Marker({
      position: position,
      map: map,
      icon: icon
    });
    }


  let markers = {
    goalMarker: new google.maps.MarkerImage(
      goalMarkerImg, // 画像のパス
      new google.maps.Size(24, 33), // マーカーのwidth,height
      new google.maps.Point(0, 0), // 画像データの中で、どの部分を起点として表示させるか
      new google.maps.Point(12, 33), // マーカーのpositionで与えられる緯度経度を画像のどの点にするか
      new google.maps.Size(24, 33)) // 画像の大きさを拡大縮小
  }

    

    
    map.addListener('click',function(e){
      var click_marker = new google.maps.Marker({
        position: e.latLng,
        map: map,
        animation: google.maps.Animation.DROP
      });
    });
    
  }); 
});
