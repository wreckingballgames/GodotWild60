extends CenterContainer


var rank: String

@export var scroll_speed: float = 2.0

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var victory_label: Label = %VictoryLabel
@onready var mech_head: Sprite2D = %MechHead
@onready var mech_body: Sprite2D = %MechBody
@onready var rank_label: Label = %RankLabel
@onready var next_level: PackedScene = preload("res://title_menu/title_menu.tscn")

@onready var pinky_pressed: bool = false
@onready var ring_pressed: bool = false
@onready var middle_pressed: bool = false
@onready var index_pressed: bool = false
@onready var thumb_pressed: bool = false


func _process(delta: float) -> void:
	player.global_position.y -= scroll_speed


func _on_win_area_area_entered(area: Area2D) -> void:
	animation_player.play("death")
	check_inputs()
	rank = check_rank()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	mech_head.hide()
	mech_body.hide()
	victory_label.show()
	rank_label.text = "Rank: " + rank
	rank_label.show()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_packed(next_level)


func check_inputs() -> void:
	if Input.is_action_pressed("flick_pinky_finger"):
		pinky_pressed = true
	if Input.is_action_pressed("flick_ring_finger"):
		ring_pressed = true
	if Input.is_action_pressed("flick_middle_finger"):
		middle_pressed = true
	if Input.is_action_pressed("flick_index_finger"):
		index_pressed = true
	if Input.is_action_pressed("flick_thumb"):
		thumb_pressed = true


func check_rank() -> String:
	if middle_pressed:
		return "F U"
	elif ring_pressed and index_pressed and thumb_pressed:
		return "Rockstar"
	else:
		return "S"
