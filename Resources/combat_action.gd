extends Resource
class_name CombatAction 

enum Type {
	ATTACK,
	HEAL
}

@export var display_name : String
@export var action_type : Type

@export_category("Damage")
@export var damage : int
@export var projectile_scene: PackedScene

@export_category("Heal")
@export var heal_amount: int
