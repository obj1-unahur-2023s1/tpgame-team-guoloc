import wollok.game.*
import cabezal.*
import logoPlanta.*
import gestores.*

object ningunaPlanta{
	const property id = 0
	const property costoSoles = 0
	method nuevaPlanta(){}
	method esPlanta() = false
	method imagenCabezal() = "cabezal.png"
	
	//metodos vacios
	method id(a){}
	method accionCabezal(){}
	method accionar(a){}
	method esZombie() = false
}

object pala{
	const property id = 0
	const property costoSoles = 0
	method nuevaPlanta(posicion) = self
	method imagenCabezal() = "imgPlantas/cabezal_pala.png"
	method accionCabezal(){
		cabezal.desplantar()
	}
	
	method esPlanta() = false
	//metodos vacíos
	method serImpactado(algo){}
	method accionar(a){}
	method id(a){}
	method esZombie() = false
}

class Planta{
	var property id =gestorIds.nuevoId()
	var property position
	var property salud = 1000
	method serDesplantado(){
		game.removeVisual(self)
	}
	method accionCabezal(){
		cabezal.plantar()
	}
	
	method esPlanta() = true
	method esZombie() = false
	method serImpactado(algo){
	}
	method accionar(posicion){}
	
	method recibirDanio(danio){
		salud = salud - danio
		if(salud <= 0){
			self.morir()
		}
	}
	method morir(){
		game.colliders(self).filter({o => o.esZombie()}).forEach({z => z.continuar()})
		self.serDesplantado()
		
	}
	
	
}

class Girasol inherits Planta{
	const property costoSoles = 50
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/girasol_f", idanim = id)
	var property solesGenerados = 0
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Girasol(position = posicion)
	
	
	override method accionar(posicion){
		game.onTick(10000, "generarSoles" + id.toString(), {self.generarSoles(position)})
	}
	
	method generarSoles(posicion){
		if (self.puedeGenerarSol(posicion))
		{
			const solCreado = new Sol(position = posicion, idSol = gestorIds.nuevoId())
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
	var property idSol = gestorIds.nuevoId()
	
	
	
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
	
	method esZombie() = false
	method serDesplantado(){}
	method esPlanta() = false
	method serImpactado(algo){}
	method recibirDanio(){}
	
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
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Guisante(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_guisante.png"
	
	override method serDesplantado(){
		super()
		game.removeTickEvent("disparar" + id.toString())
	}
	
	override method accionar(posicion){
		
		game.onTick(1500,"disparar" +id.toString() ,{self.dispararGuisante(posicion)})
	}
	
	method dispararGuisante(posicion){
		const guisante = new ProyectilGuisante(position = posicion, idGuisante = gestorIds.nuevoId())
		game.addVisual(guisante)
		game.onCollideDo(guisante,{objeto => objeto.serImpactado(guisante)})
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

	
	method serImpactado(algo){}
	method initialize(){
		game.onTick(500,"movimientoGuisante"+ idGuisante.toString(),{self.moverDerecha()})
	}
	
	method image() = imagen
	
	method moverDerecha(){
		position = game.at(position.x()+1,position.y())
	}
	
	method esPlanta() = false
	method esZombie() = false
	
	method impactar(objeto){
		objeto.serImpactado(self)
		self.destruir()
	}
	
	method destruir(){
		game.removeTickEvent("movimientoGuisante" + idGuisante)
		game.removeVisual(self)
	}
	
}




