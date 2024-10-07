extends State
class_name UnitMoving

@export var unit: Unit

func physics_update(delta):
	if unit.current_target == null:
		unit.move_forward(delta)
	if unit.current_target != null:
		unit.move_towards_target(delta)
		if unit.attack_range_area.overlaps_body(unit.current_target):
			state_transition.emit(self, "UnitAttacking")
	
