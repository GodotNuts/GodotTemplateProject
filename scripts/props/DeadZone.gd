extends Area2D

func _on_DeadZone_body_entered(body: Node) -> void:
    print("Should be killing " + body.name + ". (Make sure to check your collision masks!)")
