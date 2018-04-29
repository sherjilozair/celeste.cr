require "crsfml"

class Player < Entity
  include SF::Drawable

  def initialize
    super(SF.vector2(64, 64))
    @sprid = SF.int_rect(8, 0, 8, 8)
    @hitbox = SF.int_rect(1, 3, 6, 5)
  end

  def update
    @pos.x -= 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Left)
    @pos.x += 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Right)
    @pos.y -= 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Up)
    @pos.y += 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Down)

    # spikes collide
    die if Util.spikes_at(
             @pos.x + @hitbox.left,
             @pos.y + @hitbox.top,
             @hitbox.width,
             @hitbox.height
           )
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
