# Example script showing how to add new cards dynamically
# This can be attached to any node that needs to manage cards

extends Node

@onready var card_slider = get_node("/root/CardSlider")

func _ready():
	# Example: Add cards after a delay
	await get_tree().create_timer(2.0).timeout
	add_sample_cards()

func add_sample_cards():
	# Add new cards with different types
	card_slider.add_new_card("Dragons", "res://images/dragon_card.png", "dragon")
	card_slider.add_new_card("Wizards", "res://images/wizard_card.png", "wizard")
	card_slider.add_new_card("Knights", "res://images/knight_card.png", "knight")

# Example function to load cards from a data file
func load_cards_from_json(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			var card_list = json.data
			for card_info in card_list:
				card_slider.add_new_card(
					card_info.title, 
					card_info.image, 
					card_info.type
				)

# Example function to save current cards to JSON
func save_cards_to_json(file_path: String):
	var card_data = card_slider.card_data
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(card_data)
		file.store_string(json_string)
		file.close()

# Example of connecting to card selection events
func _on_card_selected(card_index: int):
	print("Card selected: ", card_slider.card_data[card_index].title)
	
	# You can add game logic here, like:
	# - Opening card details
	# - Starting a battle with selected unit type
	# - Showing upgrade options

# Example of updating currency
func update_currency(coins: int, gems: int):
	card_slider.coin_label.text = str(coins)
	card_slider.gem_label.text = str(gems)