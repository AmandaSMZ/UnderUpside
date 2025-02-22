extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ani_gorra.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body:Node2D):
	if body.is_in_group("jugadores"):
		$audio_gorra.play()
		visible = false
		print("Reproduciendo sonido:", $audio_gorra.playing)
		body.add_gorra()
		await $audio_gorra.finished
		queue_free()
		
