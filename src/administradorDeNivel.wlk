import wollok.game.*
import configuracion.*
import cabezal.*
import zombies.*
import logoPlanta.*

object administradorDeNivel {
	
	var property indiceNivelActual = 0
	const logoPrincipal = new LogoPrincipal(position=game.at(4,0), image="pantalla_inicio.png")
	
	method configurarInputs(){
		//Configurar los inputs del administrador de nivel. 
		keyboard.enter().onPressDo{if(indiceNivelActual!=1){self.cargarNivelPantallaJuego()}} //Ir de pantalla de inicio a pantalla de juego
	}
	method cargarNivelPantallaInicio(){
		//Cargar los visuals y fondo del juego
		game.boardGround("fondo.png")
		game.addVisual(logoPrincipal)
		indiceNivelActual = 0
		game.schedule(100, {administradorMusica.iniciarMusicaInicio()}) //esto esta en administrador de nivel
		
	}
	
	method cargarNivelPantallaJuego(){
		//Cargar los visuals de la pantalla de juego (donde plantamos)
		game.clear()
		game.schedule(100, {administradorMusica.iniciarMusicaJuego()})
		game.addVisualCharacter(cabezal)
		game.addVisual(cabezalDeSeleccion)
		configuracion.agregarTareas()
		configuracion.agregarLogosPlantas()
		indiceNivelActual = 1
		spawnZombies.esperarYComenzarAtaque(3)
		
	}
	
	method cargarNivelPantallaGameOver(){
		//Cargar los visuals de la pantalla de game over
		game.clear()
		administradorMusica.pararMusica()
		game.addVisual(new LogoPrincipal(position=game.at(4,0), image="pantalla_gameOver.png"))
		indiceNivelActual = 2
		self.configurarInputs()
		indicadorSoles.cantidadSoles(200)
		spawnZombies.reiniciarZombies()
	}
	
	method cargarNivelPantallaVictoria(){
		//Cargar los visuals de la pantalla de game over
		game.clear()
		administradorMusica.pararMusica()
		game.addVisual(new LogoPrincipal(position=game.at(4,0), image="pantalla_victoria.png"))
		indiceNivelActual = 3
		self.configurarInputs()
		indicadorSoles.cantidadSoles(200)
		spawnZombies.reiniciarZombies()
	}
		
}

class LogoPrincipal{
	var property position
	var property image
	
}

object administradorMusica{
	var musicaFondo
	
	method iniciarMusicaInicio(){
		musicaFondo = game.sound("sonido/mus_inicio.mp3")
		musicaFondo.volume(0.3)
		musicaFondo.shouldLoop(true)
		musicaFondo.play()
	}
	

	method iniciarMusicaJuego(){
		musicaFondo.stop()
		musicaFondo = game.sound("sonido/mus_juego.mp3")
		musicaFondo.shouldLoop(true)
		musicaFondo.volume(0.3)
		musicaFondo.play()
	}
	
	method pararMusica(){
		musicaFondo.stop()
	}
}
