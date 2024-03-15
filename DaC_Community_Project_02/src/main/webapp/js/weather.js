/**
 * 
 */
      //weather
      var url = 'http://api.openweathermap.org/data/2.5/weather?q=seoul&APPID=ef7e4754ad9e63a695df556b89943155';
      var loadImg = $('#load_img');
  
      loadImg.show();
  
      $.getJSON(url, function(data) {
  
          var sys = data.sys; // 국가명, 일출/일몰
          var city = data.name; // 도시명
          var weather = data.weather; //날씨 객체
          var main = data.main; // 온도, 기압 관련 객체
  
          var wmain = weather[0].main; // 구름상태
          var wId = weather[0].id; // 날씨 상태 id 코드
          var icon = weather[0].icon; // 날씨 아이콘
          var country = sys.country; // 국가명
          var temp = main.temp; // 현재온도
          var tempMin = main.temp_min; // 최저 온도
          var tempMax = main.temp_max; // 최고 온도
          // 온도는 국제단위인 켈빈값이여서 -273.15를 빼줘서 섭씨로 바꿈
  
          var iconUrl = 'http://openweathermap.org/img/w/' + icon;
  
          var wrap = $('#weather_info');
  
          wrap.find('.city').html(city + '/' + country);
          wrap.find('.icon').html('<img src=" ' + iconUrl + '.png ">');
          wrap.find('.w_id').html(wmain);
          wrap.find('.temp_min').html(parseInt(tempMin - 273.15) + '&deg;'+ "&nbsp");
          wrap.find('.temp_max').html(parseInt(tempMax - 273.15) + '&deg;'+ "&nbsp");
          wrap.find('.temp').html(parseInt(temp - 273.15) + '&deg;'+ "&nbsp");
          loadImg.hide();
  
      })
      .fail(function() {
          alert('loading error!');
      });