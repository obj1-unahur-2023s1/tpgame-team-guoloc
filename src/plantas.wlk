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
	method parar(){}
	
	//metodos vacíos
	
	method serImpactado(algo){}
	method accionar(a){}
	method id(a){}
}

class Planta{
	var property id =gestorIds.nuevoId()
	var property position
	var property salud = 50
	var property nombrePlanta
	var property costoSoles
	
	var property gestorAnimacion = new GestorAnimacion(imagenBase=self.pathImage(), idanim = id)
	method image() = gestorAnimacion.image()
	method imagenCabezal() = "imgPlantas/cabezal_"+nombrePlanta+".png"
	
	method pathImage() = "imgPlantas/"+nombrePlanta+"_f"
	method parar(){}
	method serDesplantado(){
		gestorAnimacion.eliminarTick()
		game.removeVisual(self)
	}
	method accionCabezal(){
		cabezal.plantar()
	}
	
	method explotar(algo){}
	method recolectar(sol){}


	method serImpactado(algo){}
	method accionar(posicion){
		game.onCollideDo(self, {o => o.parar()})
	}
	method recibirAtaque(zombie){
		salud = salud - zombie.damage()
		if(salud <= 0){
			self.morir()
		}
	}
	method morir(){
		game.colliders(self).forEach({o => o.continuar()})
		self.serDesplantado()
		
	}
	
	
}

class Girasol inherits Planta(costoSoles = 50, nombrePlanta = "girasol"){
	
	method nuevaPlanta(posicion) = new Girasol(position = posicion)
	
	override method accionar(posicion){
		super(posicion)
		game.onTick(10000, "generarSoles" + id.toString(), {self.generarSoles()})
	}
	
	method generarSoles(){
			const solCreado = new Sol(position = position, idSol = gestorIds.nuevoId())
			game.addVisual(solCreado)
			solCreado.accionar()
			
	}

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
		super(posicion)
		self.modoExplosion()
	}
	
	method modoExplosion(){
		game.onCollideDo(self, {z => z.explotar(self)})
	}
	
	method explotar(){
		game.colliders(self).forEach({o => o.recibirDanio(damage)})
		self.serDesplantado()
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
		super(posicion)
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
		game.onTick(200,"ataqueEspinas" +id.toString() ,{self.atacar()})
	}
	
	method atacar(){
		game.colliders(self).forEach({o => o.recibirDanio(damage)})
	}
	
	
	override method serDesplantado(){
		super()
		game.removeTickEvent("ataqueEspinas" + id.toString())
	}
	override method recibirAtaque(zombie){}
	
	method destruir(){}
}

//generados por plantas


class Sol {
		var property idSol = gestorIds.nuevoId()
	var property gestorAnimacion = new GestorAnimacion (imagenBase = "otros/sol_f", idanim = idSol)
	var property position

	

	method image() = gestorAnimacion.image()
	method continuar(){}
	method accionar(){
		game.onCollideDo(self, { p => p.recolectar(self)})
	}
	
	method recolectar(sol){}
		
	method recibirAtaque(a){}
	method parar(){}
	method serDesplantado(){}
	method serImpactado(algo){}
	method recibirDanio(a){}
	method destruir(){
		gestorAnimacion.eliminarTick()
		game.removeVisual(self)
	}
	
}




class ProyectilGuisanteDoble inherits ProyectilGuisante{
	override method initialize(){
		super()
		damage = 20
		imagen = "imgPlantas/guisanteDoble_proyectil.png"
	}
	
	
}


class ProyectilGuisante{
	var property position
	var property posicionInicial
	var property damage = 10
	var property imagen = "imgPlantas/guisante_proyectil.png"
	const idGuisante = gestorIds.nuevoId()

	method recibirAtaque(a){}
	method serImpactado(algo){}
	method recibirDanio(a){}
	method initialize(){
		game.onTick(250,"movimientoGuisante"+ idGuisante.toString(),{self.moverDerecha()})
	}
	
	method image() = imagen
	method parar(){}
	method moverDerecha(){
		if ((position.x() >= posicionInicial.x() +9) || position.x() >= 18 ){
			self.delete()
		}
		else
		{
			position = game.at(position.x()+1,position.y())
		}
		
		
	}
	method recolectar(sol){}
	method serDesplantado(){}	
	method delete(){
		if(game.hasVisual(self)){
			game.removeVisual(self)
			game.removeTickEvent("movimientoGuisante" + idGuisante)
		}
		
		}
	
}

