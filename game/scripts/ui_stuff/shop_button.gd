extends MarginContainer

signal pressed

@onready var name_label: Label = $InnerMargin/VBoxContainer/HBoxContainer2/UpgradeNameLabel
@onready var new_value_label: Label = $InnerMargin/VBoxContainer/HBoxContainer2/NewValueLabel
@onready var level_label: Label = $InnerMargin/VBoxContainer/HBoxContainer/UpgradeLevelLabel
@onready var price_label: Label = $InnerMargin/VBoxContainer/HBoxContainer/UpgradePriceLabel
@onready var container: VBoxContainer = $InnerMargin/VBoxContainer
@onready var button: Button = $Button

@export var disabled: bool = false
@export var upgrade_type: String = ""

func _ready():
	if disabled:
		button.disabled = true
	else:
		button.pressed.connect(_on_internal_button_pressed)
	
func update_data(upgrade_name, next_value, upgrade_level, upgrade_price):
	name_label.text = upgrade_name.capitalize()
	var new_value_text: String = ""
	match upgrade_name:
		"damage":
			new_value_text = " (Next: x" + str(snapped(next_value, 0.01)) + ")"
		"fire_rate":
			new_value_text = " (Next: " + str(snapped(next_value, 0.01)) + " r/s)"
		"crit_chance":
			new_value_text = " (Next: " + str(snapped(next_value, 0.1)) + "%)"
		"crit_multiplier":
			new_value_text = " (Next: " + str(int(next_value)) + "%)"
			
	new_value_label.text = new_value_text
	level_label.text = "Level: " + str(upgrade_level)
	price_label.text = str(int(upgrade_price))
	
func _on_internal_button_pressed():
	print("Button pressed")
	pressed.emit()
