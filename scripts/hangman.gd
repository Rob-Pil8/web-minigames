extends Node2D

@onready var errors: int = 0
@onready var max_errors: int = 0
@onready var word_holder = $GameLogic/WordHolder

signal lost
signal won

func _ready() -> void:
	$UI.show()
	$GameUI.hide()
	$GameUI/VBoxContainer/InputErrorLabel.hide()
	
func _on_send_button_button_down() -> void:
	var word
	
	# hide the invalid text label
	var invalid_text_label = $UI/VBoxContainer/InvalidInputLabel
	invalid_text_label.hide()
	
	# compile the regex to check if the input is valid
	var regex = RegEx.new()	
	var input_string: String = $UI/VBoxContainer/HBoxContainer/TextInput.text
	regex.compile("^[ ]*[A-Za-z]+[ ]*$")
	
	# if the input in invalid result is null
	var result = regex.search(input_string)
	
	# show the error if the input isn't valid
	if not result:
		invalid_text_label.show()
		
	else:
		word = input_string
		start_game(word)
	#print(word)

	


func _on_random_word_button_button_down() -> void:
	# I have ~365k words to choose from. They are split into 37 files with 10k words each
	# This chooses a random file, loads it in memory and choose a random word from it
	var file_number: int = 37
	var chosen_file: int = (randi() % file_number) +1
	var file_path = "res://resources/word_list/{number}.txt".format({"number": str(chosen_file)})
	var words: Array[String] = []
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file:
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line != "":
				words.append(line)
		file.close()
		
	var word_count: int = len(words)
	var selected_word_index: int = randi() % word_count
	var selected_word = words[selected_word_index]
	#print(selected_word)
	
	start_game(selected_word)



func start_game(word: String):
	$UI.hide()
	$GameUI.show()
	var word_display_node = $GameUI/VBoxContainer/WordDisplay
	
	# display the first letter of the word, every other letter is shown as a "_" until it's guessed
	# also it capitalizes every letter of the word
	word[0] = word[0].to_upper()
	var word_displayed = word
	for i in range(1, len(word)):
		word_displayed[i] = "_"
		word[i] = word[i].to_upper()
		
	word_display_node.text = word_displayed
	word_holder.word = word


func _on_send_letter_button_pressed() -> void:
	var input_field = $GameUI/VBoxContainer/LetterInput/InsertLetterField
	var input_error_label = $GameUI/VBoxContainer/InputErrorLabel
	var used_letters = $GameLogic/UsedLetters
	var word_display_node = $GameUI/VBoxContainer/WordDisplay
	var inserted_character: String = input_field.text
	var already_used: bool
	
	input_error_label.hide()
	input_field.text = ""
	if (inserted_character > 'z' or inserted_character < 'a') and (inserted_character > 'Z' or inserted_character < 'A'):
		input_error_label.show()
	
	#check if the letter has already been used
	already_used = used_letters.letter_already_used(inserted_character)
	
	if already_used:
		errors += 1
		#TODO Tell the letter has already been used
	else:
		for i in range(len(word_holder.word)):
			if word_holder.word[i].to_upper() == inserted_character.to_upper():
				word_display_node.text[i] = inserted_character.to_upper()
				
	
	if errors > max_errors:
		lost.emit()
		
	
	#TODO implement error counter
	#TODO implement word_display update
