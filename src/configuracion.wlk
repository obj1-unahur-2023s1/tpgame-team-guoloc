import wollok.game.*
import cabezal.*

object configuracion{
	//Realizar las acciones de configuracion del juego
	
	method configurarPantalla(){
		//Configurar la resolucion del juego y el tamaño de las celdas
		//Resolucion del juego: 1280x512
		game.width(20)
		game.height(8)
		game.cellSize(64)
	}
	
	
	method agregarVisuales(){
		//Agregar los visuales iniciales al juego
		game.boardGround("fondo.png")
		game.addVisualCharacter(cabezal)
	}
	
	method agregarTareas(){
		//Agregar las tareas/eventos de los objetos del juego
		cabezal.configurarTareas()
	}
	
	
}