require "crsfml"

class Globals
  class_property :texture
  class_property :objects
  class_property :clouds
  class_property :particles
  class_property :colors
  class_property :map

  @@map = Map.new
  @@texture = SF::Texture.from_file("assets/sprites.png")
  @@objects = Array(Entity).new
  @@clouds = Array(Cloud).new
  @@particles = Array(Particle).new
  @@colors = {
    SF::Color.new(0, 0, 0),
    SF::Color.new(29, 43, 83),
    SF::Color.new(126, 37, 83),
    SF::Color.new(0, 135, 81),
    SF::Color.new(171, 82, 54),
    SF::Color.new(95, 87, 79),
    SF::Color.new(194, 195, 199),
    SF::Color.new(255, 241, 232),
    SF::Color.new(255, 0, 77),
    SF::Color.new(255, 163, 0),
    SF::Color.new(255, 236, 39),
    SF::Color.new(0, 228, 54),
    SF::Color.new(41, 173, 255),
    SF::Color.new(131, 118, 156),
    SF::Color.new(255, 119, 168),
    SF::Color.new(255, 204, 170),
  }
end
