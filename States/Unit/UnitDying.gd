extends State
class_name UnitDying

@export var unit: Unit

func update(delta):
	unit.time_to_death-=delta
	if unit.time_to_death<=0:
		unit.queue_free()
