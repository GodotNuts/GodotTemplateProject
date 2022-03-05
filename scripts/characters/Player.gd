extends KinematicBody2D

export (float) var MoveSpeed
export (bool) var CanJump
export (float) var JumpStrength

var _in_air = false
var _velocity = Vector2.ZERO
onready var _body = $Body

func _physics_process(delta: float) -> void:
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
    var jumped = CanJump and Input.is_action_just_pressed("ui_select")
    if jumped or _in_air:
        if jumped and not _in_air:
            _velocity = Vector2.UP * JumpStrength
            _in_air = true
        _velocity.y += GlobalProperties.Gravity * delta
        _body.position.y += _velocity.y
        if _body.position.y >= 0.0:
            _in_air = false
            _body.position.y = 0.0
            _velocity.y = 0

    move_and_slide(direction * MoveSpeed)
