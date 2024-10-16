extends Control

var projectile_spell_scene = load("res://Projectiles/spell_projectile.tscn")
@onready var resources_container = $ResourcesContainer
@onready var purchases_container = $PurchasesContainer
@onready var available_units_grid = $AvailableUnits
@onready var available_cannons_grid = $AvailableCannons
@onready var gameplay_map = get_parent().get_parent()
@onready var player_castle = get_parent().get_parent().player_castle
@onready var camera = get_parent()
@onready var gold_info = $ResourcesContainer/GoldLabel
@onready var exp_info = $ResourcesContainer/ExperienceLabel
@onready var cost_info = $CostInfo
@onready var cooldown_bar: ProgressBar = $SpellButton/CooldownBar
var speell_cooldown: float = 0

var move_screen_left = false
var move_screen_right = false
var screen_move_speed = 1250.0

var available_units_scenes: Array
var available_cannons_scenes: Array

var units_costs: Array
var cannons_costs: Array
var tower_costs: Array = [15,15,15,15]

var units_stats: Array
var cannons_stats: Array

var amount_of_towers = 0
var current_stage = 1

var spell_projectiles: Array[CharacterBody2D]


func _ready() -> void:
	load_new_units()
	for i in range(10):
		var spell_projectile = projectile_spell_scene.instantiate()
		spell_projectiles.append(spell_projectile)
		get_tree().root.add_child(spell_projectile)
	

func advance_age():
	current_stage+=1
	load_new_units()
	player_castle.advance_age(current_stage)
	for projectile in spell_projectiles:
		projectile.advance_age()

func _process(delta) -> void:
	gold_info.text = "GOLD: " + str(global_data.player_gold)
	exp_info.text = "EXP: " + str(global_data.player_experience)
	move_camera(delta)
	if speell_cooldown>0:
		speell_cooldown-=delta
		update_cooldown_bar()

func move_camera(delta):
	if move_screen_left and camera.position.x - (screen_move_speed * delta) > 0:
		camera.position.x -= screen_move_speed * delta
	elif move_screen_right and camera.position.x + (screen_move_speed * delta) < 1600:
		camera.position.x += screen_move_speed * delta
		
	if Input.is_action_pressed("ui_left") and camera.position.x - (screen_move_speed * delta) > 0:
		camera.position.x -= screen_move_speed * delta
	elif Input.is_action_pressed("ui_right") and camera.position.x + (screen_move_speed * delta) < 1600:
		camera.position.x += screen_move_speed * delta

func _on_units_button_button_down() -> void:
	purchases_container.hide()
	available_units_grid.show()


func _on_cannons_button_button_down() -> void:
	purchases_container.hide()
	available_cannons_grid.show()


func _on_go_back_button_button_down() -> void:
	available_units_grid.hide()
	available_cannons_grid.hide()
	purchases_container.show()


func _on_move_screen_left_mouse_entered() -> void:
	move_screen_left = true


func _on_move_screen_left_mouse_exited() -> void:
	move_screen_left = false


func _on_move_screen_right_mouse_entered() -> void:
	move_screen_right = true


func _on_move_screen_right_mouse_exited() -> void:
	move_screen_right = false

func load_new_units() -> void:
	available_units_scenes = global_data.stages_units_scenes[current_stage]
	available_cannons_scenes = global_data.stages_cannons_scenes[current_stage]
	units_costs = global_data.stages_unit_costs[current_stage]
	cannons_costs = global_data.stages_cannons_costs[current_stage]
	units_stats = global_data.stages_units_stats[current_stage]
	cannons_stats = global_data.stages_cannons_stats[current_stage]
	
	$SpellButton/TextureRect.texture = load("res://Interface/Icons/Spells/SpellAge" + str(current_stage) + ".png")
	
	$AvailableUnits/Unit1/TextureRect.texture = load("res://Interface/Icons/Units/Unit1Age" + str(current_stage) + ".png")
	$AvailableUnits/Unit2/TextureRect.texture = load("res://Interface/Icons/Units/Unit2Age" + str(current_stage) + ".png")
	$AvailableUnits/Unit3/TextureRect.texture = load("res://Interface/Icons/Units/Unit3Age" + str(current_stage) + ".png")
	
	$AvailableCannons/Cannon1/TextureRect.texture = load("res://Interface/Icons/Cannons/Cannon1Age" + str(current_stage) + ".png")
	$AvailableCannons/Cannon2/TextureRect.texture = load("res://Interface/Icons/Cannons/Cannon2Age" + str(current_stage) + ".png")
	$AvailableCannons/Cannon3/TextureRect.texture = load("res://Interface/Icons/Cannons/Cannon3Age" + str(current_stage) + ".png")
	
	if available_units_scenes.size() < 4:
		$AvailableUnits/Unit4.hide()
	else:
		$AvailableUnits/Unit4/TextureRect.texture = load("res://Interface/Icons/Units/Unit41Age" + str(current_stage) + ".png")
		$AvailableUnits/Unit4.show()
		
	if available_cannons_scenes.size() < 4:
		$AvailableCannons/Cannon4.hide()
	else:
		$AvailableCannons/Cannon4/TextureRect.texture = load("res://Interface/Icons/Cannons/Cannon4Age" + str(current_stage) + ".png")
		$AvailableCannons/Cannon4.show()

func _on_buy_tower_button_button_down() -> void:
	if amount_of_towers<4 and global_data.player_gold>=tower_costs[amount_of_towers]:
		global_data.player_gold-=tower_costs[amount_of_towers]
		amount_of_towers+=1
		gameplay_map.player_castle.append_tower()

func _on_unit_1_button_down() -> void:
	if global_data.player_gold>=units_costs[0]:
		global_data.player_gold-=units_costs[0]
		var new_unit = available_units_scenes[0].instantiate()
		gameplay_map.add_child(new_unit)
		new_unit.load_unit_stats(units_stats[0])

func _on_unit_2_button_down() -> void:
	if global_data.player_gold>=units_costs[1]:
		global_data.player_gold-=units_costs[1]
		var new_unit = available_units_scenes[1].instantiate()
		gameplay_map.add_child(new_unit)
		new_unit.load_unit_stats(units_stats[1])

func _on_unit_3_button_down() -> void:
	if global_data.player_gold>=units_costs[2]:
		global_data.player_gold-=units_costs[2]
		var new_unit = available_units_scenes[2].instantiate()
		gameplay_map.add_child(new_unit)
		new_unit.load_unit_stats(units_stats[2])

func _on_unit_4_button_down() -> void:
	if global_data.player_gold>=units_costs[3]:
		global_data.player_gold-=units_costs[3]
		var new_unit = available_units_scenes[3].instantiate()
		gameplay_map.add_child(new_unit)
		new_unit.load_unit_stats(units_stats[3])

func _on_cannon_1_button_down() -> void:
	if global_data.player_gold>=cannons_costs[0]:
		global_data.player_gold-=cannons_costs[0]
		var new_cannon = available_cannons_scenes[0].instantiate()
		gameplay_map.add_child(new_cannon)
		new_cannon.load_cannon_stats(cannons_stats[0])

func _on_cannon_2_button_down() -> void:
	if global_data.player_gold>=cannons_costs[1]:
		global_data.player_gold-=cannons_costs[1]
		var new_cannon = available_cannons_scenes[1].instantiate()
		gameplay_map.add_child(new_cannon)
		new_cannon.load_cannon_stats(cannons_stats[1])

func _on_cannon_3_button_down() -> void:
	if global_data.player_gold>=cannons_costs[2]:
		global_data.player_gold-=cannons_costs[2]
		var new_cannon = available_cannons_scenes[2].instantiate()
		gameplay_map.add_child(new_cannon)
		new_cannon.load_cannon_stats(cannons_stats[2])

func _on_cannon_4_button_down() -> void:
	if global_data.player_gold>=cannons_costs[3]:
		global_data.player_gold-=cannons_costs[3]
		var new_cannon = available_cannons_scenes[3].instantiate()
		gameplay_map.add_child(new_cannon)
		new_cannon.load_cannon_stats(cannons_stats[0])

func _on_sell_cannon_button_button_down() -> void:
	gameplay_map.enable_cannon_highlighters()


func _on_advance_age_button_button_down() -> void:
	if current_stage<5 and global_data.player_experience>=global_data.stages_exp_requirements[current_stage+1]:
		advance_age()


func _on_unit_1_mouse_entered() -> void:
	$AvailableUnits/Unit1.modulate.a = 0.75
	cost_info.text = "COST: " + str(units_costs[0])
	cost_info.show()
	

func _on_unit_1_mouse_exited() -> void:
	$AvailableUnits/Unit1.modulate.a = 1.0
	cost_info.hide()
	
func _on_unit_2_mouse_entered() -> void:
	$AvailableUnits/Unit2.modulate.a = 0.75
	cost_info.text = "COST: " + str(units_costs[1])
	cost_info.show()
	
func _on_unit_2_mouse_exited() -> void:
	$AvailableUnits/Unit2.modulate.a = 1.0
	cost_info.hide()
	
func _on_unit_3_mouse_entered() -> void:
	$AvailableUnits/Unit3.modulate.a = 0.75
	cost_info.text = "COST: " + str(units_costs[2])
	cost_info.show()
	
func _on_unit_3_mouse_exited() -> void:
	$AvailableUnits/Unit3.modulate.a = 1.0
	cost_info.hide()
	
func _on_unit_4_mouse_entered() -> void:
	$AvailableUnits/Unit4.modulate.a = 0.75
	cost_info.text = "COST: " + str(units_costs[3])
	cost_info.show()
	
func _on_unit_4_mouse_exited() -> void:
	$AvailableUnits/Unit4.modulate.a = 1.0
	cost_info.hide()


func _on_units_button_mouse_entered() -> void:
	$PurchasesContainer/UnitsButton.modulate.a = 0.75
	cost_info.text = "BUY UNITS"
	cost_info.show()

func _on_units_button_mouse_exited() -> void:
	$PurchasesContainer/UnitsButton.modulate.a = 1.0
	cost_info.hide()
	
func _on_cannons_button_mouse_entered() -> void:
	$PurchasesContainer/CannonsButton.modulate.a = 0.75
	cost_info.text = "BUY CANNONS"
	cost_info.show()

func _on_cannons_button_mouse_exited() -> void:
	$PurchasesContainer/CannonsButton.modulate.a = 1.0
	cost_info.hide()

func _on_buy_tower_button_mouse_entered() -> void:
	$PurchasesContainer/BuyTowerButton.modulate.a = 0.75
	cost_info.text = "BUY TOWER: " + str(tower_costs[amount_of_towers])
	cost_info.show()

func _on_buy_tower_button_mouse_exited() -> void:
	$PurchasesContainer/BuyTowerButton.modulate.a = 1.0
	cost_info.hide()
	
func _on_sell_cannon_button_mouse_entered() -> void:
	$PurchasesContainer/SellCannonButton.modulate.a = 0.75
	cost_info.text = "SELL CANNON"
	cost_info.show()

func _on_sell_cannon_button_mouse_exited() -> void:
	$PurchasesContainer/SellCannonButton.modulate.a = 1.0
	cost_info.hide()
	
func _on_advance_age_button_mouse_entered() -> void:
	$PurchasesContainer/AdvanceAgeButton.modulate.a = 0.75
	cost_info.text = "ADVANCE AGE"
	cost_info.show()

func _on_advance_age_button_mouse_exited() -> void:
	$PurchasesContainer/AdvanceAgeButton.modulate.a = 1.0
	cost_info.hide()


func _on_cannon_1_mouse_entered() -> void:
	$AvailableCannons/Cannon1.modulate.a = 0.75
	cost_info.text = "COST: " + str(cannons_costs[0])
	cost_info.show()


func _on_cannon_1_mouse_exited() -> void:
	$AvailableCannons/Cannon1.modulate.a = 1.0
	cost_info.hide()
	
func _on_cannon_2_mouse_entered() -> void:
	$AvailableCannons/Cannon2.modulate.a = 0.75
	cost_info.text = "COST: " + str(cannons_costs[1])
	cost_info.show()


func _on_cannon_2_mouse_exited() -> void:
	$AvailableCannons/Cannon2.modulate.a = 1.0
	cost_info.hide()

func _on_cannon_3_mouse_entered() -> void:
	$AvailableCannons/Cannon3.modulate.a = 0.75
	cost_info.text = "COST: " + str(cannons_costs[2])
	cost_info.show()


func _on_cannon_3_mouse_exited() -> void:
	$AvailableCannons/Cannon3.modulate.a = 1.0
	cost_info.hide()
	
func _on_cannon_4_mouse_entered() -> void:
	$AvailableCannons/Cannon4.modulate.a = 0.75
	cost_info.text = "COST: " + str(cannons_costs[3])
	cost_info.show()


func _on_cannon_4_mouse_exited() -> void:
	$AvailableCannons/Cannon4.modulate.a = 1.0
	cost_info.hide()


func _on_spell_button_button_down() -> void:
	if speell_cooldown<=0:
		fire_spell_projectiles()
		speell_cooldown = 45.0
		update_cooldown_bar()
	
func update_cooldown_bar():
	cooldown_bar.value=speell_cooldown


func _on_spell_button_mouse_entered() -> void:
	if speell_cooldown<=0:
		$SpellButton.modulate.a = 0.75


func _on_spell_button_mouse_exited() -> void:
	$SpellButton.modulate.a = 1.0
	
func fire_spell_projectiles() -> void:
	for projectile in spell_projectiles:
		projectile.start_falling()
