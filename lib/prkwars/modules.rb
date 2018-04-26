require 'chingu'

##
# Module containing Z order of various game objects.
module ZOrder
  GAMEOBJECT = 2
end

##
# Module containing constants used throughout the game.
module Constants
  PLAYER_VELOCITY = 6
  BULLET_VELOCITY = 12
end

##
# Module used by classes as a mixin for collision checking with the gamespace
# so that they do not get out of bounds.
#
module GamespacePersistence
  ##
  # A method determining whether a gamespace +fully+ contains a certain
  # game object.

  def in_bounds(entity, gamespace)
    return true if gamespace.bounding_box.contain?(entity.bounding_box)
    false
  end

  ##
  # A method determining game object coordinations in case they are out of
  # bounds.

  def correct_coords(entity, gamespace)
    if entity.bounding_box.top < gamespace.bounding_box.top # ceiling
      entity.y += gamespace.bounding_box.top - entity.bounding_box.top
    elsif entity.bounding_box.bottom > gamespace.bounding_box.bottom # floor
      entity.y -= entity.bounding_box.bottom - gamespace.bounding_box.bottom
    end
    if entity.bounding_box.left < gamespace.bounding_box.left # left side
      entity.x += gamespace.bounding_box.left - entity.bounding_box.left
    elsif entity.bounding_box.right > gamespace.bounding_box.right # right side
      entity.x -= entity.bounding_box.right - gamespace.bounding_box.right
    end
  end
end
