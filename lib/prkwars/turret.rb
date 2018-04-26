require_relative './modules'
require_relative './enemy'
require_relative './bullet_turret'
require 'chingu'

##
# Class representing the Turret enemy unit which is stationary and endlessly
# shoots bullets in the direction of the player.
#
class Turret < Enemy
  SHOOT_GAP = 40
  VELOCITY = 3
  HP = 3

  ##
  # Initializing a +Turret+ builds a new +Chingu::Animation+ with the
  # turret sprites. Each time a +Turret+ gets hit, it changes its sprite
  # to better display the amount of HP. Also sets the gamespace instance variable,
  # HP and a shooting timer.

  def initialize(gamespace, options = {})
    super(options)

    @animation = Chingu::Animation.new(file: 'media/turrets.png', size: 32)

    @gamespace = gamespace
    @hp = HP
    @shoot_timer = 0
    @image = @animation[@hp - 1]
  end

  ##
  # Updating a +Turret+ only consists of shooting a bullet if the framecounter
  # got far enough.

  def update
    @shoot_timer += 1
    return unless @shoot_timer == SHOOT_GAP

    shoot_bullet
    @shoot_timer = 0
  end

  ##
  # A common +Enemy+ method - reduces the unit's HP by one and changes the
  # sprite.
  def take_damage
    @hp -= 1
    @image = @animation[@hp - 1]
  end

  private

  ##
  # Shoots a bullet at a proper velocity towards the player's unit.
  def shoot_bullet
    dist_x = @gamespace.player.x - @x
    dist_y = @gamespace.player.y - @y

    bullet_angle = Math.atan2(dist_y, dist_x) / Math::PI * 180 + 90

    dist = Math.sqrt(dist_x * dist_x + dist_y * dist_y)

    ticks = dist / VELOCITY

    BulletTurret.create(@gamespace,
                        zorder: ZOrder::GAMEOBJECT, x: @x,
                        y: @y, velocity_x: dist_x / ticks,
                        velocity_y: dist_y / ticks, angle: bullet_angle)
  end
end
