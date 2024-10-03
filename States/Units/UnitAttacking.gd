extends State
class_name UnitAttacking

@export var unit: Unit

func enter():
	unit.time_to_next_attack = 0.0

func update(delta):
	if unit.current_target:
		unit.attack_target(delta)
	else:
		state_transition.emit(self, "UnitMoving")
		
