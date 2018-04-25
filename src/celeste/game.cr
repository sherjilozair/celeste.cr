require "crsfml"

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