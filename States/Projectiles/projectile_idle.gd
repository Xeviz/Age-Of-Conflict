extends State
class_name ProjectileIdle

@export var projectile: SpellProjectile


func update(delta):
	if not projectile.sprites_updated and projectile.displayed_animation.animation != projectile.current_explosion_animation:
		projectile.update_sprites()
