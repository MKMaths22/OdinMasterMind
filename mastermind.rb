# frozen_string_literal: true

# Initially I will code the function that gives feedback when a guess is made by the codebreaker
# The colours will be represented by an array
PEG_COLOURS = %w[A B C D E F].freeze
# 6 possible peg colours and 12 guesses allowed for the codebreaker
HINT_COLOURS = %w[Red White].freeze
# The first colour is for correct colour and position, second one for colour correct but in wrong position
# The Code is an array of four peg_colours, as is the guess. The feedback is an array of Hint_Colours.

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
  (1..exact_matches(code, guess)).each do |i|
    output_array[i - 1] = HINT_COLOURS[0]
  end
  output_array
end

p feedback(%w[C B C C], %w[C C C B])
