extends Node2D
class_name Cannon


@onready var placement_highligher = $AreaHighlighter
@onready var state_machine = $FiniteStateMachine
@onready var attack_range_area = $AttackRangeArea
@onready var projectile_scene = preload("res://Projectiles/cannon_projectile.tscn")
@onready var canon_sprite: AnimatedSprite2D = $AnimatedSprite2D

var fired_projectiles: Array = []
var stored_projectiles: Array = []

var belongs_to_player = true
var current_target: Unit

var attack_speed: float = 0.7
var time_to_next_attack: float = 0.0

var projectile_damage = 5
var projectile_range = 1600
var is_ready = false

var cost: int = 250
var sell_value: int = 150

func _ready() -> void:
	is_ready = true


func load_cannon_stats(recipe):
	cost = recipe["cost"]
	sell_value = recipe["sell_value"]
	attack_speed = recipe["attack_speed"]
	projectile_damage = recipe["damage"]
	

func shoot_projectile():
	canon_sprite.play("fire")
	var new_projectile
	if stored_projectiles.is_empty():
		new_projectile = projectile_scene.instantiate()
		get_parent().add_child(new_projectile)
		new_projectile.bind_to_shooter(self)
	else:
		new_projectile = stored_projectiles.pop_back()
		new_projectile.bind_to_shooter(self)
	canon_sprite.play("fire")
	new_projectile.state_machine.on_child_transition(new_projectile.state_machine.current_state, "FiredInDirection")
	fired_projectiles.append(new_projectile)
	time_to_next_attack=attack_speed
	
func on_projectile_stored(projectile):
	fired_projectiles.erase(projectile)
	stored_projectiles.append(projectile)

func _on_attack_range_area_body_entered(body: Node2D) -> void:
	
	if state_machine.current_state is CannonFiring:
		return
	elif body is Unit and body.belongs_to_player != belongs_to_player and body.is_targetable:
		print("coś weszło w range")
		current_target = body
		state_machine.on_child_transition(state_machine.current_state, "CannonFiring")
		

func find_nearest_target():
	current_target = null
	var shortest_distance: float = INF
	var units_in_range = attack_range_area.get_overlapping_bodies()

	for body in units_in_range:
		if body is Unit and body.belongs_to_player != belongs_to_player and body.current_health>0:
			var distance = self.global_position.distance_to(body.global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				current_target = body
	
	if current_target:
		state_machine.on_child_transition(state_machine.current_state, "CannonFiring")
	else:
		state_machine.on_child_transition(state_machine.current_state, "CannonAwaitingTarget")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if canon_sprite.animation == "fire":
		canon_sprite.play("idle")
