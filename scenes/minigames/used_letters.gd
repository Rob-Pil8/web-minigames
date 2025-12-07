extends Node

@onready var used_letters: Dictionary

func _ready() -> void:
	
	var A_in_ascii: int = 65
	var Z_in_ascii: int = 90
	
	for i in range(A_in_ascii, Z_in_ascii+1):
		used_letters[char(i)] = false
	

#returns true if a letter has already been used
func letter_already_used(letter: String):
	var already_used = false
	letter = letter.to_upper()
	
	if letter in used_letters:
		if used_letters[letter] == true:
			already_used = true
		
		used_letters[letter] = true
	
	return already_used
