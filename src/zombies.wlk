import wollok.game.*
import plantas.*
import gestores.*
import administradorDeNivel.*

class Zombie {
	var property id = gestorIds.nuevoId()
	var property salud = 25
	var property positionX = 19
	var property positionY = 1.randomUpTo(7).truncate(0)
	var property position = game.at(positionX, positionY)
	var moving = true
	var property nombreZombie
	var property gestorAnimacion = new GestorAnimacion(imagenBase = self.imagenBase(), idanim = id)
	var property damage = 5
	
	method imagenBase() = "zombies/"+nombreZombie+"_f"
	method imagenComiendo() = "zombies/"+nombreZombie+"_comiendo_f"
	method image() = gestorAnimacion.image()
	method refrescarImagen(){gestorAnimacion = new GestorAnimacion(imagenBase = self.imagenBase(), idanim = id)}
	method text() = salud.toString()
	method textColor() = "FFFFFF"
	method recibirAtaque(algo){}
	method serDesplantado(){self.continuar()}
	method recolectar(sol){}
	
	method atacar(){
		game.colliders(self).forEach({p => p.recibirAtaque(self)})
	}
	
	method moverse() { 
		if (moving) {
			self.avanzarALaIzquierda(1)
			self.perderSiLlegoAlFinal()
		}
	}
	
	
	method serImpactado(algo) { 
		self.recibirDanio(algo.damage())
		algo.delete()
	}
	
	

	method muerte() {
		if (salud <= 0) {
			game.removeTickEvent("moverZombie" + self.id().toString())
			game.removeTickEvent("zombieAtaque" + self.id().toString() )
			gestorAnimacion.eliminarTick()
			game.removeVisual(self)
		}
	}
	
	method continuar(){
			moving = true
			gestorAnimacion.eliminarTick()
			gestorAnimacion = new GestorAnimacion(imagenBase = self.imagenBase(), idanim = id)
	}
	
	method parar(){
		if(moving){
			moving = false
			gestorAnimacion.eliminarTick()
			gestorAnimacion = new GestorAnimacion(imagenBase = self.imagenComiendo(), idanim = id)
		}	
	}
	
	
	method perderSiLlegoAlFinal(){
		if(self.position().x() < 0)
			administradorDeNivel.cargarNivelPantallaGameOver()
	}
	
	method avanzarALaIzquierda(cantidad){
		self.position(position.left(cantidad))
	} 
	
	method puedeSubir() = self.position().y() < 6
	method puedeBajar() = self.position().y() > 1
	

	method recibirDanio(danio) {
		salud = (salud - danio).max(0)
		self.muerte()
	}
	
	method explotar(algo){
		algo.explotar()
	}
}

class ZombieNormal inherits Zombie(nombreZombie = "zombieSimple") {
	method nuevoZombie() = new ZombieNormal()
	
}

class ZombieConoDeTransito inherits Zombie(salud = 40, nombreZombie = "zombie_ch"){
	method nuevoZombie() = new ZombieConoDeTransito()
	
	//10% de probabilidad de bajar una casilla al avanzar 
	override method avanzarALaIzquierda(cantidad){
		super(cantidad)
		const n = 1.randomUpTo(11).truncate(0)
		if ((n==5) and self.puedeBajar())
			self.position(position.down(cantidad))
	}
	
}

class ZombieBucketHead inherits Zombie(salud = 50,  nombreZombie = "zombie_bh") {

	method nuevoZombie() = new ZombieBucketHead()
	
	//5% de probabilidad de subir una casilla al avanzar 
	override method avanzarALaIzquierda(cantidad){
		super(cantidad)
		const n = 1.randomUpTo(21).truncate(0)
		if ((n==5) and self.puedeSubir())
			self.position(position.up(cantidad))
	}
}

object configuracionZombie{
	
	const zombie = new ZombieNormal()
	
	method spawnearZombie() {
			game.addVisual(zombie)
			game.onTick(800, "moverZombie" + zombie.id().toString(), {zombie.moverse()})
			game.onTick(2000, "zombieAtaque" + zombie.id().toString(), {zombie.atacar()})
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
	}
	
	
}
