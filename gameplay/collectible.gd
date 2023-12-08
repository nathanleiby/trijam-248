extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	Events.emit_signal("time_collected", 15)
	queue_free()
