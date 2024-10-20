extends Area2D


func _process(_delta):
    # Hide princess if already collected
    visible = !GameManager.princess_collected


func _on_body_entered(body):
    # Check if player collected the princess
    if body.is_in_group("Player"):
        GameManager.set_princess_collected()
