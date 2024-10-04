extends Node2D


@onready var cannon_placement_area = $CannonPlacementArea
@onready var placement_highligher = $AreaHighlighter
@onready var state_machine = $FiniteStateMachine

var mounted_cannon: Node2D
