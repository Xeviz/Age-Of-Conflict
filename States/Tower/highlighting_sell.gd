extends State
class_name HighlightingSell


@export var tower: Tower

func enter():
	if tower.mounted_cannon != null:
		tower.mounted_cannon.placement_highligher.show()

func exit():
	if tower.mounted_cannon != null:
		tower.mounted_cannon.placement_highligher.hide()
