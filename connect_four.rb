module Board
	DARK_PIECE = "X"
	LIGHT_PIECE = "O"
	@@board = {"A" => [],"B" => [],"C" => [],"D" => [],"E" => [],"F" => [],"G" => [],"H" => [],"I" => [],"J" => []}
	def self.board
		return @@board
	end

	def self.display_board
		board = Array.new
		8.times do |y|
			board << "|"
			@@board.each_value do |x|
				board << (x[7-y] == nil ? " " : x[7-y])
				board << "|"
			end
			board << "\n"
		end
		return board.join("")

	end

	def self.add_piece piece,row
		@@board[row].push(piece)
	end
	def self.winner?
		#check verticals
		@@board.each_value {|x| x.each {|y| return[true,y] if y == x[x.index(y)+1] && y == x[x.index(y)+2] && y == x[x.index(y)+3]} }
		#check horizontals
		@@board.each_pair do |x,y|
			y.each do |z|
				return [true,z] if z == @@board[x.next][y.index(z)+1] && @@board[x.next.next][y.index(z)+2] == z && @@board[x.next.next.next][y.index(z)+3] == z
			end
		end
		#check diagonals
		@@board.each_pair do |x,y|
			y.each do |z|
				return [true,z] if z == @@board[x.next][y.index(z)] && @@board[x.next.next][y.index(z)] == z && @@board[x.next.next.next][y.index(z)] == z
			end
		end
		#return false otherwise
		return false
	end
	def self.clear
		@@board = {"A" => [],"B" => [],"C" => [],"D" => [],"E" => [],"F" => [],"G" => [],"H" => [],"I" => [],"J" => []}
	end
end
class Player
	attr_accessor :turn, :piece
	def initialize turn
		@turn = turn
		@piece = turn == 1 ? Board::LIGHT_PIECE : Board::DARK_PIECE
	end
	def add_piece place
		Board.add_piece(@piece,place)
	end

end
class Computer < Player
	attr_accessor :turn, :piece
	def initialize turn
		super(turn)
	end
	def add_piece
		letters = ["A","B","C","D","E","F","G","H","I","J"]
		Board.add_piece(@piece,letters[Random.rand(10)])	
	end
end
def game

	puts "Two-player Game?"
	answer = ""
	until answer[0] == "y" || answer[0] == "n"
		answer = gets.chomp.downcase
	end
	if answer[0] == "y"
		player1 = Player.new(1)
		player2 = Player.new(2)
		until Board.winner? != false
			puts "PLAYER 1 TURN"
			puts Board.display_board
			puts "Where would you like to play (A-J)?"
			answer = gets.chomp.upcase[0]
			begin
			player1.add_piece(answer)
			rescue
				puts "Sorry you can't play there"
				puts "Where would you like to play (A-J)?"
				answer = gets.chomp.upcase[0]
				retry
			end
			break unless Board.winner? == false
			puts "PLAYER 2 TURN"
			puts Board.display_board
			puts "Where would you like to play (A-J)?"
			answer = gets.chomp.upcase[0]
			begin
			player2.add_piece(answer)
			rescue
				puts "Sorry you can't play there"
				puts "Where would you like to play (A-J)?"
				answer = gets.chomp.upcase[0]
				retry
		
			end
			

		end
		puts Board.display_board
		if Board.winner?[1] == player1.piece
			puts "PLAYER 1 wins!"
		else
			puts "PLAYER 2 wins!"
		end
	else
		puts "Would you like to go first?"
		answer = ""
		until answer[0] == "y" || answer[0] == "n"
			answer = gets.chomp.downcase
		end
		if answer == "y"
			player = Player.new(1)
			comp = Computer.new(2)
		else
			comp = Computer.new(1)
			player = Player.new(2)
		end
		if player.turn == 1
			until Board.winner? != false
				puts Board.display_board
				puts "Where would you like to play (A-J)?"
				answer = gets.chomp.upcase[0]
				begin
				player.add_piece(answer)
				rescue
					puts "Sorry you can't play there"
					puts "Where would you like to play (A-J)?"
					answer = gets.chomp.upcase[0]
					retry
				end
				break unless Board.winner? == false
				
				comp.add_piece		
			end
		else
			until Board.winner? != false
				
				comp.add_piece
				break unless Board.winner? == false
				puts Board.display_board
				puts "Where would you like to play (A-J)?"
				answer = gets.chomp.upcase[0]
				begin 
					player.add_piece(answer)
				rescue
					puts "Sorry you can't play there"
					puts "Where would you like to play (A-J)?"
					answer = gets.chomp.upcase[0]
					retry
				end
			end 
			puts Board.display_board
			if Board.winner?[1] == player.piece
				puts "Congratulations, you won!"
			else
				puts "Sorry, you lost"
			end
		end
		
		puts "Rematch?"
		answer = ""
		until answer[0] == "y" || answer[0] == "n"
			answer = gets.chomp.downcase
		end
		Board.clear
		game if answer[0] == "y"
	end
end
game
