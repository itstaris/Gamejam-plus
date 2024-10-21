extends Area2D

@export var next_scene: PackedScene
@onready var sprite = $Sprite2D


func _process(_delta):
    # Show door as open if princess has been collected
    sprite.frame = 1 if GameManager.princess_collected else 0


func _on_body_entered(body):
    # Load next level if player enters door
    if body.is_in_group("Player") and GameManager.princess_collected:
        AudioManager.level_clear_sfx.play()
        GameManager.load_next_level()
