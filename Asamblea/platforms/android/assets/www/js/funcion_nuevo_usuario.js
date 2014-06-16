 function nuevo_usuario(){

	var name = $("#name").val();
	var email = $("#email").val();
	var pass = $("#pass").val();

	var string = 'http://tec-asamblea.herokuapp.com/api/asamblea/crear_usuario?nombre=' + name + '&email=' + email + '&password=' + pass + '&password_confirmation=' + pass;
	//			  http://tec-asamblea.herokuapp.com/api/asamblea/crear_usuario?nombre=Usuario1&email=an@a.com&password=123456&password_confirmation=123456
	//window.alert(string);

	$.getJSON(string, function(data) {

						        var texto = data.respuesta;
						        if (texto=='Usuario creado'){
						        	toast('Usuario Creado. Ahora puede iniciar sesión');
						        	setTimeout(function (){
						        		window.location='../pages/log_in.html';	
							            
							         }, 2000);	
						        				     
							        return true;
							        				        	
						        }

						        else{
						        	toast('Usuario no creado, intente de nuevo');
						        }
						      
						  });
	
}

function toast(message) {
    var $toast = $('<div class="ui-loader ui-overlay-shadow ui-body-e ui-corner-all"><h3>' + message + '</h3></div>');

    $toast.css({
        display: 'block', 
        background: '#fff',
        opacity: 0.90, 
        position: 'fixed',
        padding: '7px',
        'text-align': 'center',
        width: '270px',
        left: ($(window).width() - 284) / 2,
        top: $(window).height() / 2 - 20
    });

    var removeToast = function(){
        $(this).remove();
    };

    $toast.click(removeToast);

    $toast.appendTo($.mobile.pageContainer).delay(2000);
    $toast.fadeOut(400, removeToast);
}