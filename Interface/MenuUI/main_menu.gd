extends Control

@onready var gameplay_scene = preload("res://GameplayMap/gameplay_map.tscn")
@onready var result_label: Label = $Label
@onready var play_button: Button = $VBoxContainer/PlayButton
var result = false
var score = true

func _ready() -> void:
	pass
	

func _on_play_button_button_down():
	get_tree().change_scene_to_file("res://GameplayMap/gameplay_map.tscn")
	
	

func _on_exit_button_button_down():
	get_tree().quit()

func game_won():
	result_label.text = "YOU HAVE WON!"
	play_button.text = "PLAY AGAIN"
	result_label.show()
	
func game_lost():
	result_label.text = "YOU HAVE LOST!"
	play_button.text = "PLAY AGAIN"
	result_label.show()
