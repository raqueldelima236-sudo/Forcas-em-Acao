extends "res://pagina_base.gd"
## PÁGINA 6 (no storyboard) — REFERÊNCIAS. Links clicáveis abrem no navegador.

const NARRA := "res://assets/audios/pagina3.mp3"


func _ready() -> void:
	narracao = NARRA
	super()


func _on_texto_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
