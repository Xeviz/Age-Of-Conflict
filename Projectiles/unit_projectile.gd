extends Node2D
class_name UnitProjectile


@onready var projectile_area: Area2D = $ProjectileArea
@onready var starting_position = position
@onready var state_machine = $FiniteStateMachine

var speed : float = 100.0
var damage : int = 10
var target: Node2D
var direction

func bind_to_shooter(shooter):
	damage = shooter.ammo_damage
	target = shooter.current_target
	

func _on_projectile_area_body_entered(body):
	if body == target and body.current_health>0:
		body.receive_damage(damage)
		state_machine.on_child_transition(state_machine.current_state, "ProjectileStored")
		
func travel_towards_target(delta):
	direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta
