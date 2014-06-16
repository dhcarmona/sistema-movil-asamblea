 function ingresar(){

	var email = $("#email").val();
	var pass = $("#pass").val();


	var string = 'http://tec-asamblea.herokuapp.com/api/asamblea/log_in?email=' + email + '&password=' + pass;
				  
	$.getJSON(string, function(data) {

						        var texto = data.respuesta;
						        var titular = data.nombre;
						       
						        if (texto==''){
						        	toast('Usuario o contraseña invalida');		        	
						        }

						        else{
						        	
						        	toast('Bienvenido');
						        	localStorage.setItem("nombre", titular);
						        	localStorage.setItem("email", email);
						        	localStorage.setItem("token", texto);
						        	setTimeout(function (){
						        		window.location='../pages/log_in_sesion_iniciada.html';
							             //$(location).attr('href','../pages/log_in_sesion_iniciada.html'); 
							         }, 2000);	
						        	
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

function pre_log_in(){

	var token = localStorage.getItem("token");	
  	if (token != ""){
  		 $(location).attr('href','../pages/log_in_sesion_iniciada.html'); 
  	}

}

function cerrar_sesion(){

	localStorage.setItem("nombre", '');
	localStorage.setItem("email", '');
	localStorage.setItem("token", '');
	$(location).attr('href','../pages/log_in.html'); 
  				      				
}