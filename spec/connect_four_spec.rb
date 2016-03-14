require "spec_helper"

describe "Board module" do
	
	before :each do
		Board.clear
	end
	

	describe "#board" do
		it "returns the board" do
			expect(Board.board).to eql({"A" => [],"B" => [],"C" => [],"D" => [],"E" => [],"F" => [],"G" => [],"H" => [],"I" => [],"J" => []})
		end
		it "returns the board with a piece in it" do
			Board.add_piece(Board::DARK_PIECE,"A")
			expect(Board.board).to eql({"A" => [Board::DARK_PIECE],"B" => [],"C" => [],"D" => [],"E" => [],"F" => [],"G" => [],"H" => [],"I" => [],"J" => []})
		end

	end


	
	describe "#display_board" do
		
			context "empty board" do
				it "displays an empty board" do
					expect(Board.display_board).to eql("| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n")
				end
			end
			context "empty board" do
				it "displays a filled board" do
					Board.add_piece(Board::DARK_PIECE,"A")
					Board.add_piece(Board::LIGHT_PIECE,"B")
					expect(Board.display_board).to eql("| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n| | | | | | | | | | |\n|#{Board::DARK_PIECE}|#{Board::LIGHT_PIECE}| | | | | | | | |\n")
					
				end
			end
		
	end

	describe "#add_piece" do
		
			context " when there are no pieces below it" do
				it "adds the piece to the bottom" do
					Board.add_piece(Board::DARK_PIECE,"A")
					expect(Board.board["A"][0]).to eql(Board::DARK_PIECE) 
				end
			end
			context " when there are pieces below it" do
				it "adds the piece ontop of the other" do
					Board.add_piece(Board::DARK_PIECE,"A")
					Board.add_piece(Board::LIGHT_PIECE,"A")
					expect(Board.board["A"][1]).to eql(Board::LIGHT_PIECE) 
				end
			end
		
	end
	describe "#winner?" do
		
			context "vertical combination" do
				it "identifies the winning combo" do
					Board.add_piece(Board::DARK_PIECE,"A") 
					Board.add_piece(Board::DARK_PIECE,"A")
					Board.add_piece(Board::DARK_PIECE,"A")
					Board.add_piece(Board::DARK_PIECE,"A")
					expect(Board.winner?).to eql([true,Board::DARK_PIECE])
				end
			end
			context "horizontal combination" do 
				it "identifies the winning combo" do
					Board.add_piece(Board::DARK_PIECE,"A") 
					Board.add_piece(Board::DARK_PIECE,"B")
					Board.add_piece(Board::DARK_PIECE,"C")
					Board.add_piece(Board::DARK_PIECE,"D")
					expect(Board.winner?).to eql([true,Board::DARK_PIECE])
				end
			end		
			context "diagonal combination" do
				it "identifies the winning combo" do
					Board.add_piece(Board::DARK_PIECE,"A") 
					Board.add_piece(Board::LIGHT_PIECE,"B")
					Board.add_piece(Board::DARK_PIECE,"B")
					Board.add_piece(Board::LIGHT_PIECE,"C")
					Board.add_piece(Board::LIGHT_PIECE,"C")
					Board.add_piece(Board::DARK_PIECE,"C")
					Board.add_piece(Board::LIGHT_PIECE,"D")
					Board.add_piece(Board::LIGHT_PIECE,"D")
					Board.add_piece(Board::LIGHT_PIECE,"D")
					Board.add_piece(Board::DARK_PIECE,"D")
					expect(Board.winner?).to eql([true,Board::DARK_PIECE])
				end
			end
			context "no combination" do
				it "returns false" do
					expect(Board.winner?).to eql(false)
				end
			end
		
	end
	describe "#clear" do
		it "clears the board" do
			Board.add_piece(Board::LIGHT_PIECE,"C")
			Board.clear
			expect(Board.board).to eql({"A" => [],"B" => [],"C" => [],"D" => [],"E" => [],"F" => [],"G" => [],"H" => [],"I" => [],"J" => [],})
		end 
	end
end
describe "Player class" do

	before :each do
		@player = Player.new(2)
	end

	describe "#new" do

		it "creates a new Player object" do
			expect(@player).to be_an_instance_of(Player)
		end

		it "accepts one position argument" do
			expect{ Player.new }.to raise_error(ArgumentError)
			expect{ @player }.to_not raise_error
			expect{ Player.new(2,false) }.to raise_error(ArgumentError)

		end

	end

	describe "#add_piece" do

		it "accepts one argument" do
			expect{ @player.add_piece }.to raise_error(ArgumentError)
			expect{ @player.add_piece("A") }.to_not raise_error
			expect{ @player.add_piece("A","B") }.to raise_error(ArgumentError)
		end
		it "places a piece on the board" do

			@player.add_piece("A")
			expect(Board.board["A"][0]).to eql(@player.piece)

		end

	end

	describe "#piece" do

		it "returns the Player's piece" do
			expect(@player.piece).to eql(Board::DARK_PIECE)
			player2 = Player.new(1)
			expect(player2.piece).to eql(Board::LIGHT_PIECE)
		end

	end
	describe "#turn" do

		it "sets the proper position of the Player" do
			expect(@player.turn).to eql(2)
			player2 = Player.new(1)
			expect(player2.turn).to eql(1)
		end
	end




end
describe "Computer class" do

	before :each do
		@comp = Computer.new(2)
	end

	describe "#new" do

		it "creates a new Computer object" do
			expect(@comp).to be_an_instance_of(Computer)
			expect(@comp).to be_a_kind_of(Player)
		end

		it "accepts one position argument" do
			expect{ Computer.new }.to raise_error(ArgumentError)
			expect{@comp}.to_not raise_error
			expect{ Computer.new(2,false) }.to raise_error(ArgumentError)

		end

	end

	describe "#add_piece" do

		it "accepts no arguments" do
			
			expect{ @comp.add_piece("A") }.to raise_error(ArgumentError) 
			
		end
		it "places a piece on the board" do

			@comp.add_piece
			expect(Board.board["A"][0]).to eql(@comp.piece)

		end

	end

	describe "#piece" do

		it "returns the Player's piece" do
			expect(@comp.piece).to eql(Board::DARK_PIECE)
			comp2 = Computer.new(1)
			expect(comp2.piece).to eql(Board::LIGHT_PIECE)
		end

	end
	describe "#turn" do

		it "sets the proper position of the Player" do
			expect(@comp.turn).to eql(2)
			comp2 = Computer.new(1)
			expect(comp2.turn).to eql(1)
		end
	end




end

