import wollok.game.*

class Zombie {
	var property vida = 100
	var property positionX = 20
	var property positionY = 0.randomUpTo(5).truncate(0)
	var property position = game.at(positionX, positionY)
	
	method initialize() {
		game.onTick(1200, "zombieMovin" , {self.moverse()})
		game.whenCollideDo(self, {self.atacar()})
	}
	
	method moverse() { self.position(position.left(1)) }
	
	method atacar() {
		game.onTick(1000, "zombieAtack", {game.colliders(self).recibirAtaque()})
	}
	
	method recibirAtaque() {}
		
	method morir() {
		if (vida == 0) {
			game.removeTickEvent("zombieMovin")
			game.removeVisual(self)
		}
	}
}

class ZombieNormal inherits Zombie {
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_n_f")
	
	method image() = imagenActual.image()
	
	method initialize() {
		game.onTick(1200, "zombieMovin" , {self.moverse()})
	}
}

class ZombieConoDeTransito inherits Zombie {
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_ch_f")
	
	method image() = imagenActual.image()
	
	method initialize() {
		game.onTick(1200, "zombieMovin" , {self.moverse()})
	}
}

class ZombieBucketHead inherits Zombie {
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_bh_f")
	
	method image() = imagenActual.image()
	
	method initialize() {
		game.onTick(1200, "zombieMovin" , {self.moverse()})
	}
}

class GestorAnimacion{
	var frameActual = 0
	const imagenBase
	
	method initialize(){
		game.onTick(400, "animacionIdle", {self.cambiarFrame()})
	}

	method cambiarFrame(){frameActual = self.frameOpuesto()}
	method frameOpuesto() = if(frameActual==0) 1 else 0
	method image() = imagenBase + frameActual.toString() + ".png"
}