extends CanvasLayer

@export var card_container : HBoxContainer
@export var card_scene : PackedScene
@export var card_select : Control

var player # Player connects this
var type
var stat_sheet

@onready var CardSelectUILabel := $CardSelectUI/Label

func _ready() -> void:
	card_select.visible = false

func add_card(stat_sheet: StatSheet):
	var card = card_scene.instantiate()
	card.stat_sheet = stat_sheet
	card_container.add_child(card)

func apply_card_type_modifier(new_type):
	#TODO: Change text depending on pickup
	CardSelectUILabel.text = "Select a card to change type"
	type = new_type
	card_select.select_card()

func apply_card_stat_modifier(new_stats: StatSheet):
	CardSelectUILabel.text = "Select a card to give +" + str(new_stats.damage) + "/+" + str(new_stats.health)
	stat_sheet = new_stats
	card_select.select_card()

#Called when a boost or type card is used
func _on_card_select_ui_card_selected(selected_card: CardUI) -> void:
	if type:
		selected_card.update_type(type)
	if stat_sheet:
		selected_card.update_stats(stat_sheet)
	stat_sheet = null
	type = null
