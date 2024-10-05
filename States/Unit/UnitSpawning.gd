extends State
class_name UnitSpawning

@export var unit: Unit


func update(delta):
	unit.time_to_spawn -= delta
	if unit.time_to_spawn <= 0:
		unit.set_collision_layer_value(1, true)
		unit.show()
		unit.is_targetable = true
		unit.enemy_detection_area.set_collision_layer_value(1, true)
		state_transition.emit(self, "UnitMoving")
