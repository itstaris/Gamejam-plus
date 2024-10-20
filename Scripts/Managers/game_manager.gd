extends Node2D

var death_count : int = 0
var princess_collected : bool = false
var current_level : int = 1

# Preload death scene
const death_scene = preload("res://Scenes/Interface/DeathScreen.tscn")

# All levels are stored in the same folder, as Level1.tscn, Level2.tscn, etc.
func level_path(level: int) -> String:
    return "res://Scenes/Levels/Level%d.tscn" % level

# Sets princess as collected
func set_princess_collected():
    princess_collected = true

# Adds a death, changes scene to death screen
func add_death():
    death_count += 1
    get_tree().change_scene_to_packed.call_deferred(death_scene)

# Loads next level
func load_next_level():
    current_level += 1
    reload_level()

# Reloads current level
func reload_level():
    princess_collected = false
    get_tree().change_scene_to_file.call_deferred(level_path(current_level))
