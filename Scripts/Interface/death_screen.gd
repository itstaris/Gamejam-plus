extends Node2D

@onready var timer: Timer = $Timer


func _ready() -> void:
    # Death screen is shown for 0.5 seconds
    timer.start()


func _on_death_timer_timeout() -> void:
    # Once the timer is done, reload the failed level
    GameManager.reload_level()
