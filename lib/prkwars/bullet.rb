require_relative './modules.rb'
require 'chingu'

##
# Class representing a bullet shot by the player. Destroys itself
# if is present out of bounds.
#
class Bullet < Chingu::GameObject
  trait :velocity
  trait :bounding_box
  trait :collision_detection
  include GamespacePersistence

  ##
  # Initializes the gamespace where the bullet is present in. Velocity is
  # passed as a paremeter in the options hash

  def initialize(gamespace, options = {})
    super(options)
    @image = Image['media/bullet.png']
    @gamespace = gamespace

    cache_bounding_box
  end

  ##
  # Updating position is not necessary thanks to the velocity trait.
  # In case the bullet is out of bounds, it gets destroyed and explosion
  # particles are spawned.

  def update
    return if in_bounds(self, @gamespace)

    2.times do
      ExplosionParticle.create(@gamespace,
                               x: @x, y: @y,
                               zorder: ZOrder::GAMEOBJECT)
      destroy!
    end
  end
end
