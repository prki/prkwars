require 'chingu'
include Gosu

##
# Class used for messages that pop up on the screen whenever something
# relevant happens - e.g. score goes up.
#
class PopupText < Chingu::GameObject
  ##
  # Initialization method for +PopupText+ requires x, y to determine
  # where the message gets spawned on the screen.

  def initialize(message, x, y, options = {})
    super(options)

    @msg = Chingu::Text.create(message, x: x, y: y, size: 30)
  end

  ##
  # Updating the popuptext changes the y coordinate and slowly fades
  # the message out.
  def update
    @msg.y -= 1
    @msg.color.alpha -= 4
    @msg.destroy! if color.alpha.zero?
  end
end
