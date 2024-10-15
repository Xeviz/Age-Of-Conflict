extends State
class_name CannonFiring

@export var cannon: Cannon
var rotation_speed: float = 8.0

func enter():
	print("strzelam.")

func update(delta):
	cannon.time_to_next_attack-=delta
	if cannon.current_target:
		cannon.look_at(cannon.current_target.global_position)
	
		
	if cannon.current_target == null or cannon.current_target.current_health<=0:
		cannon.find_nearest_target()
	elif cannon.time_to_next_attack<=0:
		cannon.shoot_projectile()
		cannon.time_to_next_attack=cannon.attack_speed
	
