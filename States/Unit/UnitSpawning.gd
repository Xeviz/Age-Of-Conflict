extends State
class_name UnitSpawning

@export var unit: Unit

func enter():
	unit.set_collision_layer_value(1, false)
	unit.hide()
	if unit.belongs_to_player:
		global_data.player_spawn_queue += unit.time_to_spawn
	else:
		global_data.enemy_spawn_queue += unit.time_to_spawn
	unit.time_to_spawn = global_data.player_spawn_queue

func update(delta):
	unit.time_to_spawn -= delta
	if unit.time_to_spawn <= 0:
		unit.set_collision_layer_value(1, true)
		unit.show()
		unit.is_targetable = true
		unit.enemy_detection_area.monitoring = true
		unit.enemy_detection_area.monitorable = true
		state_transition.emit(self, "UnitMoving")
		
func exit():
	unit.is_targetable=true
	if unit.belongs_to_player:
		unit.set_collision_layer_value(1, true)
		unit.set_collision_layer_value(2, false)
		unit.set_collision_mask_value(2, true)
		unit.set_collision_mask_value(1, false)
		unit.enemy_detection_area.set_collision_layer_value(2, true)
		unit.enemy_detection_area.set_collision_mask_value(2, true)
		if unit is not RangedUnit:
			unit.attack_range_area.set_collision_layer_value(2, true)
			unit.attack_range_area.set_collision_mask_value(2, true)
		
	else:
		unit.set_collision_layer_value(1, false)
		unit.set_collision_layer_value(2, true)
		unit.set_collision_mask_value(2, false)
		unit.set_collision_mask_value(1, true)
		unit.enemy_detection_area.set_collision_layer_value(1, true)
		unit.enemy_detection_area.set_collision_mask_value(1, true)
		if unit is not RangedUnit:
			unit.attack_range_area.set_collision_layer_value(1, true)
			unit.attack_range_area.set_collision_mask_value(1, true)
