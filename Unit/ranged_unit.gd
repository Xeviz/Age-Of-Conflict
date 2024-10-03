extends Unit
class_name RangedUnit

var fired_bullets: Array = []
var stored_bullets: Array = []

func shoot_projectile(delta):
	time_to_next_attack-=delta
	if current_target.current_health<=0:
		current_target = null
	elif time_to_next_attack<=0:
		current_target.receive_damage(damage)
		update_health_bar()
		time_to_next_attack=attack_speed
