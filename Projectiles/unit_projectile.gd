extends CharacterBody2D
class_name UnitProjectile


@onready var projectile_area: Area2D = $ProjectileArea
@onready var starting_position = position
@onready var state_machine = $FiniteStateMachine

var speed : float = 450.0
var damage : int = 10
var target: Node2D
var direction
var is_fired = true
var latest_target_position: Vector2

func bind_to_shooter(shooter):
	damage = shooter.damage
	target = shooter.current_target

func _on_projectile_area_body_entered(body):
	if body == target:
		body.receive_damage(damage)
		get_parent().remove_child(self)
		queue_free()
	
		
func travel_towards_target(delta):
	if target != null and target.is_targetable:
		latest_target_position = target.global_position
		latest_target_position.y -= 64
		look_at(latest_target_position)

	direction = (latest_target_position - global_position).normalized()
	velocity = direction * speed

	move_and_slide()

	if latest_target_position.distance_to(global_position) < 5:
		get_parent().remove_child(self)
		queue_free()
	
