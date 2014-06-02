$(document).ready(function(){

	 $.getJSON('http://tec-asamblea.herokuapp.com/api/asamblea/diputados.json', function(data) {
						        var output='';
						        for (var i in data) {
						            output+='<li><a href="acura.html">' + data[i].nombre  +"</a></li>";
						        }
						        $( ".lista" ).append(output);
						      //  document.getElementById("placeholder").append(output);
						  });
				

			});