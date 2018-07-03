class Hero
	attr_accessor :linha, :coluna
	#attr_reader  :somente leitura
	#attr_writer  :somente escrita

	def nova_posicao(direcao)
		player = self.dup #duplica array # self tem a função do "this" em C++
		
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
		player.linha += movimento[0]
		player.coluna += movimento[1]
		player
	end

	def to_array
		[self.linha,self.coluna]
	end

	def space_nil(mapa_txt)
		mapa_txt[self.linha][self.coluna] = " " # Espaço vazio quando sair da posição atual
	end

	def next_space(mapa_txt)
		mapa_txt[self.linha][self.coluna] = "H"
	end

end