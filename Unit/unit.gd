extends CharacterBody2D
class_name Unit

@onready var health_bar = $HealthBar
@onready var unit_collider = $UnitCollider
@onready var unit_detection_area_collider = $EnemyDetectionArea/CollisionShape2D
@onready var state_machine = $FiniteStateMachine


var speed: float = 35.0
var max_health: int = 10
var current_health: int = 10
var damage: int = 3
var attack_speed: float = 2.0
var time_to_next_attack: float = 0.0
var experience_on_death: int = 100
var gold_on_death: int = 50

var is_alive: bool = true
var belongs_to_player: bool = true
var direction = Vector2.RIGHT
var current_target: Node2D
var unit_name: String
var time_to_death: float = 1.5

var attack_range: float = 45.0

func _ready():
	if name == "MeleeUnit2":
		belongs_to_player = false

func lock_on_target(target):
	current_target = target
	
func move_forward(delta):
	if belongs_to_player:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT
	velocity.x = speed * direction.x
	move_and_slide()
	
func move_towards_target(delta):
	direction = (current_target.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
func attack_target(delta):
	time_to_next_attack-=delta
	if current_target.current_health<=0:
		current_target = null
	elif time_to_next_attack<=0:
		current_target.receive_damage(damage)
		time_to_next_attack=attack_speed
		

func update_health_bar():
	health_bar.value = current_health

func spawn_unit_from_recipe(recipe, spawn_cords):
	speed = recipe["speed"]
	max_health = recipe["health"]
	current_health = recipe["health"]
	damage = recipe["damage"]
	experience_on_death = recipe["experience"]
	gold_on_death = recipe["gold_on_death"]
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
	
	unit_collider.disabled = true
	$PlaceholderTexture.hide()
	if belongs_to_player:
		global_data.player_experience += int(experience_on_death*1.1)
		global_data.enemy_experience += experience_on_death
		global_data.player_gold += gold_on_death
		global_data.enemy_gold += int(gold_on_death*1.3)
	else:
		global_data.player_experience += experience_on_death
		global_data.enemy_experience += int(experience_on_death*1.1)
		global_data.player_gold += int(gold_on_death*1.3)
		global_data.enemy_gold += gold_on_death
		
	state_machine.on_child_transition(state_machine.current_state, "UnitDying")
	

func _on_enemy_detection_area_body_entered(body):
	if body is Unit and belongs_to_player != body.belongs_to_player:
		lock_on_target(body)
