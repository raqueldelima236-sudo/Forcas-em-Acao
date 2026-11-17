extends Node
## Autoload "Global": narração em áudio (MP3 gravado) controlada por clique.
## O áudio NUNCA toca sozinho: só quando o leitor aperta "Ouvir texto".
## Apertar de novo para na hora, trocar de página também para,
## e o botão volta a "Ouvir texto" quando o áudio termina.

## Emitido quando a narração começa (true) ou termina/é interrompida (false).
signal narracao_alterada(ativa: bool)

var narrando := false

var _player: AudioStreamPlayer


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.name = "PlayerNarracao"
	add_child(_player)
	_player.finished.connect(_ao_terminar_audio)


# --- Controle por clique ------------------------------------------------------

## Botão "Ouvir texto": liga se estava parado, desliga se estava tocando.
## "caminho" é o arquivo de áudio da página (ex.: "res://assets/audios/pagina1.mp3").
func alternar_narracao(caminho: String) -> void:
	if narrando:
		parar()
	else:
		narrar(caminho)


func narrar(caminho: String) -> void:
	parar()
	if caminho == "":
		return
	var audio := load(caminho) as AudioStream
	if audio == null:
		push_warning("Não foi possível carregar o áudio: %s" % caminho)
		return
	_player.stream = audio
	_player.play()
	narrando = true
	narracao_alterada.emit(true)


func parar() -> void:
	if _player and _player.playing:
		_player.stop()
	if narrando:
		narrando = false
		narracao_alterada.emit(false)


func ir_para(caminho: String) -> void:
	if caminho == "":
		return
	parar()
	get_tree().change_scene_to_file(caminho)


func _notification(what: int) -> void:
	# fechar a janela ou minimizar o app no celular também silencia o áudio
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_APPLICATION_PAUSED:
		parar()


# --- Fim natural do áudio -----------------------------------------------------

func _ao_terminar_audio() -> void:
	if narrando:
		narrando = false
		narracao_alterada.emit(false)
