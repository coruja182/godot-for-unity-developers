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


func _process(delta: float) -> void:
	if global_position == oponnent.global_position:
		attack_oponent = false
	
	if attack_oponent:
		global_position = global_position.move_toward(oponnent.global_position, delta * attack_speed)

	if !attack_oponent:
		global_position = global_position.move_toward(start_position, delta * attack_speed * 0.75)



func cast_combat_action(combat_action : CombatAction) -> void:
	current_combat_action = combat_action
	if combat_action.damage	> 0:
		attack_oponent = true
	elif combat_action.projectile_scene:
		pass
	elif combat_action.heal_amount > 0:
		pass
