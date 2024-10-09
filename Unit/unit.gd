extends CharacterBody2D
class_name Unit

@onready var health_bar = $HealthBar
@onready var unit_collider = $UnitCollider
@onready var unit_detection_area_collider = $EnemyDetectionArea/CollisionShape2D
@onready var enemy_detection_area: Area2D = $EnemyDetectionArea
@onready var attack_range_area: Area2D = $AttackRangeArea
@onready var state_machine: FiniteStateMachine = $FiniteStateMachine
@onready var unit_sprite: AnimatedSprite2D = $AnimatedSprite2D


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
	
func attack_target():
	if current_target.current_health<=0:
		current_target = null
		time_to_next_attack=attack_speed
	else:
		unit_sprite.play("hit")
		current_target.receive_damage(damage)
		time_to_next_attack=attack_speed
		if current_target.current_health<=0:
			current_target = null
		

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
	if not belongs_to_player:
		scale.x *= -1
	
func receive_damage(damage_amount):
	current_health-=damage_amount
	health_bar.value = current_health
	if current_health<=0 and is_alive:
		is_alive = false
		is_targetable = false
		die()

func die():
	self.set_collision_layer_value(1, false)
	self.set_collision_layer_value(2, false)
	self.set_collision_mask_value(1, false)
	self.set_collision_mask_value(2, false)
	enemy_detection_area.set_collision_layer_value(1, false)
	enemy_detection_area.set_collision_layer_value(2, false)
	enemy_detection_area.set_collision_mask_value(1, false)
	enemy_detection_area.set_collision_mask_value(2, false)
	if belongs_to_player:
		global_data.player_experience += exp_to_owner
		global_data.enemy_experience += exp_to_slayer
		global_data.enemy_gold += gold_on_death
		global_data.player_gold += int(cost/2)
	else:
		global_data.player_experience += exp_to_slayer
		global_data.enemy_experience += exp_to_owner
		global_data.player_gold += gold_on_death
		global_data.enemy_gold += int(cost/2)
		
	state_machine.on_child_transition(state_machine.current_state, "UnitDying")
	

func _on_enemy_detection_area_body_entered(body):
	if current_target != null:
		return
	if is_alive and (body is Unit or body is Castle) and belongs_to_player != body.belongs_to_player and body.is_targetable:
		lock_on_target(body)


func find_nearest_target():
	var potential_targets = enemy_detection_area.get_overlapping_bodies()
	var closest_distance = INF
	for target in potential_targets:
		if is_alive and (target is Unit or target is Castle) and belongs_to_player != target.belongs_to_player and target.is_targetable:
			if target.global_position.distance_to(self.global_position)<closest_distance:
				lock_on_target(target)
				closest_distance = target.global_position.distance_to(self.global_position)
	state_machine.on_child_transition(state_machine.current_state, "UnitMoving")
	


func _on_animated_sprite_2d_animation_finished() -> void:
	print("skonczylem "  + str(unit_sprite.animation))
	if unit_sprite.animation == "hit":
		unit_sprite.play("idle")
