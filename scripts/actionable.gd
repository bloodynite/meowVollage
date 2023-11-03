extends Area2D

@export var dialog_resource: DialogueResource
@export var dialog_start: String = 'start'

func action() -> void:
	print('actionable')
	DialogueManager.show_example_dialogue_balloon(dialog_resource, dialog_start)
