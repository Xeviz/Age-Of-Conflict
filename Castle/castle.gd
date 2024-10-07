extends StaticBody2D
class_name Castle

@onready var health_bar = $HealthBar
@onready var towers = $Towers
@onready var tower_scene = preload("res://Tower/tower.tscn")
@onready var gameplay_map = get_parent()
@onready var castle_sprite: Sprite2D = $Sprite2D

var max_health: int = 750
var current_health: int = 750

var is_alive: bool = true
var belongs_to_player: bool = true
var is_targetable: bool = true
var next_tower_spawn_pos = Vector2(100, -250)
var current_age = 1



func _ready():
	if name == "EnemyCastle":
		belongs_to_player = false
	health_bar.max_value = max_health
	health_bar.value = current_health

func receive_damage(damage_amount):
	current_health-=damage_amount
	health_bar.value = current_health

func append_tower():
	var new_tower = tower_scene.instantiate()
	new_tower.position = next_tower_spawn_pos
	towers.add_child(new_tower)
	new_tower.update_tower_texture(current_age)
	next_tower_spawn_pos.y += -100
	

func advance_age(cur_age):
	current_age = cur_age
	max_health += global_data.stages_castle_health_bonus[cur_age]
	current_health += global_data.stages_castle_health_bonus[cur_age]
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	var new_texture = load("res://Textures/Castle/Age" + str(cur_age) + "Castle.png")
	castle_sprite.texture = new_texture
	
	var castle_towers = towers.get_children()
	for tower in castle_towers:
		tower.update_tower_texture(current_age)
	
