extends State
class_name CannonPreview

@export var cannon: Cannon

func enter():
	cannon.hide()
	
func update(delta):
	pass
	
func exit():
	cannon.show()
