import wollok.game.*
import plantas.*
import gestores.*

class Zombie {
	var property id = gestorIds.nuevoId()
	var property salud = 5000
	var property positionX = 20
	var property positionY = 1.randomUpTo(5).truncate(0)
	var property position = game.at(positionX, positionY)
	var moving = true

	
	method text() = salud.toString()
	method esZombie() = true
	method esSol() = false
	method esPlanta() = false
	method serDesplantado(){}
	method esCabezal() = false
	

	
	method moverse() { 
		if (moving) {
			self.position(position.left(1))
		}
	}
	
	
	method parar(){
	}
	
	method atacar(){
			self.plantasAtacables().forEach({p => p.recibirDanio(30)})	
	}
	
	method serImpactado(algo) { 
		salud = (salud - algo.damage()).max(0)
		self.muerte()
		algo.destruir()
	}
	
	

	method muerte() {
		if (salud == 0) {
			game.removeTickEvent("moverZombie" + self.id().toString())
			game.removeTickEvent("zombieAtaque" + self.id().toString() )
			game.removeVisual(self)
		}
	}
	
	method plantasEnPosicion() = game.colliders(self).filter({p => p.esPlanta()})
	method plantasAtacables() = self.plantasEnPosicion().filter({p => p.detieneMovimiento()})
	method colisionaConPlantaAtacable() = self.plantasAtacables().size() > 0
	
}

class ZombieNormal inherits Zombie {
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombieSimple_f")
	
	method continuar(){
			moving = true
			imagenActual = new GestorAnimacion(imagenBase = "zombies/zombieSimple_f")
	}
	
	
	override method parar(){
		if(self.colisionaConPlantaAtacable() && moving){
			moving = false
			imagenActual = new GestorAnimacion(imagenBase = "zombies/zombieSimple_Comiendo_f")
		}	
	}
	
	method image() = imagenActual.image()
}

class ZombieConoDeTransito inherits Zombie {
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_bh_f")
	
	method image() = imagenActual.image()
	
	method continuar(){
			moving = true
			imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_ch_f")
	}
	
	override method parar(){
		if(self.colisionaConPlantaAtacable() && moving){
			moving = false
			imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_ch_Comiendo_f")
		}	
	}
}

class ZombieBucketHead inherits Zombie {
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_bh_f")
	
	method image() = imagenActual.image()
	
	method continuar(){
			moving = true
			imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_bh_f")
	}
	
	override method parar(){
		if(self.colisionaConPlantaAtacable() && moving){
			moving = false
			imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_bh_Comiendo_f")
		}	
	}
}

object configuracionZombie inherits Zombie {
	const zombie = new ZombieNormal()
	
	method spawnearZombie() {
			game.addVisual(zombie)
			game.onTick(800, "moverZombie" + zombie.id().toString(), {zombie.moverse()})
			game.onTick(2000, "zombieAtaque" + zombie.id().toString(), {zombie.atacar()})
			game.whenCollideDo(zombie, {p => zombie.parar()})

	}
}