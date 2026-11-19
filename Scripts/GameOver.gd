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
extends Control

@onready var BestLabel = $BestLabel
@onready var CurrentLabel = $ScoreLabel

const SAVE_PATH = "user://highscore.save"
const LAST_SCORE_PATH = "user://last_score.save"

@export var medal_rect: TextureRect
@export var bronze_tex: Texture2D
@export var silver_tex: Texture2D
@export var gold_tex: Texture2D
@export var platinum_tex: Texture2D

func update_medal(current_score: int) -> void:
	if not medal_rect:
		return

	if current_score >= 40 and platinum_tex:
		medal_rect.visible = true
		medal_rect.texture = platinum_tex
	elif current_score >= 25 and gold_tex:
		medal_rect.visible = true
		medal_rect.texture = gold_tex
	elif current_score >= 15 and silver_tex:
		medal_rect.visible = true
		medal_rect.texture = silver_tex
	elif current_score >= 5 and bronze_tex:
		medal_rect.visible = true
		medal_rect.texture = bronze_tex
	else:
		medal_rect.visible = false

func update_scores() -> void:
	var best_score = 0
	var current_score = 0

	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			best_score = file.get_32()

	if FileAccess.file_exists(LAST_SCORE_PATH):
		var file = FileAccess.open(LAST_SCORE_PATH, FileAccess.READ)
		if file:
			current_score = file.get_32()

	BestLabel.text = str(best_score)
	CurrentLabel.text = str(current_score)
	update_medal(current_score)

func _ready() -> void:
	update_scores()
