extends CharacterBody2D
class_name Unit

@onready var health_bar = $HealthBar
@onready var unit_collider = $UnitCollider
@onready var unit_detection_area_collider = $EnemyDetectionArea/CollisionShape2D


var speed: float = 5.0
var max_health: int = 10
var current_health: int = 10
var damage: int = 3
var attack_speed: float = 2.0
var experience_on_death: int = 100

var is_alive: bool = true
var belongs_to_player: bool = true
var current_target: Unit
var unit_name: String


func lock_on_target(target):
	current_target = target
	
func move_forward(delta):
	pass
	
func move_towards_target(delta):
	pass
	
func attack_target(delta):
	pass

func _physics_process(delta):
	pass

func spawn_unit_from_recipe(recipe, spawn_cords):
	speed = recipe["speed"]
	max_health = recipe["health"]
	current_health = recipe["health"]
	damage = recipe["damage"]
	experience_on_death = recipe["experience"]
	unit_collider.shape.extents = Vector2(recipe["unit_width"], recipe["unit_height"])
	unit_detection_area_collider.shape.radius = recipe["detection_radius"]
	unit_name = recipe["unit_name"]
	
	health_bar.max_value = max_health
	health_bar.position.x = -(recipe["unit_width"]/2)
	health_bar.position.y = -(recipe["unit_height"]/2) - 5
	
	global_position = spawn_cords
	
func receive_damage(damage_amount):
	current_health-=damage
	health_bar.value = current_health
	if current_health<=0 and is_alive:
		is_alive = false
		die()

func die():
	pass
	
	
	

	
