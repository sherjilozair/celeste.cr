require "crsfml"

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
