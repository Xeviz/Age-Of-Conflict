extends State
class_name FallingDown

@export var projectile: SpellProjectile

func enter():
	print("szykuje sie do spadania")

func physics_update(delta):
	if projectile.falling_delay>0:
		projectile.falling_delay-=delta
		return
	if projectile.global_position.y<=projectile.explosion_height:
		projectile.fall_down(delta)
	else:
		projectile.explode()
		state_transition.emit(self, "ProjectileIdle")
