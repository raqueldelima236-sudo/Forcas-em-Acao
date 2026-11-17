extends "res://pagina_base.gd"
## PÁGINA 7 (no storyboard) — CONTRACAPA. O botão da direita aqui é "Voltar ao início".

const NARRA := "res://assets/audios/pagina4.mp3"


func _ready() -> void:
	narracao = NARRA
	super()
