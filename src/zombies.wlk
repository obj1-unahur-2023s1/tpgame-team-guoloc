import wollok.game.*
import plantas.*
import gestores.*
import administradorDeNivel.*

class Zombie {
	var property id = gestorIds.nuevoId()
	var property salud = 25
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
	method recolectar(sol){}
	

	
	method moverse() { 
		if (moving) {
			self.position(position.left(1))
			if(self.position().x() < 0)
				administradorDeNivel.cargarNivelPantallaGameOver()
		}
	}
	
	
	
	method parar(){
	}
	
	method atacar(){
			self.plantasAtacables().forEach({p => p.recibirDanio(10)})	
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
	
	method nuevoZombie() = new ZombieNormal()
}

class ZombieConoDeTransito inherits Zombie(salud = 40){
	var property imagenActual = new GestorAnimacion(imagenBase = "zombies/zombie_ch_f")
	
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
	
	method nuevoZombie() = new ZombieConoDeTransito()
}

class ZombieBucketHead inherits Zombie(salud = 50) {
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
	
	method nuevoZombie() = new ZombieBucketHead()
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

object spawnZombies{
	const zombiesPosibles = [new ZombieNormal(), new ZombieBucketHead(), new ZombieConoDeTransito()]
	const listaZombies = []
	var segsEntreZombies = 10
	const cantZombies = 10
	
	method esperarYComenzarAtaque(segs){
		game.schedule(segs*1000, { => self.iniciarSpawn() })
	}
	
	method generarListaZombiesRandom(){
		(1..cantZombies).forEach{x => listaZombies.add(zombiesPosibles.anyOne().nuevoZombie())}
	}
	
	method iniciarSpawn(){
		self.generarListaZombiesRandom()
		game.onTick(segsEntreZombies*1000 , "crearZombie", {self.crearZombie()})
	}
	
	method crearZombie(){
		if (listaZombies.isEmpty()){
			administradorDeNivel.cargarNivelPantallaVictoria()
		}
		else{
			self.ponerZombieEnNivel(listaZombies.first())
			listaZombies.remove(listaZombies.first())
			segsEntreZombies = (segsEntreZombies-0.5).max(5)	
		}
	}
	
	method ponerZombieEnNivel(zombie){
		game.addVisual(zombie)
		game.onTick(800, "moverZombie" + zombie.id().toString(), {zombie.moverse()})
		game.onTick(2000, "zombieAtaque" + zombie.id().toString(), {zombie.atacar()})
		game.whenCollideDo(zombie, {p => zombie.parar()})
	}
	
	
}
