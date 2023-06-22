import wollok.game.*
import plantas.*
import gestores.*

class Zombie {
	var property salud = 100
	var property positionX = 20
	var property positionY = 1.randomUpTo(5).truncate(0)
	var property position = game.at(positionX, positionY)
	var moving = true
	
	method moverse() { 
		if (moving) {
			self.position(position.left(1))
		}
	}
	
	method atacar(planta) {
		if (planta.esPlanta()) {
			moving = false
			game.onTick(1500, "zombieAtaque", {planta.recibirDanio(25)})
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
			game.onTick(800, "moverZombie", {zombie.moverse()})
			game.whenCollideDo(zombie, {p => zombie.atacar(p)}) 
	}
}