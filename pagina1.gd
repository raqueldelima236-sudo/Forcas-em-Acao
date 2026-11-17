extends "res://pagina_base.gd"
## PÁGINA 1 — CAPA
## Interação: TOQUE no bloco  |  Animação: KEY FRAMES (AnimationPlayer, animação "balancar")

const NARRA := "res://assets/audios/pagina1.mp3"

@onready var animacao: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	narracao = NARRA
	super()


func _on_bloco_pressed() -> void:
	animacao.stop()
	animacao.play("balancar")
