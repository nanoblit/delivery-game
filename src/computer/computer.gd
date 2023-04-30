extends Node2D


var keys := {
	65: "a",
	66: "b",
	67: "c",
	68: "d",
	69: "e",
	70: "f",
	71: "g",
	72: "h",
	73: "i",
	74: "j",
	75: "k",
	76: "l",
	77: "m",
	78: "n",
	79: "o",
	80: "p",
	81: "q",
	82: "r",
	83: "s",
	84: "t",
	85: "u",
	86: "v",
	87: "w",
	88: "x",
	89: "y",
	90: "z",
	32: " ",
}

var keywords = [
	"false",
	"await",
	"else",
	"import",
	"pass",
	"none",
	"break",
	"except",
	"in",
	"raise",
	"true",
	"class",
	"finally",
	"is",
	"return",
	"and",
	"continue",
	"for",
	"lambda",
	"try",
	"as",
	"def",
	"from",
	"nonlocal",
	"while",
	"assert",
	"del",
	"global",
	"not",
	"with",
	"async",
	"elif",
	"if",
	"or",
	"yield",
] 


var current_word_text := ""
var ghost_text := ""
var current_position := Vector2.ZERO
var screen_width := 500
var line_height := 16

var input = null
@onready var ghost := $InputCollection/Ghost
@onready var input_collection := $InputCollection


func _ready() -> void:
	current_word_text = ""
	ghost_text = get_random_keyword()
	reset_ghost()
	input = get_new_label()


func _input(event):
	var typed_possible_sign = event is InputEventKey && event.pressed && event.key_label in keys
	if typed_possible_sign:
		update_text_if_correct(keys[event.key_label])
		var word_finished = current_word_text == ghost_text
		if word_finished:
			current_word_text = ""
			current_position = get_new_text_position()
			input = get_new_label()
			ghost_text = get_random_keyword()
			reset_ghost()


func get_random_keyword():
	var idx = randi() % keywords.size()
	return keywords[idx]


func get_new_text_position():
	var word_size = get_ghost_size(ghost_text)
	print(ghost_text + " " + str(word_size))
	var next_word_out_of_screen = (current_position + word_size).x >= screen_width
	if next_word_out_of_screen:
		# Move to the beginning of the next line
		return Vector2(0, current_position.y + line_height)
	else:
		# Move to the next word pos
		return Vector2(current_position.x + word_size.x, current_position.y)


func get_new_label():
	var input := Label.new()
	input_collection.add_child(input)
	input.position = current_position
	return input


func get_ghost_size(text: String):
	return input.get_theme_default_font().get_string_size(" " + text)


func reset_ghost():
	ghost.position = current_position
	ghost.text = ghost_text


func update_text_if_correct(letter: String):
	var current_str = current_word_text + letter
	var new_text_follows_ghost = ghost_text.findn(current_str) == 0
	if new_text_follows_ghost:
		current_word_text = current_str
		input.text = current_word_text
