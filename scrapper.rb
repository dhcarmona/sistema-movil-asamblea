require 'rubygems'
require 'watir'
require 'nokogiri'

class AsambleaScrapper

def initialize
end

def ObtenerDatosTextoDiputado(link_diputado)
	browser = Watir::Browser.start link_diputado
	sleep 6
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
	sleep 6
	page_html = Nokogiri::HTML.parse(browser.html)
	res = {}
	comision = {}
	en_comisiones = false
	contador_comisiones = 0 #lleva el indice para las comisiones
	contador_comision = 0 #contador para saber el tipo de dato
	en_proyectos = false
	contador_proyectos = 0
	en_acuerdos = false
	contador_acuerdos = 0
	comisiones = {}
	info_fracc = {}
	info_personal = {}
	#scrapping de la informacion personal del diputado
	page_html.xpath('//table/tbody/tr/td[@class="ms-descriptiontext ms-alignleft"]').each_with_index do |row,index|
		case index
			when 1
				info_personal['apellido'] = row.text()
				next
			when 2
				info_personal['nombre'] = row.text()
			when 3
				info_personal['administracion'] = row.text()
				next
			when 4
				info_personal['fecha_nacimiento'] = row.text()
				next
			when 5
				info_personal['fecha_retiro'] = row.text()
				break
		end
	end
	res["info_personal"] = info_personal
	page_html.xpath('//table[@id="BdwpRows"]/tbody/tr/td[@class="ms-vb"]').each_with_index do |row,index|
	
		case index
			when 1
				info_fracc["siglas"] = row.text()
				next
			when 2
				info_fracc["nombre"] = row.text()
			when 3
				info_fracc["fecha_ingreso"] = row.text()
				next
			when 4
				info_fracc["fecha_retiro"] = row.text()
				next
			when 6
				puts row.content()
		end #case
=begin
		unless (row.children().first().children().first().children().first().children().first().children().first().children().first().nil?)
				if (row.children().first().children().first().children().first().children().first().children().first().children().first()['onclick'].include? "'SIL_Instance','Organos'")
				#si el row es del tipo que comienza una nueva comision
				contador_comision = 0
				comision = {} #limpia el hash de comision
				comision["nombre"] = row.text() #agrega el nombre de la comision
				contador_comision += 1
		                next #avanza al siguiente row, que se supone tiene el tipo de comision
	 		elsif ( contador_comisiones > 0 ) #si el contador de comisiones aumento, quiere decir que estamos dentro de una comision
					case contador_comisiones
						when 1
							comision["tipo"] = row.text()
							contador_comision += 1
							next
						when 2
							comision["puesto"] = row.text()
							contador_comision += 1
							next
						when 3
							comision["legislatura"] = row.text()
							contador_comision += 1
							next
						when 4
							comision["fecha_ingreso"] = row.text()
							contador_comision = 0 #resetea el contador
							comisiones[contador_comisiones] = comision
							contador_comisiones += 1 #configura para la siguiente comision
							next
					end #case
			end #if
			#si llega aca, es porque el siguiente row no fue inicio de comision y el contador estaba en 0, lo que significa
			#que se acabaron las comisiones
			res["comisiones"] = comisiones
=end
	end #each
	

end #funcion



def ObtenerListaDiputados
	#abrir el browser
	browser = Watir::Browser.start  "http://www.asamblea.go.cr/Diputadas_Diputados/Lists/Diputados/Diputadas%20y%20diputados%20por%20Fraccin.aspx"
	#cargar el html, esto ejecuta el javascript	
	page_html = Nokogiri::HTML.parse(browser.html)

	#guardar un hash para los diputados y sus nombres
	h = {}
	
	page_html.xpath('//a[@href]').each_with_index do |link, index|
	  if (index>30) then
	  	h[link.text.strip] = link['href']
	  end
	end

	puts h
	return h

end
	d = AsambleaScrapper.new
	d.ObtenerDatosTextoDiputado('http://www.asamblea.go.cr/Centro_de_Informacion/Consultas_SIL/Pginas/Detalle%20Diputadas%20y%20Diputados.aspx?Cedula_Diputado=808&Administracion=20142018')
	
end
