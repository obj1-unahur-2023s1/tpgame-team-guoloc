import wollok.game.*
import configuracion.*
import cabezal.*

object administradorDeNivel {
	
	var property indiceNivelActual = 0
	const logoPrincipal = new LogoPrincipal(position=game.at(4,0), image="pantalla_inicio.png")
	
	method configurarInputs(){
		//Configurar los inputs del administrador de nivel. 
		keyboard.space().onPressDo{if(indiceNivelActual==0){self.cargarNivelPantallaJuego()}} //Ir de pantalla de inicio a pantalla de juego
	}
	method cargarNivelPantallaInicio(){
		//Cargar los visuals y fondo del juego
		game.boardGround("fondo.png")
		game.addVisual(logoPrincipal)
		indiceNivelActual = 0
		game.schedule(100, {administradorMusica.iniciarMusica()}) //esto esta en administrador de nivel
		
	}
	
	method cargarNivelPantallaJuego(){
		//Cargar los visuals de la pantalla de juego (donde plantamos)
		game.removeVisual(logoPrincipal)
		game.addVisualCharacter(cabezal)
		game.addVisual(cabezalDeSeleccion)
		configuracion.agregarTareas()
		configuracion.agregarLogosPlantas()
		indiceNivelActual = 1
	}
	
	method cargarNivelPantallaGameOver(){
		//Cargar los visuals de la pantalla de game over
		game.clear()
		game.addVisual(new LogoPrincipal(position=game.center(), image="pantalla_gameOver.png"))
		indiceNivelActual = 2
	}
	

}

class LogoPrincipal{
	var property position
	var property image
}

object administradorMusica{
	const musicaFondo = game.sound("mus_spider.mp3")
	method iniciarMusica(){
		musicaFondo.volume(0.1)
		musicaFondo.play()
		musicaFondo.resume()
		
	}
}
