require 'rubygems'
require 'watir'
require 'nokogiri'
require 'open-uri'
require 'pdf/reader'
require "i18n"
require 'rest_client'
require 'net/http'

class AsambleaScrapper

def initialize
end

def ObtenerDatosTextoDiputado(link_diputado)
	browser = Watir::Browser.start link_diputado
	sleep 3
	page_html = Nokogiri::HTML.parse(browser.html)
	res = {}
	comision = {}
	#scrapping de la informacion personal del diputado
	info_personal = {}
	page_html.xpath('//table/tbody/tr/td[@class="ms-descriptiontext ms-alignleft"]').each_with_index do |row,index|
		puts row.text()
	end
	en_comisiones = false
	contador_comisiones = 0 #lleva el indice para las comisiones
	contador_comision = 0 #contador para saber el tipo de dato
	en_proyectos = false
	contador_proyectos = 0
	en_acuerdos = false
	contador_acuerdos = 0
	comisiones = {}
	info_fracc = {}
	page_html.xpath('//table[@id="BdwpRows"]/tbody/tr/td[@class="ms-vb"]').each_with_index do |row,index|
		puts row.text()
	end #each
	

end #funcion

def ObtenerDatosDiputado(link_diputado)
	browser = Watir::Browser.start link_diputado
	sleep 4
	page_html = Nokogiri::HTML.parse(browser.html)
	browser.close
	res = {}
	res_final = {}
	comision = {}
	contador_comisiones = 0 #lleva el indice para las comisiones
	contador_comision = 0 #contador para saber el tipo de dato
	comisiones = {}
	res_final['texto_comisiones'] = ""
	info_fracc = {}
	info_personal = {}
	res_final['texto_proyectos'] = ""
	proyecto = {}
	proyectos = {}
	contador_proyecto = 0
	contador_proyectos = 0

	
	#scrapping de la informacion personal del diputado
	
	page_html.xpath('//table/tbody/tr/td[@class="ms-descriptiontext ms-alignleft"]').each_with_index do |row,index|

		case index
			when 0
				info_personal['apellido'] = row.text()
				next
			when 1
				info_personal['nombre'] = row.text()
				res_final['nombre_completo'] = info_personal['nombre'] + " " + info_personal['apellido']
				res_final['nombre'] = row.text()
				res_final['apellido'] = info_personal['apellido']
				next

			when 2
				info_personal['administracion'] = row.text()
				next
			when 3
				info_personal['fecha_nacimiento'] = row.text()
				next
			when 4
				info_personal['provincia'] = row.text()
				res_final['provincia'] = row.text()
				next
			when 5
				info_personal['fecha_retiro'] = row.text()
				res["info_personal"] = info_personal
				break
		end #case
	end #each

	page_html.xpath('//table[@id="BdwpRows"]/tbody/tr/td[@class="ms-vb"]').each_with_index do |row,index|

		case index
			when 1
				info_fracc["siglas"] = row.text()
				next
			when 2
				info_fracc["nombre"] = row.text()
				res_final['partido'] = row.text().strip
				next
			when 3
				info_fracc["fecha_ingreso"] = row.text()
				next
			when 4
				info_fracc["fecha_retiro"] = row.text()
				next
			when 6
				res["info_fracc"]= info_fracc 
				

		end #case

		

		if (contador_comision != -1)
			if ( !(row.text() =~ /^\d+$/) && (contador_comision == 0) && !(row.text().eql? ""))
					#puts "Econtrada comision "+ row.text()
					#si el row es del tipo que comienza una nueva comision, entonces no va a ser un numero. Los numeros corresponden solo a proyectos, en la primera fila.
					res_final['texto_comisiones'] = res_final['texto_comisiones'] + row.text() + "\n"

					comision = {} #limpia el hash de comision
					comision["nombre"] = row.text() #agrega el nombre de la comision
					contador_comision += 1
			        next #avanza al siguiente row, que se supone tiene el tipo de comision
		 	elsif ( contador_comision > 0 ) #si el contador de comisiones aumento, quiere decir que estamos dentro de una comision
						case contador_comision
							when 1
								#puts " Tipo "+ row.text()
								comision["tipo"] = row.text()
								#res_final['texto_comisiones'] = res_final['texto_comisiones'] + "Tipo: " + row.text() + "\n"
								contador_comision += 1
								next
							when 2
								#puts "Puesto "+ row.text()
								res_final['texto_comisiones'] = res_final['texto_comisiones'] + "Puesto: " + row.text() + "\n"
								comision["puesto"] = row.text()
								contador_comision += 1
								next
							when 3
								#puts "Legislatura"+ row.text()
								comision["legislatura"] = row.text()
								contador_comision += 1
								next
							when 4
								#puts "Fecha constitucion"+ row.text()
								comision["fecha_constitucion"] = row.text()
								contador_comision += 1 #resetea el contador
								next
							when 5
								#puts "Fecha ingreso"+ row.text()
								comision["fecha_ingreso"] = row.text()
								contador_comision = 0 #resetea el contador
								comisiones[contador_comisiones] = comision
								#puts "Contador comisiones "
								#puts contador_comisiones
								res_final['texto_comisiones'] = res_final['texto_comisiones'] + "\n"
								#puts "Contador comision "
								#puts contador_comision
								contador_comisiones += 1 #configura para la siguiente comision
								next
						end #case
			end #if
			#si llega aca, es porque el siguiente row no fue inicio de comision y el contador estaba en 0, lo que significa
			#que se acabaron las comisiones
			if !(row.text().eql? "")
				contador_comision = -1 #indico que se acabaron las comisiones, no tiene que buscarlas ya mas
				res_final["cantidad_comisiones"] = contador_comisiones
				res["comisiones"] = comisiones		
				#puts "Cambiada bandera de comisiones por texto " + row.text()		
			end #if

		end #if del -1
		#comenzamos con los proyectos
		if (contador_proyecto != -1)
			#puts "entro a proyectos"
			if ((row.text() =~ /^\d+$/) && !(row.text().eql? "") && (contador_proyecto == 0)) #si el texto es un numero, entonces es un proyecto
				#res_final['texto_proyectos'] = res_final['texto_proyectos'] + row.text() + "\n"
				#puts "proyecto con texto "+ row.text()
				proyecto = {} #limpia el hash de proyecto
				proyecto["id"] = row.text() #agrega el id del proyecto
				contador_proyecto += 1
				#puts "ahora contador_proyecto es "
				#puts contador_proyecto
				next
		 	elsif ( contador_proyecto > 0 ) #si el contador de comisiones aumento, quiere decir que estamos dentro de una comision
						case contador_proyecto
							when 1
								proyecto["asunto"] = row.text()
								res_final['texto_proyectos'] = res_final['texto_proyectos'] + "Asunto: " + row.text() + "\n"
								contador_proyecto += 1
								next
							when 2
								proyecto["tipo"] = row.text()

								contador_proyecto += 1
								next
							when 3
								proyecto["fecha_inicio"] = row.text()
								#res_final['texto_proyectos'] = res_final['texto_proyectos'] + "Fecha de inicio: " + row.text() + "\n"
								contador_proyecto += 1
								next
							when 4
								proyecto["fecha_vencimiento"] = row.text()
								contador_proyecto = 0 #resetea el contador
								proyectos[contador_proyectos] = proyecto
								res_final['texto_proyectos'] = res_final['texto_proyectos'] + "\n"
								contador_proyectos+= 1 #configura para la siguiente comision
								next
						end #case
			end #if

			if !(row.text().eql? "")
				contador_proyecto = -1 #indico que se acabaron los proyectos, no tiene que buscarlas ya mas	
				#puts "Cambiada bandera de proyectos por texto " + row.text()		
				res_final['cantidad_proyectos'] = contador_proyectos
			end #if

		else #if del -1
			#puts "me sali de proyectos porque contador_proyecto es "
			
		end

	end	#each
	res_final['cantidad_proyectos'] = contador_proyectos
	res["proyectos"] = proyectos	
	puts "Parseado perfil de diputado "+res_final["nombre_completo"]
	return res_final
end #funcion

=begin
def ObtenerDatosDiputados

	
	page_html.xpath('//a[@href]').each_with_index do |link, index|
	  if (index>30) then
	  	h[link.text.strip] = link['href']
	  end
	end

	puts h
	return h
=end
def ObtenerDatosDiputados
	contador_datos = 0
	contador_descripciones = 0
	contador_diputado = 0
	contador_links = 0
	contador_correos = 0
	contador_actas = 0
	diputados = []
	textos_asistencia = {}
	correos_hash = {}
	enlaces = []
	descripciones = []
	actas = {}
	acta_actual = {}
	ultima_fecha_acta_revisada = ""
	ultima_fecha_acta_disponible = ""
	enlace_acta = ""
	apellido_correo = ""
	nombre_correo = ""
	sexos = []
	browser = Watir::Browser.start  "http://www.asamblea.go.cr/Diputadas_Diputados/Lists/Diputados/Diputadas%20y%20diputados%20por%20Fraccin.aspx"
	#cargar el html, esto ejecuta el javascript	
	sleep 2
	page_html = Nokogiri::HTML.parse(browser.html)
	browser.close
	browser2 = Watir::Browser.start  "http://www.asamblea.go.cr/Diputadas_Diputados/Lists/Diputados/Diputadas%20y%20Diputados.aspx"
	#cargar el html, esto ejecuta el javascript	
	sleep 2
	html_correos = Nokogiri::HTML.parse(browser2.html)
	browser2.close

	browser3 = Watir::Browser.start  "http://www.asamblea.go.cr/Actas/Forms/Plenario.aspx"
	#cargar el html, esto ejecuta el javascript	
	sleep 2
	html_actas = Nokogiri::HTML.parse(browser3.html)
	browser3.close
#onetidDoclibViewTbl0

	actas_nodos = html_actas.xpath('//table[@id="onetidDoclibViewTbl0"]/tbody/tr/td[@class="ms-vb2"]')
	actas_enlaces = html_actas.xpath('//table[@id="onetidDoclibViewTbl0"]/tbody/tr/td[@class="ms-vb2"]/a')
	correos = html_correos.xpath('//table[@id="{8C2F8CC4-FDF7-4F23-88A5-D911EA61D4ED}-{5028423F-F273-4D5F-8722-08B98F56855C}"]/tbody/tr/td')
	imagenes = page_html.xpath('//table[@id="{8C2F8CC4-FDF7-4F23-88A5-D911EA61D4ED}-{982FB728-3786-4240-8B25-6C35E29E858C}"]/tbody/tr/td[@class="ms-vb2"]/img')
	colection = page_html.xpath('//table[@id="{8C2F8CC4-FDF7-4F23-88A5-D911EA61D4ED}-{982FB728-3786-4240-8B25-6C35E29E858C}"]/tbody/tr/td[@class="ms-vb2"]')
	links = page_html.xpath('//table[@id="{8C2F8CC4-FDF7-4F23-88A5-D911EA61D4ED}-{982FB728-3786-4240-8B25-6C35E29E858C}"]/tbody/tr/td[@class="ms-vb2"]/table/tbody/tr/td/a')

#ACTAS

	actas_nodos.each_with_index do |row,index|
		#link, fecha, hora, tipo
		case contador_actas
			when 0 #es el link
				
				enlace_acta = "http://www.asamblea.go.cr/Actas/"+row.text()+".pdf"
				contador_actas += 1
				next
			when 1 #la fecha
				actas[row.text()] = enlace_acta
				ultima_fecha_acta_revisada = row.text()
				contador_actas += 1
				next
			when 2
				contador_actas += 1
				next
			when 3
				contador_actas = 0
				next
		end #case
	end #each

#tenemos en actas el hash con los enlaces a las actas, ahora necesitamos el texto de la segunda pagina.
	actas.each do |key,value|
		begin
			encoded_url = URI.encode(value)
			puts "Obtenido texto para fecha "+ key
			io    = open(encoded_url)
			reader = PDF::Reader.new(io)
			texto =  I18n.transliterate(reader.pages[1].text.downcase).downcase
			textos_asistencia[key] = texto		
		rescue
			puts "Error de formato"
		end #begin
	end #each

#ya tenemos en el hash textos_asistencia los textos de la segunda pagina de todas las actas


	correos.each do |row|
		#apellido, nombre, correo, correo
		case contador_correos
			when 0

				apellido_correo = row.text().strip
				contador_correos+=1
				next
			when 1
				nombre_correo = row.text().strip
				contador_correos+=1
				next
			when 2
				correo = row.text().strip

				correos_hash[nombre_correo + " " + apellido_correo] = row.text().strip
				if apellido_correo.strip.include? "ESQUIVEL"
					puts "Guardado correo en "+nombre_correo + " " + apellido_correo +" con correo "+ correos_hash[nombre_correo + " " + apellido_correo]
				end #if
				contador_correos+=1
				next
			when 3
				contador_correos = 0
				next	
		end #case							
	end #each

	#en correos_hash están los correos según el nombre

	#vamos primero a conseguir los enlaces a los perfiles
	links.each do |row|
		#estan repetidos, en pares, así que solo contamos el primero
		#if (contador_links==0) #si es el primero del par, row["href"] tiene el link y row.text() tiene el apellido, pero no importan porque esos los conseguimos del perfil.
		case contador_links
			when 0
				#en row.text esta el apellido
				#necesitamos procesar el link que esta en link[index] pero estan repetidos
				enlaces << row["href"] #se guarda el enlace
				#la siguiente iteracion se va a ignorar, porque estan repetidos
		 		contador_links +=1
		 		next
		 	when 1
		 		#ignoramos la linea y ponemos el contador a 0
		 		contador_links = 0
		 		next
		end #case
	end #each

	#ahora vamos a conseguir las descripciones de los diputados
	colection.each_with_index do |row,index|
		#apellido, nombre, desc, vacio,vacio
		if (index == 0)
			next
		end #if
		case contador_descripciones
			when 0 #si esta en 0, es un apellido, lo ignoramos
				contador_descripciones += 1	
				next
			when 1 #nombre, ignorado
				contador_descripciones += 1	
				next 
			when 2 #descripcion, lo rescatamos
				descripciones << row.text().strip
				contador_descripciones += 1	
				next
			when 3 #vacio
				contador_descripciones += 1	
				next
			when 4 #vacio
				contador_descripciones = 0	
				next
		end #case
	end #each

	#ya tenemos las descripciones de los diputados. Ahora tenemos que analizar las descipciones por palabras clave que nos indiquen el sexo. Por razones probabilísticas,
	# asumimos que es hombre si no se logra probar lo contrario.
	descripciones.each_with_index do |row,index|
		sexos << "M"
		if ( (row.include? "Diputada") || (row.include? "Divorciada") || (row.include? "Directora") || (row.include? "Candidata") || 
				(row.include? "diputada") || (row.include? "candidata") || (row.include? "Administradora") || (row.include? "Licenciada") || (row.include? "educadora") || 
			 	(row.include? "licenciada") || (row.include? "Profesora") || (row.include? "profesora") || (row.include? "Abogada") || (row.include? "abogada") || 
			 	(row.include? "Soltera") || (row.include? "soltera") || (row.include? "Presidenta") || (row.include? "Regidora") || (row.include? "Delegada") || 
			 	(row.include? "regidora") || (row.include? "delegada") || (row.include? "Consultora") || (row.include? "Educadora") )
			sexos[index] = "F"
		end #if
	end #each

	#ya tenemos los sexos de los diputados, por lo menos lo mejor que podemos obtenerlos del sistema de la Asamblea.
	# Ya tenemos, entonces: los sexos, los enlaces, falta procesar los enlaces y tomar los correos.

	#Vamos a procesar los enlaces.
	enlaces.each_with_index do |row,index|
		#puts row["href"] tiene el enlace
		
			diputado = {} #creamos el hash para guardar la info del diputado, incluida la que ya tenemos y la que nos viene del perfil.
			diputado["sexo"] = sexos[index] #como todo está en orden, guardamos el sexo
			diputado["url_foto"] = "http://www.asamblea.go.cr/"+ imagenes[index]["src"] #igual
			diputado["descripcion"] = descripciones[index] #ditto
			diputado["password"] = "123456"
			diputado["password_confirmation"] = "123456"
			
 			hash_datos = ObtenerDatosDiputado(enlaces[index])
 			if !(correos_hash[hash_datos["nombre_completo"]].nil?) #si el correo no es nulo
 				diputado["email"] = I18n.transliterate(correos_hash[hash_datos["nombre_completo"]].strip.downcase).downcase.delete(' ')
 			else #si el correo es nulo
 				diputado["email"] = I18n.transliterate(hash_datos["nombre"]).downcase.to_s.delete(' ') +
 									 '.' + 
 									 I18n.transliterate(hash_datos["apellido"]).downcase.to_s.delete(' ') + 
 									 '@asamblea.go.cr'

			end #if
			diputado["nombre"] = hash_datos["nombre_completo"] #nombre
			diputado["provincia"] = hash_datos["provincia"] #provincia
			diputado["partido"] = hash_datos["partido"] #nombre
			diputado["cantidad_proyectos"] = hash_datos["cantidad_proyectos"] #cantidad_proyectos
			diputado["cantidad_comisiones"] = hash_datos["cantidad_comisiones"] #cantidad_comisiones
			diputado["texto_proyectos"] = hash_datos["texto_proyectos"] #texto_proyectos
			diputado["texto_comisiones"] = hash_datos["texto_comisiones"] #texto_comisiones
			#ahora vamos a revisar asistencia
			diputado["asistencias"] = RevisarAsistenciaPorTodasActas(textos_asistencia, hash_datos["nombre"], hash_datos["apellido"] )
			if (diputado["nombre"].include? "ESQUIVEL")
				puts "Encontrado Abelino con correo "+ diputado["email"]
				puts diputado
			end #if
			diputados << diputado
		
	end #each

# Al llegar acá, ya tenemos toda la info de los diputados en el array de diputados. Vamos a empaquetarlos y a enviarlos al servidor
# Prueba con don oscar lopez, es el unico en el array de diputados
	EnviarInfoDiputadosAlServidor(diputados)
		


	
end #metodo

def RevisarAsistenciaPorNombre(texto_asistencia, nombre, apellido)

	nombre_nuevo =  I18n.transliterate(nombre.downcase).downcase
	apellido_nuevo = I18n.transliterate(apellido.downcase).downcase	
	esta = ( (texto_asistencia.include? nombre_nuevo) && (texto_asistencia.include? apellido_nuevo))
	return esta

end #metodo

def RevisarAsistenciaPorTodasActas(hash_textos, nombre, apellido)
	contador_asistencias = 0
	hash_textos.each do |key,value|
		if RevisarAsistenciaPorNombre(value, nombre, apellido)
			contador_asistencias += 1
		end #if
	end #each
	return contador_asistencias


end #metodo

def EnviarInfoDiputadosAlServidor(array_diputados)
	array_diputados.each do |diputado|
		puts "Enviando al servidor: " + diputado["nombre"] + "con correo "+ diputado["email"]
		uri = URI.parse('http://tec-asamblea.herokuapp.com/api/asamblea/crear_diputado')
		response = Net::HTTP.post_form(uri, {:nombre => diputado["nombre"], 
					 :email => diputado["email"],
					 :descripcion => diputado["descripcion"],
					 :url_foto => diputado["url_foto"],
					 :sexo => diputado["sexo"],
					 :provincia => diputado["provincia"],
					 :partido => diputado["partido"],
					 :password => diputado["password"],
					 :cantidad_proyectos => diputado["cantidad_proyectos"],
					 :texto_proyectos => diputado["texto_proyectos"],
					 :texto_comisiones => diputado["texto_comisiones"],
					 :password_confirmation => diputado["password_confirmation"],
					 :cantidad_asistencias => diputado["asistencias"],
					 :appkey => "1405ee0b5234c53980d46d493ae2a0cb"
     	 		})
		puts response.body
	end #each
end #metodo




	d = AsambleaScrapper.new
	d.ObtenerDatosDiputados
	#d.ObtenerDatosDiputado('http://www.asamblea.go.cr/Diputadas_Diputados/_layouts/ProfileRedirect.aspx?Application=SIL_Instance&Entity=Diputado&ItemId=__cgc000830003008300g020023000300130043002300030013008300')
	#d.RevisarAsistenciaPorNombre("sas","ÓSCAR", "LÓPEZ")
end
