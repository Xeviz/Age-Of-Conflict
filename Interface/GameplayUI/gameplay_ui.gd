extends Control

@onready var resources_container = $ResourcesContainer
@onready var purchases_container = $PurchasesContainer
@onready var available_units = $AvailableUnits
@onready var available_cannons = $AvailableCannons



func _on_units_button_button_down():
	purchases_container.hide()
	available_units.show()


func _on_cannons_button_button_down():
	purchases_container.hide()
	available_cannons.show()


func _on_go_back_button_button_down():
	available_units.hide()
	available_cannons.hide()
	purchases_container.show()
