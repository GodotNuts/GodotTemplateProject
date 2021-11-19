extends TileMap

export (Dictionary) onready var DeadZoneSceneMap
export (bool) onready var ShouldRemoveTileAfterSpawn

func _ready() -> void:
    if DeadZoneSceneMap and DeadZoneSceneMap.size() > 0:
        for key in DeadZoneSceneMap.keys():
            var used_cells_by_key = get_used_cells_by_id(key)
            if used_cells_by_key.size() > 0:
                for cell in  used_cells_by_key:
                    var cell_contents = DeadZoneSceneMap[key].instance()
                    add_child(cell_contents)
                    cell_contents.global_position = map_to_world(cell) + (cell_size / 2.0) + global_position
                    if ShouldRemoveTileAfterSpawn:
                        set_cellv(cell, -1)
