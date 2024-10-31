extends Label
class_name DamageDisplayer



func _physics_process(delta: float) -> void:
	global_position.y -= 25.0 * delta
	if modulate.a >= 0.75 * delta:
		modulate.a -= 0.75 * delta
	else:
		queue_free()
