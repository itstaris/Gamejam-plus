extends Control

func _on_menu_button_pressed():
    get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")

func _on_quit_button_pressed():
        GameManager.load_next_level()
