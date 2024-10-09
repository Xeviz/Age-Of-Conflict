extends State
class_name PerformingConditionals

@export var enemy_ai: Node

var possible_actions = ["BUY_UNIT", "BUY_TOWER", "BUY_CANNON", "SELL_CANNON"]
var current_action = "NONE"


func update(delta):
	pick_action_to_perform()
	if current_action == "BUY_TOWER":
		buy_tower()
	elif current_action == "BUY_UNIT":
		buy_unit()
	elif current_action == "BUY_CANNON":
		buy_cannon()
	state_transition.emit(self, "PerformingUnconditionals")
		
func pick_action_to_perform():
	if enemy_ai.chance_to_buy_tower() == true:
		current_action = "BUY_TOWER"
	elif enemy_ai.chance_to_buy_cannon() == true:
		current_action = "BUY_CANNON"
	elif enemy_ai.chance_to_buy_unit() == true:
		current_action = "BUY_UNIT"
	
func buy_tower():
	current_action = "NONE"
	enemy_ai.buy_tower()
	
func buy_unit():
	current_action = "NONE"
	enemy_ai.buy_unit()
	
func buy_cannon():
	current_action = "NONE"
	enemy_ai.buy_cannon()
