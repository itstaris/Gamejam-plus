extends Sprite2D


func _process(_delta):
    # Show the princesss head icon if the princess has been collected
    visible = GameManager.princess_collected
