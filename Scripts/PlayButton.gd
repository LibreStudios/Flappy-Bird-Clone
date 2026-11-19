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
extends TextureButton
@export var clicksound: AudioStreamPlayer
@export var start_player: AnimationPlayer

func _pressed() -> void:
	if start_player:
		start_player.play("Start")
	if clicksound:
		clicksound.play()
		await get_tree().create_timer(1.0).timeout
		
func _on_pressed() -> void:
	pass # Replace with function body.
