require "crsfml"

class Cloud
  include SF::Drawable

  @x : Float64
  @y : Float64
  @spd : Float64
  @w : Float64

  def initialize
    @x = Random.rand(128.0)
    @y = Random.rand(128.0)
    @spd = 1.0 + Random.rand(4.0)
    @w = 32.0 + Random.rand(32.0)
  end

  def update
    @x += @spd
    if @x > 128
      @x = -@w
      @y = Random.rand(128.0 - 8.0)
    end
  end

  def draw(target, states)
    rect = SF::RectangleShape.new({@w, 4 + (1 - @w/64.0)*12})
    rect.position = {@x, @y}
    rect.fill_color = Globals.colors[1]
    target.draw rect, states
  end
end
