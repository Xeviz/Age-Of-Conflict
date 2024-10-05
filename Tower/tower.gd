extends Node2D
class_name Tower


@onready var cannon_placement_area = $CannonPlacementArea
@onready var placement_highligher = $AreaHighlighter
@onready var state_machine = $FiniteStateMachine
@onready var cannon_scene = preload("res://Cannon/cannon.tscn")

var mounted_cannon: Cannon



func mount_cannon():
	mounted_cannon = cannon_scene.instantiate()
	mounted_cannon.position = cannon_placement_area.position
	add_child(mounted_cannon)
	
	
func sell_cannon():
	mounted_cannon.queue_free()
	
func go_to_highlighting_append():
	state_machine.on_child_transition(state_machine.current_state, "HighlightingAppend")
	
func go_to_highlighting_sell():
	state_machine.on_child_transition(state_machine.current_state, "HighlightingSell")
