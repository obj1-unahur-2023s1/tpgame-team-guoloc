import wollok.game.*

class LogoPlanta {
	//Logo donde posicionaremos el cabezal para cambiar la planta elegida
	const x
	const nombrePlanta
	var property image = "logosPlantas/logo_"+nombrePlanta+"_0.png"
	var property position = game.at(x,7)
	
}

object logoSol{
	var property image = "otros/logo_sol.png"
	var property position = game.at(0,7)
}
