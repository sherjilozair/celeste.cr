require "crsfml"

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