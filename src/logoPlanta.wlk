import wollok.game.*

class LogoPlanta {
	//Logo donde posicionaremos el cabezal para cambiar la planta elegida
	const x
	const nombrePlanta
	var property image = "logosPlantas/logo_"+nombrePlanta+"_0.png"
	var property position = game.at(x,7)

	method serDesplantado(){}
	method recolectar(sol){}
	
}


object indicadorSoles{
	var property image = "otros/logo_sol.png"
	var property cantidadSoles = 200
	var property position = game.at(0,7)
	
	method aumentarSoles(cantidad){
		cantidadSoles = (cantidadSoles + cantidad).min(999)
	}		
	method sacarSoles(cantidad){
		cantidadSoles = (cantidadSoles - cantidad).max(0)
	}
	method cantidadSoles(cantidad){
		cantidadSoles = cantidad
	}

	method serDesplantado(){}

}

class HUDSoles{
	var property position = game.at(0,7)
	const property desc
	method image() = "otros/numeros/" + self.desc() + self.cantidad().toString()+".png"
	method serDesplantado(){}
	method cantidad()

}



object centenasCantidadSoles inherits HUDSoles(desc = "centenas_"){

	override method cantidad() = (indicadorSoles.cantidadSoles()/100).truncate(0) 
	
}

object decenasCantidadSoles inherits HUDSoles(desc = "decenas_"){

	override method cantidad() = ((indicadorSoles.cantidadSoles() - centenasCantidadSoles.cantidad()*100)/10).truncate(0)
}

object unidadesCantidadSoles inherits HUDSoles(desc = "unidad_"){
	override method cantidad() = (indicadorSoles.cantidadSoles() - (centenasCantidadSoles.cantidad()*100) - (decenasCantidadSoles.cantidad()*10))
	
}