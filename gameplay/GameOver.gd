extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOverCanvas.visible = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_timer_timeout():
	$GameOverCanvas.visible = true

