require "crsfml"

class Particle
  include SF::Drawable

  @x : Float64
  @y : Float64
  @s : Int32
  @spd : Float64
  @off : Float64
  @c : Int32

  def initialize
    @x = Random.rand(128.0)
    @y = Random.rand(128.0)
    @s = 1 + (Random.rand(5.0)/4.0).floor.to_i
    @spd = 0.25 + Random.rand(5.0)
    @off = Random.rand(1.0)
    @c = 5 + Random.rand(3)
  end

  def update
    @x += @spd
    @y += Math.sin(@off)
    @off += Math.min(0.05, @spd/32.0)

    if @x > 128 + 4
      @x = -4.0
      @y = Random.rand * 128.0
    end
  end

  def draw(target, states)
    rect = SF::RectangleShape.new({@s, @s})
    rect.position = {@x, @y}
    rect.fill_color = Globals.colors[@c]
    target.draw rect, states
  end
end
