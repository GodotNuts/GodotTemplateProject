extends TileMap

signal room_visibility_changed(is_visible)

onready var _fog = $Fog
onready var _tween = $Tween

func _ready() -> void:
    var used_cells = get_used_cells()
    for cell in used_cells:
        _fog.set_cell(cell.x, cell.y, 0, false, false, false, Vector2(1, 1))

    _fog.update_bitmask_region()
    remove_fog()

func remove_fog() -> void:
    _tween_fog(Color.transparent)

func show_fog() -> void:
    _tween_fog(Color.white)

func _tween_fog(to_color : Color) -> void:
    _tween.interpolate_property(_fog, "modulate", _fog.modulate, to_color, 1.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
    _tween.start()
    yield(_tween, "tween_all_completed")
    emit_signal("room_visibility_changed", to_color == Color.transparent)
