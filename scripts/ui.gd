extends CanvasLayer

@export var card_container : HBoxContainer
@export var card_scene : PackedScene

var player # Player should connect this

func add_card():
	var card = card_scene.instantiate()
	card_container.add_child(card)
