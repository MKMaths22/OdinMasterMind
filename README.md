# OdinMasterMind
This project uses the MIT License.

I decided to make this game 4 rounds between a human player and the Computer, in which the human decides whether to be codemaker or codebreaker in the first round, alternating roles for subsequent rounds. Each round has 12 guesses and there are 6 possible colours used in the code, with duplicates allowed.
Changing any of these constants, or the colours used for feedback hints, is as easy as altering one line of code. For example, to have Orange pegs for exact matches instead of Red, just go to line 12 and change 'Red' to 'Orange' in the code 'HINT_COLOURS = %w[Red White].freeze'.

The computer is very smart when codebreaker, using all feedback it receives to narrow down the possible codes to only those that could give that feedback, and then choosing a possible code at random. 

The computer outputs to the console how many possible codes are remaining, which shows how effective this strategy is. Also, whether the human or computer are guessing, all feedback is displayed in one easy-to-read table for all of the guesses so far in the round.

I have done my best to separate methods/information using modules and classes as per the philosophy of Object Oriented Programming. Enjoy! 
