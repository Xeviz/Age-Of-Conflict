extends State
class_name FiredOnTarget

@export var projectile: Node2D


func physics_update(delta):
	projectile.travel_towards_target(delta)
	
