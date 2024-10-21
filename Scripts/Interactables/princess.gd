extends Area2D

var collectable: bool = true

func _on_body_entered(body):
    # Check if player collected the princess
    if body.is_in_group("Player") and collectable:
        collectable = false
        AudioManager.princess_get_sfx.play()
        $anim.play("katia")

func _on_anim_animation_finished():
    GameManager.set_princess_collected()
    queue_free()
