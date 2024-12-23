extends State
class_name UnitPreview

@export var unit: Unit
@onready var spawn_area: Area2D
var ignored_button_click = false

func enter():
	unit.is_targetable = false
	ignored_button_click = false
	spawn_area = unit.get_parent().player_spawn_area
	if unit.belongs_to_player:
		unit.get_parent().player_previewing_unit = true
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
			unit.get_parent().player_previewing_unit = false
			state_transition.emit(self, "UnitSpawning")
			return
	else:
		unit.hide()
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("left_mouse_click"):
			global_data.player_gold+=unit.cost
			unit.get_parent().player_previewing_unit = false
			unit.queue_free()
	
func exit():
	unit.unit_sprite.modulate.a = 0.25
