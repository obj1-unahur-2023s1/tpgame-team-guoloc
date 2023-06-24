import wollok.game.*
import plantas.*
import cabezal.*


class GestorAnimacion{
	var frameActual = 0
	const imagenBase
	var property idanim = 0
	
	method initialize(){
		game.onTick(200, "animacionIdle" + idanim.toString(), {self.cambiarFrame()})
	}

	method cambiarFrame(){frameActual = self.frameOpuesto()}
	method frameOpuesto() = if(frameActual==0) 1 else 0
	method image() = imagenBase + frameActual.toString() + ".png"
}

object gestorIds{
	var id = 0
	method nuevoId(){
		id += 1
		return id	
	}
	
}