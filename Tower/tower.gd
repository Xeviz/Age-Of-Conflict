extends Node2D
class_name Tower


@onready var cannon_placement_area: Area2D = $CannonPlacementArea
@onready var placement_highligher: ColorRect = $AreaHighlighter
@onready var state_machine: FiniteStateMachine = $FiniteStateMachine
@onready var gameplay_map = get_parent().get_parent().gameplay_map
@onready var tower_sprite = $Sprite2D

var mounted_cannon: Cannon

func _ready() -> void:
	print(gameplay_map)

func mount_cannon(cannon_to_mount):
	mounted_cannon = cannon_to_mount
	if not mounted_cannon.belongs_to_player:
		mounted_cannon.position = cannon_placement_area.position
	add_child(mounted_cannon)
	
func update_tower_texture(age):
	var new_texture = load("res://Textures/Tower/Age" + str(age) + "Tower.png")
	tower_sprite.texture = new_texture
	
func sell_cannon():
	mounted_cannon.queue_free()
	
func go_to_highlighting_append():
	state_machine.on_child_transition(state_machine.current_state, "HighlightingAppend")
	
func go_to_highlighting_sell():
	state_machine.on_child_transition(state_machine.current_state, "HighlightingSell")

func go_to_idle():
	state_machine.on_child_transition(state_machine.current_state, "TowerIdle")

func _on_cannon_placement_area_mouse_entered() -> void:
	gameplay_map.targeted_tower = self

func _on_cannon_placement_area_mouse_exited() -> void:
	gameplay_map.targeted_tower = null
