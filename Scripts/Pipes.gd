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

var speed = 200.0
@export var game_over_anim: AnimationPlayer

signal scored
signal died

func _on_pipe_entered(body: Node2D) -> void:
	if body and body.has_method("set_dead"):
		body.set_dead(true)
	died.emit()


func _ready() -> void:
	speed = 0.0
	position.y = randf_range(-100.0, 150.0)
	$Area2D3.body_entered.connect(_on_pipe_entered)
	$Area2D2.body_entered.connect(_on_pipe_entered)

func _on_score_area_entered(body: Node2D) -> void:
	if body.name == "Player":
		scored.emit()
		$ScoreArea.queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		speed = 200.0
	position.x -= speed * delta
	if position.x < -300:
		queue_free()


func _on_score_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		scored.emit()
		$ScoreArea.queue_free()
