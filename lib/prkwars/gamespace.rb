require 'chingu'

##
# Class representing the space where the game is being played. Class is
# essentially an encapsulation for the big rectangle where the game can be
# played. Also holds possible spawn points for enemy entities.
#
class GameSpace < Chingu::GameObject
  trait :collision_detection
  trait :bounding_box

  ##
  # Accessor to the player - used by various enemies to determine the position
  # of the player.
  attr_accessor :player

  ##
  # Initialization method sets up the spawn points for enemies and
  # sets up the background image.

  def initialize(options = {})
    super(options)

    @image = Image['media/background.png']
    setup_spawn_points
  end

  ##
  # Returns a random spawn point from the list of spawn points defined
  # by the +setup_spawn_points+ method.

  def enemy_spawn_point(player_x, player_y)
    sample_points = points_far_enough(player_x, player_y)

    sample_points.sample
  end

  private

  ##
  # Sets up a list of possible spawn points to be used by enemies.

  def setup_spawn_points
    @spawn_points = [[60, 60], [1200, 60], [60, 640], [1200, 640], [800, 640],
                     [800, 60], [800, 640], [250, 400], [500, 600],
                     [120, 640], [340, 520], [380, 640], [960, 80],
                     [1100, 420]]
  end

  ##
  # Returns a list of points which are far enough from the player. Minimum
  # distance is arbitrary and at the moment set to 130 game units.

  def points_far_enough(player_x, player_y)
    points = []

    @spawn_points.each do |point|
      dist = Math.sqrt((player_x - point[0]) * (player_x - point[0]) +
                       (player_y - point[1]) * (player_y - point[1]))

      points.push(point) if dist > 130
    end

    points
  end
end
