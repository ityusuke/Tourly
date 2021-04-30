window.onload = function () {
  $('.range-group').each(function() {
    for (var i = 0; i < 5; i ++) {
      $(this).append('<a>');
    }
  }); 
  $('.range-group>a').eq(-5).click();
  $('.range-group>a').on('click', function() {
    var index = $(this).index()-1;
    $(this).siblings().removeClass('on');
    for (var i = 0; i < index; i++) {
        $(this).parent().find('a').eq(i).addClass('on'); 
    }
    $(this).parent().find('.input-range').attr('value', index);
  });
  $('.modal').modal();
  function modalClose(){
    $('.modal').modal('close');
  }
}