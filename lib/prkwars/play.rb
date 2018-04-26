require 'chingu'

##
# A class representing the game state of playing the game itself.
#
class Play < Chingu::GameState
  trait :timer

  PLAYER_START_X = 800
  PLAYER_START_Y = 640

  include GamespacePersistence

  ##
  # Initialization method of Play maps input to the exit function,
  # creates a +gamespace+ to play in and spawns the +player+.
  # Together with that, sets up variables for enemy generation,
  # score calculation and message displays.

  def initialize(options = {})
    super(options)

    self.input = { esc: :exit }

    @gamespace = GameSpace.create(x: 1280 / 2, y: 720 / 2)
    @player = Player.create(@gamespace,
                            zorder: ZOrder::GAMEOBJECT,
                            x: PLAYER_START_X, y: PLAYER_START_Y)
    @gamespace.player = @player

    setup_enemy_generation
    setup_score_calculation
    setup_display_messages
  end

  ##
  # Update loop does three major things each frame:
  # * Collides enemies with player's bullets and reduces their HP if possible.
  # * Collides enemies with player's ship and removes the player's life if so.
  # * Performs another step in the enemy unit generation.

  def update
    super
    collide_enemies_bullets
    collide_enemies_player

    generate_random_enemy
  end

  private

  ##
  # Sets up instance variables for score calculation.

  def setup_score_calculation
    @score = 0
    @multiplier = 1
    @score_this_life = 0
    @next_multiplier = 2000
  end

  ##
  # Called whenever an enemy dies and the score gets updated.
  # Updates the score as well as the message displayed. Also
  # pops up a +PopupText+ in case that score multiplier goes higher.

  def update_score
    @score += 100 * @multiplier
    @score_this_life += 100 * @multiplier

    @message_score.text = "Score: #{@score}"

    return if @score_this_life != @next_multiplier

    @multiplier += 1
    PopupText.create("#{@multiplier}x Multiplier", @player.x, @player.y - 10)
    @next_multiplier *= 2
  end

  ##
  # A method colliding all the enemies with all the player bullets
  # on the screen. In case an enemy gets hit, +ExplosionParticle+s get
  # spawned and the enemy takes damage. In case the enemy dies, they
  # get destroyed and a +PopupText+ is displayed to show how much
  # score the player got.

  def collide_enemies_bullets
    Enemy.descendants.each do |enemy|
      enemy.each_bounding_box_collision(Bullet) do |nmy, bullet|
        10.times do
          ExplosionParticle.create(@gamespace,
                                   x: bullet.x, y: bullet.y,
                                   zorder: ZOrder::GAMEOBJECT)
        end
        bullet.destroy!
        nmy.take_damage
        next unless nmy.hp.zero?
        Warp.create(zorder: ZOrder::GAMEOBJECT, x: nmy.x, y: nmy.y)
        PopupText.create((100 * @multiplier).to_s, nmy.x, nmy.y)
        nmy.destroy
        update_score
      end
    end
  end

  ##
  # A method coliding all the enemies with the player's unit.
  # In case such a collision happens, player unit dies and
  # the +handle_player_death+ method is called.

  def collide_enemies_player
    Enemy.descendants.each do |enemy|
      @player.each_bounding_box_collision(enemy) do
        handle_player_death
        return true # no need to check collisions of turret bullets
      end
    end

    @player.each_bounding_box_collision(BulletTurret) do
      handle_player_death
    end
  end

  ##
  # A method generating random enemies. Steps up the framecounter
  # for each enemy type by one and calls their corresponding methods.
  def generate_random_enemy
    @framecounter_turret += 1
    generate_random_turret

    @framecounter_stalker += 1
    generate_random_stalker
  end

  ##
  # Generates a +Turret+ in a random position if the framecounter got
  # to the next generation point. If so, the framecounter gets reset
  # to zero.

  def generate_random_turret
    return if @framecounter_turret != @nextgen_turret

    x, y = generate_random_position
    turret = Turret.create(@gamespace, zorder: ZOrder::GAMEOBJECT, x: x, y: y)

    correct_coords(turret, @gamespace)

    create_warp(x, y)

    @framecounter_turret = 0
    @nextgen_turret = rand(80..150)
  end

  ##
  # Generates a +Stalker+ in a random position if the framecounter got
  # to the next generation point. If so, the framecounter gets reset
  # to zero.

  def generate_random_stalker
    return if @framecounter_stalker != @nextgen_stalker

    x, y = generate_random_position
    Stalker.create(@gamespace, zorder: ZOrder::GAMEOBJECT, x: x, y: y)
    create_warp(x, y)

    @framecounter_stalker = 0
    @nextgen_stalker = rand(20..50)
  end

  ##
  # Method spawning a +Warp+ at a point provided by the parameters..

  def create_warp(x, y)
    Warp.create(zorder: ZOrder::GAMEOBJECT, x: x, y: y)
  end

  ##
  # Method generating a random position for an enemy unit to spawn in.

  def generate_random_position
    x, y = @gamespace.enemy_spawn_point(@player.x, @player.y)

    x += rand(-30..30)
    y += rand(-30..30)

    [x, y]
  end

  ##
  # Method switching to the +GameOver+ state.

  def handle_game_over
    switch_game_state(GameOver.new(@score))
  end

  ##
  # Method handling the death of a player.
  # Kills all the units, reduces player's lives by one and goes to
  # +GameOver+ if player's lives were reduced to zero.
  # If not, +ExplosionParticle+s get spawned, all enemy generation
  # is reset and the player starts from a new point.

  def handle_player_death
    kill_everything
    @player.lives -= 1
    handle_game_over if @player.lives.zero?

    500.times do
      ExplosionParticle.create(@gamespace,
                               x: @player.x, y: @player.y,
                               zorder: ZOrder::GAMEOBJECT)
    end

    setup_enemy_generation
    @message_lives.text = "Lives: #{@player.lives}"
    @score_this_life = 0
    @next_multiplier = 2000
    @multiplier = 1
    PopupText.create("#{@multiplier}x Multiplier", @player.x, @player.y - 10)
    @player.x = PLAYER_START_X
    @player.y = PLAYER_START_Y
  end

  ##
  # Method killing all game objects except for the player's unit.

  def kill_everything
    Enemy.descendants.each do |enemy|
      ObjectSpace.each_object(enemy, &:destroy!)
    end

    ObjectSpace.each_object(BulletTurret, &:destroy!)

    ObjectSpace.each_object(Bullet, &:destroy!)
  end

  ##
  # Method setting up framecounters for each generation,
  # generates a random number for the next generation of
  # enemy units.

  def setup_enemy_generation
    @framecounter_turret = 0
    @nextgen_turret = rand(150..300)
    @framecounter_stalker = 0
    @nextgen_stalker = rand(110..180)
  end

  ##
  # Method setting up the messages displayed in the HUD
  # to show the amount of player's lives and the player's score.

  def setup_display_messages
    @message_lives = Chingu::Text.create("Lives: #{@player.lives}",
                                         x: 1020, y: 5, size: 30)

    @message_score = Chingu::Text.create("Score: #{@score}",
                                         x: 100, y: 5, size: 30)
  end
end
