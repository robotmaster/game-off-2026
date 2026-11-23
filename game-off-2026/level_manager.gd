extends Node

var room_number := 0

const rooms = [
	"res://scenes/rooms/intro.tscn",
	"res://scenes/rooms/polygon_intro.tscn",
	"res://scenes/rooms/moving_poly_intro.tscn",
	"res://scenes/rooms/moving_2.tscn",
	"res://scenes/rooms/rotations_intro.tscn",
]

func next_room() -> String:
	room_number += 1
	if room_number >= len(rooms):
		return rooms[len(rooms) - 1]
	return rooms[room_number]
