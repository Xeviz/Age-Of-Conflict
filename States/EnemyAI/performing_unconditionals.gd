extends State
class_name PerformingUnconditionals


@export var enemy_ai: Node




func update(delta):
	if check_if_advance_possible():
		enemy_ai.advance_age()
	if enemy_ai.enemy_castle.was_recently_attacked and enemy_ai.chance_to_buy_unit():
		enemy_ai.buy_unit()
	elif not enemy_ai.enemy_castle.was_recently_attacked:
		state_transition.emit(self, "PerformingConditionals")
	
func check_if_advance_possible():
	if enemy_ai.current_stage<5 and global_data.enemy_experience>=global_data.stages_exp_requirements[enemy_ai.current_stage+1]:
		return true
	return false
	
