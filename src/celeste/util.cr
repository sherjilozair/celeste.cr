require "crsfml"

class Util
  def self.appr(val, target, amount)
    if val > target
      Math.max(val - amount, target)
    else
      Math.min(val + amount, target)
    end
  end

  # TODO: add the mechanic where you don't die
  # if you're going away from the spike.
  def self.spikes_at(x : Int32, y : Int32, w : Int32, h : Int32)
    (Math.max(0, x/8)..Math.min(15, (x + w - 1)/8)).any? do |i|
      (Math.max(0, y/8)..Math.min(15, (y + h - 1)/8)).any? do |j|
        [17, 27, 43, 59].includes? Globals.map.tile(i, j)
      end
    end
  end

  def self.tile_flag_at(x, y, w, h, flag)
    (Math.max(0, x/8)..Math.min(15, (x + w - 1)/8)).any? do |i|
      (Math.max(0, y/8)..Math.min(15, (y + h - 1)/8)).any? do |j|
        Globals.map.flag(i, j, flag)
      end
    end
  end

  def self.solid_at(x, y, w, h)
    tile_flag_at(x, y, w, h, 0)
  end

  def ice_at(x, y, w, h)
    tile_flag_at(x, y, w, h, 4)
  end
end
