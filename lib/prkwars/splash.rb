require 'chingu'

##
# Class representing the game state right after turning the game on.

class Splash < Chingu::GameState
  ##
  # A setup method called by the chingu library when the +Splash+ class
  # gets pushed into the game state stack/gets switched to.
  # Sets up input for exit/playing the game and sets up splash messages.
  def setup
    self.input = { space: :play, esc: :exit }
    Chingu::Text.create('PRK WARS',
                        x: 20, y: 20, size: 60, color: Gosu::Color::RED)
    Chingu::Text.create('A simple Grid Wars/Geometry Wars clone',
                        x: 20, y: 90, size: 30)
    Chingu::Text.create('Press <space> to play the game, <esc> to exit.',
                        x: 20, y: 130, size: 30)
    Chingu::Text.create('Controls: WASD: movement, arrow keys: shooting'\
                        ' direction.',
                        x: 20, y: 170, size: 30)
  end

  ##
  # A method called when the player presses space in order to play the game.
  # Uses the +transitional_game_state+ method provided by the +chingu+ library
  # in order to make things prettier.
  def play
    transitional_game_state(Chingu::GameStates::FadeTo, speed: 10)
    switch_game_state(Play.new)
  end
end
