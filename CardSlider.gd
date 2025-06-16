extends Control

var card_container: HBoxContainer
var card_viewport: Control
var dots_container: HBoxContainer
var coin_label: Label
var gem_label: Label

var cards = []
var current_card_index = 0
var card_width = 0  # Will be set based on viewport
var card_height = 0  # Will be set based on viewport
var is_dragging = false
var drag_start_pos = Vector2.ZERO
var initial_container_pos = 0.0

# Card data structure
var card_data = [
	{
		"title": "Elf",
		"image": "res://images/elf.jpg",
		"type": "elf"
	},
	{
		"title": "Footballer", 
		"image": "res://images/fotb.jpg",
		"type": "sport"
	},
	{
		"title": "Dino",
		"image": "res://images/dino.jpg", 
		"type": "animal"
	}
]

func _ready():
	# Calculate card size based on viewport
	var viewport_size = get_viewport().get_visible_rect().size
	card_width = viewport_size.x * 0.3  # 30% of screen width
	card_height = viewport_size.y * 0.7  # 70% of screen height
	
	setup_ui()
	create_cards()
	update_dots()
	update_currency_display()

func setup_ui():
	# Set up the main container for horizontal layout
	anchor_right = 1.0
	anchor_bottom = 1.0
	
	# Create main horizontal layout
	var hbox = HBoxContainer.new()
	hbox.name = "HBoxContainer"
	add_child(hbox)
	
	# Left sidebar with navigation
	#create_left_sidebar(hbox)
	
	# Main content area
	var main_content = VBoxContainer.new()
	main_content.name = "MainContent"
	main_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(main_content)
	
	# Top bar with currency
	#create_top_bar(main_content)
	
	# Card area (main content)
	create_card_area(main_content)
	
	# Dots indicator
	create_dots_container(main_content)
	
	# Right sidebar with additional controls
	#create_right_sidebar(hbox)

func create_top_bar(parent):
	var top_bar = HBoxContainer.new()
	top_bar.name = "TopBar"
	top_bar.custom_minimum_size = Vector2(0, 60)
	parent.add_child(top_bar)
	
	# Spacer
	var spacer1 = Control.new()
	spacer1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.add_child(spacer1)
	
	# Coin container
	var coin_container = HBoxContainer.new()
	coin_container.name = "CoinContainer"
	top_bar.add_child(coin_container)
	
	var coin_icon = Label.new()
	coin_icon.text = "💵"
	coin_icon.add_theme_font_size_override("font_size", 24)
	coin_container.add_child(coin_icon)
	
	coin_label = Label.new()
	coin_label.name = "CoinLabel"
	coin_label.text = "1200"
	coin_label.add_theme_font_size_override("font_size", 20)
	coin_container.add_child(coin_label)
	
	# Spacer
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(40, 0)
	top_bar.add_child(spacer2)
	
	# Gem container  
	var gem_container = HBoxContainer.new()
	gem_container.name = "GemContainer"
	top_bar.add_child(gem_container)
	
	var gem_icon = Label.new()
	gem_icon.text = "💎"
	gem_icon.add_theme_font_size_override("font_size", 24)
	gem_container.add_child(gem_icon)
	
	gem_label = Label.new()
	gem_label.name = "GemLabel"
	gem_label.text = "367"
	gem_label.add_theme_font_size_override("font_size", 20)
	gem_container.add_child(gem_label)
	
	# Spacer
	var spacer3 = Control.new()
	spacer3.custom_minimum_size = Vector2(40, 0)
	top_bar.add_child(spacer3)
	
	# Menu button
	var menu_btn = Button.new()
	menu_btn.text = "☰"
	menu_btn.custom_minimum_size = Vector2(50, 50)
	top_bar.add_child(menu_btn)

func create_card_area(parent):
	card_viewport = Control.new()
	card_viewport.name = "CardArea"
	card_viewport.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card_viewport.clip_contents = true
	parent.add_child(card_viewport)
	
	card_container = HBoxContainer.new()
	card_container.name = "CardContainer"
	card_viewport.add_child(card_container)

func create_dots_container(parent):
	dots_container = HBoxContainer.new()
	dots_container.name = "DotsContainer"
	dots_container.alignment = BoxContainer.ALIGNMENT_CENTER
	dots_container.custom_minimum_size = Vector2(0, 40)
	dots_container.size_flags_vertical = Control.SIZE_SHRINK_END  # Keep at bottom
	dots_container.position.y = get_viewport().get_visible_rect().size.y - 100  # Position from bottom
	parent.add_child(dots_container)

func create_left_sidebar(parent):
	var left_sidebar = VBoxContainer.new()
	left_sidebar.name = "LeftSidebar"
	left_sidebar.custom_minimum_size = Vector2(80, 0)
	parent.add_child(left_sidebar)
	
	# Profile button at top
	var profile_btn = Button.new()
	profile_btn.custom_minimum_size = Vector2(60, 60)
	profile_btn.text = "👤"
	profile_btn.add_theme_font_size_override("font_size", 24)
	left_sidebar.add_child(profile_btn)
	
	# Spacer
	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_sidebar.add_child(spacer)
	
	# Navigation buttons
	var nav_items = ["🏠", "📜", "👕"]
	
	for item in nav_items:
		var btn = Button.new()
		btn.text = item
		btn.custom_minimum_size = Vector2(60, 60)
		btn.add_theme_font_size_override("font_size", 24)
		left_sidebar.add_child(btn)
		
		var small_spacer = Control.new()
		small_spacer.custom_minimum_size = Vector2(0, 10)
		left_sidebar.add_child(small_spacer)

func create_right_sidebar(parent):
	var right_sidebar = VBoxContainer.new()
	right_sidebar.name = "RightSidebar"
	right_sidebar.custom_minimum_size = Vector2(80, 0)
	parent.add_child(right_sidebar)
	
	# Spacer
	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_sidebar.add_child(spacer)
	
	# Right side navigation
	var nav_items = ["🏆", "💰"]
	
	for item in nav_items:
		var btn = Button.new()
		btn.text = item
		btn.custom_minimum_size = Vector2(60, 60)
		btn.add_theme_font_size_override("font_size", 24)
		right_sidebar.add_child(btn)
		
		var small_spacer = Control.new()
		small_spacer.custom_minimum_size = Vector2(0, 10)
		right_sidebar.add_child(small_spacer)

func create_cards():
	card_container = get_node("HBoxContainer/MainContent/CardArea/CardContainer")
	
	for i in range(card_data.size()):
		var card = create_card(card_data[i], i)
		cards.append(card)
		card_container.add_child(card)
	
	# Position cards
	update_card_positions()

func create_card(data, index):
	var card = Control.new()
	card.custom_minimum_size = Vector2(card_width, card_height)
	card.name = "Card_" + str(index)
	
	# Card background with rounded corners effect
	var bg = ColorRect.new()
	bg.color = Color(0.1, 0.15, 0.25, 0.95)
	bg.size = card.custom_minimum_size
	card.add_child(bg)
	
	# Card border
	var border = ColorRect.new()
	border.color = Color(0.3, 0.4, 0.6, 0.8)
	border.position = Vector2(2, 2)
	border.size = Vector2(card_width - 4, card_height - 4)
	card.add_child(border)
	
	# Inner background
	var inner_bg = ColorRect.new()
	inner_bg.color = Color(0.05, 0.1, 0.2, 1.0)
	inner_bg.position = Vector2(4, 4)
	inner_bg.size = Vector2(card_width - 8, card_height - 8)
	card.add_child(inner_bg)
	
	# Card content
	var vbox = VBoxContainer.new()
	vbox.position = Vector2(10, 10)
	vbox.size = Vector2(card_width - 20, card_height - 20)
	vbox.custom_minimum_size = Vector2(card_width - 20, card_height - 20)
	card.add_child(vbox)
	
	# Card image area
	var image_container = Control.new()
	var image_height = card_height * 0.75  # Image takes 75% of card height
	image_container.custom_minimum_size = Vector2(card_width - 20, image_height)
	vbox.add_child(image_container)
	
	# Image background
	var image_rect = ColorRect.new()
	image_rect.color = Color(0.3, 0.3, 0.4, 0.5)
	image_rect.size = Vector2(card_width - 20, image_height)
	image_container.add_child(image_rect)
	
	# Try to load actual image if it exists
	if FileAccess.file_exists(data.image):
		var texture = load(data.image)
		if texture:
			var texture_rect = TextureRect.new()
			texture_rect.texture = texture
			texture_rect.size = Vector2(card_width - 20, image_height)
			texture_rect.custom_minimum_size = Vector2(card_width - 20, image_height)
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			image_container.add_child(texture_rect)
	else:
		# Placeholder character for different card types
		var placeholder = Label.new()
		placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		placeholder.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		placeholder.size = Vector2(card_width - 20, image_height)
		placeholder.add_theme_font_size_override("font_size", 80)
		placeholder.add_theme_color_override("font_color", Color(0.7, 0.7, 0.8, 0.8))
		
		match data.type:
			"warrior":
				placeholder.text = "⚔️"
			"elf":
				placeholder.text = "🧙"
			"archer":
				placeholder.text = "🏹"
			"animal":
				placeholder.text = "🐉"
			_:
				placeholder.text = "🛡️"
		
		image_container.add_child(placeholder)
	
	# Title background
	var title_bg = ColorRect.new()
	title_bg.color = Color(0.2, 0.3, 0.5, 0.8)
	title_bg.custom_minimum_size = Vector2(card_width - 20, 50)
	vbox.add_child(title_bg)
	
	# Card title
	var title_label = Label.new()
	title_label.text = data.title
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_label.size = Vector2(card_width - 20, 50)
	title_label.add_theme_font_size_override("font_size", 24)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	title_bg.add_child(title_label)
	
	return card

func update_card_positions():
	if not card_container:
		return
		
	var viewport_size = get_viewport().get_visible_rect().size
	var center_x = viewport_size.x / 2
	
	for i in range(cards.size()):
		var card = cards[i]
		var offset = (i - current_card_index) * (card_width + 30)
		card.position.x = center_x - card_width / 2.0 + offset
		card.position.y = 20  # Small top margin
		
		# Scale and fade non-active cards
		if i == current_card_index:
			card.scale = Vector2(1.0, 1.0)
			card.modulate = Color(1, 1, 1, 1)
			card.z_index = 10
		else:
			var distance = abs(i - current_card_index)
			var scale_factor = max(0.7, 1.0 - distance * 0.15)
			var alpha = max(0.4, 1.0 - distance * 0.3)
			card.scale = Vector2(scale_factor, scale_factor)
			card.modulate = Color(1, 1, 1, alpha)
			card.z_index = 5 - distance

func update_dots():
	dots_container = get_node("HBoxContainer/MainContent/DotsContainer")
	
	# Clear existing dots
	for child in dots_container.get_children():
		child.queue_free()
	
	# Create new dots
	for i in range(cards.size()):
		var dot = Button.new()
		dot.custom_minimum_size = Vector2(16, 16)
		dot.flat = true
		
		# Create a circular dot appearance
		var dot_bg = ColorRect.new()
		dot_bg.size = Vector2(16, 16)
		dot.add_child(dot_bg)
		
		if i == current_card_index:
			dot_bg.color = Color(0.9, 0.7, 0.3, 1.0)  # Golden color for active
		else:
			dot_bg.color = Color(0.5, 0.5, 0.5, 0.7)  # Gray for inactive
			
		dot.pressed.connect(_on_dot_pressed.bind(i))
		dots_container.add_child(dot)
		
		if i < cards.size() - 1:
			var spacer = Control.new()
			spacer.custom_minimum_size = Vector2(12, 0)
			dots_container.add_child(spacer)

func _on_dot_pressed(index):
	current_card_index = index
	update_card_positions()
	update_dots()

func update_currency_display():
	coin_label = get_node("VBoxContainer/TopBar/CoinContainer/CoinLabel")
	gem_label = get_node("VBoxContainer/TopBar/GemContainer/GemLabel")
	
	if coin_label:
		coin_label.text = "1200"
	if gem_label:
		gem_label.text = "367"

# Input handling for card swiping
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				drag_start_pos = event.position
				initial_container_pos = card_container.position.x
			else:
				if is_dragging:
					handle_drag_end(event.position)
				is_dragging = false
	
	elif event is InputEventMouseMotion and is_dragging:
		handle_drag_motion(event.position)

func handle_drag_motion(current_pos):
	var drag_delta = current_pos.x - drag_start_pos.x
	# Update card positions based on drag
	var main_content = get_node("HBoxContainer/MainContent")
	var content_width = main_content.size.x
	var center_x = content_width / 2
	
	for i in range(cards.size()):
		var card = cards[i]
		var base_offset = (i - current_card_index) * (card_width + 30)
		card.position.x = center_x - card_width/2.0 + base_offset + drag_delta

func handle_drag_end(end_pos):
	var drag_distance = end_pos.x - drag_start_pos.x
	var threshold = 100
	
	if abs(drag_distance) > threshold:
		if drag_distance > 0 and current_card_index > 0:
			# Swiped right, go to previous card
			current_card_index -= 1
		elif drag_distance < 0 and current_card_index < cards.size() - 1:
			# Swiped left, go to next card
			current_card_index += 1
	
	# Animate back to position
	update_card_positions()
	update_dots()

# Function to add new cards dynamically
func add_new_card(title: String, image_path: String, type: String):
	var new_card_data = {
		"title": title,
		"image": image_path,
		"type": type
	}
	
	card_data.append(new_card_data)
	var new_card = create_card(new_card_data, cards.size())
	cards.append(new_card)
	card_container.add_child(new_card)
	
	update_card_positions()
	update_dots()

# Function to remove a card
func remove_card(index: int):
	if index >= 0 and index < cards.size():
		cards[index].queue_free()
		cards.remove_at(index)
		card_data.remove_at(index)
		
		if current_card_index >= cards.size():
			current_card_index = max(0, cards.size() - 1)
		
		update_card_positions()
		update_dots()

# Example usage functions
func _on_add_card_button_pressed():
	# Example of adding a new card
	add_new_card("New Hero", "res://images/new_hero.png", "hero")

func _on_remove_card_button_pressed():
	# Example of removing current card
	if cards.size() > 0:
		remove_card(current_card_index)
