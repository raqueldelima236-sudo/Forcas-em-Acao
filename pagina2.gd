extends "res://pagina_base.gd"
## PÁGINA 2 — PESO E FORÇA NORMAL
## Interação: MÚLTIPLOS TOQUES (pinça)  |  Animação: SPRITE SHEET (balança, nó Balanca)
## Para testar no PC: roda do mouse ou setas ↑ ↓ mudam a massa.

const NARRA := "res://assets/audios/pagina2.mp3"

const ESC := 768.0 / 720.0   # fator do layout original (720x960) para 768x1024
const CX := 266.0 * ESC      # centro (x) do bloco e dos dedos
const CHAO_Y := 770.0 * ESC  # linha do piso
const DEDOS_Y := 604.0 * ESC # altura dos círculos dos dedos

var massa := 2           # massa inteira mostrada (1 a 5 kg)
var massa_cont := 2.0    # massa contínua controlada pelo gesto
var massa_visual := 2.0  # valor animado pelo Tween
var massa_ini := 2.0
var dist_ini := 0.0
var toques := {}         # índice do dedo -> posição
var tween_massa: Tween
var tween_balanca: Tween

@onready var bloco: Panel = %Bloco
@onready var rot_bloco: Label = %RotBloco
@onready var seta_n: Control = %SetaN
@onready var seta_p: Control = %SetaP
@onready var rot_n: Label = %RotN
@onready var rot_p: Label = %RotP
@onready var dedo_a: Control = %DedoA
@onready var dedo_b: Control = %DedoB
@onready var seta_dedo_a: Control = %SetaDedoA
@onready var seta_dedo_b: Control = %SetaDedoB
@onready var rot_massa: Label = %RotMassa
@onready var rot_valor_p: Label = %RotValorP
@onready var rot_valor_n: Label = %RotValorN
@onready var balanca: Sprite2D = %Balanca


func _ready() -> void:
	narracao = NARRA
	super()
	_aplicar_massa(2.0)
	balanca.frame = 2


## Atualiza TUDO o que depende da massa (m pode ser fracionária durante o Tween).
func _aplicar_massa(m: float) -> void:
	massa_visual = m
	var mi := clampi(roundi(m), 1, 5)
	var w := (88.0 + 16.0 * m) * ESC
	var h := (52.0 + 7.0 * m) * ESC
	var comp := (28.0 + 13.0 * m) * ESC

	bloco.size = Vector2(w, h)
	bloco.position = Vector2(CX - w * 0.5, CHAO_Y - h)
	rot_bloco.text = "%d kg" % mi

	seta_n.position = Vector2(CX, CHAO_Y - h)
	seta_n.comp = comp
	seta_p.position = Vector2(CX, CHAO_Y)
	seta_p.comp = comp
	rot_n.position = Vector2(CX + 16.0 * ESC, CHAO_Y - h - comp * 0.5 - 16.0 * ESC)
	rot_p.position = Vector2(CX + 16.0 * ESC, CHAO_Y + comp * 0.5 - 16.0 * ESC)

	var sep := (26.0 + (m - 1.0) * 24.0) * ESC
	dedo_a.position = Vector2(CX - sep - 24.0 * ESC, DEDOS_Y - 24.0 * ESC)
	dedo_b.position = Vector2(CX + sep - 24.0 * ESC, DEDOS_Y - 24.0 * ESC)
	seta_dedo_a.position = Vector2(CX - sep - 32.0 * ESC, DEDOS_Y)
	seta_dedo_b.position = Vector2(CX + sep + 32.0 * ESC, DEDOS_Y)

	rot_massa.text = "massa: %d kg" % mi
	var peso := ("%.1f" % (mi * 9.8)).replace(".", ",")
	rot_valor_p.text = "P = %s N" % peso
	rot_valor_n.text = "N = %s N" % peso


func _definir_massa(nova: int) -> void:
	nova = clampi(nova, 1, 5)
	if nova == massa:
		return
	massa = nova
	if tween_massa and tween_massa.is_valid():
		tween_massa.kill()
	tween_massa = create_tween()
	tween_massa.tween_method(_aplicar_massa, massa_visual, float(nova), 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_animar_balanca(nova)


## SPRITE SHEET: o nó Balanca tem 6 quadros (hframes); o ponteiro passa por quadros consecutivos.
func _animar_balanca(destino: int) -> void:
	if tween_balanca and tween_balanca.is_valid():
		tween_balanca.kill()
	if destino == balanca.frame:
		return
	var passos := absi(destino - balanca.frame)
	tween_balanca = create_tween()
	tween_balanca.tween_property(balanca, "frame", destino, 0.07 * passos)


## MÚLTIPLOS TOQUES: pinça (celular), gesto de zoom (trackpad), roda do mouse e setas (teste no PC)
func _input(event: InputEvent) -> void:
	var t := event as InputEventScreenTouch
	if t:
		if t.pressed:
			toques[t.index] = t.position
		else:
			toques.erase(t.index)
		if toques.size() == 2:
			dist_ini = _dist_toques()
			massa_ini = massa_cont
		return

	var d := event as InputEventScreenDrag
	if d:
		if toques.has(d.index):
			toques[d.index] = d.position
		if toques.size() == 2 and dist_ini > 8.0:
			massa_cont = clampf(massa_ini * _dist_toques() / dist_ini, 1.0, 5.0)
			_definir_massa(roundi(massa_cont))
		return

	var g := event as InputEventMagnifyGesture
	if g:
		massa_cont = clampf(massa_cont * g.factor, 1.0, 5.0)
		_definir_massa(roundi(massa_cont))
		return

	var mb := event as InputEventMouseButton
	if mb and mb.pressed:
		if mb.button_index == MOUSE_BUTTON_WHEEL_UP:
			_mudar_massa(1.0)
		elif mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_mudar_massa(-1.0)
		return

	var k := event as InputEventKey
	if k and k.pressed and not k.echo:
		if k.keycode == KEY_UP:
			_mudar_massa(1.0)
		elif k.keycode == KEY_DOWN:
			_mudar_massa(-1.0)


func _mudar_massa(delta: float) -> void:
	massa_cont = clampf(roundf(massa_cont) + delta, 1.0, 5.0)
	_definir_massa(roundi(massa_cont))


func _dist_toques() -> float:
	var pts := toques.values()
	if pts.size() < 2:
		return 0.0
	return (pts[0] as Vector2).distance_to(pts[1] as Vector2)
