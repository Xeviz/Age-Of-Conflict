extends Node2D
class_name CannonProjectile


@onready var projectile_area: Area2D = $ProjectileArea
@onready var starting_position = position
@onready var state_machine = $FiniteStateMachine

var speed : float = 280.0
var damage : int = 2
var direction
var is_fired = true
var projectile_owner: Node2D
var latest_target_position: Vector2
var belongs_to_player = true

func bind_to_shooter(shooter):
	damage = shooter.projectile_damage
	latest_target_position = shooter.current_target.global_position
	belongs_to_player = shooter.belongs_to_player
	projectile_owner = shooter

func _on_projectile_area_body_entered(body):
	if (body is Unit or body is Castle) and belongs_to_player != body.belongs_to_player:
		body.receive_damage(damage)
		projectile_owner.fired_projectiles.erase(self)
		state_machine.on_child_transition(state_machine.current_state, "ProjectileStored")
	
		
func travel_in_direction(delta):
	direction = (latest_target_position - global_position).normalized()
	global_position += direction * speed * delta
