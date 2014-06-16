
	var correo = localStorage.getItem("email_dipu");
	var cadena = "http://tec-asamblea.herokuapp.com/api/asamblea/preguntas_diputado.json?email=" + correo;
	$.getJSON(cadena, function(data) {
						        var output='';
						        for (var i in data) {
						            output+='<li ><a rel="external" href="perfil_pregunta.html?imagen=' + data[i].url_foto + '&pregunta=' +  data[i].pregunta + '&respuesta=' + data[i].respuesta + '"><img src="' + data[i].url_foto + '" height="600" width="600"/><h2>' + data[i].pregunta + '</h2><p>' + data[i].respuesta + '</p></a></li>';		            
						        }
						        $( "#lista" ).append(output).listview('refresh');
						      
						  });
				