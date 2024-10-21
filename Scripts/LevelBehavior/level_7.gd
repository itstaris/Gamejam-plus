extends Node2D

@onready var light: PointLight2D = $CanvasModulate/PointLight2D
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var lamp: Sprite2D = $Lamp

func _process(_delta: float) -> void:
    # Randomly change the light to be on, off, or dimmed
    if randf() < 0.01:
        match randi() % 3:
            0: # On
                canvas_modulate.color = Color(1, 1, 1, 1)
                light.energy = 1
                lamp.frame = randi() % 2
            1: # Off
                canvas_modulate.color = Color(0, 0, 0, 1)
                light.energy = 0
                lamp.frame = 2
            2: # Dimmed
                canvas_modulate.color = Color(0.5, 0.5, 0.5, 1)
                light.energy = 0.5
                lamp.frame = randi() % 2
