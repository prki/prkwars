require_relative './modules'
require 'chingu'

##
# Class used for holding behaviour of particles during explosions of various
# entitites.
#
class ExplosionParticle < Chingu::GameObject
  trait :velocity
  trait :effect # fade
  trait :bounding_box
  include GamespacePersistence

  ##
  # Generates an explosion particle with a set fade_rate (chingu). X and Y
  # velocity is picked randomly between (-7..7).

  def initialize(gamespace, options = {})
    super(options)

    @gamespace = gamespace
    @fade_rate = -3
    @mode = :default
    @image = Image['media/myparticle.png']
    @velocity_x = rand(-7..7)
    @velocity_y = rand(-7..7)
    @angle = Math.atan2(@velocity_x, @velocity_y) / Math::PI * 180 + 90
  end

  ##
  # In case a particle collides with the gamespace boundaries, velocity
  # gets corrected (impact angle to the other side). A particle gets
  # destroyed once it completely fades out.

  def update
    velocity_correct! unless bounding_box.collide_rect?(@gamespace.bounding_box)
    destroy! if color.alpha.zero?
  end

  private

  ##
  # Method correcting the velocity if hitting a wall.

  def velocity_correct!
    if hitting_side
      @velocity_x = -@velocity_x
    else
      @velocity_y = -@velocity_y
    end
  end

  ##
  # Method determining whether a particle is hitting a wall - used to correct
  # the velocity values.
  def hitting_side
    if bounding_box.left < @gamespace.bounding_box.left ||
       bounding_box.right > @gamespace.bounding_box.right
      true
    else
      false
    end
  end
end
