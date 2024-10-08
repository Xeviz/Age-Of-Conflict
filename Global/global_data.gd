extends Node

var player_experience: int = 0
var enemy_experience: int = 0

var player_stage: int = 1
var enemy_stage: int = 1

var player_gold: int = 100
var enemy_gold: int = 100

var player_spawn_queue: float = 0.0
var enemy_spawn_queue: float = 0.0

var stages_exp_requirements = {
	2: 4000,
	3: 15000,
	4: 75000,
	5: 500000
}

var stages_castle_health_bonus = {
	1: 0,
	2: 500,
	3: 1500,
	4: 2500,
	5: 4000
}

var stages_units_scenes = {
	1: [load("res://Unit/Age1/unit1_age1.tscn"), load("res://Unit/Age1/unit2_age1.tscn"), load("res://Unit/Age1/unit3_age1.tscn")],
	2: [load("res://Unit/Age2/unit1_age2.tscn"), load("res://Unit/Age2/unit2_age2.tscn"), load("res://Unit/Age2/unit3_age2.tscn")],
	3: [load("res://Unit/Age3/unit1_age3.tscn"), load("res://Unit/Age3/unit2_age3.tscn"), load("res://Unit/Age3/unit3_age3.tscn")],
	4: [load("res://Unit/Age4/unit1_age4.tscn"), load("res://Unit/Age4/unit2_age4.tscn"), load("res://Unit/Age4/unit3_age4.tscn")],
	5: [load("res://Unit/Age5/unit1_age5.tscn"), load("res://Unit/Age5/unit2_age5.tscn"), load("res://Unit/Age5/unit3_age5.tscn"), load("res://Unit/Age5/unit4_age5.tscn")]
}

var stages_cannons_scenes = {
	1: [load("res://Cannon/cannon.tscn"), load("res://Cannon/cannon.tscn"), load("res://Cannon/cannon.tscn")],
	2: [load("res://Cannon/cannon2.tscn"), load("res://Cannon/cannon2.tscn"), load("res://Cannon/cannon2.tscn")],
	3: [load("res://Cannon/cannon3.tscn"), load("res://Cannon/cannon3.tscn"), load("res://Cannon/cannon3.tscn")],
	4: [load("res://Cannon/cannon4.tscn"), load("res://Cannon/cannon4.tscn"), load("res://Cannon/cannon4.tscn")],
	5: [load("res://Cannon/cannon5.tscn"), load("res://Cannon/cannon5.tscn"), load("res://Cannon/cannon5.tscn"), load("res://Cannon/cannon5_extra.tscn")]
}

var stages_unit_costs = {
	1: [25, 30, 100],
	2: [40, 60, 120],
	3: [80, 120, 200],
	4: [150, 200, 350],
	5: [200, 300, 500, 700]
}

var stages_cannons_costs = {
	1: [250, 500, 1000],
	2: [400, 800, 1600],
	3: [600, 1200, 2400],
	4: [900, 1800, 3600],
	5: [1200, 2400, 4800, 6000]
}

var stages_units_stats = {
	1: [{
		"cost": 25,
		"health": 12,
		"attack_speed": 1.2,
		"damage": 4,
		"exp_to_owner": 40,
		"exp_to_slayer": 50,
		"gold_on_death": 5,
		"time_to_spawn": 1.5,
		"speed": 40
	}, {
		"cost": 30,
		"health": 8,
		"attack_speed": 2.0,
		"damage": 3,
		"exp_to_owner": 60,
		"exp_to_slayer": 70,
		"gold_on_death": 6,
		"time_to_spawn": 2.0,
		"speed": 35
	}, {
		"cost": 100,
		"health": 35,
		"attack_speed": 1.0,
		"damage": 6,
		"exp_to_owner": 125,
		"exp_to_slayer": 150,
		"gold_on_death": 10,
		"time_to_spawn": 4.0,
		"speed": 38
	}],
	2: [{
		"cost": 40,
		"health": 20,
		"attack_speed": 1.3,
		"damage": 6,
		"exp_to_owner": 60,
		"exp_to_slayer": 70,
		"gold_on_death": 45,
		"time_to_spawn": 3.2,
		"speed": 42
	}, {
		"cost": 60,
		"health": 14,
		"attack_speed": 1.8,
		"damage": 5,
		"exp_to_owner": 80,
		"exp_to_slayer": 90,
		"gold_on_death": 60,
		"time_to_spawn": 3.7,
		"speed": 47
	}, {
		"cost": 120,
		"health": 50,
		"attack_speed": 1.1,
		"damage": 8,
		"exp_to_owner": 150,
		"exp_to_slayer": 170,
		"gold_on_death": 200,
		"time_to_spawn": 6.5,
		"speed": 36
	}],
	3: [{
		"cost": 80,
		"health": 35,
		"attack_speed": 1.4,
		"damage": 8,
		"exp_to_owner": 100,
		"exp_to_slayer": 110,
		"gold_on_death": 90,
		"time_to_spawn": 3.4,
		"speed": 44
	}, {
		"cost": 120,
		"health": 28,
		"attack_speed": 1.7,
		"damage": 7,
		"exp_to_owner": 120,
		"exp_to_slayer": 130,
		"gold_on_death": 120,
		"time_to_spawn": 4.0,
		"speed": 48
	}, {
		"cost": 200,
		"health": 70,
		"attack_speed": 1.2,
		"damage": 10,
		"exp_to_owner": 180,
		"exp_to_slayer": 200,
		"gold_on_death": 300,
		"time_to_spawn": 6.8,
		"speed": 37
	}],
	4: [{
		"cost": 150,
		"health": 50,
		"attack_speed": 1.5,
		"damage": 10,
		"exp_to_owner": 150,
		"exp_to_slayer": 160,
		"gold_on_death": 130,
		"time_to_spawn": 3.5,
		"speed": 41
	}, {
		"cost": 200,
		"health": 40,
		"attack_speed": 1.8,
		"damage": 9,
		"exp_to_owner": 170,
		"exp_to_slayer": 180,
		"gold_on_death": 150,
		"time_to_spawn": 4.5,
		"speed": 46
	}, {
		"cost": 350,
		"health": 100,
		"attack_speed": 1.3,
		"damage": 14,
		"exp_to_owner": 220,
		"exp_to_slayer": 240,
		"gold_on_death": 400,
		"time_to_spawn": 7.0,
		"speed": 35
	}],
	5: [{
		"cost": 200,
		"health": 60,
		"attack_speed": 1.6,
		"damage": 12,
		"exp_to_owner": 200,
		"exp_to_slayer": 220,
		"gold_on_death": 180,
		"time_to_spawn": 3.6,
		"speed": 43
	}, {
		"cost": 300,
		"health": 55,
		"attack_speed": 1.9,
		"damage": 10,
		"exp_to_owner": 240,
		"exp_to_slayer": 260,
		"gold_on_death": 220,
		"time_to_spawn": 4.6,
		"speed": 49
	}, {
		"cost": 500,
		"health": 120,
		"attack_speed": 1.4,
		"damage": 16,
		"exp_to_owner": 300,
		"exp_to_slayer": 320,
		"gold_on_death": 500,
		"time_to_spawn": 7.2,
		"speed": 37
	}, {
		"cost": 700,
		"health": 150,
		"attack_speed": 1.3,
		"damage": 20,
		"exp_to_owner": 350,
		"exp_to_slayer": 380,
		"gold_on_death": 700,
		"time_to_spawn": 7.5,
		"speed": 50
	}]
}

var stages_cannons_stats = {
	1: [{
		"damage": 3,
		"attack_speed": 2.0,
		"cost": 250,
		"sell_value": 150
	}, {
		"damage": 5,
		"attack_speed": 1.8,
		"cost": 500,
		"sell_value": 300
	}, {
		"damage": 8,
		"attack_speed": 1.6,
		"cost": 1000,
		"sell_value": 600
	}],
	2: [{
		"damage": 6,
		"attack_speed": 1.9,
		"cost": 400,
		"sell_value": 250
	}, {
		"damage": 9,
		"attack_speed": 1.7,
		"cost": 800,
		"sell_value": 500
	}, {
		"damage": 12,
		"attack_speed": 1.5,
		"cost": 1600,
		"sell_value": 1000
	}],
	3: [{
		"damage": 9,
		"attack_speed": 1.8,
		"cost": 600,
		"sell_value": 350
	}, {
		"damage": 13,
		"attack_speed": 1.6,
		"cost": 1200,
		"sell_value": 700
	}, {
		"damage": 18,
		"attack_speed": 1.4,
		"cost": 2400,
		"sell_value": 1400
	}],
	4: [{
		"damage": 12,
		"attack_speed": 1.7,
		"cost": 800,
		"sell_value": 450
	}, {
		"damage": 17,
		"attack_speed": 1.5,
		"cost": 1600,
		"sell_value": 900
	}, {
		"damage": 24,
		"attack_speed": 1.3,
		"cost": 3200,
		"sell_value": 1800
	}],
	5: [{
		"damage": 15,
		"attack_speed": 1.6,
		"cost": 1000,
		"sell_value": 600
	}, {
		"damage": 22,
		"attack_speed": 1.4,
		"cost": 2000,
		"sell_value": 1200
	}, {
		"damage": 30,
		"attack_speed": 1.2,
		"cost": 4000,
		"sell_value": 2400
	}, {
		"damage": 40,
		"attack_speed": 1.1,
		"cost": 8000,
		"sell_value": 4800
	}]
}
