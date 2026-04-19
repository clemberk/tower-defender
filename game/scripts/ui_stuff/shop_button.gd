extends MarginContainer

signal pressed

@onready var name_label: Label = $InnerMargin/VBoxContainer/HBoxContainer2/UpgradeNameLabel
@onready var multiplier_label: Label = $InnerMargin/VBoxContainer/HBoxContainer2/MultiplierLabel
@onready var level_label: Label = $InnerMargin/VBoxContainer/HBoxContainer/UpgradeLevelLabel
@onready var price_label: Label = $InnerMargin/VBoxContainer/HBoxContainer/UpgradePriceLabel
@onready var container: VBoxContainer = $InnerMargin/VBoxContainer
@onready var button: Button = $Button

@export var upgrade_type: String = ""

func _ready():
	button.pressed.connect(_on_internal_button_pressed)
	
func update_data(upgrade_name, upgrade_multiplier, upgrade_level, upgrade_price):
	name_label.text = upgrade_name.capitalize()
	multiplier_label.text = "(x" + str(snapped(upgrade_multiplier, 0.1)) + ")"
	level_label.text = "Level: " + str(upgrade_level)
	price_label.text = str(int(upgrade_price))
	
func _on_internal_button_pressed():
	print("Button pressed")
	pressed.emit()
