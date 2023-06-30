import wollok.game.*
import plantas.*
import logoPlanta.*
import gestores.*

object cabezal {
	//Selector de celdas para poner/sacar las plantas y realizar otras acciones
	var property id = 0
	var property position = game.at(3, 3)
	var property planta = administradorDeCabezal.objetoCabezal(0) //planta seleccionada para plantar
	var property soles = 0 //cantidad de soles disponibles para gastar
	var property image = planta.imagenCabezal()
	method serImpactado(algo){}
	method recibirDanio(danio){}
	method recibirAtaque(algo){}
	method configurarTareas(){
		//Añadir los eventos de teclado
		keyboard.space().onPressDo{planta.accionCabezal()}
		keyboard.e().onPressDo{cabezalDeSeleccion.moverIzquierda()}
		keyboard.q().onPressDo{cabezalDeSeleccion.moverDerecha()}
	}
	
	method parar(){}
	method cambiarPlanta(nuevaPlanta){
		//Cambiar la planta seleccionada para plantar
		planta = nuevaPlanta
		image = planta.imagenCabezal()
	}
	
	method plantar(){
		//Plantar una planta si se puede, sino no hace nada
		if(self.sePuedePlantarEn(self.position()) and self.tieneSolesSuficientes()){
			planta.position(self.position())
			game.addVisual(planta)
			self.inicializarPlanta()
			indicadorSoles.sacarSoles(planta.costoSoles())
			self.cambiarPlanta(planta.nuevaPlanta(self.position()))
		}
	}
	
	method inicializarPlanta(){
			planta.accionar(self.position())
	}
	
	method desplantar(){
		//Desplantar los TODOS los objetos de la posicion actual
		self.position().allElements().forEach{e=>e.serDesplantado()}
	}
	
	method recolectar(sol){
		indicadorSoles.aumentarSoles(25)
		sol.destruir()
	}
	
	
	method serDesplantado(){}
	method sePuedePlantarEn(posicion) = self.laCeldaEstaVacia() and self.laPosicionEsValida(posicion) 
	method laCeldaEstaVacia() = game.colliders(self).size() == 0
	method laPosicionEsValida(posicion) = posicion.y()!=7 and posicion.y()!=0  and posicion.x() > 0 and posicion.x() < 14
	method tieneSolesSuficientes() = indicadorSoles.cantidadSoles()>=planta.costoSoles()
	
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
	method serDesplantado(){}
	method parar(){}
}

object administradorDeCabezal{
	const objetosParaCabezal= [new Girasol(position = game.at(0,0)), new Guisante(position = game.at(0,0)), new PapaMina(position = game.at(0,0)), new Nuez(position = game.at(0,0)),new GuisanteDoble(position = game.at(0,0)),new Espinas(position = game.at(0,0)), pala ]
	method objetoCabezal(indice) = objetosParaCabezal.get(indice).nuevaPlanta(cabezal.position())
	
}