import wollok.game.*
import plantas.*
import gestores.*

class Zombie {
	var property id = gestorIds.nuevoId()
	var property salud = 100
	var property positionX = 20
	var property positionY = 1.randomUpTo(5).truncate(0)
	var property position = game.at(positionX, positionY)
	var moving = true
	var ataque = false
	
	method cambiarAtaque(){
		ataque = not ataque
	}
	
	method esZombie() = true
	
	method continuar(){
		moving = true
	}
	
	method moverse() { 
		if (moving) {
			self.position(position.left(1))
		}
	}
	
	
	method parar(){
		
		if(self.colisionaConPlanta()){
			moving = false
		}
			
	}
	
	method atacar(){
		if(not ataque){
			game.colliders(self).filter({p => p.esPlanta()}).forEach({p => p.recibirDanio(30)})
		}
		
	}
	
	method serImpactado(algo) { 
		salud = (salud - algo.damage()).max(0)
		self.muerte()
		algo.destruir()
	}
	
	method esPlanta() = false

	method muerte() {
		if (salud == 0) {
			game.removeTickEvent("moverZombie")
			game.removeVisual(self)
		}
	}
	method colisionaConPlanta() =
		game.colliders(self).any({p => p.esPlanta()})
}

class ZombieNormal inherits Zombie {
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombieSimple_f")
	
	method image() = imagenActual.image()
}

class ZombieConoDeTransito inherits Zombie {
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_bh_f")
	
	method image() = imagenActual.image()
}

class ZombieBucketHead inherits Zombie {
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_bh_f")
	
	method image() = imagenActual.image()
}

object configuracionZombie inherits Zombie {
	const zombie = new ZombieNormal()
	
	method spawnearZombie() {
			game.addVisual(zombie)
			game.onTick(800, "moverZombie" + zombie.id().toString(), {zombie.moverse()})
			game.onTick(2000, "zombieAtaque" + zombie.id().toString(), {zombie.cambiarAtaque()})
			game.whenCollideDo(zombie, {p => zombie.parar()})
			game.whenCollideDo(zombie, {p => zombie.atacar()}) 
	}
}