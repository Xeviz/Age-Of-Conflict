extends State
class_name FiredInDirection

@export var projectile: Node2D


func physics_update(delta):
	if projectile.projectile_owner == null:
		return
	if projectile.projectile_owner.global_position.distance_to(projectile.global_position)<projectile.projectile_range:
		projectile.travel_in_direction(delta)
	else:
		state_transition.emit(self, "ProjectileStored")
