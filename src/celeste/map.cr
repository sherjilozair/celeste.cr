require "crsfml"

# TODO: load bottom half of room as well.
# Load sprite flags as well. Map should own it.

class Map
  include SF::Drawable
  property :room

  @map : Array(Array(Int32))
  @flags : Array(Array(Int32))

  def initialize(@mappath = "assets/map.raw", @flagspath = "assets/sprite.flags")
    @map = File.read(@mappath).lines.map { |line|
      (0...128).map { |i|
        line[2*i...2*i + 2].to_i(16)
      }
    }

    @flags = File.read(@flagspath).lines.map { |line|
      (0...128).map { |i|
        line[2*i...2*i + 2].to_i(16)
      }
    }
    @room = {0, 0}
  end

  def update
  end

  def flag(i, j, f)
    sprid = @map[@room[1]*16 + j][@room[0]*16 + i]
    flag = @flags[sprid/128][sprid % 128] & 2**f != 0
  end

  def tile(i, j)
    @map[@room[1]*16 + j][@room[0]*16 + i]
  end

  def draw(target, states)
    (0...16).each do |j|
      (0...16).each do |i|
        sprid = @map[@room[1]*16 + j][@room[0]*16 + i]
        sprite = SF::Sprite.new Globals.texture, SF.int_rect(8*(sprid % 16), 8*(sprid/16), 8, 8)
        sprite.position = {i * 8, j * 8}
        target.draw sprite, states
      end
    end
  end
end
