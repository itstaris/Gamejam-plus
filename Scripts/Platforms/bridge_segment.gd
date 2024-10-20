extends RigidBody2D

@export var gravity : float = 1
@export var time_to_fall : float = 0.2
@export var time_to_delete : float = 1.0

func _on_body_entered(body: Node) -> void:
    # if the body is a player, turn gravity on and delete itself after a while
    if body.is_in_group("Player"):
        await get_tree().create_timer(time_to_fall).timeout
        gravity_scale = gravity
        await get_tree().create_timer(time_to_delete).timeout
        queue_free()
