import wollok.game.*
import plantas.*
import logoPlanta.*

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
		keyboard.z().onPressDo{indicadorSoles.aumentarSoles(11)} //Para probar como se ven los numeros de la cantidad de soles
		keyboard.x().onPressDo{indicadorSoles.sacarSoles(10)}
		keyboard.w().onPressDo{cabezalDeSeleccion.moverIzquierda()}
		keyboard.q().onPressDo{cabezalDeSeleccion.moverDerecha()}
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
	

	
	
}

object cabezalDeSeleccion{
	var property position = game.at(1, 7)
	
	method image() = "cabezal.png"
	
	method cambiarObjetoCabezal(){
		cabezal.cambiarPlanta(administradorDeCabezal.objetoCabezal(position.x()-1))
	}
	
	method moverIzquierda(){
		if(position.x() == 7){
			position = game.at(1,7)
		}
		else{
			position = game.at(position.x()+1,7)
		}
			
		self.cambiarObjetoCabezal()
	}
	
	method moverDerecha(){
		if(position.x() == 1){
			position = game.at(7,7)
		}
		else{
			position = game.at(position.x()-1,7)
		}
		
		self.cambiarObjetoCabezal()
	}
	
}

object administradorDeCabezal{
	const objetosParaCabezal= [new Girasol(), new Guisante(), new PapaMina(), new Nuez(),new GuisanteDoble(),new Espinas(), pala ]
	method objetoCabezal(indice) = objetosParaCabezal.get(indice).nuevaPlanta()
	
}