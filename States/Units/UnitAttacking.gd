extends State
class_name UnitAttacking

@export var unit: Unit

func enter():
	unit.velocity = Vector2.ZERO
	unit.time_to_next_attack = 0.0

func update(delta):
	print("czy mam cel? : " + str(unit.current_target))
	if unit.current_target:
		unit.attack_target(delta)
	else:
		state_transition.emit(self, "UnitMoving")
		
