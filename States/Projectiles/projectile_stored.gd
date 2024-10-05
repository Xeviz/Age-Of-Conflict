extends State
class_name ProjectileStored


@export var projectile: Node2D



func enter():
	projectile.hide()
	projectile.projectile_owner.on_projectile_stored(projectile)
	projectile.projectile_area.monitoring = false
	projectile.projectile_area.monitorable = false
	
func exit():
	projectile.show()
	projectile.projectile_area.monitoring = true
	projectile.projectile_area.monitorable = true
