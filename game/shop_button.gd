extends MarginContainer

signal pressed

@onready var name_label: Label = $InnerMargin/VBoxContainer/UpgradeNameLabel
@onready var level_label: Label = $InnerMargin/VBoxContainer/HBoxContainer/UpgradeLevelLabel
@onready var price_label: Label = $InnerMargin/VBoxContainer/HBoxContainer/UpgradePriceLabel
@onready var container: VBoxContainer = $InnerMargin/VBoxContainer
@onready var button: Button = $Button

@export var upgrade_type: String = ""

func _ready():
	button.pressed.connect(_on_internal_button_pressed)
	
func update_data(upgrade_name, upgrade_level, upgrade_price):
	name_label.text = upgrade_name.capitalize()
	level_label.text = "Level: " + str(upgrade_level)
	price_label.text = str(upgrade_price)
	
func _on_internal_button_pressed():
	print("Button pressed")
	pressed.emit()
