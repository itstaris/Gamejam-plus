extends Control

@export var golden = false

@onready var text_label = $RichTextLabel

func set_death_counter(count):
    # Set the text of the RichTextLabel to the death count.
    set_text("x %d" % count)

func set_text(text):
    # Template for the text format.
    var template = "[font_size=35][center]%s[/center][/font_size]"
    text_label.bbcode_text = template % text

func _process(_delta):
    # Update the death counter every frame.
    set_death_counter(GameManager.death_count)
