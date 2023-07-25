extends Panel
class_name CardUI
## Base card all cards inherit from

signal card_used(card: CardUI, card_position: Vector2) ## Emitted when card is played
signal type_changed() ## Emitted when type is changed
signal card_clicked(card: CardUI) ## Emitted when card is clicked

@export_category("Stats")
enum TYPE { NONE, MONSTER, ITEM, SPELL }
@export var card_type := TYPE.NONE:
	set(p_card_type):
		if p_card_type != card_type:
			card_type = p_card_type
			$MarginContainer/VBoxContainer/MarginContainer/Type.text = type_to_str(card_type)
			emit_signal("type_changed") # TODO: can you emit signals from setters?
@export var stat_sheet : StatSheet:
	set(p_stat_sheet):
		if stat_sheet != p_stat_sheet:
			stat_sheet = p_stat_sheet
			update_card()

@onready var anim_player := $AnimationPlayer
@onready var hover_parent := get_node("../../..")
@onready var container := get_node("..")
@onready var damage_lbl := $MarginContainer/VBoxContainer/Damage

var mouse_is_inside := false
var hovering := false

func _ready() -> void:
	card_used.connect(container._card_used)
	card_clicked.connect(container._card_clicked)
	$MarginContainer/VBoxContainer/MarginContainer/Name.text = name
	$MarginContainer/VBoxContainer/MarginContainer/Type.text = type_to_str(TYPE)
	if stat_sheet.damage > 0:
		damage_lbl.text = str(stat_sheet.damage)
	else:
		damage_lbl.text = ""

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
			return "None"

func update_card():
	if !is_node_ready(): return
	if stat_sheet.damage > 0:
		damage_lbl.text = str(stat_sheet.damage)
	else:
		damage_lbl.text = ""
