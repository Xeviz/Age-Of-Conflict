extends Node


var player_experience: int = 5000000
var enemy_experience: int = 0

var player_stage: int = 1
var enemy_stage: int = 1

var player_gold: int = 500000000
var enemy_gold: int = 100

var player_spawn_queue: float = 0.0
var enemy_spawn_queue: float = 0.0

func reset_global_data():
	player_experience = 500000000
	enemy_experience = 0
	player_stage = 1
	enemy_stage = 1
	player_gold = 500000000
	enemy_gold = 100
	player_spawn_queue = 0.0
	enemy_spawn_queue = 0.0

var stages_exp_requirements = {
	2: 4000,
	3: 20000,
	4: 100000,
	5: 500000
}

var stages_castle_health_bonus = {
	1: 0,
	2: 2500,
	3: 9000,
	4: 22500,
	5: 50000
}

var stages_units_scenes = {
	1: [load("res://Unit/Age1/unit1_age1.tscn"), load("res://Unit/Age1/unit2_age1.tscn"), load("res://Unit/Age1/unit3_age1.tscn")],
	2: [load("res://Unit/Age2/unit1_age2.tscn"), load("res://Unit/Age2/unit2_age2.tscn"), load("res://Unit/Age2/unit3_age2.tscn")],
	3: [load("res://Unit/Age3/unit1_age3.tscn"), load("res://Unit/Age3/unit2_age3.tscn"), load("res://Unit/Age3/unit3_age3.tscn")],
	4: [load("res://Unit/Age4/unit1_age4.tscn"), load("res://Unit/Age4/unit2_age4.tscn"), load("res://Unit/Age4/unit3_age4.tscn")],
	5: [load("res://Unit/Age5/unit1_age5.tscn"), load("res://Unit/Age5/unit2_age5.tscn"), load("res://Unit/Age5/unit3_age5.tscn"), load("res://Unit/Age5/unit4_age5.tscn")]
}

var stages_cannons_scenes = {
	1: [load("res://Cannon/Age1/cannon1_age1.tscn"), load("res://Cannon/Age1/cannon2_age1.tscn"), load("res://Cannon/Age1/cannon3_age1.tscn")],
	2: [load("res://Cannon/Age2/cannon1_age2.tscn"), load("res://Cannon/Age2/cannon2_age2.tscn"), load("res://Cannon/Age2/cannon3_age2.tscn")],
	3: [load("res://Cannon/Age3/cannon1_age3.tscn"), load("res://Cannon/Age3/cannon2_age3.tscn"), load("res://Cannon/Age3/cannon3_age3.tscn")],
	4: [load("res://Cannon/Age4/cannon1_age4.tscn"), load("res://Cannon/Age4/cannon2_age4.tscn"), load("res://Cannon/Age4/cannon3_age4.tscn")],
	5: [load("res://Cannon/Age5/cannon1_age5.tscn"), load("res://Cannon/Age5/cannon2_age5.tscn"), load("res://Cannon/Age5/cannon3_age5.tscn"), load("res://Cannon/Age5/cannon4_age5.tscn")]
}

var stages_unit_costs = {
	1: [25, 30, 100],
	2: [125, 150, 500],
	3: [625, 750, 2500],
	4: [3125, 3750, 12500],
	5: [15000, 19000, 65000, 150000]
}

var stages_cannons_costs = {
	1: [250, 750, 1500],
	2: [1250, 3750, 7500],
	3: [6250, 18750, 37500],
	4: [31250, 95000, 190000],
	5: [155000, 450000, 900000, 2500000]
}

var stages_units_stats = {
	1: [{
		"cost": 25,
		"health": 12,
		"attack_speed": 1.5,
		"damage": 4,
		"exp_to_owner": 40,
		"exp_to_slayer": 50,
		"gold_on_death": 30,
		"time_to_spawn": 1.5,
		"speed": 45
	}, {
		"cost": 30,
		"health": 6,
		"attack_speed": 2.5,
		"damage": 2,
		"exp_to_owner": 60,
		"exp_to_slayer": 70,
		"gold_on_death": 35,
		"time_to_spawn": 2.0,
		"speed": 35
	}, {
		"cost": 100,
		"health": 35,
		"attack_speed": 1.5,
		"damage": 6,
		"exp_to_owner": 125,
		"exp_to_slayer": 150,
		"gold_on_death": 150,
		"time_to_spawn": 5.0,
		"speed": 50
	}],
	2: [{
		"cost": 125,
		"health": 60,
		"attack_speed": 1.5,
		"damage": 20,
		"exp_to_owner": 200,
		"exp_to_slayer": 250,
		"gold_on_death": 150,
		"time_to_spawn": 1.5,
		"speed": 45
	}, {
		"cost": 150,
		"health": 30,
		"attack_speed": 2.5,
		"damage": 8,
		"exp_to_owner": 300,
		"exp_to_slayer": 350,
		"gold_on_death": 175,
		"time_to_spawn": 2.0,
		"speed": 35
	}, {
		"cost": 500,
		"health": 175,
		"attack_speed": 1.5,
		"damage": 30,
		"exp_to_owner": 625,
		"exp_to_slayer": 750,
		"gold_on_death": 750,
		"time_to_spawn": 5.0,
		"speed": 50
	}],
	3: [{
		"cost": 625,
		"health": 300,
		"attack_speed": 1.5,
		"damage": 90,
		"exp_to_owner": 1000,
		"exp_to_slayer": 1250,
		"gold_on_death": 750,
		"time_to_spawn": 1.5,
		"speed": 45
	}, {
		"cost": 750,
		"health": 180,
		"attack_speed": 2.5,
		"damage": 40,
		"exp_to_owner": 1500,
		"exp_to_slayer": 1750,
		"gold_on_death": 875,
		"time_to_spawn": 2.0,
		"speed": 35
	}, {
		"cost": 2500,
		"health": 875,
		"attack_speed": 1.5,
		"damage": 150,
		"exp_to_owner": 3125,
		"exp_to_slayer": 3750,
		"gold_on_death": 3750,
		"time_to_spawn": 5.0,
		"speed": 50
	}],
	4: [{
		"cost": 3125,
		"health": 1500,
		"attack_speed": 1.5,
		"damage": 450,
		"exp_to_owner": 5000,
		"exp_to_slayer": 6250,
		"gold_on_death": 3750,
		"time_to_spawn": 1.5,
		"speed": 45
	}, {
		"cost": 3750,
		"health": 900,
		"attack_speed": 2.5,
		"damage": 200,
		"exp_to_owner": 7500,
		"exp_to_slayer": 8750,
		"gold_on_death": 4375,
		"time_to_spawn": 2.0,
		"speed": 35
	}, {
		"cost": 12500,
		"health": 4375,
		"attack_speed": 1.5,
		"damage": 750,
		"exp_to_owner": 15625,
		"exp_to_slayer": 18750,
		"gold_on_death": 18750,
		"time_to_spawn": 5.0,
		"speed": 50
	}],
	5: [{
		"cost": 15000,
		"health": 7500,
		"attack_speed": 1.5,
		"damage": 225,
		"exp_to_owner": 25000,
		"exp_to_slayer": 31250,
		"gold_on_death": 18750,
		"time_to_spawn": 1.5,
		"speed": 45
	}, {
		"cost": 19000,
		"health": 4500,
		"attack_speed": 2.5,
		"damage": 800,
		"exp_to_owner": 37500,
		"exp_to_slayer": 43750,
		"gold_on_death": 22000,
		"time_to_spawn": 2.0,
		"speed": 35
	}, {
		"cost": 65000,
		"health": 22500,
		"attack_speed": 1.5,
		"damage": 3900,
		"exp_to_owner": 60000,
		"exp_to_slayer": 65000,
		"gold_on_death": 75000,
		"time_to_spawn": 5.0,
		"speed": 50
	},
	{
		"cost": 150000,
		"health": 45000,
		"attack_speed": 1.5,
		"damage": 6700,
		"exp_to_owner": 60000,
		"exp_to_slayer": 65000,
		"gold_on_death": 75000,
		"time_to_spawn": 8.0,
		"speed": 65
	}
	],
}

var stages_cannons_stats = {
	1: [{
		"damage": 3,
		"attack_speed": 2.0,
		"cost": 250,
		"sell_value": 100
	}, {
		"damage": 3,
		"attack_speed": 1.5,
		"cost": 750,
		"sell_value": 300
	}, {
		"damage": 4,
		"attack_speed": 1.3,
		"cost": 1500,
		"sell_value": 600
	}],
	2: [{
		"damage": 12,
		"attack_speed": 2.0,
		"cost": 1250,
		"sell_value": 500
	}, {
		"damage": 12,
		"attack_speed": 1.5,
		"cost": 3750,
		"sell_value": 1500
	}, {
		"damage": 16,
		"attack_speed": 1.3,
		"cost": 7500,
		"sell_value": 3000
	}],
	3: [{
		"damage": 48,
		"attack_speed": 1.8,
		"cost": 6250,
		"sell_value": 2500
	}, {
		"damage": 48,
		"attack_speed": 1.6,
		"cost": 18750,
		"sell_value": 7500
	}, {
		"damage": 64,
		"attack_speed": 1.4,
		"cost": 37500,
		"sell_value": 15000
	}],
	4: [{
		"damage": 192,
		"attack_speed": 1.8,
		"cost": 31250,
		"sell_value": 12500
	}, {
		"damage": 192,
		"attack_speed": 1.6,
		"cost": 95000,
		"sell_value": 37500
	}, {
		"damage": 256,
		"attack_speed": 1.4,
		"cost": 190000,
		"sell_value": 75000
	}],
	5: [{
		"damage": 768,
		"attack_speed": 1.8,
		"cost": 150000,
		"sell_value": 60000
	}, {
		"damage": 768,
		"attack_speed": 1.6,
		"cost": 450000,
		"sell_value": 180000
	}, {
		"damage": 1024,
		"attack_speed": 1.4,
		"cost": 900000,
		"sell_value": 360000
	},
	{
		"damage": 1200,
		"attack_speed": 1.1,
		"cost": 2500000,
		"sell_value": 1000000
	}
	]
}
