extends State
class_name CannonAwaitingTarget

@export var cannon: Cannon
var rotation_speed: float = 8.0
var target_rotation = 0.0


func update(delta):
	var current_rotation = cannon.rotation
	cannon.rotation = lerp_angle(current_rotation, target_rotation, rotation_speed * delta)
