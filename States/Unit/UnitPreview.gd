extends State
class_name UnitPreview

@export var unit: Unit
@onready var spawn_area: Area2D
var ignored_button_click = false

func enter():
	unit.is_targetable = false
	ignored_button_click = false
	spawn_area = unit.get_parent().player_spawn_area
	unit.hide()
	
func update(delta):
	if not ignored_button_click and Input.is_action_just_pressed("left_mouse_click"):
		ignored_button_click = true
		return
	var mouse_pos = unit.get_global_mouse_position()
	unit.global_position = mouse_pos
	if spawn_area.overlaps_body(unit):
		unit.show()
		if Input.is_action_just_pressed("left_mouse_click"):
			state_transition.emit(self, "UnitSpawning")
	else:
		unit.hide()
	if Input.is_action_just_pressed("ui_cancel"):
			global_data.player_gold+=unit.cost
			unit.queue_free()
	
func exit():
	unit.set_collision_layer_value(1, false)
	unit.hide()
