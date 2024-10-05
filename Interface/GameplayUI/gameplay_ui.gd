extends Control

@onready var resources_container = $ResourcesContainer
@onready var purchases_container = $PurchasesContainer
@onready var available_units_grid = $AvailableUnits
@onready var available_cannons_grid = $AvailableCannons
@onready var camera = get_parent()

var move_screen_left = false
var move_screen_right = false
var screen_move_speed = 250.0

var available_units: Array[Unit]
var available_cannons: Array[Cannon]

func _process(delta):
	if move_screen_left:
		camera.position.x -= screen_move_speed * delta
	elif move_screen_right:
		camera.position.x += screen_move_speed * delta

func _on_units_button_button_down():
	purchases_container.hide()
	available_units_grid.show()


func _on_cannons_button_button_down():
	purchases_container.hide()
	available_cannons_grid.show()


func _on_go_back_button_button_down():
	available_units_grid.hide()
	available_cannons_grid.hide()
	purchases_container.show()


func _on_move_screen_left_mouse_entered():
	move_screen_left = true


func _on_move_screen_left_mouse_exited():
	move_screen_left = false


func _on_move_screen_right_mouse_entered():
	move_screen_right = true


func _on_move_screen_right_mouse_exited():
	move_screen_right = false


func load_new_units(units):
	pass
