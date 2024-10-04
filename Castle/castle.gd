extends StaticBody2D
class_name Castle

@onready var health_bar = $HealthBar
@onready var towers = $Towers
@onready var tower_scene = preload("res://Tower/tower.tscn")

var max_health: int = 10
var current_health: int = 10

var is_alive: bool = true
var belongs_to_player: bool = true

var next_tower_spawn_pos = Vector2(100, -250)

func _ready():
	health_bar.max_value = max_health
	health_bar.value = current_health

func receive_damage(damage_amount):
	append_tower()
	current_health-=damage_amount
	health_bar.value = current_health


func append_tower():
	var new_tower = tower_scene.instantiate()
	new_tower.position = next_tower_spawn_pos
	towers.add_child(new_tower)
	next_tower_spawn_pos.y += -100
	
