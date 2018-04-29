require "crsfml"

class Player < Entity
  include SF::Drawable

  def initialize
    super(SF.vector2(64, 64))
    @sprid = SF.int_rect(8, 0, 8, 8)
    @hitbox = SF.int_rect(1, 3, 6, 5)
  end

  def update
    move({-1, 0}) if SF::Keyboard.key_pressed?(SF::Keyboard::Left)
    move({1, 0}) if SF::Keyboard.key_pressed?(SF::Keyboard::Right)
    move({0, -1}) if SF::Keyboard.key_pressed?(SF::Keyboard::Up)
    move({0, 1}) if SF::Keyboard.key_pressed?(SF::Keyboard::Down)

    # spikes collide
    die if Util.spikes_at(
      @pos.x + @hitbox.left,
      @pos.y + @hitbox.top,
      @hitbox.width,
      @hitbox.height)
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
