var query = window.location.search.substring(1);

$.getJSON('http://tec-asamblea.herokuapp.com/api/asamblea/diputados.json', function(data) {
						        
						        for (var i in data) {
						        	if (  ('email=' + data[i].email) ==  query){

						        		localStorage.setItem("email_dipu", data[i].email );
						        		var partido = data[i].Partido;

						        		if(partido == "ACCIÓN CIUDADANA"){
						        			$("#bandera").attr("src","../images/pac.png");
						        		}
						        		if(partido == "ALIANZA DEMOCRÁTICA CRISTIANA"){
						        			$("#bandera").attr("src","../images/alianzademocratica.jpg");
						        		}
						        		if(partido == "FRENTE AMPLIO"){
						        			$("#bandera").attr("src","../images/frenteamplio.gif");
						        		}
						        		if(partido == "LIBERACIÓN NACIONAL"){
						        			$("#bandera").attr("src","../images/liberacion.png");
						        		}
						        		if(partido == "MOVIMIENTO LIBERTARIO"){
						        			$("#bandera").attr("src","../images/libertario.png");
						        		}
						        		if(partido == "RENOVACIÓN COSTARRICENSE"){
						        			$("#bandera").attr("src","../images/renovacion.png");
						        		}
						        		if(partido == "RESTAURACIÓN NACIONAL"){
						        			$("#bandera").attr("src","../images/restauracion.gif");
						        		}
						        		if(partido == "UNIDAD SOCIAL CRISTIANA"){
						        			$("#bandera").attr("src","../images/unidad.png");
						        		}
						        		if(partido == "ACCESIBILIDAD SIN EXCLUSIÓN"){
						        			$("#bandera").attr("src","../images/pase.jpg");
						        		}

						        		$( "#nombre" ).append( data[i].nombre);
						        		$( "#provincia" ).append( data[i].Provincia);
						        		$( "#mensaje" ).append( data[i].email);
						        		$( "#imagen").attr("src", ""  + data[i].UrlFoto );
						        	}
						            
						        }
						  });



function toast_proyectos() {

				var query = window.location.search.substring(1);
				var message = "Proyectos";
				$.getJSON('http://tec-asamblea.herokuapp.com/api/asamblea/diputados.json', function(data) {
						        
			        for (var i in data) {
			        	if (  ('email=' + data[i].email) ==  query){
			        		var message = data[i].texto_proyectos;
			        		var $toast = $('<div class="ui-loader ui-overlay-shadow ui-body-e ui-corner-all"><h6>' + message + '</h6></div>');

						    $toast.css({
						        display: 'block', 
						        background: '#fff',
						        opacity: 0.90, 
						        position: 'fixed',
						        padding: '7px',
						        'text-align': 'center',
						        width: '270px',
						        left: ($(window).width() - 284) / 2,
						        top: $(window).height() / 4 
						    });

						    var removeToast = function(){
						        $(this).remove();
						    };

						    $toast.click(removeToast);

						    $toast.appendTo($.mobile.pageContainer).delay(5000);
						    $toast.fadeOut(400, removeToast);
						        	}
			        }  
				});


			   
			}

function toast_comisiones() {

				var query = window.location.search.substring(1);
				var message = "Proyectos";
				$.getJSON('http://tec-asamblea.herokuapp.com/api/asamblea/diputados.json', function(data) {
						        
			        for (var i in data) {
			        	if (  ('email=' + data[i].email) ==  query){
			        		var message = data[i].texto_comisiones;
			        		var $toast = $('<div class="ui-loader ui-overlay-shadow ui-body-e ui-corner-all"><h6>' + message + '</h6></div>');

						    $toast.css({
						        display: 'block', 
						        background: '#fff',
						        opacity: 0.90, 
						        position: 'fixed',
						        padding: '7px',
						        'text-align': 'center',
						        width: '270px',
						        left: ($(window).width() - 284) / 2,
						        top: $(window).height() / 4 
						    });

						    var removeToast = function(){
						        $(this).remove();
						    };

						    $toast.click(removeToast);

						    $toast.appendTo($.mobile.pageContainer).delay(5000);
						    $toast.fadeOut(400, removeToast);
						        	}
			        }  
				});


			   
			}


function toast_biografia() {

				var query = window.location.search.substring(1);
				var message = "Proyectos";
				$.getJSON('http://tec-asamblea.herokuapp.com/api/asamblea/diputados.json', function(data) {
						        
			        for (var i in data) {
			        	if (  ('email=' + data[i].email) ==  query){
			        		var message = data[i].descripcion;
			        		var $toast = $('<div class="ui-loader ui-overlay-shadow ui-body-e ui-corner-all"><h6>' + message + '</h6></div>');

						    $toast.css({
						        display: 'block', 
						        background: '#fff',
						        opacity: 0.90, 
						        position: 'fixed',
						        padding: '7px',
						        'text-align': 'center',
						        width: '270px',
						        left: ($(window).width() - 284) / 2,
						        top: $(window).height() / 4 
						    });

						    var removeToast = function(){
						        $(this).remove();
						    };

						    $toast.click(removeToast);

						    $toast.appendTo($.mobile.pageContainer).delay(5000);
						    $toast.fadeOut(400, removeToast);
						        	}
			        }  
				});


			   
			}



