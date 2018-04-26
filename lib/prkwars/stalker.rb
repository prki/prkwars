require_relative './enemy'
require 'chingu'

##
# Class representing the Stalker enemy unit which is mobile but unable to
# shoot and endlessly moves towards the player unit.
#
class Stalker < Enemy
  trait :velocity
  include GamespacePersistence
  VELOCITY = 2
  HP = 1

  ##
  # Initialization of the Stalker unit requires the gamespace for collision
  # checks, sets the sprite and HP of the unit to an instance variable.

  def initialize(gamespace, options = {})
    super(options)

    @image = Image['./media/stalker.png']

    @gamespace = gamespace
    @hp = HP
  end

  ##
  # Every time a Stalker unit gets updated, they move in a constant speed
  # towards the player. Their sprite also gets rotated.

  def update
    dist_x = @gamespace.player.x - @x
    dist_y = @gamespace.player.y - @y

    rot_to = Math.atan2(dist_y, dist_x) / Math::PI * 180 + 90

    dist = Math.sqrt(dist_x * dist_x + dist_y * dist_y)

    ticks = dist / VELOCITY

    @velocity_x = dist_x / ticks
    @velocity_y = dist_y / ticks
    @angle = rot_to
  end

  ##
  # A common method to enemies, reducing their HP by one.
  def take_damage
    @hp -= 1
  end
end
