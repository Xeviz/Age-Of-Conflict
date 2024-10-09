extends Node2D

@export var player_castle: Castle
@export var player_spawn_area: Area2D
@export var enemy_castle: Castle
@export var enemy_spawn_area: Area2D
@onready var main_menu_scene = preload("res://Interface/MenuUI/main_menu.tscn")

var targeted_tower: Tower = null

func _process(delta: float) -> void:
	if global_data.player_spawn_queue>0:
		global_data.player_spawn_queue-=delta
	else:
		global_data.player_spawn_queue = 0
	if global_data.enemy_spawn_queue>0:
		global_data.enemy_spawn_queue-=delta
	else:
		global_data.enemy_spawn_queue = 0

func _ready() -> void:
	print("jestem gotowy?")


	

func enable_tower_highlighters():
	var player_towers = player_castle.towers.get_children()
	for tower in player_towers:
		if tower.mounted_cannon == null:
			tower.go_to_highlighting_append()

func disable_tower_highlighters():
	var player_towers = player_castle.towers.get_children()
	for tower in player_towers:
		tower.go_to_idle()

func enable_cannon_highlighters():
	var player_towers = player_castle.towers.get_children()
	for tower in player_towers:
		if tower.mounted_cannon != null:
			tower.go_to_highlighting_sell()

func end_game(has_player_won):
	get_tree().change_scene_to_file("res://Interface/MenuUI/main_menu.tscn")
		

	
	
