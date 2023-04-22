# frozen_string_literal: true

# Initially I will code the function that gives feedback when a guess is made by the codebreaker
# The colours will be represented by an array
module GameConstants 
  PEG_COLOURS = %w[A B C D E F].freeze
  REGEX_COLOURS = Regexp.union(PEG_COLOURS)
  MAX_GUESSES = 12
  # the maximum number of guesses in a turn
  TURNS = 2
  # the number of turns in one game, an even number
  # 6 possible peg colours and 12 guesses allowed for the codebreaker
  # string to array method assumes that the peg colours are all uppercase letters
  HINT_COLOURS = %w[Red White].freeze
  # The first colour is for correct colour and position, second one for colour correct but in wrong position
  # The Code is an array of four peg_colours, as is the guess. Feedback is given as an array of length 4,
  # starting with the Hint_Colours pegs and completed with nil values
end

include GameConstants 

# The overall program will deal with code and guess variables as arrays but the player will input
# a guess or the code as a string of letters which may be downcase or may/may not have spaces in between
# this will need to be converted into an array
# Human is the class for the human player
class Human

include GameConstants

    attr_reader :name

    attr_accessor :role_in_this_turn, :score

    def initialize(name)
      @name = name
      @role_in_this_turn = nil
      @score = 0
    end

    def make_code
        make_code_or_guess
    end

    def make_guess 
        make_code_or_guess
    end 

    # context will determine whether we are asking for a code or guess. The algorithm will ask a Human or 
    # Computer to make a code or guess without knowing which player type is being asked. So even though
    # the methods are identical for a Human, they still have different names.
    
    def make_code_or_guess
        entered = gets 
          until entered.upcase.scan(REGEX_COLOURS).size >= 4
            puts "Not accepted. Please type four colour characters, choosing from #{PEG_COLOURS}."
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

   attr_accessor :role_in_this_turn, :score
   
   def initialize  
     @name = 'computer'
     @role_in_this_turn = nil
     @score = 0
   end

  def make_code
    output = []
    4.times do
        output.push(PEG_COLOURS[rand(PEG_COLOURS.size)])
    end
    output
  end

  def make_guess
    make_code
    # when the program is rewritten to give Computer a clever strategy, this method will be fleshed out
    # so it is distinct from make_code even though it does exactly the same thing
  end

end

# TurnProgress class keeps track of how many guesses so far in the turn and knows when it is over
class TurnProgress
    
  include GameConstants
  
  def initialize
    @code = nil
  end  
end 

# One game consists of an even number of turns, so that both sides set codes and guess codes
# equally many times. GameProgress class keeps track of how many turns and knows when it is over
class GameProgress

    include GameConstants
    
    attr_reader :parity
    attr_accessor :turn_number
    
    def initialize(parity)
      # parity = integer 0 or 1. Parity 0 means Human breaks code in the first turn/round 
      # and all odd turns/rounds. Parity 1 means the Computer breaks code in all odd turns/rounds
      @parity = parity
      @turn_number = 1
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

    def display_the_feedback(one_guess_output)
        self.total_feedback += one_guess_output
        puts total_feedback
    end

    def array_to_string(guess_array,feedback_array)
        # format for output after a guess: puts [ 'Guess: A B C D  feedback: Red, White.']
        guess_string = "Guess: " + guess_array.join(' ')
        feedback_string = "  feedback: #{feedback_array.compact.join(', ')}. \n"
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
human_player.role_in_this_turn = 'codemaker'
computer_player.role_in_this_turn = 'codebreaker'
game_controller = GameProgress.new(1)
  else
human_player.role_in_this_turn = 'codebreaker'
computer_player.role_in_this_turn = 'codemaker'
game_controller = GameProgress.new(0)
  end
# game_controller is initialised with the parity value 0 or 1 dependining on what the roles are in turn 1
# the GameProgress class automatically starts the game_controller.turn_number at 1





  


