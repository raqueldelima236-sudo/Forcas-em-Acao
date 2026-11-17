@tool
extends Control
## Seta desenhada por código: parte de (0,0) na direção "direcao" com "comp" pixels.

@export var cor := Color.WHITE:
	set(v):
		cor = v
		queue_redraw()
@export var direcao := Vector2.UP:
	set(v):
		direcao = v
		queue_redraw()
@export var espessura := 7.0:
	set(v):
		espessura = v
		queue_redraw()
@export var cabeca := 28.0:
	set(v):
		cabeca = v
		queue_redraw()
@export var comp := 60.0:
	set(v):
		comp = v
		queue_redraw()


func _draw() -> void:
	if comp < 2.0:
		return
	var d := direcao.normalized()
	var perp := Vector2(-d.y, d.x)
	var cab := minf(cabeca, comp * 0.6)
	draw_line(Vector2.ZERO, d * (comp - cab * 0.5), cor, espessura, true)
	var base := d * (comp - cab)
	draw_colored_polygon(PackedVector2Array([d * comp, base + perp * cab * 0.6, base - perp * cab * 0.6]), cor)
