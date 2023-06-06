import wollok.game.*

class Planta{
	var property costoSoles = 0
	var property salud = 50
}

class Girasol inherits Planta{
	var property image = "imgPlantas/girasol_f1.png"
	var property frame = 0
	
	method nuevaPlanta() = new Girasol()
	
	

}

class PapaMina inherits Planta{
	const property image = "imgPlantas/papa_f0.png"
	
	method nuevaPlanta() = new PapaMina()
}

class Guisante inherits Planta{
	const property image = "imgPlantas/guisante_f0.png"
	
	method nuevaPlanta() = new Guisante()
}