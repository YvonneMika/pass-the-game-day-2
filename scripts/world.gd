extends Node2D

@export var card_scene : PackedScene


## Whenever a card is dragged onto the screen this function is run
func _on_card_container_card_used(card: CardUI) -> void:
	var card_pos = get_global_mouse_position()
	if card.card_type == CardUI.TYPE.MONSTER:
		
	else:
		spawn_item(card_scene, card_pos)

## Spawn an item at a given position
func spawn_item(item_scene: PackedScene, spawn_pos: Vector2) -> void:
	var item: Item = item_scene.instantiate()
	item.position = spawn_pos
	add_child(item)
