extends Control

@onready var resources_container = $ResourcesContainer
@onready var purchases_container = $PurchasesContainer
@onready var available_units_grid = $AvailableUnits
@onready var available_cannons_grid = $AvailableCannons
@onready var gameplay_map = get_parent().get_parent()
@onready var camera = get_parent()

var move_screen_left = false
var move_screen_right = false
var screen_move_speed = 250.0

var available_units_scenes: Array
var available_cannons_scenes: Array
var current_stage = 1

func _ready() -> void:
	load_new_units()

func _process(delta) -> void:
	if move_screen_left:
		camera.position.x -= screen_move_speed * delta
	elif move_screen_right:
		camera.position.x += screen_move_speed * delta

func _on_units_button_button_down() -> void:
	purchases_container.hide()
	available_units_grid.show()


func _on_cannons_button_button_down() -> void:
	purchases_container.hide()
	available_cannons_grid.show()


func _on_go_back_button_button_down() -> void:
	available_units_grid.hide()
	available_cannons_grid.hide()
	purchases_container.show()


func _on_move_screen_left_mouse_entered() -> void:
	move_screen_left = true


func _on_move_screen_left_mouse_exited() -> void:
	move_screen_left = false


func _on_move_screen_right_mouse_entered() -> void:
	move_screen_right = true


func _on_move_screen_right_mouse_exited() -> void:
	move_screen_right = false

func load_new_units() -> void:
	available_units_scenes = global_data.stages_units_scenes[current_stage]
	available_cannons_scenes = global_data.stages_cannons_scenes[current_stage]
	
	if available_units_scenes.size() < 4:
		$AvailableUnits/Unit4.hide()
	else:
		$AvailableUnits/Unit4.show()
		
	if available_cannons_scenes.size() < 4:
		$AvailableCannons/Cannon4.hide()
	else:
		$AvailableCannons/Cannon4.show()

func _on_buy_tower_button_button_down() -> void:
	gameplay_map.player_castle.append_tower()

func _on_unit_1_button_down() -> void:
	var new_unit = available_units_scenes[0].instantiate()
	gameplay_map.add_child(new_unit)


func _on_unit_2_button_down() -> void:
	var new_unit = available_units_scenes[1].instantiate()
	gameplay_map.add_child(new_unit)


func _on_unit_3_button_down() -> void:
	var new_unit = available_units_scenes[2].instantiate()
	gameplay_map.add_child(new_unit)


func _on_unit_4_button_down() -> void:
	var new_unit = available_units_scenes[3].instantiate()
	gameplay_map.add_child(new_unit)
