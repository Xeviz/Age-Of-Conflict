extends State
class_name HighlightingAppend

@export var tower: Tower


func enter():
	tower.placement_highligher.show()

func exit():
	tower.placement_highligher.hide()
