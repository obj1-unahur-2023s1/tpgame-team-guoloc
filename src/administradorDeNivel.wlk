import wollok.game.*
import configuracion.*
import cabezal.*

object administradorDeNivel {
	
	var property indiceNivelActual = 0
	
	method configurarInputs(){
		//Configurar los inputs del administrador de nivel. 
		keyboard.a().onPressDo{if(indiceNivelActual==0){self.cargarNivelPantallaInicio()}} //Ir de pantalla de inicio a pantalla de juego
	}
	method cargarNivelPantallaInicio(){
		//Cargar los visuals y fondo de la pantalla de inicio
		indiceNivelActual = 0
		game.boardGround("pantalla_inicio.png")
	}
	
	method cargarNivelPantallaJuego(){
		//Cargar los visuals y fondo de la pantalla de juego (donde plantamos)
		game.boardGround("fondo.png")
		game.addVisualCharacter(cabezal)
		game.addVisual(cabezalDeSeleccion)
		configuracion.agregarTareas()
		configuracion.agregarLogosPlantas()
		indiceNivelActual = 1
	}
	
	method cargarNivelPantallaGameOver(){
		//Cargar los visuals de la pantalla de game over
		game.clear()
		indiceNivelActual = 2
		game.boardGround("pantalla_gameOver.png")
	}
	

}
