require 'chingu'

# Class holding the warp effect used whenever an enemy game object
# spawns somewhere.
class Warp < Chingu::GameObject
  trait :effect # fade

  ##
  # Sets the image of a warp as well as its fade rate.
  def initialize(options = {})
    super(options)

    @fade_rate = -8
    @image = Image['media/warp.png']
  end

  ##
  # Destroys a +Warp+ if it faded out.
  def update
    destroy! if color.alpha.zero?
  end
end
