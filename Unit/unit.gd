extends CharacterBody2D
class_name Unit

@onready var health_bar = $HealthBar
@onready var unit_collider = $UnitCollider
@onready var unit_detection_area_collider = $EnemyDetectionArea/CollisionShape2D
@onready var enemy_detection_area = $EnemyDetectionArea
@onready var state_machine = $FiniteStateMachine
@onready var attack_range_area = $AttackRangeArea


var speed: float = 35.0
var max_health: int = 10
var current_health: int = 10
var damage: int = 3
var attack_speed: float = 2.0
var time_to_next_attack: float = 0.0

var exp_to_owner: int = 100
var exp_to_slayer: int = 100
var gold_on_death: int = 50
var time_to_spawn: float = 1.0
var cost: int = 30

var is_alive: bool = true
var is_targetable = false
var belongs_to_player: bool = true
var direction = Vector2.RIGHT
var current_target: Node2D
var unit_name: String
var time_to_death: float = 1.5


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

func load_unit_stats(recipe):
	cost = recipe["cost"]
	max_health = recipe["health"]
	current_health = recipe["health"]
	attack_speed = recipe["attack_speed"]
	damage = recipe["damage"]
	exp_to_owner = recipe["exp_to_owner"]
	exp_to_slayer = recipe["exp_to_slayer"]
	gold_on_death = recipe["gold_on_death"]
	time_to_spawn = recipe["time_to_spawn"]
	speed = recipe["speed"]
	
	health_bar.max_value = max_health
	health_bar.value = max_health
	
func receive_damage(damage_amount):
	current_health-=damage_amount
	health_bar.value = current_health
	if current_health<=0 and is_alive:
		is_alive = false
		die()

func die():
	is_targetable = false
	unit_collider.disabled = true
	$PlaceholderTexture.hide()
	if belongs_to_player:
		global_data.player_experience += exp_to_owner
		global_data.enemy_experience += exp_to_slayer
		global_data.enemy_gold += gold_on_death
	else:
		global_data.player_experience += exp_to_slayer
		global_data.enemy_experience += exp_to_owner
		global_data.player_gold += gold_on_death
		
	state_machine.on_child_transition(state_machine.current_state, "UnitDying")
	

func _on_enemy_detection_area_body_entered(body):
	if (body is Unit or body is Castle) and belongs_to_player != body.belongs_to_player and body.is_targetable:
		lock_on_target(body)
