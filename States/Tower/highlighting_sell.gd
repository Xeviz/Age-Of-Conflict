extends State
class_name HighlightingSell


@export var tower: Tower
var gameplay_map
var ignored_button_click = false

func enter():
	ignored_button_click = false
	gameplay_map = tower.gameplay_map
	if tower.mounted_cannon != null:
		tower.mounted_cannon.placement_highligher.show()
		
func update(delta):
	if not ignored_button_click and Input.is_action_just_pressed("left_mouse_click"):
		ignored_button_click = true
		return
	if Input.is_action_just_pressed("left_mouse_click") and gameplay_map.targeted_tower == tower:
		tower.sell_cannon()
		gameplay_map.disable_tower_highlighters()
	elif (gameplay_map.targeted_tower == null and Input.is_action_just_pressed("left_mouse_click")) or Input.is_action_just_pressed("ui_cancel"):
		gameplay_map.disable_tower_highlighters()
	

func exit():
	if tower.mounted_cannon != null:
		tower.mounted_cannon.placement_highligher.hide()
