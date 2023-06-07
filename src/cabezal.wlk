import wollok.game.*
import plantas.*

object cabezal {
	//Selector de celdas para poner/sacar las plantas y realizar otras acciones
	var property position = game.at(3, 3)
	var property planta = ningunaPlanta //planta seleccionada para plantar
	var property soles = 0 //cantidad de soles disponibles para gastar
	var property image = planta.imagenCabezal()
	
	method configurarTareas(){
		//Añadir los eventos de teclado
		keyboard.num1().onPressDo{self.cambiarPlanta(new Girasol())}
		keyboard.num2().onPressDo{self.cambiarPlanta(new Guisante())}
		keyboard.num3().onPressDo{self.cambiarPlanta(new PapaMina())}
		keyboard.num4().onPressDo{self.cambiarPlanta(new Nuez())}
		keyboard.num5().onPressDo{self.cambiarPlanta(new GuisanteDoble())}
		keyboard.num6().onPressDo{self.cambiarPlanta(new Espinas())}
		keyboard.num7().onPressDo{self.cambiarPlanta(pala)}
		keyboard.a().onPressDo{if (self.laPlantaSeleccionadaEsValida())self.plantar()}
		keyboard.d().onPressDo{self.desplantar()}
	}
	
	
	method cambiarPlanta(nuevaPlanta){
		//Cambiar la planta seleccionada para plantar
		planta = nuevaPlanta
		image = planta.imagenCabezal()
	}
	
	method plantar(){
		//Plantar una planta si se puede, sino no hace nada
		if(self.sePuedePlantarEn(self.position())){
			game.addVisualIn(self.planta(), self.position());
			self.cambiarPlanta(ningunaPlanta)
		}
	}
	
	method desplantar(){
		//Desplantar los TODOS los objetos de la posicion actual
		game.getObjectsIn(position)
	}
	
	
	method sePuedePlantarEn(posicion) = self.laCeldaEstaVacia() and self.laPosicionEsValida(posicion) and planta!=ningunaPlanta
	method laCeldaEstaVacia() = game.colliders(self).size()<1
	method laPosicionEsValida(posicion) = posicion.y()!=7 and posicion.y()!=0  and posicion.x()>0
	method laPlantaSeleccionadaEsValida() = planta!=pala and planta!=ningunaPlanta
	

	
	// Pegar acá todo lo que tenían de Toni en la etapa 1
}