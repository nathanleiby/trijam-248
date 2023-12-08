extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Move this to "when player collides" instead
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Events.emit_signal("time_collected", 5)
	pass
