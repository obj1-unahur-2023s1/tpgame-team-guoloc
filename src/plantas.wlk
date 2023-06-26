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
	method esCabezal() = false
	method accionCabezal(){}
	method accionar(a){}
	method esZombie() = false
	method esSol() = false
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
	method esCabezal() = false
	method serImpactado(algo){}
	method accionar(a){}
	method id(a){}
	method esZombie() = false
	method esPlanta() = false
	method esSol() = false
}

class Planta{
	var property id =gestorIds.nuevoId()
	var property position
	var property salud = 50
	method serDesplantado(){
		game.removeVisual(self)
	}
	method accionCabezal(){
		cabezal.plantar()
	}
	
	method esCabezal() = false
	method detieneMovimiento() = true
	method esPlanta() = true
	method esZombie() = false
	method esSol() = false
	method serImpactado(algo){}
	method accionar(posicion){}
	method zombiesEnLaPosicion() = game.colliders(self).filter({o => o.esZombie()})
	method recibirDanio(danio){
		salud = salud - danio
		if(salud <= 0){
			self.morir()
		}
	}
	method morir(){
		self.zombiesEnLaPosicion().forEach({z => z.continuar()})
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
		game.onTick(10000, "generarSoles" + id.toString(), {self.generarSoles()})
	}
	
	method generarSoles(){
		if (self.puedeGenerarSol())
		{
			const solCreado = new Sol(position = position, idSol = gestorIds.nuevoId())
			game.addVisual(solCreado)
			solCreado.accionar()
		}
			
	}
	
	method puedeGenerarSol() = self.solesEnLaPosicion() == 0

	method solesEnLaPosicion() = position.allElements().filter({o => o.esSol()}).size()
		
	method imagenCabezal() = "imgPlantas/cabezal_girasol.png"
	
	override method serDesplantado(){
		super()
		game.removeTickEvent("generarSoles" + id.toString())
	}
	

}



class PapaMina inherits Planta{
	const property costoSoles = 200
	const property damage = 9999
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/papa_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new PapaMina(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_papa.png"
	
	override method accionar(posicion){
		self.modoExplosion()
	}
	
	method modoExplosion(){
		game.onCollideDo(self,{z => self.explotar()})
	}
	
	method explotar(){
		if(self.zombiesEnLaPosicion().size() > 0){
			self.zombiesEnLaPosicion().forEach({z => z.serImpactado(self)})
			self.serDesplantado()
		}
	}
	
	method destruir(){}
}

class Guisante inherits Planta{
	var property costoSoles = 100
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

class GuisanteDoble inherits Guisante{
	method initialize(){
		costoSoles = 200
		imagenActual = new GestorAnimacion(imagenBase="imgPlantas/guisanteDoble_f", idanim = id)
	} 
	
	override method image() = imagenActual.image()
	override method nuevaPlanta(posicion) = new GuisanteDoble(position = posicion)
	override method imagenCabezal() = "imgPlantas/cabezal_guisanteDoble.png"
	
	override method accionar(posicion){
		game.onTick(1500,"disparar" +id.toString() ,{self.dispararGuisante(posicion)})
	}
	
	override method dispararGuisante(posicion){
		const guisante = new ProyectilGuisanteDoble(position = posicion, idGuisante = gestorIds.nuevoId())
		game.addVisual(guisante)
		game.onCollideDo(guisante,{objeto => objeto.serImpactado(guisante)})
	}
}

class Nuez inherits Planta(salud = 100){
	const property costoSoles = 50
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/nuez_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Nuez(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_nuez.png"
}

class Espinas inherits Planta{
	const property costoSoles = 100
	const property damage = 4
	var property imagenActual = new GestorAnimacion(imagenBase="imgPlantas/espinas_f", idanim = id)
	method image() = imagenActual.image()
	method nuevaPlanta(posicion) = new Espinas(position = posicion)
	method imagenCabezal() = "imgPlantas/cabezal_espinas.png"
	
	override method accionar(posicion){
		game.onTick(200, "ataqueEspinas" + id.toString(), {self.atacar()})
	}
	
	override method detieneMovimiento() = false
	
	method atacar(){
		self.zombiesEnLaPosicion().forEach({z => z.serImpactado(self)})
	}
	
	override method serDesplantado(){
		super()
		game.removeTickEvent("ataqueEspinas" + id.toString())
	}
	
	method destruir(){}
}

//generados por plantas


class Sol {
	var property imagenActual = new GestorAnimacion (imagenBase = "otros/sol_f")
	var property position
	var property idSol = gestorIds.nuevoId()
	
	
	

	method image() = imagenActual.image()
	
	method serRecolectado(){
		if(self.colisionaConCabezal()){
			indicadorSoles.aumentarSoles(25)
			game.removeVisual(self)
		}
	}
	
	method accionar(){
		game.onCollideDo(self, { p => self.serRecolectado()})
	}
	
	method esCabezal() = false
	method esSol() = true
	method esZombie() = false
	method serDesplantado(){}
	method esPlanta() = false
	method serImpactado(algo){}
	method recibirDanio(){}
	method colisionaConCabezal() = game.colliders(self).any({o => o.esCabezal()})
	
	
}




class ProyectilGuisanteDoble inherits ProyectilGuisante{
	method initialize(){
		damage = 10
		imagen = "imgPlantas/guisanteDoble_proyectil.png"
		game.onTick(500,"movimientoGuisante"+ idGuisante.toString(),{self.moverDerecha()})
	}
	
	
}


class ProyectilGuisante{
	var property position
	var property damage = 5
	var property imagen = "imgPlantas/guisante_proyectil.png"
	const idGuisante = gestorIds.nuevoId()

	
	method serImpactado(algo){}
	method initialize(){
		game.onTick(500,"movimientoGuisante"+ idGuisante.toString(),{self.moverDerecha()})
	}
	
	method image() = imagen
	
	method moverDerecha(){
		position = game.at(position.x()+1,position.y())
		if (position.x()>18)
			self.destruir()
	}
	
	method esCabezal() = false
	method esPlanta() = false
	method esZombie() = false
	method esSol() = false
	method serDesplantado(){}
	
	
	method destruir(){
		game.removeTickEvent("movimientoGuisante" + idGuisante)
		game.removeVisual(self)
	}
	
}

