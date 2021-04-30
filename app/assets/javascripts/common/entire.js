window.onload = function () {
  $('#modal1').modal();
  $('.modal-action , .modal-trigger').click(function(e){
    e.preventDefault();
    if(!$('#modal1').hasClass('open')){
      $('#modal1').modal('open');
    }
  })
}
window.onpageshow = function(event) {
	if (event.persisted) {
		window.location.reload();
	}
}