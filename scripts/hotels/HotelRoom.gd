extends Node2D

onready var _floor = $FloorAndWalls

func _ready() -> void:
    yield(get_tree().create_timer(2.0), "timeout")
    _floor.remove_fog()
    yield(_floor, "room_visibility_changed")
    yield(get_tree().create_timer(3.0), "timeout")
    _floor.show_fog()
