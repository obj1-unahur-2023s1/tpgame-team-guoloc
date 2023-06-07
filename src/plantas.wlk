import wollok.game.*

object ningunaPlanta{
	method nuevaPlanta(){}
	method imagenCabezal() = "cabezal.png"
}

object pala{
	method nuevaPlanta(){}
	method imagenCabezal() = "imgPlantas/cabezal_pala.png"
}

class Planta{
	var property costoSoles = 0
	var property salud = 50
}

class Girasol inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/girasol_f")
	method image() = imagenActual.image()
	method nuevaPlanta() = new Girasol()
	method imagenCabezal() = "imgPlantas/cabezal_girasol.png"

}

class PapaMina inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/papa_f")
	method image() = imagenActual.image()
	method nuevaPlanta() = new PapaMina()
	method imagenCabezal() = "imgPlantas/cabezal_papa.png"
}

class Guisante inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/guisante_f")
	method image() = imagenActual.image()
	method nuevaPlanta() = new Guisante()
	method imagenCabezal() = "imgPlantas/cabezal_guisante.png"
}

class GuisanteDoble inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/guisanteDoble_f")
	method image() = imagenActual.image()
	method nuevaPlanta() = new GuisanteDoble()
	method imagenCabezal() = "imgPlantas/cabezal_guisanteDoble.png"
}

class Nuez inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/nuez_f")
	method image() = imagenActual.image()
	method nuevaPlanta() = new Guisante()
	method imagenCabezal() = "imgPlantas/cabezal_nuez.png"
}

class Espinas inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/espinas_f")
	method image() = imagenActual.image()
	method nuevaPlanta() = new Girasol()
	method imagenCabezal() = "imgPlantas/cabezal_espinas.png"

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

class GestorAnimacion{
	var frameActual = 0
	const imagenBase
	
	method initialize(){
		game.onTick(200, "animacionIdle", {self.cambiarFrame()})
	}

	method cambiarFrame(){frameActual = self.frameOpuesto()}
	method frameOpuesto() = if(frameActual==0) 1 else 0
	method image() = imagenBase + frameActual.toString() + ".png"
}