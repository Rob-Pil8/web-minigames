extends Node2D


func _on_send_button_button_down() -> void:
	var regex = RegEx.new()	
	var input_string: String = $UI/VBoxContainer/HBoxContainer/TextInput.text
	regex.compile("^[ ]*[A-Za-z]+[ ]*$")
	
	print(input_string)
