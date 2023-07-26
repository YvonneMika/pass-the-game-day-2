extends Panel
class_name CardUI
## Base card all cards inherit from

signal card_used(card: CardUI, card_position: Vector2) ## Emitted when card is played
signal type_changed() ## Emitted when type is changed
signal card_clicked(card: CardUI) ## Emitted when card is clicked

@export_category("Stats")
enum TYPE { NONE, MONSTER, ITEM, SPELL }
@export var card_type := TYPE.NONE
@export var stat_sheet : StatSheet
@export var extra_damage : int
@export var extra_health : int

@onready var anim_player := $AnimationPlayer
@onready var hover_parent := get_node("../../..")
@onready var container := get_node("..")
@onready var damage_lbl := $MarginContainer/VBoxContainer/Stats
@onready var type_lbl := $MarginContainer/VBoxContainer/Type
@onready var name_lbl := $MarginContainer/VBoxContainer/MarginContainer/Name
@onready var image := $MarginContainer/VBoxContainer/MarginContainer2/TextureRect

var mouse_is_inside := false
var hovering := false

func _ready() -> void:
	card_used.connect(container._card_used)
	card_clicked.connect(container._card_clicked)
	update_card()

func update_type(new_type: TYPE):
	if new_type != card_type:
		type_changed.emit()
		card_type = new_type
	update_card()
	
func update_stats(new_stats: StatSheet):
	if stat_sheet == null and new_stats != null:
		stat_sheet = new_stats.duplicate()
	elif new_stats != null:
		stat_sheet.damage += new_stats.damage
		stat_sheet.health += new_stats.health
	update_card()

func _on_mouse_entered() -> void:
	mouse_is_inside = true
	if hovering: return
	anim_player.play("focus")
	z_index = 2

func _on_mouse_exited() -> void:
	mouse_is_inside = false
	if hovering: return
	anim_player.play("focus_exit")
	z_index = 1

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if hovering: return
	if anim_name == "focus_exit":
		z_index = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("primary_action") and mouse_is_inside:
			if get_tree().paused: # Only place cards if not paused
				emit_signal("card_clicked", self)
				return
			hovering = true
			reparent(hover_parent)
			rotation_degrees = 0
		if event.is_action_released("primary_action") and hovering:
			hovering = false
			_on_mouse_exited()
			if container.get_parent().get_global_rect().has_point(Vector2(position.x, position.y + size.y * 0.5)):
				reparent(container)
			else:
				emit_signal("card_used", self)
				queue_free()
	
	if event is InputEventMouseMotion:
		if hovering:
			position += event.relative


func _on_renamed() -> void:
	$MarginContainer/VBoxContainer/MarginContainer/Name.text = name

func type_to_str(type) -> String:
	match type:
		TYPE.MONSTER:
			return "Monster"
		TYPE.ITEM:
			return "Item"
		TYPE.SPELL:
			return "Spell"
		_:
			return ""

func update_card():
	if !is_node_ready(): return
	name_lbl.text = calc_name()
	type_lbl.text = type_to_str(card_type)
	
	if card_type == null:
		image.texture = null
	if card_type == TYPE.MONSTER:
		image.texture = load("res://assets/images/place_holder.png")
	
	if stat_sheet.damage > 0:
		damage_lbl.text = str(stat_sheet.damage) + " ATK " + str(stat_sheet.health) + " HP"
	else:
		damage_lbl.text = ""

func calc_name() -> String:
	var name = ""
	
	#Add adjective
	if stat_sheet.damage > 0 and stat_sheet.health > 0 and not card_type == TYPE.NONE:
		var total_stats = stat_sheet.damage + stat_sheet.health
		if total_stats > 10:
			name += "Massive "
		elif total_stats > 8:
			name += "Huge "
		elif total_stats > 6:
			name += "Sizeable "
		elif total_stats > 4:
			name += "Medium "
		else:
			name += "Small "
	
	#Add base name
	if card_type == TYPE.MONSTER:
		name += "Monster"
		
	#Possible future types?
	elif card_type == TYPE.ITEM:
		name += "Potion"
	elif card_type == TYPE.SPELL:
		name += "Fireball"
	
	if name == "":
		name = "Empty Card"
	
	return name
