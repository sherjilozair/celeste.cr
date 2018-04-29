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

    image = SF::Image.from_file("assets/sprites.png")
    image.create_mask_from_color(Globals.colors[0])
    Globals.texture = SF::Texture.from_image(image)

    # effects
    16.times do
      Globals.clouds << Cloud.new
    end

    24.times do
      Globals.particles << Particle.new
    end

    Globals.map = Map.new
  end

  def update
    Globals.clouds.each do |cloud|
      cloud.update
    end

    Globals.particles.each do |particle|
      particle.update
    end

    Globals.map.update
    @player.update
  end

  def draw(target, states)
    states.transform.scale(@scale, @scale)

    Globals.clouds.each do |cloud|
      target.draw cloud, states
    end

    target.draw Globals.map, states

    Globals.particles.each do |particle|
      target.draw particle, states
    end
    target.draw @player, states
  end
end
