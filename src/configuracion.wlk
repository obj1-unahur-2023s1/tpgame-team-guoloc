import wollok.game.*
import cabezal.*
import logoPlanta.*

object configuracion{
	//Realizar las acciones de configuracion del juego
	
	method configurarResolucionPantalla(){
		//Configurar la resolucion del juego y el tamaño de las celdas
		//Resolucion del juego: 1280x512
		game.width(18)
		game.height(8)
		game.cellSize(64)
	}
	
	
	method agregarVisuales(){
		//Agregar los visuales iniciales al juego
		game.boardGround("fondo.png")
		game.addVisualCharacter(cabezal)
		game.addVisual(cabezalDeSeleccion)
	}
	
	method agregarTareas(){
		//Agregar las tareas/eventos de los objetos del juego
		cabezal.configurarTareas()
	}
	
	method agregarLogosPlantas(){
		//Agregar los logos de las plantas donde nos posicionamos para cambiar de planta
		//Esto esta re casero es para ver como queda nomas (nacho no me castresa)
		game.addVisual(indicadorSoles)
		game.addVisual(unidadesCantidadSoles)
		game.addVisual(decenasCantidadSoles)
		game.addVisual(centenasCantidadSoles)
		game.addVisual(new LogoPlanta(nombrePlanta="girasol", x=1))
		game.addVisual(new LogoPlanta(nombrePlanta="guisante", x=2))
		game.addVisual(new LogoPlanta(nombrePlanta="papa", x=3))
		game.addVisual(new LogoPlanta(nombrePlanta="nuez", x=4))
		game.addVisual(new LogoPlanta(nombrePlanta="guisanteDoble", x=5))
		game.addVisual(new LogoPlanta(nombrePlanta="espinas", x=6))
		game.addVisual(new LogoPlanta(nombrePlanta="pala", x=7))
	}
	
	
}