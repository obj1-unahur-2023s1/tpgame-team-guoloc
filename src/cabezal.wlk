import wollok.game.*
import plantas.*

object cabezal {
	//Selector de celdas para poner/sacar las plantas y realizar otras acciones
	const property image = "cabezal.png"
	var property position = game.at(3, 3)
	var property planta = new Girasol() //planta seleccionada para plantar
	var property soles = 0 //cantidad de soles disponibles para gastar
	
	method configurarTareas(){
		//Añadir los eventos de teclado
		keyboard.w().onPressDo{self.cambiarPlanta(new Guisante())}
		keyboard.s().onPressDo{self.cambiarPlanta(new PapaMina())}
		keyboard.a().onPressDo{self.plantar()}
		keyboard.d().onPressDo{self.desplantar()}
	}
	
	
	method cambiarPlanta(nuevaPlanta){
		//Cambiar la planta seleccionada para plantar
		planta = nuevaPlanta
	}
	
	method plantar(){
		//Plantar una planta si se puede, sino no hace nada
		if(self.sePuedePlantarEn(self.position())){
			game.addVisualIn(self.planta(), self.position());
			self.planta(self.planta().nuevaPlanta())
		}
	}
	
	method desplantar(){
		//Desplantar los TODOS los objetos de la posicion actual
		game.getObjectsIn(position)
	}
	
	
	method sePuedePlantarEn(posicion) = self.laCeldaEstaVacia() and self.laAlturaEsValida(posicion)
	method laCeldaEstaVacia() = game.colliders(self).size()<1
	method laAlturaEsValida(posicion) = posicion.y()!=7 and posicion.y()!=0 
	

	
	// Pegar acá todo lo que tenían de Toni en la etapa 1
}