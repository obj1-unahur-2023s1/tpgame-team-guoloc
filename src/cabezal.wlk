import wollok.game.*
import plantas.*
import logoPlanta.*

object cabezal {
	//Selector de celdas para poner/sacar las plantas y realizar otras acciones
	var property position = game.at(3, 3)
	var property planta = ningunaPlanta //planta seleccionada para plantar
	var property soles = 0 //cantidad de soles disponibles para gastar
	var property image = planta.imagenCabezal()
	var property cantidadPlantas = 0
	
	
	method esPlanta() = false
	method serImpactado(algo){}
	
	method configurarTareas(){
		//Añadir los eventos de teclado
		keyboard.space().onPressDo{planta.accionCabezal()}
		keyboard.z().onPressDo{indicadorSoles.aumentarSoles(11)} //Para probar como se ven los numeros de la cantidad de soles
		keyboard.x().onPressDo{indicadorSoles.sacarSoles(10)}
		keyboard.e().onPressDo{cabezalDeSeleccion.moverIzquierda()}
		keyboard.q().onPressDo{cabezalDeSeleccion.moverDerecha()}
		keyboard.t().onPressDo{game.addVisual(new Sol(position = self.position(), idSol = 10000.randomUpTo(100000)))}
		
	}
	
	
	method cambiarPlanta(nuevaPlanta){
		//Cambiar la planta seleccionada para plantar
		planta = nuevaPlanta
		image = planta.imagenCabezal()
	}
	
	method plantar(){
		//Plantar una planta si se puede, sino no hace nada
		if(self.sePuedePlantarEn(self.position()) and self.tieneSolesSuficientes()){
			planta.position(self.position())
			game.addVisualIn(planta,self.position())
			self.inicializarPlanta()
			indicadorSoles.sacarSoles(planta.costoSoles())
			self.cambiarPlanta(planta.nuevaPlanta(self.position()))
		}
	}
	
	method inicializarPlanta(){
			planta.id(cantidadPlantas * 100)
			cantidadPlantas += 1
			planta.accionar(self.position())
	}
	
	method desplantar(){
		//Desplantar los TODOS los objetos de la posicion actual
		self.position().allElements().forEach{e=>e.serDesplantado()}
	}
	
	method serDesplantado(){}
	method recolectarSol(sol){sol.serRecolectado()}
	method sePuedePlantarEn(posicion) = self.laCeldaEstaVacia() and self.laPosicionEsValida(posicion) and planta!=ningunaPlanta
	method plantasEnElCollider()= game.colliders(self).filter({o => o.esPlanta()}).size()
	method laCeldaEstaVacia() = self.plantasEnElCollider() == 0
	method laPosicionEsValida(posicion) = posicion.y()!=7 and posicion.y()!=0  and posicion.x() > 0 and posicion.x() < 14
	method laPlantaSeleccionadaEsValida() = planta!=pala and planta!=ningunaPlanta
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
	
}

object administradorDeCabezal{
	const objetosParaCabezal= [new Girasol(position = game.at(0,0)), new Guisante(position = game.at(0,0)), new PapaMina(position = game.at(0,0)), new Nuez(position = game.at(0,0)),new GuisanteDoble(position = game.at(0,0)),new Espinas(position = game.at(0,0)), pala ]
	method objetoCabezal(indice) = objetosParaCabezal.get(indice).nuevaPlanta(cabezal.position())
	
}