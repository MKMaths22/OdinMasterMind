# frozen_string_literal: true

# Initially I will code the function that gives feedback when a guess is made by the codebreaker
# The colours will be represented by an array
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

# The overall program will deal with code and guess variables as arrays but the player will input
# a guess or the code as a string of letters which may be downcase or may/may not have spaces in between
# this will need to be converted into an array

def inputstringtoarray(string)
  # the method will search along the string input looking for 4 characters it can match from peg colours
  # only complaining input wasn't valid if it cannot find four such characters
  entered = string 
  until entered.upcase.scan(REGEX_COLOURS).size >= 4
    puts "Not accepted. Please type four colour characters, choosing from #{PEG_COLOURS}."
    entered = gets
  end
  array = entered.upcase.scan(REGEX_COLOURS).slice(0,4)
  # returns the first four input characters that match the possible colours
end

def arraytostring(guess_array,feedback_array)
    # format for output after a guess: puts [ 'Guess: A B C D  feedback: Red, White.']
    guess_string = "Guess: " + guess_array.join(' ')
    feedback_string = "  feedback: #{feedback_array.compact.join(', ')}."
    guess_string + feedback_string
end

# Human is the class for the human player
class Human
    attr_reader :name

    attr_accessor :roleinthisturn

    def initialize(name)
      @name = name
      @roleinthisturn = nil
    end
end

# Computer is the class for the computer player
class Computer
   attr_reader :name

   attr_accessor :roleinthisturn
   
   def initialize  
     @name = 'computer'
     @roleinthisturn = nil
   end
end

# TurnProgress class keeps track of how many guesses so far in the turn and knows when it is over
class TurnProgress

end 

# One game consists of an even number of turns, so that both sides set codes and guess codes
# equally many times. GameProgress class keeps track of how many turns and knows when it is over
class GameProgress
    
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

end

# FeedbackDisplayer class maintains the feedback display for an entire turn based on guesses and
# feedback so far, so we can see the whole history of trying to crack the code
class FeedbackDisplayer

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
human_player.roleinthisturn = 'codemaker'
computer_player.roleinthisturn = 'codebreaker'
game_controller = GameProgress.new(1)
  else
human_player.roleinthisturn = 'codebreaker'
computer_player.roleinthisturn = 'codemaker'
game_controller = GameProgress.new(0)
  end
# game_controller is initialised with the parity value 0 or 1 dependining on what the roles are in turn 1
# the GameProgress class automatically starts the game_controller.turn_number at 1

puts "Game controller parity = #{game_controller.parity}" 
puts "Turn number is #{game_controller.turn_number}"

  


