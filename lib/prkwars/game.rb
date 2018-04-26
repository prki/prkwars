require_relative './play'
require 'chingu'
include Gosu

##
# Game class is simply an encapsulation of the chingu window - essentially, the
# entry point of the game.
#
class Game < Chingu::Window
  ##
  # Initialization of Game only creates a window of a specified size and
  # pushes the beginning game state - +Splash+, into the game state stack.
  def initialize
    super(1280, 720)
    push_game_state(Splash)
  end
end
