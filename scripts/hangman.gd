extends Node2D

@onready var word

func _on_send_button_button_down() -> void:
	
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
	print(result)

	
