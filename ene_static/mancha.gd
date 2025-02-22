extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("enemigos")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body:Node2D) -> void :
	if body.is_in_group("jugadores"):
		body.perder_vida()
