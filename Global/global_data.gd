extends Node

var player_experience: int = 0
var enemy_experience: int = 0

var player_stage: int = 1
var enemy_stage: int = 1

var stages_exp_requirements = {
	2: 10000,
	3: 25000,
	4: 100000,
	5: 1000000
}
