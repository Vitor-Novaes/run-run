require_relative 'ui'
require_relative 'hero'

def ler_mapa(numero_mapa)
	unless File.exists?("mapa#{numero_mapa}.txt") #=> true?
		puts "File not found: mapa#{numero_mapa}.txt"
	end

	mapa = File.read("mapa#{numero_mapa}.txt")
	mapa_txt = mapa.split "\n"
	mapa_txt
end

# Retorna índice da matriz em um array
def posicao_jogador(mapa_txt)
	mapa_txt.each_with_index do |linha_elementos, linha| # linha i / indice da linha (0,1,2 ...)
	 	coluna = linha_elementos.index "H" # retorna posição da coluna se ..=> "H"
	 	if coluna # => nil?
	 		player = Hero.new
	 		player.linha = linha
	 		player.coluna = coluna
	 		return player
	 	end
	end
	nil
end

def overview?(posicao_next,mapa_txt)
	transbordo_up_down = posicao_next[0] < 0 or posicao_next[0] >= mapa_txt.size # acima or abaixo
	transbordo_rigth_left = posicao_next[1] < 0 or posicao_next[1] >= mapa_txt[0].size # esquerda or direita

	#validação de transbordo
	if transbordo_rigth_left or transbordo_up_down
		return true
	end

	#validação de colisao
	valores_next = mapa_txt[posicao_next[0]][posicao_next[1]]
	if valores_next == "X" or valores_next == "F"
		return true
	end
	false
end

def posicoes_validas_a_partirde(mapa_txt,linha,coluna)
	posicoes = []
	nova_posicao = []
	movimentos = [[+1,0],[-1,0],[0,-1],[0,+1]]

	movimentos.each do |movimento|
		nova_posicao = [movimento[0] + linha, movimento[1] + coluna]
		if !overview?(nova_posicao,mapa_txt)
			posicoes << nova_posicao
		end
	end
	posicoes
end

def copia_mapa(mapa_txt)
	novo_mapa = mapa_txt.join("\n").tr("F"," ").split("\n")
	return novo_mapa
end

def movimento_inimigo(mapa_txt,linha,coluna)
	posicoes = posicoes_validas_a_partirde(mapa_txt,linha,coluna)
	if posicoes.empty?
		return
	end

	movimento_random = rand(posicoes.size)
	posicao_next = []
	posicao_next = posicoes[movimento_random].dup
		mapa_txt[linha][coluna] = " "
		mapa_txt[posicao_next[0]][posicao_next[1]] = "F"

end

def find_inimigos(mapa_txt)
	mapa_txt.each_with_index do |linha_atual,linha|
		linha_atual.chars.each_with_index do |caracter,coluna|
			if caracter == "F"
				movimento_inimigo(mapa_txt,linha,coluna)
			end
		end
	end
end

def bomba(posicao_next,mapa_txt)
	if mapa_txt[posicao_next.linha][posicao_next.coluna] == "*" 
		for direita in 1..4
			mapa_txt[posicao_next.linha][posicao_next.coluna + direita] = " "
		end
	end
	
end

def iniciar
	nome_player = ui_boas_vindas
	mapa_txt = ler_mapa(2)

	while true # loop do cenario
		ui_print_mapa(mapa_txt)
		player = posicao_jogador(mapa_txt) # return Object player attr :linha, :coluna
		direcao = ui_pede_movimento

		#movimento do heroi
		posicao_next = player.nova_posicao(direcao) # return nova posição Object player
		if overview?(posicao_next.to_array,mapa_txt) #overview ? true or false
			system("clear") or system "cls"
			next
		end
		player.space_nil(mapa_txt)
		bomba(posicao_next,mapa_txt)
		posicao_next.next_space(mapa_txt)

		#movimento dos fantasmas
		find_inimigos(mapa_txt)

		if posicao_jogador(mapa_txt) == nil
			ui_game_over
			break
		end

		system("clear") or system "cls"
	end
end
