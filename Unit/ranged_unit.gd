extends Unit
class_name RangedUnit

var projectile_scene = preload("res://Projectiles/unit_projectile.tscn")

var projectile_damage: int = 10
var fired_projectiles: Array = []
var stored_projectiles: Array = []


func shoot_projectile(delta):
	time_to_next_attack-=delta
	if current_target.current_health<=0:
		current_target = null
	elif time_to_next_attack<=0:
		var new_projectile
		if stored_projectiles.is_empty():
			new_projectile = projectile_scene.instantiate()
			new_projectile.bind_to_shooter(self)
			get_parent().add_child(new_projectile)
		else:
			print('strzelam zmagazynowanym')
			new_projectile = stored_projectiles.pop_back()
			new_projectile.global_position = global_position
			
		new_projectile.global_position = global_position
		new_projectile.state_machine.on_child_transition(new_projectile.state_machine.current_state, "FiredOnTarget")
		fired_projectiles.append(new_projectile)
		print(fired_projectiles)
		time_to_next_attack=attack_speed
		
func on_projectile_stored(projectile):
	fired_projectiles.erase(projectile)
	stored_projectiles.append(projectile)
		
func _on_enemy_detection_area_body_entered(body):
	if body is Unit and belongs_to_player != body.belongs_to_player:
		lock_on_target(body)
		state_machine.on_child_transition(state_machine.current_state, "UnitShooting")
