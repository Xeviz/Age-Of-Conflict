extends State
class_name UnitShooting

@export var unit: Unit



func update(delta):
	if unit.current_target:
		unit.shoot_projectile(delta)
	else:
		state_transition.emit(self, "UnitMoving")
