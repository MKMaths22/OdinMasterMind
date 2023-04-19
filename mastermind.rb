# Initially I will code the function that gives feedback when a guess is made by the codebreaker
# The colours will be represented by an array
PEG_COLOURS = %w[A B C D E F]
# 6 possible peg colours and 12 guesses allowed for the codebreaker
HINT_COLOURS = %w[Red White]
p PEG_COLOURS
# The first colour is for correct colour and position, second one for colour correct but in wrong position
# The Code is an array of four peg_colours, as is the guess. The feedback is an array of Hint_Colours.
def feedback(code, guess)
    matched = Array.new(4, false)
    not_exact_matches = []
    output_array = []
    4.times do |i|
      if code[i] == guess[i]
        matched[i] = true
        output_array.push(HINT_COLOURS[0])
      else
        not_exact_matches.push(i)
      end
    end
    # all exact matches have been found and the correct number of Red pegs given as feedback
    not_exact_matches.each do |i|
      not_exact_matches.each do |j|
        if guess[i] == code[j] && matched[j] == false
          matched[j] = true
          output_array.push(HINT_COLOURS[1])
        end
      end
    end
    # we have pushed White pegs into the feedback output array for each new match which will be partial
    output_array
end
p feedback(%w(A C B A), %w(A D F E))