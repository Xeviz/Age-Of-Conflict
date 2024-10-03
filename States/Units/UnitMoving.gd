extends State
class_name UnitMoving

@export var unit: Unit

func physics_update(delta):
	if not unit.current_target:
		unit.move_forward(delta)
	if unit.current_target:
		unit.move_towards_target(delta)
		var distance_to_target = unit.global_position.distance_to(unit.current_target.global_position)
		print(distance_to_target)
		if distance_to_target <= unit.attack_range:
			print("atakuje")
			state_transition.emit(self, "UnitAttacking")
	
