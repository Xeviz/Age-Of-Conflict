extends Unit
class_name RangedUnit

var projectile_scene = preload("res://Projectiles/unit_projectile.tscn")

var projectile_damage: int = 2


func shoot_projectile(delta):
	time_to_next_attack-=delta
	if current_target.current_health<=0:
		current_target = null
	elif time_to_next_attack<=0:
		var new_projectile
		new_projectile = projectile_scene.instantiate()
		new_projectile.bind_to_shooter(self)
		get_parent().add_child(new_projectile)
		new_projectile.global_position = global_position
		new_projectile.state_machine.on_child_transition(new_projectile.state_machine.current_state, "FiredOnTarget")
		time_to_next_attack=attack_speed
		
func _on_enemy_detection_area_body_entered(body):
	if current_target != null:
		return
	if is_alive and (body is Unit or body is Castle) and belongs_to_player != body.belongs_to_player and body.is_targetable:
		print("lockuje sie na typku z hp " + str(body.current_health))
		lock_on_target(body)
		state_machine.on_child_transition(state_machine.current_state, "UnitShooting")


func find_nearest_target():
	var potential_targets = enemy_detection_area.get_overlapping_bodies()
	var closest_distance = INF
	for target in potential_targets:
		if is_alive and (target is Unit or target is Castle) and belongs_to_player != target.belongs_to_player and target.is_targetable:
			if target.global_position.distance_to(self.global_position)<closest_distance:
				lock_on_target(target)
				closest_distance = target.global_position.distance_to(self.global_position)
	state_machine.on_child_transition(state_machine.current_state, "UnitMoving")
		
	
