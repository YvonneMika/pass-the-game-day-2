extends Character
class_name Player

@export var UI : CanvasLayer

func _enter_tree() -> void:
	UI.player = self

func on_item_pickup(item: Item):
	if item is Card:
		UI.add_card()
