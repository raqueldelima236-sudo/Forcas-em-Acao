@tool
extends Control
## Círculo preenchido ou tracejado (desenhado dentro de um quadrado de lado 2 x raio).

@export var raio := 20.0:
	set(v):
		raio = v
		queue_redraw()
@export var preenchimento := Color(0, 0, 0, 0):
	set(v):
		preenchimento = v
		queue_redraw()
@export var cor_borda := Color.WHITE:
	set(v):
		cor_borda = v
		queue_redraw()
@export var largura := 3.0:
	set(v):
		largura = v
		queue_redraw()
@export var tracejado := false:
	set(v):
		tracejado = v
		queue_redraw()


func _draw() -> void:
	var c := Vector2(raio, raio)
	if preenchimento.a > 0.0:
		draw_circle(c, raio, preenchimento)
	if tracejado:
		var n := 14
		for i in n:
			var a0 := TAU * i / n
			draw_arc(c, raio - largura, a0, a0 + TAU / n * 0.55, 8, cor_borda, largura, true)
	else:
		draw_arc(c, raio - largura * 0.5, 0.0, TAU, 48, cor_borda, largura, true)
