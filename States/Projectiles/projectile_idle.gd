extends State
class_name ProjectileIdle

@export var projectile: SpellProjectile

func enter():
	if projectile.current_falling_animation != "FallingAge" + str(projectile.current_age):
		projectile.update_sprites()
