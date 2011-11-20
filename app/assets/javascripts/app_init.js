$(document).ready(function() {
	$('.uso_modal').click(function(){
		$.ajax({
			url : $(this).attr('href'),
			dataType : 'html',
			success : function(html){
				$.blockUI({ message: html, title : '' });
			}
		});
		return false;
	});

	// We use a stylesheet for our modals. See jquery.modal.css
	$.blockUI.defaults.css = {};

});
