extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func actualizar_vidas():
	if $hbox_vidas.get_child_count() > 0:
		$hbox_vidas.get_child($hbox_vidas.get_child_count() - 1).queue_free()
		
