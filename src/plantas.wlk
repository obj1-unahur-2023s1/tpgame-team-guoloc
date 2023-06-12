import wollok.game.*
import cabezal.*

object ningunaPlanta{
	const property id = 0
	method nuevaPlanta(){}
	method imagenCabezal() = "cabezal.png"
	
	//metodos vacios
	method id(a){}
	method accionCabezal(){}
	method accionar(a){}
}

object pala{
	const property id = 0
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
	var property costoSoles = 0
	var property salud = 50
	method accionCabezal(){
		cabezal.plantar()
	}
	
	method serImpactado(algo){}
	method accionar(p){}
}

class Girasol inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/girasol_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Girasol(position = posicion)
	
	method imagenCabezal() = "imgPlantas/cabezal_girasol.png"
	
	

}

class PapaMina inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/papa_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new PapaMina(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_papa.png"
}

class Guisante inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/guisante_f", idanim = id)
	var property guisantesDisparados = 0
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Guisante(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_guisante.png"
	
	
	override method accionar(posicion){
		
		game.onTick(3000,"disparar" +id.toString() ,{self.dispararGuisante(posicion) guisantesDisparados +=1})
	}
	
	method dispararGuisante(posicion){
		game.addVisual(new ProyectilGuisante(position = posicion, id = guisantesDisparados))
	}
}

class GuisanteDoble inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/guisanteDoble_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new GuisanteDoble(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_guisanteDoble.png"
}

class Nuez inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/nuez_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Nuez(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_nuez.png"
}

class Espinas inherits Planta{
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/espinas_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Espinas(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_espinas.png"

}

class ProyectilGuisante{
	var property position
	var property damage = 50
	var property imagen = "otros/logo_sol.png"
	const id
	method initialize(){
		game.onTick(1000,"movimiento" + id.toString(),{self.moverDerecha()})
	}
	
	method image() = imagen
	
	method moverDerecha(){
		position = game.at(position.x()+1,position.y())
	}
	
	method impactar(objeto){
		objeto.serImpactado(self)
	}
	
	method destruir(){
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


