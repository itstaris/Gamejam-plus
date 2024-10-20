extends Node

# This script captures the input from the player and stores it in a queue.
# Needed to implement inverted controls and forced input delay.
# The delay is set to roughly half a second, at 60 FPS.

var input_disabled : bool = false
var inverted_controls : bool = false
var delay : float = 30

var x_axis : float = 0
var jump : bool = false

var x_axis_queue : Array[float] = []
var jump_queue : Array[bool] = []

func enable_input():
    input_disabled = false
    reset_input()

func disable_input():
    input_disabled = true
    reset_input()

func reset_input():
    x_axis = 0
    jump = false
    x_axis_queue.clear()
    jump_queue.clear()

func _process(_delta: float) -> void:
    if !input_disabled:
        if delay > 0:
            if x_axis_queue.size() < delay:
                x_axis_queue.append(Input.get_axis("Left", "Right") * (-1 if inverted_controls else 1))
                jump_queue.append(Input.is_action_pressed("Jump"))
            else:
                x_axis = x_axis_queue.pop_front()
                jump = jump_queue.pop_front()
        else:
            x_axis = Input.get_axis("Left", "Right") * (-1 if inverted_controls else 1)
            jump = Input.is_action_pressed("Jump")
