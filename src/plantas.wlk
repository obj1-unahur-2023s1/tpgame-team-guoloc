import wollok.game.*
import cabezal.*
import logoPlanta.*

object ningunaPlanta{
	const property id = 0
	const property costoSoles = 0
	method nuevaPlanta(){}
	method imagenCabezal() = "cabezal.png"
	
	//metodos vacios
	method id(a){}
	method accionCabezal(){}
	method accionar(a){}
}

object pala{
	const property id = 0
	const property costoSoles = 0
	method nuevaPlanta(posicion) = self
	method imagenCabezal() = "imgPlantas/cabezal_pala.png"
	method accionCabezal(){
		cabezal.desplantar()
	}
	
	//metodos vacíos
	method serImpactado(algo){}
	method accionar(a){}
	method id(a){}
}

class Planta{
	var property id = 0
	var property position
	var property salud = 50
	method serDesplantado(){
		game.removeVisual(self)
	}
	method accionCabezal(){
		cabezal.plantar()
	}
	
	method serImpactado(algo){}
	method accionar(posicion){}
}

class Girasol inherits Planta{
	const property costoSoles = 50
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/girasol_f", idanim = id)
	var property solesGenerados = 0
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Girasol(position = posicion)
	
	override method accionar(posicion){
		game.onTick(10000, "generarSoles" + id.toString(), {self.generarSoles(position) solesGenerados += 1})
	}
	
	method generarSoles(posicion){
		if (self.puedeGenerarSol(posicion))
		{
			const solCreado = new Sol(position = posicion, idSol = solesGenerados.toString())
			game.addVisual(solCreado)
			solCreado.accionar()
		}
			
	}
	
	method puedeGenerarSol(posicion) = posicion.allElements().size()<2 

	
	method imagenCabezal() = "imgPlantas/cabezal_girasol.png"
	
	override method serDesplantado(){
		super()
		game.removeTickEvent("generarSoles" + id.toString())
	}
	

}

class Sol {
	var property imagenActual = new GestorAnimacion (imagenBase = "otros/sol_f")
	var property position
	var property idSol
	
	method initialize(){
		if (game.getObjectsIn(self.position()).contains(self))
		game.onCollideDo(cabezal, { cabezal => self.serRecolectado()})
	}
	
	method image() = imagenActual.image()
	
	method serRecolectado(){
		indicadorSoles.aumentarSoles(25)
		game.removeTickEvent("desaparecerSol" +idSol.toString())
		game.removeVisual(self)
	}
	
	method accionar(){
		game.onTick(2000,"desaparecerSol" +idSol.toString() ,{self.serRecolectado()})
	}
	
	method serDesplantado(){}
	
}

class PapaMina inherits Planta{
	const property costoSoles = 25
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/papa_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new PapaMina(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_papa.png"
}

class Guisante inherits Planta{
	const property costoSoles = 100
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/guisante_f", idanim = id)
	var property guisantesDisparados = 0
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Guisante(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_guisante.png"
	
	override method serDesplantado(){
		super()
		game.removeTickEvent("disparar" + id.toString())
	}
	
	override method accionar(posicion){
		
		game.onTick(1500,"disparar" +id.toString() ,{self.dispararGuisante(posicion) guisantesDisparados +=1})
	}
	
	method dispararGuisante(posicion){
		game.addVisual(new ProyectilGuisante(position = posicion, idGuisante = guisantesDisparados.toString(), idPlanta = id.toString()))
	}
}

class GuisanteDoble inherits Planta{
	const property costoSoles = 200
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/guisanteDoble_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new GuisanteDoble(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_guisanteDoble.png"
}

class Nuez inherits Planta{
	const property costoSoles = 50
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/nuez_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Nuez(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_nuez.png"
}

class Espinas inherits Planta{
	const property costoSoles = 50
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/espinas_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Espinas(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_espinas.png"

}

class ProyectilGuisante{
	var property position
	var property damage = 50
	var property imagen = "imgPlantas/guisante_proyectil.png"
	const idGuisante
	const idPlanta
	method initialize(){
		game.onTick(500,"movimiento" + idPlanta  + idGuisante,{self.moverDerecha()})
	}
	
	method image() = imagen
	
	method moverDerecha(){
		position = game.at(position.x()+1,position.y())
	}
	

	
	method impactar(objeto){
		objeto.serImpactado(self)
		self.destruir()
	}
	
	method destruir(){
		game.removeTickEvent("movimiento" + idPlanta + idGuisante)
		game.removeVisual(self)
	}
	
}



class GestorAnimacion{
	var frameActual = 0
	const imagenBase
	var property idanim = 0
	
	method initialize(){
		game.onTick(200, "animacionIdle" + idanim.toString(), {self.cambiarFrame()})
	}

	method cambiarFrame(){frameActual = self.frameOpuesto()}
	method frameOpuesto() = if(frameActual==0) 1 else 0
	method image() = imagenBase + frameActual.toString() + ".png"
}


