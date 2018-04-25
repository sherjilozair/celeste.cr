require "crsfml"

class Globals
  class_property :texture
  class_property :objects
  class_property :clouds
  class_property :particles
  @@texture = SF::Texture.from_file("assets/sprites.png")
  @@objects = Array(Entity).new
  @@clouds = Array(Cloud).new
  @@particles = Array(Particle).new
end