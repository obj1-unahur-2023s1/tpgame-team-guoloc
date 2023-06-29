import wollok.game.*
import cabezal.*
import logoPlanta.*
import gestores.*

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
	method esZombie() = false
	method esPlanta() = false
	method esSol() = false
}

class Planta{
	var property id =gestorIds.nuevoId()
	var property position
	var property salud = 50
	var property nombrePlanta
	var property costoSoles
	
	var property imagenActual = new GestorAnimacion(imagenBase=self.pathImage(), idanim = id)
	method image() = imagenActual.image()
	method imagenCabezal() = "imgPlantas/cabezal_"+nombrePlanta+".png"
	
	method pathImage() = "imgPlantas/"+nombrePlanta+"_f"
	
	method serDesplantado(){
		game.removeVisual(self)
	}
	method accionCabezal(){
		cabezal.plantar()
	}
	
	method recolectar(sol){}

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

class Girasol inherits Planta(costoSoles = 50, nombrePlanta = "girasol"){
	
	var property solesGenerados = 0
	
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
	
	override method serDesplantado(){
		super()
		game.removeTickEvent("generarSoles" + id.toString())
	}
	

}



class PapaMina inherits Planta(costoSoles = 200, nombrePlanta = "papa"){
	const property damage = 9999
	method nuevaPlanta(posicion) = new PapaMina(position = posicion)
	
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

class Guisante inherits Planta(costoSoles = 100, nombrePlanta = "guisante"){

	method nuevaPlanta(posicion) = new Guisante(position = posicion)
	
	override method serDesplantado(){
		super()
		game.removeTickEvent("disparar" + id.toString())
	}
	
	override method accionar(posicion){
		
		game.onTick(2500,"disparar" +id.toString() ,{self.dispararGuisante(posicion)})
	}
	
	method dispararGuisante(posicion){
		const guisante = new ProyectilGuisante(position = posicion, posicionInicial = posicion, idGuisante = gestorIds.nuevoId())
		game.addVisual(guisante)
		game.onCollideDo(guisante,{objeto => objeto.serImpactado(guisante)})
	}
}

class GuisanteDoble inherits Guisante(costoSoles = 200, nombrePlanta = "guisanteDoble"){
	
	override method nuevaPlanta(posicion) = new GuisanteDoble(position = posicion)
	
	override method dispararGuisante(posicion){
		const guisante = new ProyectilGuisanteDoble(position = posicion, posicionInicial = posicion, idGuisante = gestorIds.nuevoId())
		game.addVisual(guisante)
		game.onCollideDo(guisante,{objeto => objeto.serImpactado(guisante)})
	}
}

class Nuez inherits Planta(costoSoles = 50, nombrePlanta = "nuez", salud=100){
	
	method nuevaPlanta(posicion) = new Nuez(position = posicion)

}

class Espinas inherits Planta(costoSoles = 100, nombrePlanta = "espinas"){
	
	const property damage = 4
	
	method nuevaPlanta(posicion) = new Espinas(position = posicion)
	
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
	
	method accionar(){
		game.onCollideDo(self, { p => p.recolectar(self)})
	}
	
	method recolectar(sol){}

	method esSol() = true
	method esZombie() = false
	method serDesplantado(){}
	method esPlanta() = false
	method serImpactado(algo){}
	method recibirDanio(){}
	method colisionaConCabezal() = game.colliders(self).any({o => o.esCabezal()})
	method destruir(){
		game.removeVisual(self)
	}
	
}




class ProyectilGuisanteDoble inherits ProyectilGuisante(damage=20, imagen="imgPlantas/guisanteDoble_proyectil.png"){
	method initialize(){
		damage = 20
		imagen = "imgPlantas/guisanteDoble_proyectil.png"
		game.onTick(250,"movimientoGuisante"+ idGuisante.toString(),{self.moverDerecha()})
	}
	
	
}


class ProyectilGuisante{
	var property position
	var property posicionInicial
	var property damage = 10
	var property imagen = "imgPlantas/guisante_proyectil.png"
	const idGuisante = gestorIds.nuevoId()

	
	method serImpactado(algo){}
	method initialize(){
		game.onTick(250,"movimientoGuisante"+ idGuisante.toString(),{self.moverDerecha()})
	}
	
	method image() = imagen
	
	method moverDerecha(){
		if ((position.x() >= posicionInicial.x() +9) || position.x() >= 18 ){
			self.destruir()
		}
		else
		{
			position = game.at(position.x()+1,position.y())
		}
		
		
	}
	
	method recolectar(sol){}

	method esPlanta() = false
	method esZombie() = false
	method esSol() = false
	method serDesplantado(){}
	
	
	method destruir(){
		game.removeTickEvent("movimientoGuisante" + idGuisante)
		game.removeVisual(self)
	}
	
}

