extends Control
class_name CardSelectionUI

@export var CardContainer : HBoxContainer

signal card_selected(card: CardUI) ## Emitted when a card is selected

func select_card():
	if CardContainer.get_child_count() > 0:
		get_tree().paused = true
		visible = true

func _on_card_container_card_clicked(card) -> void:
	get_tree().paused = false
	visible = false
	emit_signal("card_selected", card)
