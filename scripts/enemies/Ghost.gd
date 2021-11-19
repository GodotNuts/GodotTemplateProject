extends "res://scripts/enemies/AreaEnemyBase.gd"

const FlightMagnitude = 20.0
const FlightFrequency = 5.0
const FlightSpeed = 8.0

var _current_flight_angle := 0.0
var _flying_left := 1

func _physics_process(delta : float) -> void:
    _current_flight_angle += deg2rad(FlightFrequency)
    global_position.y += FlightMagnitude * sin(_current_flight_angle) * delta
    global_position.x -= FlightSpeed * delta * (_flying_left)

    if _left_wall_collision.is_colliding():
        _flying_left = -1
        _sprite.scale.x = -1
    elif _right_wall_collision.is_colliding():
        _flying_left = 1
        _sprite.scale.x = 1

