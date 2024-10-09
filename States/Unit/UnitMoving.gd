extends State
class_name UnitMoving

@export var unit: Unit

func enter():
	unit.unit_sprite.play("walk")

func physics_update(delta):
	if unit == null:
		return
	if unit.current_target == null:
		unit.move_forward(delta)
	if unit is not RangedUnit and unit.current_target != null:
		unit.move_towards_target(delta)
		if unit.attack_range_area.overlaps_body(unit.current_target):
			state_transition.emit(self, "UnitAttacking")
	elif unit is RangedUnit and unit.current_target != null:
		state_transition.emit(self, "UnitShooting")
	
