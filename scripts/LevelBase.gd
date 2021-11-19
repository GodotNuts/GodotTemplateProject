extends Node2D

onready var _player = $Player
onready var _camera = $Camera2D

func _ready() -> void:
    _player.set_camera(_camera)
