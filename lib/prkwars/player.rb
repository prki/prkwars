require_relative './modules'
require 'chingu'

##
# Class holding all the logic related to the player - input controller
# and any manipulation of player's sprite.
class Player < Chingu::GameObject
  trait :bounding_box
  trait :collision_detection

  attr_accessor :lives
  attr_reader :invulnerable

  include GamespacePersistence
  STARTING_LIVES = 3
  SHOOT_GAP = 8
  STARTING_BOMBS = 3
  INVUL_FRAMES = 30

  ##
  # Initialization of player assigns gamespace to the player, their sprite
  # and sets the input layout for the player.
  def initialize(gamespace, options = {})
    super(options)

    @image = Image['./media/player_ship.png']
    self.input = { holding_w: :move_up, holding_a: :move_left,
                   holding_d: :move_right, holding_s: :move_down,
                   holding_left: :shoot_left, holding_right: :shoot_right,
                   holding_up: :shoot_up, holding_down: :shoot_down }
    init_vector_variables

    @gamespace = gamespace
    @lives = STARTING_LIVES
    @bombs = STARTING_BOMBS
  end

  ##
  # A method changing the player's y position by the +PLAYER_VELOCITY+
  # constant.

  def move_up
    @y -= Constants::PLAYER_VELOCITY
    @y_change = -Constants::PLAYER_VELOCITY
  end

  ##
  # A method changing the player's y position by the +PLAYER_VELOCITY+
  # constant.

  def move_down
    @y += Constants::PLAYER_VELOCITY
    @y_change = Constants::PLAYER_VELOCITY
  end

  ##
  # A method changing the player's x position by the +PLAYER_VELOCITY+
  # constant.

  def move_left
    @x -= Constants::PLAYER_VELOCITY
    @x_change = -Constants::PLAYER_VELOCITY
  end

  ##
  # A method changing the player's x position by the +PLAYER_VELOCITY+
  # constant.

  def move_right
    @x += Constants::PLAYER_VELOCITY
    @x_change = Constants::PLAYER_VELOCITY
  end

  ##
  # Sets the shooting vector's x part to +-BULLET_VELOCITY+.

  def shoot_left
    @shoot_vec_x = -Constants::BULLET_VELOCITY
  end

  ##
  # Sets the shooting vector's x part to +BULLET_VELOCITY+.

  def shoot_right
    @shoot_vec_x = Constants::BULLET_VELOCITY
  end

  ##
  # Sets the shooting vector's y part to +-BULLET_VELOCITY+.

  def shoot_up
    @shoot_vec_y = -Constants::BULLET_VELOCITY
  end

  ##
  # Sets the shooting vector's y part to +BULLET_VELOCITY+.
  def shoot_down
    @shoot_vec_y = Constants::BULLET_VELOCITY
  end

  ##
  # Method updating the player each frame. Player's sprite gets rotated
  # to correspond to his movement direction. In case they're out of bounds
  # the player's coordinates are corrected and bullets are shot if possible.

  def update
    rotate_player
    correct_coords(self, @gamespace) unless in_bounds(self, @gamespace)
    @shoot_timer += 1
    return unless @shoot_timer == SHOOT_GAP

    shoot_bullet
    @shoot_timer = 0
  end

  private

  ##
  # Initializes variables used by the player class to determine shooting
  # speed as well as rotations of their sprite.

  def init_vector_variables
    @x_change = 0 # Used for rotating the triangular sprite
    @y_change = 0
    @shoot_timer = 0
    @shoot_vec_x = 0 # Used for deciding the shooting direction
    @shoot_vec_y = 0
  end

  ##
  # Rotates the player sprite if there was a change in their movement direction.

  def rotate_player
    return unless @x_change != 0 || @y_change != 0

    rot_to = Math.atan2(@y_change, @x_change) / Math::PI * 180 + 90

    self.angle = rot_to

    @x_change = 0
    @y_change = 0
  end

  ##
  # Method shooting bullets in the direction which was input by the player.
  # These directions are repesented by the @shoot_vec_x and @shoot_vec_y
  # instance variables.

  def shoot_bullet
    return unless @shoot_vec_x != 0 || @shoot_vec_y != 0

    bullet_angle = Math.atan2(@shoot_vec_y, @shoot_vec_x) / Math::PI * 180 - 180

    norm_x = -@shoot_vec_y
    norm_y = @shoot_vec_x

    dist_norm = Math.sqrt(norm_x * norm_x + norm_y * norm_y)

    unit_x = norm_x / dist_norm
    unit_y = norm_y / dist_norm

    Bullet.create(@gamespace,
                  zorder: ZOrder::GAMEOBJECT, x: @x + unit_x * 7,
                  y: @y + unit_y * 7,
                  velocity_x: @shoot_vec_x, velocity_y: @shoot_vec_y,
                  angle: bullet_angle)

    Bullet.create(@gamespace,
                  zorder: ZOrder::GAMEOBJECT, x: @x - unit_x * 7,
                  y: @y - unit_y * 7,
                  velocity_x: @shoot_vec_x, velocity_y: @shoot_vec_y,
                  angle: bullet_angle)
    @shoot_vec_x = 0
    @shoot_vec_y = 0
  end
end
