# frozen_string_literal: true

# Initially I will code the function that gives feedback when a guess is made by the codebreaker
# The colours will be represented by an array
module GameConstants 
  PEG_COLOURS = %w[A B C D E F].freeze
  REGEX_COLOURS = Regexp.union(PEG_COLOURS)
  MAX_GUESSES = 12
  # the maximum number of guesses in a turn
  TURNS = 4
  # the number of turns in one game, an even number
  # 6 possible peg colours and 12 guesses allowed for the codebreaker
  # string to array method assumes that the peg colours are all uppercase letters
  HINT_COLOURS = %w[Red White].freeze
  # The first colour is for correct colour and position, second one for colour correct but in wrong position
  # The Code is an array of four peg_colours, as is the guess. Feedback is given as an array of length 4,
  # starting with the Hint_Colours pegs and completed with nil values
  def point_or_points(num)
    num == 1 ? "1 point" : "#{num} points"
  end
  # point_or_s makes sure that the singular 'point' is displayed when necessary
end

include GameConstants 

# The overall program will deal with code and guess variables as arrays but the player will input
# a guess or the code as a string of letters which may be downcase or may/may not have spaces in between
# this will need to be converted into an array
# Human is the class for the human player
class Human

include GameConstants

    attr_reader :name

    attr_accessor :codebreaker, :codemaker, :score

    def initialize(name)
      @name = name
      @codebreaker = false
      @codemaker = false
      @score = 0
    end

    def toggle_role
        self.codemaker = !@codemaker
        self.codebreaker = !@codebreaker
    end

    def make_code
        self.codemaker ? make_code_or_guess : [] 
    end

    def make_guess 
        self.codebreaker ? make_code_or_guess : []
    end 

    # context will determine whether we are asking for a code or guess. The algorithm will ask a Human or 
    # Computer to make a code or guess without knowing which player type is being asked. So if they are asked
    # the wrong thing, they will return nil
    private 
    
    def make_code_or_guess
        puts "Let's hope the computer can't crack this." if self.codemaker
        puts "Guess the code." if self.codebreaker
        puts "Enter four colours from #{PEG_COLOURS}. Duplicates allowed."
        entered = gets 
          until entered.upcase.scan(REGEX_COLOURS).size >= 4
            puts "Not accepted. Please type four colour characters, choosing from #{PEG_COLOURS}. Duplicates allowed."
            entered = gets
          end
        array = entered.upcase.scan(REGEX_COLOURS).slice(0,4)
        # returns the first four input characters that match the possible colours
        # which is a valid code for setting a code or a valid guess

    end
end

# Computer is the class for the computer player
class Computer
  include GameConstants
   attr_reader :name

   attr_accessor :codemaker, :codebreaker, :score
   
   def initialize  
     @name = 'computer'
     @codemaker = false
     @codebreaker = false
     @score = 0
   end
  
  def toggle_role
    self.codemaker = !@codemaker
    self.codebreaker = !@codebreaker
  end
  
  
  def make_code
    self.codemaker ? make_random_code_or_guess : []
  end

  def make_guess
    self.codebreaker ? make_random_code_or_guess : []
    # when the program is rewritten to give Computer a clever strategy, this method will be fleshed out
  end

  private

  def make_random_code_or_guess
    puts "computer guessing..." if self.codebreaker
    puts "computer setting code..." if self.codemaker
    sleep(3)
    # to slow down the computer
    output = []
      4.times do
        output.push(PEG_COLOURS[rand(PEG_COLOURS.size)])
      end
      output
  end 

end

# TurnProgress class keeps track of how many guesses so far in the turn and knows when it is over
class TurnProgress
    
  include GameConstants

  attr_accessor :code, :guesses_so_far, :code_solved
  
  def initialize
    @code = nil
    @guesses_so_far = 0
    @code_solved = false
  end
  
  def start_new_guess
    self.guesses_so_far += 1
  end

  def start_new_turn
    self.code_solved = false
    self.guesses_so_far = 0
  end
end 

# One game consists of an even number of turns, so that both sides set codes and guess codes
# equally many times. GameProgress class keeps track of how many turns and knows when it is over
class GameProgress

    include GameConstants

    attr_accessor :turn_number
    
    def initialize
      @turn_number = 0
      # starts at zero so that at the start of a turn it is the number of completed turns/rounds
    end 

    def start_new_turn
        self.turn_number += 1
        sleep(2)
        puts "\n This is the start of Round number #{self.turn_number}." if self.turn_number.between?(2,TURNS - 1)
        puts "\n And finally, Round number #{TURNS}" if self.turn_number == TURNS
    end

end

# FeedbackProvider class can accept a guess and code and give the feedback for that one case
class FeedbackProvider

    include GameConstants
    
    def exact_matches(array_one, array_two)
        matches = 0
        4.times do |i|
          matches += 1 if array_one[i] == array_two[i]
        end
        matches
      end
      
      def total_matches(array_one, array_two)
        matches = 0
        PEG_COLOURS.each do |i|
          matches += [array_one.count(i), array_two.count(i)].min
        end
        matches
      end
      
      def feedback(code, guess)
        output_array = Array.new(4)
      
        (1..total_matches(code, guess)).each do |i|
          output_array[i - 1] = HINT_COLOURS[1]
        end
        # so we now have a White peg for every match which may or may not be an exact match
        (1..exact_matches(code, guess)).each do |i|
          output_array[i - 1] = HINT_COLOURS[0]
        end
        # now we have changed White pegs into Red for each exact match and feedback is complete
        output_array
      end
end

# FeedbackDisplayer class maintains the feedback display for an entire turn based on guesses and
# feedback so far, so we can see the whole history of trying to crack the code
class FeedbackDisplayer
    
    attr_accessor :total_feedback
    
    def initialize
        @total_feedback = ""
        #tracks the total feedback so far in the current turn/round as a string
    end

    def add_the_feedback(one_guess_output)
        self.total_feedback += one_guess_output
    end

    def reset_the_feedback
        self.total_feedback = ""
    end

    def array_to_string(guess_array,feedback_array)
        # format for output after a guess: puts [ 'Guess: A B C D  feedback: Red, White.']
        guess_string = "Guess: " + guess_array.join(' ')
        stringy_feedback = feedback_array.compact.join(', ')
        if stringy_feedback == ''
             feedback_string = "  feedback: No matches. \n"
        else feedback_string = "  feedback: #{feedback_array.compact.join(', ')}. \n"
        end 
        guess_string + feedback_string
    end
end

computer_player = Computer.new
puts "Welcome to Mastermind versus the Computer. What is your name?"
human_player = Human.new(gets.strip)
puts "In the first round, would you like to make or break the code? Type M for codeMaker or B for codeBreaker."
THISREGEX = Regexp.union(%w(M B))
inputted = gets.strip.upcase 
  until inputted.match(THISREGEX)
    puts "Please type M or B to continue."
    inputted = gets.strip.upcase
  end
decision = inputted.scan(THISREGEX)[0]
  if decision == 'M'
human_player.codemaker = true 
computer_player.codebreaker = true
  else
human_player.codebreaker = true 
computer_player.codemaker = true
  end

# the GameProgress class automatically starts the game_controller.turn_number at 0
# and this is incremented at the beginning of each turn. Similarly the TurnProgress class
# starts with guesses_so_far at 0 and increments it at the start of a guess
game_controller = GameProgress.new
turn_controller = TurnProgress.new
feedback_giver = FeedbackProvider.new
feedback_display = FeedbackDisplayer.new


until game_controller.turn_number == TURNS do
    game_controller.start_new_turn
    # increments the turn number
    turn_controller.code = computer_player.make_code.concat(human_player.make_code)
    # whichever player is codebreaker supplies empty array for making code so concat works

    until turn_controller.guesses_so_far == MAX_GUESSES do
          turn_controller.start_new_guess
          # increments the guesses_so_far number
          puts "Last guess now. Good luck!" if human_player.codebreaker && turn_controller.guesses_so_far == MAX_GUESSES
          current_guess = computer_player.make_guess.concat(human_player.make_guess)
          # current_guess is an array and whichever player is codemaker supplies empty array so concat works
          current_feedback_array = feedback_giver.feedback(turn_controller.code, current_guess)
          current_feedback_string = feedback_display.array_to_string(current_guess, current_feedback_array)
          feedback_display.add_the_feedback(current_feedback_string)
          
          if current_feedback_array[3] == HINT_COLOURS[0]
            turn_controller.code_solved = true
            puts "You solved it. Well done, #{human_player.name}!" if human_player.codebreaker
            puts "The computer solved your code." if computer_player.codebreaker
            puts "The total feedback for the guesses was: \n#{feedback_display.total_feedback}"
            human_player.score += turn_controller.guesses_so_far if human_player.codemaker
            computer_player.score += turn_controller.guesses_so_far if computer_player.codemaker
            puts "The scores are now: #{human_player.name} has #{point_or_points(human_player.score)} and \n
            the computer has #{point_or_points(computer_player.score)}"
          end 
          break if turn_controller.code_solved 
          # the code was guessed correctly
          puts "The total feedback so far is: \n#{feedback_display.total_feedback}"
    end
    # here is the code that executes if all guesses have been used up in the turn/round
    unless turn_controller.code_solved 
      puts "The code #{turn_controller.code} has not been cracked in #{MAX_GUESSES} guesses, so the codemaker scores #{MAX_GUESSES + 1} points."
      if human_player.codemaker
        human_player.score += (MAX_GUESSES + 1)
        puts "That's a good round, #{human_player.name}."
      else
        computer_player.score += (MAX_GUESSES + 1)
      end
      puts "The scores are now: #{human_player.name} has #{point_or_points(human_player.score)} and \n
            the computer has #{point_or_points(computer_player.score)}"
    end

    human_player.toggle_role
    computer_player.toggle_role
    feedback_display.reset_the_feedback
    turn_controller.start_new_turn
    
end

puts "The game is over. Here are the scores..."
sleep(2)
if human_player.score > computer_player.score
    puts "Congratulations, #{human_player.name}! You won by #{point_or_points(human_player.score)} to #{computer_player.score}."
elsif human_player.score < computer_player.score
    puts "The computer wins the game by #{point_or_points(computer_player.score)} to #{human_player.score}. \n
    Better luck next time, #{human_player.name}"
else 
    puts "The game is drawn --- both players scored #{point_or_points(human_player.score)}"
end 







  


