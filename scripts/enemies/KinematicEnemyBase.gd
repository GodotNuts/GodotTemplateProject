extends KinematicBody2D

onready var _left_wall_collision = $LeftWallCollision
onready var _left_ground_collection = $LeftGroundCollision
onready var _right_wall_collision = $RightWallCollision
onready var _right_ground_collection = $RightGroundCollision
onready var _sprite = $Sprite
onready var _anim = $AnimationPlayer

var _velocity := Vector2.ZERO

func _on_EnemyHitBox_area_entered(area: Area2D) -> void:
    take_damage(area)

func take_damage(area : Area2D) -> void:
    pass
