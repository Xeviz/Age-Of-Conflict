extends CharacterBody2D
class_name CannonProjectile


@onready var projectile_area: Area2D = $ProjectileArea
@onready var starting_position = position
@onready var state_machine = $FiniteStateMachine

var speed : float = 280.0
var damage : int = 2
var direction
var is_fired = true
var projectile_owner: Node2D
var initial_target_position: Vector2
var belongs_to_player = true
var projectile_range: int = 400

func bind_to_shooter(shooter):
	global_position = shooter.global_position
	damage = shooter.projectile_damage
	projectile_range = shooter.projectile_range
	initial_target_position = shooter.current_target.global_position
	direction = (initial_target_position - global_position).normalized()
	belongs_to_player = shooter.belongs_to_player
	projectile_owner = shooter
	velocity = direction * speed
	
func _on_projectile_area_body_entered(body):
	if (body is Unit or body is Castle) and belongs_to_player != body.belongs_to_player and body.current_health>0:
		body.receive_damage(damage)
		projectile_owner.fired_projectiles.erase(self)
		velocity = Vector2.ZERO
		state_machine.on_child_transition(state_machine.current_state, "ProjectileStored")
	
		
func travel_in_direction(delta):
	move_and_slide()
