extends State
class_name FiredInDirection

@export var projectile: Node2D


func physics_update(delta):
	if projectile.global_position != projectile.latest_target_position:
		projectile.travel_in_direction(delta)
	else:
		state_transition.emit(self, "ProjectileStored")
