
	 $.getJSON('http://tec-asamblea.herokuapp.com/api/asamblea/diputados_por_partido.json?partido=LIBERACI%C3%93N%20NACIONAL', function(data) {
						        var output='';
						        for (var i in data) {
						            output+='<li ><img src="' + data[i].UrlFoto + '" Align="left" width="35" height="42"><a rel="external" href="perfil_diputado.html?email=' + data[i].email + '">' + data[i].nombre  +"</a></li>";
						        }
						        $( ".lista" ).append(output).listview('refresh');
						      
						  });
				