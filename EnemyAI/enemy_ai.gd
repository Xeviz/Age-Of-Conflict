extends Node
class_name EnemyAI

@onready var gameplay_map = get_parent()
@onready var enemy_castle: Castle = get_parent().enemy_castle
@onready var enemy_spawn_area: Area2D = get_parent().enemy_spawn_area
@onready var enemy_towers: Node2D = get_parent().enemy_castle.get_node("Towers")

var available_units_scenes: Array
var available_cannons_scenes: Array
var next_unit_to_spawn: int = 0
var next_cannon_to_buy: int = 0

var units_costs: Array
var cannons_costs: Array
var tower_costs: Array = [500,1000,3000,10000]
var available_cannon_spots: Array = [false, false, false, false]

var units_stats: Array
var cannons_stats: Array

var amount_of_towers = 0
var current_stage = 1

var x_spawn_border = [1600, 2800]
var y_spawn_border = [600, 900]

var coords_of_latest_attacker: Vector2



func _ready() -> void:
	load_new_units()
	
func load_new_units() -> void:
	available_units_scenes = global_data.stages_units_scenes[current_stage]
	available_cannons_scenes = global_data.stages_cannons_scenes[current_stage]
	units_costs = global_data.stages_unit_costs[current_stage]
	cannons_costs = global_data.stages_cannons_costs[current_stage]
	units_stats = global_data.stages_units_stats[current_stage]
	cannons_stats = global_data.stages_cannons_stats[current_stage]
	
func advance_age():
	current_stage+=1
	load_new_units()
	enemy_castle.advance_age(current_stage)

func chance_to_buy_tower():
	if amount_of_towers>=4 or true in available_cannon_spots or global_data.enemy_gold<tower_costs[amount_of_towers]:
		return false
	var chance_to_perform = (global_data.enemy_gold/tower_costs[amount_of_towers])*10
	
	if randi_range(0, 100) <= chance_to_perform:
		return true
	else:
		return false
	
func buy_tower():
	enemy_castle.append_tower()
	available_cannon_spots[amount_of_towers] = true
	amount_of_towers+=1

func chance_to_buy_unit():
	if global_data.enemy_spawn_queue>0:
		return false
	for g in range(units_costs.size()):
		if global_data.enemy_gold<units_costs[g]:
			continue
		var chance_to_perform = (global_data.enemy_gold/units_costs[g])*10
		if randi_range(0, 100) <= chance_to_perform:
			next_unit_to_spawn = g
			return true
	return false

func buy_unit():
	global_data.enemy_gold -= units_costs[next_unit_to_spawn]
	var new_unit = available_units_scenes[next_unit_to_spawn].instantiate()
	new_unit.belongs_to_player = false
	gameplay_map.add_child(new_unit)
	new_unit.load_unit_stats(units_stats[next_unit_to_spawn])
	new_unit.state_machine.on_child_transition(new_unit.state_machine.current_state, "UnitSpawning")
	if enemy_castle.was_recently_attacked:
		new_unit.global_position = Vector2(2800, 750)
	else:
		new_unit.global_position = get_random_spawn_pos()
	
func get_random_spawn_pos():
	var spawn_pos = Vector2.ZERO
	spawn_pos.x = randi_range(x_spawn_border[0], x_spawn_border[1])
	spawn_pos.y = randi_range(y_spawn_border[0], y_spawn_border[1])
	return spawn_pos

func chance_to_buy_cannon():
	if true not in available_cannon_spots:
		return false
	for g in range(cannons_costs.size()):
		if global_data.enemy_gold<cannons_costs[g]:
			continue
		var chance_to_perform = (global_data.enemy_gold/cannons_costs[g])*10
		if randi_range(0, 100) <= chance_to_perform:
			next_cannon_to_buy = g
			return true
	return false
	
func buy_cannon():
	global_data.enemy_gold -= cannons_costs[next_cannon_to_buy]
	var new_cannon = available_cannons_scenes[next_cannon_to_buy].instantiate()
	new_cannon.belongs_to_player = false
	new_cannon.load_cannon_stats(cannons_stats[next_cannon_to_buy])
	var index = 0
	for tower in enemy_castle.towers.get_children():
		if tower.mounted_cannon == null:
			tower.mount_cannon(new_cannon)
			available_cannon_spots[index] = false
			return
		index+=1
