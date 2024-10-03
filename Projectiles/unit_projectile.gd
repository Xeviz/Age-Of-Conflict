extends Node2D
class_name UnitProjectile


@onready var projectile_area: Area2D = $ProjectileArea
@onready var starting_position = position
@onready var state_machine = $FiniteStateMachine

var speed : float = 150.0
var damage : int = 10
var target: Node2D
var direction
var is_fired = true
var projectile_owner: Node2D
var latest_target_position: Vector2

func bind_to_shooter(shooter):
	damage = shooter.projectile_damage
	target = shooter.current_target
	projectile_owner = shooter

func _on_projectile_area_body_entered(body):
	if body == target:
		body.receive_damage(damage)
		projectile_owner.fired_projectiles.erase(self)
		state_machine.on_child_transition(state_machine.current_state, "ProjectileStored")
	
		
func travel_towards_target(delta):
	if target:
		latest_target_position = target.global_position
	elif not target and latest_target_position.distance_to(global_position)<5:
		projectile_owner.fired_projectiles.erase(self)
		state_machine.on_child_transition(state_machine.current_state, "ProjectileStored")
	direction = (latest_target_position - global_position).normalized()
	global_position += direction * speed * delta
