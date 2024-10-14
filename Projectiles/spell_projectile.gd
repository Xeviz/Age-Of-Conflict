extends CharacterBody2D
class_name SpellProjectile

@export var explosion_area: Area2D
@export var displayed_animation: AnimatedSprite2D
@export var state_machine: FiniteStateMachine

var explosion_height: int
var falling_delay: float = 1.0
var direction: Vector2 = Vector2.DOWN
var falling_speed: float = 250.0

func _ready() -> void:
	randomize_values()
	velocity = Vector2.ZERO

func randomize_values():
	explosion_height = randi_range(650, 850)
	falling_delay = randf_range(0.75, 5.5)
	global_position = Vector2(randi_range(600, 2600), -100)
	
	
func start_falling():
	displayed_animation.show()
	displayed_animation.play("falling")
	velocity = direction * falling_speed
	state_machine.on_child_transition(state_machine.current_state, "FallingDown")
	
	
func explode():
	velocity = Vector2.ZERO
	displayed_animation.play("explosion")
	var enemies_caught = explosion_area.get_overlapping_bodies()
	for body in enemies_caught:
		if body is Unit:
			body.receive_damage(9999999)

func fall_down(delta):
	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	if displayed_animation.animation == "explosion":
		displayed_animation.hide()
		randomize_values()
