import wollok.game.*

class LogoPlanta {
	//Logo donde posicionaremos el cabezal para cambiar la planta elegida
	const x
	const nombrePlanta
	var property image = "logosPlantas/logo_"+nombrePlanta+"_0.png"
	var property position = game.at(x,7)
	method esZombie() = false
	method esSol() = false
	method esPlanta() = false
	method serDesplantado(){}
	method recolectar(sol){}
	
}


object indicadorSoles{
	var property image = "otros/logo_sol.png"
	var property cantidadSoles = 200
	var property position = game.at(0,7)
	method refrescarNumeros(){
		centenasCantidadSoles.refrescarNumero()
		decenasCantidadSoles.refrescarNumero()
		unidadesCantidadSoles.refrescarNumero()
	}
	
	method aumentarSoles(cantidad){
		if ((cantidadSoles+cantidad)>999)
			cantidadSoles = 999
		else
			cantidadSoles+=cantidad
		self.refrescarNumeros()
	}		
	method sacarSoles(cantidad){
		if ((cantidadSoles-cantidad)<0)
			cantidadSoles = 0
		else
			cantidadSoles-=cantidad
		self.refrescarNumeros()
	}	
	method centenas() = (cantidadSoles/100).truncate(0) 	//Describe la cantidad de centeas de la cantidad de soles - Numero
	method decenas() = ((cantidadSoles - self.centenas()*100)/10).truncate(0)		//Describe la cantidad de decenas de la cantidad de soles - Numero
	method unidades() = (cantidadSoles - (self.centenas()*100) - (self.decenas()*10))		//Describe la cantidad de unidades de la cantidad de soles - Numero
	method esZombie() = false
	method esSol() = false
	method esPlanta() = false
	method serDesplantado(){}

}

class HUDSoles{
	method esZombie() = false
	method esSol() = false
	method esPlanta() = false
	method serDesplantado(){}

}

object centenasCantidadSoles inherits HUDSoles{
	var property position = game.at(0,7)
	var property image = "otros/numeros/centenas_"+indicadorSoles.centenas().toString()+".png"
	method refrescarNumero(){
		self.image("otros/numeros/centenas_"+indicadorSoles.centenas().toString()+".png")
	}
	
}

object decenasCantidadSoles inherits HUDSoles{
	var property position = game.at(0,7)
	var property image = "otros/numeros/decenas_"+indicadorSoles.decenas().toString()+".png"
	method refrescarNumero(){
		self.image("otros/numeros/decenas_"+indicadorSoles.decenas().toString()+".png")
	}
}

object unidadesCantidadSoles inherits HUDSoles{
	var property position = game.at(0,7)
	var property image = "otros/numeros/unidad_"+indicadorSoles.unidades().toString()+".png"
	method refrescarNumero(){
		self.image("otros/numeros/unidad_"+indicadorSoles.unidades().toString()+".png")
	}
}