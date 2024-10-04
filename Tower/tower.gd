extends Node2D
class_name Tower


@onready var cannon_placement_area = $CannonPlacementArea
@onready var placement_highligher = $AreaHighlighter
@onready var state_machine = $FiniteStateMachine
@onready var cannon_scene = preload("res://Cannon/cannon.tscn")

var mounted_cannon: Cannon
var test = 0.5

func _ready() -> void:
	mount_cannon()

func _process(delta: float) -> void:
	test-=delta
	if mounted_cannon != null and test<0:
		dismount_cannon()

func mount_cannon():
	mounted_cannon = cannon_scene.instantiate()
	mounted_cannon.position = cannon_placement_area.position
	add_child(mounted_cannon)
	
	
func dismount_cannon():
	print(str(mounted_cannon.position))
	mounted_cannon.queue_free()
	print(str(mounted_cannon.position))
