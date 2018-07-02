
def ui_boas_vindas
	puts "PACMAN GAME - v 1.0 Alfa\n"
	puts "\n\nQual seu nome ? \n"
	nome = gets.strip
	puts "Vamos começar #{nome}"
	nome
end

def ui_print_mapa(mapa_txt)
	puts mapa_txt	
end

def ui_pede_movimento
	puts "Qual o movimeto ?\n"
	move = gets.strip
	move.upcase
end

def ui_game_over
	puts "\n\n\n\n\n\n"
	puts "You Lost ... Loser"
end