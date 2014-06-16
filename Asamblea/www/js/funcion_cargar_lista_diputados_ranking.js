	  function Actualizar(){

		  var tipo = localStorage.getItem('busqueda_avanzada_tipo');  // proyectos - asistencia 
		  var sexo = localStorage.getItem('busqueda_avanzada_sexo');  // F - M - 

		  if (tipo == "proyectos"){
		  		 var url = "http://tec-asamblea.herokuapp.com/api/asamblea/busqueda_proyectos.json?sexo=" + sexo;
		  }

		  else {
		  		 var url = "http://tec-asamblea.herokuapp.com/api/asamblea/busqueda_asistencias.json?sexo=" + sexo;

		  }
		

		 $.getJSON(url, function(data) {

		 								var lfckv = document.getElementById("lifecheck").checked;
			 							if (lfckv != false){
			 									data= data.reverse();

			 							}

								        var output='';
								        for (var i in data) {
								            if(tipo == "proyectos"){
								            output+='<li href="perfil_diputado.html?email=' + data[i].email + '"><img src="' + data[i].UrlFoto + '" Align="left" width="39" height="58"><a rel="external" href="perfil_diputado.html?email=' + data[i].email + '"><center>' + data[i].nombre  +"</center></a> <center>" + data[i].cantidad_proyectos  + " proyectos</center></li>";
								        	}

								        	else{
								            output+='<li href="perfil_diputado.html?email=' + data[i].email + '"><img src="' + data[i].UrlFoto + '" Align="left" width="39" height="58"><a rel="external" href="perfil_diputado.html?email=' + data[i].email + '"><center>' + data[i].nombre  +"</center></a>  <center>Asistencia: " + data[i].cantidad_asistencias  + " días</center></li>";
								        	}
								        }
								        $( ".lista" ).empty().append(output).listview('refresh');
							    
							    								      
							  });

	 }

	 function Asistencia(){
	 	localStorage.setItem("busqueda_avanzada_tipo", 'asistencia');
	 	Actualizar();
	 }

	 function Proyectos(){
	 	localStorage.setItem("busqueda_avanzada_tipo", 'proyectos');
	 	Actualizar();
	 }

	 function Hombres(){
		localStorage.setItem("busqueda_avanzada_sexo", 'M');
		Actualizar();
	 }

	 function Mujeres(){
		localStorage.setItem("busqueda_avanzada_sexo", 'F');
		Actualizar();
	 }

	 function Todos(){
		localStorage.setItem("busqueda_avanzada_sexo", '');
		Actualizar();
	 }

	 function Mayor_menor(){
	 	Actualizar();
	 }
				