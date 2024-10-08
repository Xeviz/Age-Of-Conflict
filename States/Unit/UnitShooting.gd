extends State
class_name UnitShooting

@export var unit: Unit



func update(delta):
	if unit.current_target != null and unit.current_target.is_targetable:
		unit.shoot_projectile(delta)
	else:
		unit.find_nearest_target()
