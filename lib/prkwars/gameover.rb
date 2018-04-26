require 'chingu'

##
# Class representing the game over state shown when the player loses the game.
#
class GameOver < Chingu::GameState
  ##
  # Initialization of the game over screen does nothing else but map inputs to
  # the +play+ method (in case the player wishes to play again) and draws text
  # on the screen.

  def initialize(score, options = {})
    super(options)

    self.input = { space: :play, esc: :exit }

    Chingu::Text.create("Final score: #{score}", x: 20, y: 20, size: 30)
    Chingu::Text.create('Press <space> to play again, <esc> to exit.',
                        x: 20, y: 60)
  end

  ##
  # Switches the game state. Calls +Play.new+ instead of just Play in order
  # to call the initialize method instead of the setup method.
  def play
    switch_game_state(Play.new)
  end
end
