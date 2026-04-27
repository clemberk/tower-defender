extends MarginContainer

signal pressed

@onready var name_label: Label = $InnerMargin/VBoxContainer/HBoxContainer/ItemNameLabel
@onready var price_label: Label = $InnerMargin/VBoxContainer/HBoxContainer2/ItemPriceLabel
@onready var skilltree_label: Label = $InnerMargin/VBoxContainer/HBoxContainer2/OpenSkilltreeLabel

@onready var button: Button = $Button

@export var item_type: String = ""

@export var disabled: bool = false

@export var skilltree_label_is_visible = false


func _ready():
	if disabled:
		button.disabled = true
	else:
		button.pressed.connect(_on_internal_button_pressed)
		
	skilltree_label.visible = skilltree_label_is_visible
	price_label.visible = !skilltree_label_is_visible
	
func update_data(item_name, item_price):
	name_label.text = item_name.capitalize()
	price_label.text = str(int(item_price))
	
	
func _on_internal_button_pressed():
	print("Button pressed")
	pressed.emit()
