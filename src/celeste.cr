require "./celeste/*"
require "crsfml"

class G
  class_property :texture
  @@texture = SF::Texture.from_file("assets/sprites.png")
end

class Player
  include SF::Drawable

  def initialize
    @position = [64, 64]
    @sprid = SF.int_rect(8, 0, 8, 8)
  end

  def update
    @position[0] -= 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Left)
    @position[0] += 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Right)
    @position[1] -= 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Up)
    @position[1] += 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Down)
  end

  def draw(target, states)
    sprite = SF::Sprite.new G.texture, @sprid
    sprite.position = Tuple(Int32, Int32).from(@position) # TODO: this is ugly
    target.draw sprite, states
  end
end

class Game
  include SF::Drawable

  property :size
  property :name
  property :scale

  def initialize
    @size = {x: 128, y: 128}
    @scale = 12
    @name = "Celeste"
    @player = Player.new
  end

  def update
    @player.update
  end

  def draw(target, states)
    states.transform.scale(@scale, @scale)
    target.draw @player, states
  end
end

game = Game.new

window = SF::RenderWindow.new(
  SF::VideoMode.new(game.size[:x]*game.scale, game.size[:y]*game.scale),
  game.name, settings: SF::ContextSettings.new(depth: 24, antialiasing: 8)
)
window.framerate_limit = 30
window.vertical_sync_enabled = true

while window.open?
  while event = window.poll_event
    window.close if event.is_a?(SF::Event::Closed)
  end

  game.update
  window.clear
  window.draw game
  window.display
end
