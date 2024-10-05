extends Node

var player_experience: int = 0
var enemy_experience: int = 0

var player_stage: int = 1
var enemy_stage: int = 1

var player_gold: int = 0
var enemy_gold: int = 0

var stages_exp_requirements = {
	2: 10000,
	3: 25000,
	4: 100000,
	5: 1000000
}


var stages_units_scenes = {
	1: [load("res://Unit/Age1/unit1_age1.tscn"), load("res://Unit/Age1/unit2_age1.tscn"), load("res://Unit/Age1/unit3_age1.tscn")]
}

var stages_cannons_scenes = {
	1: [load("res://Cannon/cannon.tscn"), load("res://Cannon/cannon.tscn"), load("res://Cannon/cannon.tscn")]
}
