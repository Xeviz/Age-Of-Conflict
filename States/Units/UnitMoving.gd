extends State
class_name UnitMoving

@export var unit: Unit

func physics_update(delta):
	if not unit.current_target:
		unit.move_forward(delta)
	if unit.current_target:
		unit.move_towards_target(delta)
		var distance_to_target = unit.global_position.distance_to(unit.current_target.global_position)
		if unit.attack_range_area.overlaps_body(unit.current_target):
			state_transition.emit(self, "UnitAttacking")
	
