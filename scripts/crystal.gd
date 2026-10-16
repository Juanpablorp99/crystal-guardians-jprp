extends Area2D

signal collected

var was_collected: bool = false

func _on_body_entered(body: Node2D) -> void:
	if was_collected:
		return

	if body.is_in_group("player"):
		# Solo cuenta si la misión de recoger cristales está activa
		if not QuestManager.collect_crystal():
			return
		was_collected = true
		collected.emit()
		queue_free()
