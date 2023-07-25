extends Character
class_name Player

@export var UI : CanvasLayer

func _enter_tree() -> void:
	UI.player = self

func on_item_pickup(item: Item):
	if item is ItemCard:
		UI.add_card()
	elif item is ItemMonsterCard:
		UI.apply_card_type_modifier(CardUI.TYPE.MONSTER) # TODO card type enum?
	elif item is ItemDamageCard:
		UI.apply_card_stat_modifier(item.stats)
	else:
		print("Couldn't find item ", item)
