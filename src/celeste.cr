require "./celeste/*"
require "crsfml"

class Globals
  class_property :texture
  class_property :objects
  class_property :clouds
  class_property :particles
  @@texture = SF::Texture.from_file("assets/sprites.png")
  @@objects = Array(GameObject).new
  @@clouds = Array(Cloud).new
  @@particles = Array(Particle).new
end

class Cloud
  include SF::Drawable
  property x, y, spd, w

  def initialize(@x : Int32, @y : Int32, @spd : Int32, @w : Int32)
  end

  def update
    self.x += self.spd
    if self.x > 128
      self.x = -self.w
      self.y = Random.rand(128 - 8)
    end
  end

  def draw(target, states)
    rect = SF::RectangleShape.new({self.w, 4 + (1 - self.w/64)*12})
    rect.position = {self.x, self.y}
    rect.fill_color = SF::Color::Blue
    target.draw rect, states
  end
end

class Particle
  include SF::Drawable
  property x, y, s, spd, off

  def initialize(@x : Float64, @y : Float64, @s : Float64, @spd : Float64, @off : Float64)
  end

  def update
    self.x += self.spd
    self.y += Math.sin(self.off)
    self.off += Math.min(0.05, self.spd/32.0)

    if self.x > 128 + 4
      self.x = -4.0
      self.y = Random.rand(128.0)
    end
  end

  def draw(target, states)
    rect = SF::RectangleShape.new({self.s, self.s})
    rect.position = {self.x, self.y}
    rect.fill_color = SF::Color::Blue
    target.draw rect, states
  end
end

class GameObject
  def initialize(@pos : SF::Vector2i)
    @collidable = true
    @solids = true
    @flipX = false
    @flipY = false
    @hitbox = SF.int_rect(0, 0, 8, 8)
    @spd = SF.vector2i(0, 0)
    @rem = SF.vector2f(0, 0)
  end

  def solid?(pos : SF::Vector2i)
    if pos.y > 0 && !self.check(Platform, SF.vector2(pos.x, 0)) && self.check(Platform, pos)
      return true
    end
    return solid_at(self.pos.x + self.hitbox.x + pos.x, self.pos.y + self.hitbox.y + pos.y, self.hitbox.w, self.hitbox.h) || self.check(FallFloor, pos) || self.check(FakeWall, pos)
  end

  def collide(cls : Class, pos)
    Globals.objects.each do |other|
      if other != nil && other.class == cls && other != self &&
         other.collidable && other.pos.x + other.hitbox.x + other.hitbox.w > self.pos.x + self.hitbox.x + pos.x
        # TODO: add the other AABB conditions.
        return other
      end
    end
    return nil
  end

  def check(cls : Class, pos)
    self.collide(cls, pos) != nil
  end

  def move(pos)
    # [x] get move amount
    self.rem.x += ox
    amount = self.rem.x.round
    self.rem.x -= amount
    self.move_x(amount, 0)

    # [y] get move amount
    self.rem.y += oy
    amount = obj.rem.y.round
    self.rem.y -= amount
    self.move_y(amount)
  end

  def move_x(amount, start)
    if self.solids
      step = amount.sign
      (start..amount.abs).each do |i|
        if !self.is_solid(step, 0)
          self.pos.x += step
        else
          self.spd.x = 0
          self.rem.x = 0
          break
        end
      end
    else
      self.x += amount
    end
  end

  def move_y(amount)
    if self.solids
      step = amount.sign
      (0..amount.abs).each do |i|
        if !self.is_solid(0, step)
          self.pos.y += step
        else
          self.spd.y = 0
          self.rem.y = 0
          break
        end
      end
    else
      self.y += amount
    end
  end
end

class Platform < GameObject
end

class Player < GameObject
  include SF::Drawable

  def initialize
    super(SF.vector2(64, 64))
    @sprid = SF.int_rect(8, 0, 8, 8)
  end

  def update
    @pos.x -= 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Left)
    @pos.x += 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Right)
    @pos.y -= 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Up)
    @pos.y += 1 if SF::Keyboard.key_pressed?(SF::Keyboard::Down)
  end

  def draw(target, states)
    sprite = SF::Sprite.new Globals.texture, @sprid
    sprite.position = @pos
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

    # effects
    16.times do
      Globals.clouds << Cloud.new(Random.rand(128),
        Random.rand(128), 1 + Random.rand(4), 32 + Random.rand(32))
    end

    24.times do
      Globals.particles << Particle.new(Random.rand(128.0), Random.rand(128.0),
        Random.rand(5)/4.0, Random.rand(5.0), Random.rand(1.0))
    end
  end

  def update
    Globals.clouds.each do |cloud|
      cloud.update
    end

    Globals.particles.each do |particle|
      particle.update
    end

    @player.update
  end

  def draw(target, states)
    states.transform.scale(@scale, @scale)

    Globals.clouds.each do |cloud|
      target.draw cloud, states
    end

    Globals.particles.each do |particle|
      target.draw particle, states
    end

    target.draw @player, states
  end
end

class FallFloor < GameObject
end

class FakeWall < GameObject
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
