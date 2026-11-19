# Copyright (C) 2026 LibreStudios
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
extends Node2D

var pipe_scene = preload("res://Scenes/Pipes.tscn")
@onready var ScoreLabel = $HUD/CanvasLayer/Score
@onready var Pipes = $Environment/Pipes/Pipes
var score = 0
@onready var Player = $Character/Player
var global_speed = 200.0
@onready var FPSLabel = $HUD/CanvasLayer/FPSLabel
const SAVE_PATH = "user://highscore.save"
const LAST_SCORE_PATH = "user://last_score.save"
@export var pointasp: AudioStreamPlayer
@export var game_over_anim: AnimationPlayer

func save_new_high_score(current_score: int) -> void:
	
	var last_file = FileAccess.open(LAST_SCORE_PATH, FileAccess.WRITE)
	if last_file:
		last_file.store_32(current_score)
		
	var best = 0
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			best = file.get_32()
	
	if current_score > best:
		var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		if file:
			file.store_32(current_score)

func _ready() -> void:
	$HUD/CanvasLayer/Score.visible = false
	$HUD/CanvasLayer/PauseButton.visible = false
	global_speed = 0.0
	ScoreLabel.text = str(0)
func _on_timer_timeout() -> void:
	var new_pipe = pipe_scene.instantiate()
	new_pipe.position = Vector2(864, randf_range(200, 500))
	
	new_pipe.speed = global_speed
	
	new_pipe.scored.connect(_on_pipe_scored)
	add_child(new_pipe)
	new_pipe.died.connect(_on_pipe_died)
func _on_pipe_died() -> void:
	save_new_high_score(score)
	if game_over_anim:
		game_over_anim.play("GameOver")
	# GameOver Control düğümünde update_scores() varsa çağır:
	if has_node("GameOver/CanvasLayer/Control") and $GameOver/CanvasLayer/Control.has_method("update_scores"):
		$GameOver/CanvasLayer/Control.update_scores()


func _on_pipe_scored() -> void:
	score += 1
	ScoreLabel.text = str(score)
	global_speed += 12.0 
	save_new_high_score(score)
	pointasp.play()

func _on_score_timer_timeout() -> void:
	score += 1
	ScoreLabel.text = str(score)
	global_speed += 12.0
	pointasp.play()
func _process(_delta: float) -> void:
	FPSLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	if Input.is_action_just_pressed("ui_accept"):
		$HUD/CanvasLayer/PauseButton.visible = true
		ScoreLabel.visible = true
		$HUD/ScoreTimer.start()
		global_speed = 200.0
		await get_tree().create_timer(0.5).timeout
		$MainMenu/CanvasLayer.visible = false
