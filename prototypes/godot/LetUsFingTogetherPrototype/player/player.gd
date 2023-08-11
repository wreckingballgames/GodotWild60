extends CharacterBody2D


@export var speed: float = 10000


func _physics_process(delta: float) -> void:
	var movement_axis := get_movement_input()
	velocity.y = movement_axis * speed * delta
	
	move_and_slide()


func get_movement_input() -> float:
	return Input.get_axis("move_up", "move_down")
