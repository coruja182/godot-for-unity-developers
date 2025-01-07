class_name Menu extends Control


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/sample_scene.tscn")
