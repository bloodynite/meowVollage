extends Area2D

@export var dialog_resource: DialogueResource
@export var dialog_start: String = 'start'

func action() -> void:
	DialogueManager.show_example_dialogue_balloon(dialog_resource, 'beared_guy')
