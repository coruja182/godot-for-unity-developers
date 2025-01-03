extends Area2D
class_name Character


signal on_health_change
signal on_die(character: Area2D)

@export var combat_actions : Array[CombatAction]
@export var oponnent : Area2D
@export var is_player : bool
@export var character : Area2D
@export var current_health : int = 25
@export var max_health : int = 25

@export var attack_speed : int = 2500

var start_position : Vector2
var attack_oponent : bool
var current_combat_action : CombatAction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = global_position
	get_parent().connect("on_begin_turn", on_character_begin_turn)


func _process(delta: float) -> void:
	if attack_oponent:
		global_position = global_position.move_toward(oponnent.global_position, delta * attack_speed)

	if !attack_oponent:
		global_position = global_position.move_toward(start_position, delta * attack_speed * 0.75)

	if attack_oponent and global_position == oponnent.global_position:
		attack_oponent = false
		get_parent().end_turn()


func cast_combat_action(combat_action : CombatAction) -> void:
	current_combat_action = combat_action
	if combat_action.damage	> 0:
		attack_oponent = true
	elif combat_action.projectile_scene:
		pass
	elif combat_action.heal_amount > 0:
		pass

func on_character_begin_turn(p_character : Character) -> void:
	if character == p_character:
		determine_combat_action()


func determine_combat_action() -> void:
	var health_percentage : float = get_health_percentage()
	var want_to_heal : bool = false
	var assigned_combat_action : CombatAction
	
	if health_percentage <= 35:
		var random_int = randi() % 3
		want_to_heal =  random_int == 0

	if want_to_heal and has_combat_action_of_type(CombatAction.Type.HEAL):
		assigned_combat_action = get_combat_action_of_type(CombatAction.Type.HEAL)
	elif has_combat_action_of_type(CombatAction.Type.ATTACK):
		assigned_combat_action = get_combat_action_of_type(CombatAction.Type.ATTACK)

	if assigned_combat_action:
		cast_combat_action(assigned_combat_action)
	else:
		print_debug("WARN: NO ACTION WAS COMPUTED")
		get_parent().end_turn()


func get_health_percentage() -> float:
	return (float(current_health) / float(max_health)) * 100


func has_combat_action_of_type(type: CombatAction.Type) -> bool:
	for i_combat_action: CombatAction in (character as Character).combat_actions:
		if i_combat_action.action_type == type:
			return true

	return false


func get_combat_action_of_type(type: CombatAction.Type) -> CombatAction:
	var available_actions = combat_actions.filter(func(ca): return ca.action_type == type)
	return available_actions[randi_range(0, available_actions.size()-1)]
