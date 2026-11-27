extends Node

var room_number := 0

var show_centroids := false

const first_room_with_centroids = "res://scenes/rooms/rotations_intro.tscn"

const rooms = [
	"res://scenes/rooms/basics/intro.tscn",
	"res://scenes/rooms/basics/polygon_intro.tscn",
	"res://scenes/rooms/basics/polygon_intro_2.tscn",
	"res://scenes/rooms/moving/moving_poly_intro.tscn",
	"res://scenes/rooms/moving/moving_2.tscn",
	"res://scenes/rooms/moving/moving_3.tscn",
	"res://scenes/rooms/moving/falling_lock_intro.tscn",
	"res://scenes/rooms/moving/polygon_moving_hard.tscn",
	"res://scenes/rooms/rotating/rotations_intro.tscn",
	"res://scenes/rooms/rotating/rotations_hard.tscn"
]

const room_to_tip = {
	"res://scenes/rooms/basics/intro.tscn": "Get to the exit.\nIt's too easy!",
	"res://scenes/rooms/basics/polygon_intro.tscn": "Red + Green + Blue = White\nand maybe something else",
	"res://scenes/rooms/basics/polygon_intro_2.tscn": "Something else you might wanna know:\nR to reset\nB to undo your last jump",
	"res://scenes/rooms/moving/moving_poly_intro.tscn": "Legend goes that entering areas of high energy gives you special powers.",
	"res://scenes/rooms/moving/moving_2.tscn": "This one is easy.\nBy the way, how many holes are in a straw?",
	"res://scenes/rooms/moving/moving_3.tscn": "Remember what I said about the high energy?\nEnergy can come in different forms, you know?",
	"res://scenes/rooms/moving/falling_lock_intro.tscn": "Some people pass out after using immense power.",
	"res://scenes/rooms/moving/polygon_moving_hard.tscn": "Wait what?\nNow there's three?",
	"res://scenes/rooms/rotating/rotations_intro.tscn": "Fun fact: The centroid of a polygon is its center of mass if it has uniform density. It is calculated as Cₓ = (1 / 6A) Σ (xᵢ + xᵢ₊₁)(xᵢ yᵢ₊₁ − xᵢ₊₁ yᵢ) and Cᵧ = (1 / 6A) Σ (yᵢ + yᵢ₊₁)(xᵢ yᵢ₊₁ − xᵢ₊₁ yᵢ), where A is ½ Σ (xᵢ yᵢ₊₁ − xᵢ₊₁ yᵢ)",
	"res://scenes/rooms/rotating/rotations_hard.tscn": "Good luck on this one!",
}

func _ready() -> void:
	for room in rooms:
		pass
		assert(room in room_to_tip, "Room mismatch in level manager")
	
	var path := get_tree().current_scene.scene_file_path
	if path in rooms:
		room_number = rooms.find(path)

func get_room() -> String:
	return rooms[ room_number]

func next_room() -> String:
	room_number += 1
	if room_number >= len(rooms):
		return ""
	return "res://scenes/level_start.tscn"

func _process(_delta: float) -> void:
	var centroid_index := rooms.find(first_room_with_centroids)
	show_centroids = room_number >= centroid_index
