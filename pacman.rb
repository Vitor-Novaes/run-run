require_relative 'ui'

def ler_mapa(numero_mapa)
	unless File.exists?("mapa#{numero_mapa}.txt") #=> true?
		puts "File not found: mapa#{numero_mapa}.txt"
	end

	mapa = File.read("mapa#{numero_mapa}.txt")
	mapa_txt = mapa.split "\n"
end

# Retorna índice da matriz em um array
def posicao_jogador(mapa_txt)
	mapa_txt.each_with_index do |linha_elementos, linha| # linha i / indice da linha (0,1,2 ...)
	 	coluna = linha_elementos.index "H" # retorna posição da coluna se ..=> "H"
	 	if coluna # => nil?
	 		return [linha,coluna]
	 	end
	end
end

def nova_posicao(direcao,posicao_atual)
	posicao_next = posicao_atual.dup #duplica array
	#Array associativo
	movimentos = {"W" => [-1,0],"S" => [1,0], "A" => [0,-1], "D" => [0,1]}
	
	# case direcao
	# 	when "W"
	# 		posicao_next[0] += -1
	# 	when "S"
	# 		posicao_next[0] += 1
	# 	when "A"
	# 		posicao_next[1] += -1
	# 	when "D"
	# 		posicao_next[1] += 1
	# end
	
	movimento = movimentos[direcao]
	posicao_next[0] += movimento[0]
	posicao_next[1] += movimento[1] 
	posicao_next
end

def proximo_movimento?(posicao_next,mapa_txt)
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

def move_inimigo(mapa_txt,linha,coluna)
	posicao_next = [linha,coluna+1]

	if mapa_txt[posicao_next[0]][posicao_next[1]] == "X" # validação de colisao
		mapa_txt[linha][coluna] = "F"	
	end
	if !proximo_movimento?(posicao_next,mapa_txt)
		mapa_txt[linha][coluna] = " "
		mapa_txt[posicao_next[0]][posicao_next[1]] = "F"
	end
	
end

def move_inimigos(mapa_txt)
	mapa_txt.each_with_index do |linha_atual,linha|
		linha_atual.chars.each_with_index do |caracter,coluna|
			if caracter == "F"
				move_inimigo(mapa_txt,linha,coluna)
			end
		end
	end
end

def iniciar
	nome_player = ui_boas_vindas
	mapa_txt = ler_mapa(2)
	
	while true # loop do cenario
		ui_print_mapa(mapa_txt)
		posicao_atual = posicao_jogador(mapa_txt) # posição_atual => array[linha,coluna]
		direcao = ui_pede_movimento

		#movimento do heroi
		posicao_next = nova_posicao(direcao,posicao_atual)
		if proximo_movimento?(posicao_next,mapa_txt) #overview ? true or false
			system("clear") or system "cls"
			next
		end
		mapa_txt[posicao_atual[0]][posicao_atual[1]] = " " # Espaço vazio quando sair da posição atual 
		mapa_txt[posicao_next[0]][posicao_next[1]] = "H" 
		
		#movimento dos fantasmas
		move_inimigos(mapa_txt)



		system("clear") or system "cls"
	end
end