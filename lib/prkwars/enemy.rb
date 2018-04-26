require 'chingu'

##
# A generic Enemy class inheriting from Chingu::Gameobject. Any enemy
# unit inherits from this class. The class contains a method
# which returns all the descendants - useful for checking all possible
# collisions.
#
class Enemy < Chingu::GameObject
  ##
  # Each enemy has hitpoints, how many has to be specified by the enemy class!
  attr_accessor :hp
  trait :bounding_box
  trait :collision_detection
  trait :timer

  ##
  # Method returning all the descendants of the Enemy class. Used for
  # collision checks in the main game loop.
  def self.descendants
    ObjectSpace.each_object(::Class).select { |klass| klass < self }
  end
end
