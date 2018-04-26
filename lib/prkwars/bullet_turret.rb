require_relative './modules'
require 'chingu'

##
# A bullet shot by the Turret enemy unit. Destroys itself if out of bounds.
class BulletTurret < Chingu::GameObject
  trait :velocity
  trait :bounding_box
  trait :collision_detection
  include GamespacePersistence

  ##
  # Initializes gamespace in which the bullet is present and assigns
  # the turret. Velocity of the bullet is passed as an options parameter,
  # used by the chingu library.
  def initialize(gamespace, options = {})
    super(options)
    @image = Image['media/bullet_turret.png']
    @gamespace = gamespace
  end

  ##
  # As velocity is set by chingu, the only thing update does is that it checks
  # whether there's any reason for the bullets to exist - if not, they get
  # destroyed.
  def update
    destroy! unless in_bounds(self, @gamespace)
  end
end
