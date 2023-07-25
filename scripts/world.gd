extends Node2D

@export var card_scene : PackedScene
@export var monster_scene : PackedScene

## Whenever a card is dragged onto the screen this function is run
func _on_card_container_card_used(card: CardUI) -> void:
	var card_pos = get_global_mouse_position()
	if card.card_type == CardUI.TYPE.MONSTER:
		spawn_character(monster_scene, card_pos, card.stat_sheet)
		
	else:
		spawn_item(card_scene, card_pos)

## Spawn an item at a given position
func spawn_item(item_scene: PackedScene, spawn_pos: Vector2) -> void:
	var item: Item = item_scene.instantiate()
	item.position = spawn_pos
	add_child(item)

func spawn_character(character_scene: PackedScene, spawn_pos: Vector2, stat_sheet: StatSheet) -> void:
	var character: Character = character_scene.instantiate()
	var monster = monster_scene.instantiate()
	monster.stat_sheet = stat_sheet
	monster.position = spawn_pos
	add_child(monster)
