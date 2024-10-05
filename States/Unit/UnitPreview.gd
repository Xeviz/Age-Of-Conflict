extends State
class_name UnitPreview

@export var unit: Unit
@onready var spawn_area: Area2D

func enter():
	spawn_area = unit.get_parent().player_spawn_area
	unit.hide()
	
func update(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	unit.global_position = mouse_pos
	if spawn_area.overlaps_body(unit):
		unit.show()
		if Input.is_action_just_pressed("left_mouse_click"):
			state_transition.emit(self, "UnitSpawning")
	else:
		unit.hide()
		if Input.is_action_just_pressed("left_mouse_click"):
			unit.queue_free()
	if Input.is_action_just_pressed("ui_cancel"):
			unit.queue_free()
	
func exit():
	unit.set_collision_layer_value(1, false)
	unit.hide()
