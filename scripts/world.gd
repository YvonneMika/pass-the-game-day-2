extends Node2D

@export var card_scene : PackedScene
@export var monster_scene : PackedScene

# Dev notes: There is a custom resource called StatSheet that holds stats,
# Right now it only has health and damage used very basically when a monster or enemy attacks something
# stat_sheet.gd can be easily modified and because it it always passed when a card is used or picked up
# or character is spawned it will always be transfered

# Example:
# right now you can create a +1 damage monster card by picking them up, 
# If that monster with +1 damage attacks an enemy it can kill it
# if you make a monster without changing it's stat_sheet.damage to 1 it will be 0 and won't do damage when spawned

## Whenever a card is dragged onto the screen this function is run
func _on_card_container_card_used(card: CardUI) -> void:
	var card_pos = get_global_mouse_position()
	if card.card_type == CardUI.TYPE.MONSTER:
		spawn_character(monster_scene, card_pos, card.stat_sheet)
	else:
		spawn_item(card_scene, card_pos, card.stat_sheet)

## Spawn an item at a given position
func spawn_item(item_scene: PackedScene, spawn_pos: Vector2, stat_sheet: StatSheet) -> void:
	var item: Item = item_scene.instantiate()
	item.position = spawn_pos
	item.stat_sheet = stat_sheet
	add_child(item)
	print("Item created at " + str(spawn_pos) + " with " + str(stat_sheet.damage) + " ATK/" + str(stat_sheet.health) + " HP")

func spawn_character(character_scene: PackedScene, spawn_pos: Vector2, stat_sheet: StatSheet) -> void:
	var character: Character = character_scene.instantiate()
	var monster = monster_scene.instantiate()
	monster.stat_sheet = stat_sheet
	monster.position = spawn_pos
	add_child(monster)
	print("Monster created at " + str(spawn_pos) + " with " + str(stat_sheet.damage) + " ATK/" + str(stat_sheet.health) + " HP")
