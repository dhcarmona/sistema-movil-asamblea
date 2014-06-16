function cargar(){

							jQuery("#imagen").attr('src', 'http://sismo.net16.net/asamblea/images/1402815070961.jpg.png');
							$( "#question" ).append( 'parlaaaaaaaaaaa');
							$( "#answer" ).append('parlaaaaaaaaaaa222222222222');
							
							var picture = getURLParameter('imagen');
							var quest = getURLParameter('pregunta');
							var answ = getURLParameter('respuesta');

							window.alert(picture);
							window.alert(quest);
							window.alert(answ);

}

function getURLParameter(name) {
							 return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
							}

