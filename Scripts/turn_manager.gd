extends Node
class_name TurnManager


signal on_begin_turn(character : Area2D)
signal on_end_turn(character : Area2D)


@export var characters : Array[Area2D]
@export var next_turn_delay : float = 2.0
@export var current_character : Area2D

var current_character_index : int = -1
var game_over : bool


func _ready() -> void:
	begin_next_turn()


func begin_next_turn() -> void:
	current_character_index += 1

	if current_character_index == characters.size():
		current_character_index = 0
		
	current_character = characters[current_character_index]
	emit_signal("on_begin_turn", current_character)


func end_turn() -> void:
	emit_signal("on_end_turn", current_character)
	await get_tree().create_timer(next_turn_delay).timeout
	begin_next_turn()
