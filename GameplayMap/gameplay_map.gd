extends Node2D

@export var player_castle: Castle
@export var player_spawn_area: Area2D
@export var enemy_castle: Castle
@export var enemy_spawn_area: Area2D
@onready var main_menu_scene = preload("res://Interface/MenuUI/main_menu.tscn")

var targeted_tower: Tower = null
var player_previewing_unit: bool = false
var game_seconds: float = 0.0
var current_gold_bonus = 100


func _process(delta: float) -> void:
	if player_previewing_unit:
		$ColorRect.show()
	else:
		$ColorRect.hide()
	
	update_time(delta)
	update_spawn_queue(delta)
		
func update_time(delta: float) -> void:
	game_seconds+=delta
	if game_seconds>=60:
		game_seconds-=60
		give_enemy_gold()
		
func give_enemy_gold() -> void:
	global_data.enemy_gold += current_gold_bonus
	current_gold_bonus = current_gold_bonus * 2


func update_spawn_queue(delta: float) -> void:
	if global_data.player_spawn_queue>0:
		global_data.player_spawn_queue-=delta
	else:
		global_data.player_spawn_queue = 0
	if global_data.enemy_spawn_queue>0:
		global_data.enemy_spawn_queue-=delta
	else:
		global_data.enemy_spawn_queue = 0
	

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
		

	
	
