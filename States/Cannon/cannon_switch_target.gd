extends State
class_name CannonPreview

@export var cannon: Cannon
@onready var gameplay_map = cannon.get_parent()
var ignored_button_click = false

func enter():
	ignored_button_click = false
	cannon.hide()
	gameplay_map.enable_tower_highlighters()
	
func update(delta):
	if not ignored_button_click and Input.is_action_just_pressed("left_mouse_click"):
		ignored_button_click = true
		return
	if gameplay_map.targeted_tower != null:
		cannon.global_position = gameplay_map.targeted_tower.cannon_placement_area.global_position
		cannon.show()
		if Input.is_action_just_pressed("left_mouse_click"):
			gameplay_map.targeted_tower.mount_cannon(cannon)
			state_transition.emit(self, "CannonAwaitingTarget")
	else:
		cannon.hide()
		if Input.is_action_just_pressed("left_mouse_click"):
			gameplay_map.disable_tower_highlighters()
			cannon.queue_free()
	if Input.is_action_just_pressed("ui_cancel"):
		gameplay_map.disable_tower_highlighters()
		cannon.queue_free()
			
func exit():
	cannon.attack_range_area.monitorable = true
	cannon.attack_range_area.monitoring = true
	gameplay_map.disable_tower_highlighters()
