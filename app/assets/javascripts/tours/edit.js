window.onload = function () {
  var map
  var geocoder
  var geos = []
  var spot_names = []
  var d
  var r
  var request

  $('.inner').find('.tour_spots_spotname input').each(function(){
    spot_names.push($(this).val());
  })
  $('.inner').find('.edit_latlng').each(function(){
    geos.push({x: $(this).find('.x_lat').val(), y: $(this).find('.y_lat').val()});
  })

  initMap();
  

  //////////////////////////
  //initMap
  //Mapを初期化する
  //////////////////////////
  function initMap() {
    geocoder = new google.maps.Geocoder()
    let center;
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
  //searchPlace
  //Google Mapの検索処理を行う
  //////////////////////////
  $(document).on('click','.searchMaps',function searchPlace() {
    let spot = $(this).parents('.spots_section');
    let inputAddress = spot.find('.tour_spots_spotname input').val();
    geocoder.geocode({
      'address': inputAddress
    }, function (results, status) {
      if (status == 'OK') {
        var marker = createMaker(results, inputAddress);
        setParamsToHidden(spot, results, marker, inputAddress);
        map.setCenter(getCenterPosition());
        if (geos.length >= 2) {
          initMap();
          redraw();
        }
      } else {
      }
    });
  })

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
  //////////////////////////
  //setParamsToHidden
  //パラメータの設定
  //////////////////////////
  function setParamsToHidden(spot, results, marker, inputAddress) {
    let location = results[0].geometry.location;
    let lat = location.lat();
    let lng = location.lng();
    spot.find(".x_lat").val(lat);
    spot.find(".y_lat").val(lng);
    geos.push({
      "x": lat,
      "y": lng
    });
    spot_names.push(inputAddress);
  }

  //////////////////////////
  //deleteMakers
  //Google Map上の全マーカーを削除する
  //////////////////////////
  $(document).on('click','#edit_delete_pins',function deleteMakers() {
    //生成済マーカーを順次すべて削除する
    map = new google.maps.Map(document.getElementById('map'), {
      center: new google.maps.LatLng(35.681382, 139.766084),
      zoom: 12
    });
    $(".x_lat").each(function () {
      $(this).val('');
    })
    $(".y_lat").each(function () {
      $(this).val('');
    })
    geos = [];
    spot_names = [];
    $('.spots_section').find(".tour_spots_spotname input").each(function () {
      $(this).val('');
    })
    let inner = $('.inner')
    let dist_in = inner.find('.distance_input');
    dist_in.each(function(){
      $(this).find('span').each(function(){
        $(this).text('-');
      })
    })
  })

  //////////////////////////
  //Mateliarizeの各種設定
  //////////////////////////
  $('.tooltipped').tooltip({delay: 50});
  $('#input_chip').removeClass('chips-placeholder');
  $('#input_chip').addClass('chips-initial');
  let chips_array = [];
  let tags_array = $('.tour_tags').val().split(',');
  tags_array.map(function(item){
    chips_array.push({tag:item});
  })
  $('.chips-initial').material_chip({
    data: chips_array,
  });

  //評価入力欄の制御
  $('.range-group').each(function() {
    for (var i = 0; i < 5; i ++) {
      $(this).append('<a>');
    }
  }); 
  $('.range-group>a').on('click', function() {
    var index = $(this).index()-1;
    $(this).siblings().removeClass('on');
    for (var i = 0; i < index; i++) {
        $(this).parent().find('a').eq(i).addClass('on'); 
    }
    $(this).parent().find('.input-range').attr('value', index);
  });
  $('.range-group').each(function(){
    let evaluate = Number($('.range-group').find('input').val());
    $(this).find('a').eq(evaluate-1).click();
  })


  //submit時の設定
  $('#smtbtn').attr('type','button')
  $('#smtbtn').on('click', function() {
    try {
      let tags_text
      $('.chips').find('.chip').each(function(){
        tags_text += ($(this).text()+ ",");
      })
      let tags = tags_text.replaceAll('close','').replaceAll('undefined','');
      if(tags.slice(-1) === ","){
        tags = tags.slice(0,-1);
      } 
      $('.tour_tags').val(tags);
    } catch {
      return false;
    }finally{
    $('#smtbtn').attr('type','submit')
    $('#smtbtn').click();
    }
  });
}