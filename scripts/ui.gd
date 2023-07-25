extends CanvasLayer

@export var card_container : HBoxContainer
@export var card_scene : PackedScene
@export var card_select : Control

var player # Player connects this
var type
var stats

func _ready() -> void:
	card_select.visible = false

func add_card():
	var card = card_scene.instantiate()
	card_container.add_child(card)

func apply_card_type_modifier(new_type):
	type = new_type
	card_select.select_card()

func apply_card_stat_modifier(new_stats: Dictionary):
	stats = new_stats
	card_select.select_card()

func _on_card_select_ui_card_selected(selected_card: CardUI) -> void:
	if type:
		selected_card.card_type = type
	if stats:
		for stat in stats:
			selected_card[stat] += stats[stat]
			print(selected_card[stat])
	stats = null
	type = null
