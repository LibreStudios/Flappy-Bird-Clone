# Copyright (C) 2026 LibreStudios

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

extends CharacterBody2D

var JUMP_VELOCITY = -425.0
var gravity = 1550
@export var game_over_anim: AnimationPlayer
@export var flyasp: AudioStreamPlayer
@export var dieasp: AudioStreamPlayer
@export var ScoreLabel: Label
@export var PauseButton: TextureButton

var is_dead: bool = false

func _ready() -> void:
	gravity = 0.0
	visible = false
	ScoreLabel.visible = true
func set_dead(dead: bool) -> void:
	if is_dead and dead:
		return
	is_dead = dead
	if is_dead:
		velocity.y = 0.0
		if game_over_anim:
			game_over_anim.play("GameOver")
			ScoreLabel.visible = false
			PauseButton.visible = false
			
			

func _physics_process(delta: float) -> void:
	if is_dead:
		if not is_on_floor():
			velocity.y += gravity * delta
		move_and_slide()
		rotation = clamp(deg_to_rad(velocity.y * 0.15), deg_to_rad(-60), deg_to_rad(90))
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("ui_accept"):
		visible = true
		gravity = 1550.0
		velocity.y = JUMP_VELOCITY
		flyasp.play()
	move_and_slide()
	
	rotation = clamp(deg_to_rad(velocity.y * 0.15), deg_to_rad(-60), deg_to_rad(90))

func _on_area_2d_body_entered(_body: Node2D) -> void:
	set_dead(true)
	dieasp.play()
