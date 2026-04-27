extends MarginContainer

signal pressed

@onready var name_label: Label = $InnerMargin/VBoxContainer/HBoxContainer/ItemNameLabel
@onready var price_label: Label = $InnerMargin/VBoxContainer/HBoxContainer2/ItemPriceLabel
@onready var skilltree_label: Label = $InnerMargin/VBoxContainer/HBoxContainer2/OpenSkilltreeLabel

@onready var button: Button = $Button

@export var item_type: String = ""

@export var disabled: bool = false


func _ready():
	if disabled:
		button.disabled = true
	else:
		button.pressed.connect(_on_internal_button_pressed)
	
func update_data(item_name, item_price, in_possesion):
	name_label.text = item_name.capitalize()
	price_label.text = str(int(item_price))
	
	if in_possesion:
		skilltree_label.visible = true
		price_label.visible = false
	else:
		skilltree_label.visible = false
		price_label.visible = true
	
func _on_internal_button_pressed():
	pressed.emit()
