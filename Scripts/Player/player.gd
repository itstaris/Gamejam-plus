extends CharacterBody2D

# --------- VARIABLES ---------- #

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 200
@export var jump_force : float = 300
@export var acceleration : float = 500
@export var friction : float = 25
@export var gravity : float = 15
@export var coyote_time : = 0.1
@export var death_delay : float = 0.6

@export_category("Toggle Functions")
@export var inverted_controls : bool = false
@export var delay : float = 0

var jumping : bool = false
var coyote : bool = false
var last_floor : bool = false
var velocity_queue : Array[Vector2] = []
var max_velocity_queue : int = 30
var _velocity : Vector2 = Vector2.ZERO
var last_jump_time : float = 0
var jump_debounce : float = 0.1

@onready var player_sprite = $PlayerSprite
@onready var spawn_point = %SpawnPoint
@onready var level_camera = %LevelCamera
@onready var coyote_timer = $CoyoteTimer
@onready var input_capture = $InputCapture
@onready var trail_particles = $TrailParticles
@onready var death_particles = $DeathParticles
@onready var helmet_particle = $HelmetParticle

# --------- BUILT-IN FUNCTIONS ---------- #

func _ready():
    global_position = spawn_point.global_position
    coyote_timer.wait_time = coyote_time


func _process(delta):
    input_capture.delay = delay
    input_capture.inverted_controls = inverted_controls

    # Calling functions
    movement(delta)
    player_animations()
    flip_player()

# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement(delta):
    # Gravity
    _velocity = velocity
    if !is_on_floor():
        _velocity.y += gravity

    handle_jumping(delta)

    # Move Player
    var inputAxis = input_capture.x_axis

    if inputAxis != 0:
        _velocity.x = move_toward(_velocity.x, inputAxis * move_speed, acceleration)
    else:
        _velocity.x = move_toward(_velocity.x, 0, friction)

    velocity = _velocity

    move_and_slide()

    if is_on_floor() and jumping:
        jumping = false
    if !is_on_floor() and last_floor and !jumping:
        coyote = true
        coyote_timer.start()

    last_floor = is_on_floor()

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping(delta):
    if input_capture.jump and (is_on_floor() or coyote) and last_jump_time > jump_debounce:
        last_jump_time = 0
        jump()
    else:
        last_jump_time += delta

# Player jump
func jump():
    jump_tween()
    AudioManager.jump_sfx.play()
    _velocity.y = -jump_force
    jumping = true

# Handle Player Animations
func player_animations():
    trail_particles.emitting = false

    if is_on_floor():
        if abs(velocity.x) > 0:
            trail_particles.emitting = true
            player_sprite.play("Walk", 1.5)
        else:
            player_sprite.play("Idle")
    else:
        player_sprite.play("Jump")

# Flip player sprite based on X velocity
func flip_player():
    if velocity.x < 0:
        player_sprite.flip_h = true
    elif velocity.x > 0:
        player_sprite.flip_h = false

func jump_tween():
    var tween = create_tween()
    tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
    tween.tween_property(self, "scale", Vector2.ONE, 0.1)

# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap
func _on_hitbox_body_entered(body):
    if body.is_in_group("Traps"):
        AudioManager.death_sfx.play()
        death_particles.emitting = true
        helmet_particle.emitting = true
        input_capture.disable_input()
        level_camera.shake()
        player_sprite.visible = false
        trail_particles.visible = false
        await get_tree().create_timer(death_delay).timeout
        GameManager.add_death()

func _on_coyote_timer_timeout():
    coyote = false
