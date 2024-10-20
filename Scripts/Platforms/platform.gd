extends Node2D

const WAIT_duration := 1
@onready var plataform :=$plataforma as AnimatableBody2D
@export var move_speed := 3.0
@export var distance := 192
@export var move_horizontal := true

var follow := Vector2.ZERO
var plataform_center :=16

func _ready():
    move_plataform()

func _physics_process(delta: float) -> void:
    plataform.position = plataform.position.lerp(follow, 0.5)
    
    
func move_plataform():
    var move_direction = Vector2.RIGHT * distance if move_horizontal else -Vector2.UP * distance
    var duration = move_direction.length() / float(move_speed * plataform_center)
    
    var plataform_tween = create_tween().set_loops().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
    plataform_tween.tween_property(self, "follow", move_direction, duration).set_delay(WAIT_duration)
    plataform_tween.tween_property(self, "follow", Vector2.ZERO, duration).set_delay(WAIT_duration)
