extends State
class_name UnitMoving

@export var unit: Unit

func update(delta):
	if not unit.current_target:
		unit.move_forward(delta)
	if unit.current_target:
		unit.move_towards_target(delta)
		var distance_to_target = unit.global_position.distance_to(unit.current_target.global_position)
		if distance_to_target <= unit.range
