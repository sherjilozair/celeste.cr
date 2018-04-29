require "crsfml"

class Player < Entity
  include SF::Drawable

  def initialize
    super(SF.vector2(64, 64))
    @sprid = SF.int_rect(8, 0, 8, 8)
    @hitbox = SF.int_rect(1, 3, 6, 5)
  end

  def update
    # move({-1, 0}) if SF::Keyboard.key_pressed?(SF::Keyboard::Left)
    # move({1, 0}) if SF::Keyboard.key_pressed?(SF::Keyboard::Right)
    # move({0, -1}) if SF::Keyboard.key_pressed?(SF::Keyboard::Up)
    # move({0, 1}) if SF::Keyboard.key_pressed?(SF::Keyboard::Down)

    if SF::Keyboard.key_pressed?(SF::Keyboard::Right)
      input = 1
    elsif SF::Keyboard.key_pressed?(SF::Keyboard::Left)
      input = -1
    else
      input = 0
    end

    # spikes collide
    die if Util.spikes_at(
             @pos.x + @hitbox.left,
             @pos.y + @hitbox.top,
             @hitbox.width,
             @hitbox.height)

    on_ground = solid?(SF.vector2(0, 1))

    # gravity
    maxfall = 2.0_f32
    gravity = 0.21_f32

    if !on_ground
      @spd.y = Util.appr(@spd.y, maxfall, gravity)
    end

    maxrun = 1.0_f32
    accel = 0.6_f32

    @spd.x = Util.appr(@spd.x, input * maxrun, accel)

    move({@spd.x, @spd.y})
  end

  def die
    puts "dead"
  end

  def draw(target, states)
    sprite = SF::Sprite.new Globals.texture, @sprid
    sprite.position = @pos
    target.draw sprite, states
  end
end
