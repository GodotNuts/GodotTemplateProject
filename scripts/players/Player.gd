extends KinematicBody2D

# States: InAir, OnFloor, Invincible, Running, Idle, OnWall, Dash, Spinning

export (float) var Speed = 220
export (float) var JumpStrength = -200
export (float, 0, 1.0) var Friction = 0.1
export (float, 0, 1.0) var Acceleration = 0.25

onready var _sprite = $Sprite
onready var _rwallray = $RightWallCollision
onready var _lwallray = $LeftWallCollision
onready var _anim = $AnimationPlayer
onready var _knockback_timer = $RegainControlTimer

var _previous_animation = ""
var _velocity = Vector2.ZERO
var _was_on_floor = true
var _is_on_wall = false
var _was_on_wall = false
var _player_jumped = false
var _x_is_toward_wall = false
var _x_sign = 0
var _current_jump_strength = JumpStrength
var MaxJumps = 2
var MaxJumpsWithWall = 3
var _current_gravity = GlobalProperties.Gravity
var _can_jump_counter = CanDoCounter.new(MaxJumps, "ui_up")

var _can_control = true
var _current_knockback_direction = 0
const KnockbackStrength = 80
var _current_knockback_speed

func _physics_process(delta : float) -> void:
    if _can_control:
        _was_on_floor = is_on_floor()
        _is_on_wall = is_on_wall()
        _get_x_input(delta)
        _x_sign = sign(_velocity.x)
        _reset_jump()
        _set_facing_direction()
        _apply_gravity(delta)
        _commit_move()
        _check_jump()
        _play_animation()
        _was_on_wall = _is_on_wall
    else:
        _apply_knockback_directional_movement(delta)
        _apply_gravity(delta)
        _commit_move()
        _play_animation()

func _on_RegainControlTimer_timeout() -> void:
    _can_control = true
    _current_knockback_direction = 0

func knockback(from_pos : Vector2) -> void:
    _can_control = false
    _current_knockback_direction = (global_position - from_pos).angle()
    _current_knockback_speed = KnockbackStrength
    _knockback_timer.start()

func _apply_knockback_directional_movement(delta : float) -> void:
    _velocity = Vector2.RIGHT.rotated(_current_knockback_direction) * _current_knockback_speed
    _current_knockback_speed = lerp(_current_knockback_speed, 0, delta)

func _reset_jump() -> void:
    if _was_on_floor:
        _can_jump_counter.reset()
        _can_jump_counter.update_max(MaxJumps)
        _current_jump_strength = JumpStrength
    elif _was_on_wall:
        _can_jump_counter.update_max(MaxJumpsWithWall)
        _current_jump_strength = JumpStrength / 1.2

func _check_jump() -> void:
    _player_jumped = _can_jump_counter.can_do() and _can_jump_counter.is_triggered()

    if _player_jumped:
        _velocity.y = _current_jump_strength

func _commit_move() -> Vector2:
    _velocity = move_and_slide(_velocity, Vector2.UP)
    return _velocity

func _apply_gravity(delta : float) -> void:
    _velocity.y += _current_gravity * delta

func _play_animation() -> void:
    var x_is_zero = is_zero_approx(_velocity.x)
    var is_on_floor = is_on_floor()
    if not x_is_zero:
        _sprite.scale.x = sign(_velocity.x)
    if is_on_floor and not x_is_zero:
        _play("Run")
    elif not is_on_floor:
        _play("Jump")
    elif is_on_floor and x_is_zero:
        _play("Idle")

func _play(animation : String) -> void:
    if _previous_animation != animation:
        _anim.play(animation)
        _previous_animation = animation

func _get_x_input(delta : float) -> void:
    var dir = 0
    _velocity.x = 0
    if Input.is_action_pressed("ui_right"):
        dir += 1
    if Input.is_action_pressed("ui_left"):
        dir -= 1

    if not is_zero_approx(dir):
        _velocity.x = lerp(_velocity.x, dir * Speed, Acceleration)
    else:
        _velocity.x = lerp(_velocity.x, 0, Friction)

func take_damage(damage : int) -> void:
    print("Taking " + str(damage) + " damage")

func _set_facing_direction() -> void:
    if _x_sign != _sprite.scale.x and _x_sign != 0:
        _sprite.scale.x = _x_sign

func set_camera(camera) -> void:
    $CameraTransform.remote_path = camera.get_path()

class CanDoCounter:
    var _max
    var _count = 0
    var _was = false
    var _action

    func _init(max_, action) -> void:
        _max = max_
        _action = action

    func reset(to_value : int = 0) -> void:
        _count = to_value

    func can_do() -> bool:
        if is_triggered():
            if _was:
                _count = 1
            else:
                _count += 1

            return _count < _max

        return true

    func update_max(max_) -> void:
        _max = max_

    func is_triggered() -> bool:
        return Input.is_action_just_pressed(_action)


