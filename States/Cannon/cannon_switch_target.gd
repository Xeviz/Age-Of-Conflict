extends State
class_name CannonSwitchTarget

@export var cannon: Cannon

func enter():
	cannon.find_nearest_target()
