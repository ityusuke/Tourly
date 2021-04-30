window.onload = function () {
  var map
  var geocoder
  var geos = []
  var spot_names = []
  var d
  var r
  var request
  
  $('.spot_item').find('.collapsible-header .spot_name').each(function(){
    spot_names.push($(this).text());
  })
  $('.spot_item').find('.hidden_area').each(function(){
    geos.push({x: $(this).find('.spot_x').text(), y: $(this).find('.spot_y').text()});
  })
  initMap();

  //////////////////////////
  //initMap
  //Mapを初期化する
  //////////////////////////
  function initMap() {
    geocoder = new google.maps.Geocoder()
    map = new google.maps.Map(document.getElementById('map'), {
      center: getCenterPosition(),
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      zoom: 12
    });
    drawRoute();
    redraw();
  }

  //////////////////////////
  //drawRoute
  //Google Map上にルートを描画する
  //////////////////////////
  function drawRoute() {
    //マーカーが2つ以上の場合のみルートを描画する
    if (geos.length < 2) {
      return false
    }
    d = new google.maps.DirectionsService(); // ルート検索オブジェクト
    r = new google.maps.DirectionsRenderer({ // ルート描画オブジェクト
      map: map, // 描画先の地図
      preserveViewport: true, // 描画後に中心点をずらさない
    });
    r.setOptions({
      suppressMarkers: true,
      draggable: true,
      polylineOptions: {
        strokeColor: '#ff0000',
        strokeOpacity: 1,
        strokeWeight: 3
      }
    })
    request = createRequset();
    d.route(request, function (result, status) {
      // OKの場合ルート描画
      if (status == google.maps.DirectionsStatus.OK) {
        r.setDirections(result);
        setDistanceToHtml(result)
      }
    });
  }

  //////////////////////////
  //createRequset
  //Directions APIへのリクエストを生成する
  //////////////////////////
  function createRequset() {
    //マーカーが3つ以上の場合のみ経由地点を追加する
    let origin_point = new google.maps.LatLng(geos[0].x, geos[0].y)
    let destination_point = new google.maps.LatLng(geos[geos.length - 1].x, geos[geos.length - 1].y)
    let waypoints_list = []
    if (geos.length > 2) {
      for (i = 1; i < geos.length - 1; i++) {
        waypoints_list.push({
          location: new google.maps.LatLng(geos[i].x, geos[i].y)
        });
      }
      var request = {
        origin: {
          location: origin_point
        }, // 出発地
        destination: destination_point, // 目的地
        waypoints: waypoints_list,
        travelMode: google.maps.DirectionsTravelMode.DRIVING, // 交通手段(歩行。DRIVINGの場合は車)
      };
    } else {
      var request = {
        origin: origin_point, // 出発地
        destination: destination_point, // 目的地
        travelMode: google.maps.DirectionsTravelMode.DRIVING, // 交通手段(歩行。DRIVINGの場合は車),
      };
    }
    return request;
  }

  //////////////////////////
  //setDistanceToHtml
  //Spot間の時間と距離を算出する
  //////////////////////////
  function setDistanceToHtml(result){
    let inner = $('.inner:not(:last)')
    let time_in = inner.find('.routeDistance');
    let routeTime = inner.find('.routeTime');
    let resultLegs = result.routes[0].legs;
    if (resultLegs.length){
      for(let m=0;m <= resultLegs.length-1;m++){
        let leg_distance = resultLegs[m].distance;
        let leg_duration = resultLegs[m].duration;
        $(time_in[m]).text(leg_distance.text);
        $(routeTime[m]).text(leg_duration.text);
      }
    }
  }

  //////////////////////////
  //redraw
  //Map初期化時のマーカー再描画
  //////////////////////////
  function redraw() {  
    for (let ix = 0; ix <= geos.length - 1; ix++) {
      geocoder.geocode({
        latLng: new google.maps.LatLng(geos[ix].x, geos[ix].y)
      }, function (results, status) {
        if (status == 'OK') {
          map.setCenter(getCenterPosition());
          var marker = createMaker(results, spot_names[ix]);
        } else {
          alert('該当する結果がありませんでした：' + status);
        }
      });
    }
  }

  //////////////////////////
  //createMaker
  //マーカー生成
  //////////////////////////
  function createMaker(results, inputAddress) {
    return new google.maps.Marker({
      map: map,
      position: results[0].geometry.location,
      icon: {
        fillColor: "blue",
        fillOpacity: 0.8,
        path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
        scale: 6,
        strokeColor: "blue",
        strokeWeight: 1.0
      },
      label: {
        text: inputAddress, //ラベル文字
        color: 'red', //文字の色
        fontSize: '16px', //文字のサイズ
        fontWeight: '600' //文字の太さ
      },
      animation: google.maps.Animation.DROP
    });
  }

  //////////////////////////
  //getCenterPosition
  //Mapの中心を設定する
  //////////////////////////
  function getCenterPosition(){
    if (!geos.length) {
      return new google.maps.LatLng(35.681382, 139.766084);
    } else {
      return new google.maps.LatLng(geos[geos.length - 1].x, geos[geos.length - 1].y);
    }
  }

  $('.collapsible').collapsible();
  $('.collapsible').collapsible('open', 0);
  $('.chip').click(function(){
    e.preventDefault();
    return false;
  })
}