import wollok.game.*
import plantas.*
import cabezal.*


class GestorAnimacion{
	var frameActual = 0
	const imagenBase
	var property idanim
	
	method initialize(){
		game.onTick(200, "animacion" + idanim.toString(), {self.cambiarFrame()})
	}

	method cambiarFrame(){frameActual = self.frameOpuesto()}
	method frameOpuesto() = if(frameActual==0) 1 else 0
	method image() = imagenBase + frameActual.toString() + ".png"
	method eliminarTick(){
		game.removeTickEvent("animacion" + idanim.toString())
	}
}

object gestorIds{
	
	method nuevoId(){
		return 1.randomUpTo(1000000).truncate(0)
	}
	
}