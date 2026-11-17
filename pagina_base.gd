extends Node2D
## Script-base das 4 páginas: botões Página anterior / Ouvir texto / Próxima página,
## entrada suave (fade) e narração sob demanda. Cada página tem o seu próprio script que "estende" este.
## A narração só toca quando o leitor aperta "Ouvir texto"; apertar de novo para.

const TXT_OUVIR := "Ouvir texto"
const TXT_PARAR := "Parar áudio"

@export_file("*.tscn") var pagina_anterior := ""
@export_file("*.tscn") var pagina_proxima := ""

var narracao := ""   # cada página define o seu texto narrado

@onready var interface: Control = $CanvasLayer/Interface
@onready var btn_ouvir: Button = %BtnOuvir


func _ready() -> void:
	Global.parar()   # garante que a página sempre abre em silêncio
	Global.narracao_alterada.connect(_atualizar_botao_ouvir)
	_atualizar_botao_ouvir(Global.narrando)
	interface.modulate.a = 0.0
	create_tween().tween_property(interface, "modulate:a", 1.0, 0.25)


func _atualizar_botao_ouvir(ativa: bool) -> void:
	btn_ouvir.text = TXT_PARAR if ativa else TXT_OUVIR


func _on_voltar_pressed() -> void:
	Global.ir_para(pagina_anterior)


func _on_avancar_pressed() -> void:
	Global.ir_para(pagina_proxima)


func _on_ouvir_pressed() -> void:
	Global.alternar_narracao(narracao)
