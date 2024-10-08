extends State
class_name UnitAttacking

@export var unit: Unit

func enter():
	unit.velocity = Vector2.ZERO
	unit.time_to_next_attack = 0.0

func update(delta):
	unit.time_to_next_attack-=delta
	if unit.current_target != null and unit.current_target.is_targetable and unit.time_to_next_attack<=0:
		unit.attack_target()
		unit.time_to_next_attack=unit.attack_speed
	elif unit.current_target == null or not unit.current_target.is_targetable:
		unit.find_nearest_target()
		
