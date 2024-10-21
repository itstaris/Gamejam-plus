extends Camera2D

@export var shake_strength: float = 20.0
@export var shake_fade: float = 10.0
@export var shaking: bool = false

var rng = RandomNumberGenerator.new()
var _shake_strength: float = 0.0

func shake():
    _shake_strength = shake_strength

func _process(delta):
    if _shake_strength > 0:
        _shake_strength = lerp(_shake_strength, 0.0, shake_fade * delta)
        offset = Vector2(
            rng.randf_range(-_shake_strength, _shake_strength),
            -_shake_strength
        )
