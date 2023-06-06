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
	var property imagenActual = new GestorAnimacionGuisante()

	method image() = imagenActual.image()
	
	method nuevaPlanta() = new Guisante()
}

class GestorAnimacionGuisante{
	
	var frameActual = 0
	
	method initialize(){
		game.onTick(200, "animacionGuisante", {self.cambiarFrame()})
	}
	
	method cambiarFrame(){
		frameActual = self.frameOpuesto()
	}
	
	method frameOpuesto() = if(frameActual==0) 1 else 0
	
	method image() = "imgPlantas/guisante_f" + frameActual.toString() + ".png"
}