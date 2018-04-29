require "crsfml"

class Util
  def appr(val, target, amount)
    if val > target
      max(val - amount, target)
    else
      min(val + amount, target)
    end
  end

  # TODO: add the mechanic where you don't die
  # if you're going away from the spike.
  def self.spikes_at(x : Int32, y : Int32, w : Int32, h : Int32)
    (Math.max(0, x/8)..Math.min(15, (x + w - 1)/8)).any? { |i|
      (Math.max(0, y/8)..Math.min(15, (y + h - 1)/8)).any? { |j|
        [17, 27, 43, 59].includes? Globals.map.tile(i, j) }}
  end

  def self.tile_flag_at(x, y, w, h, flag)
    (Math.max(0, x/8)..Math.min(15, (x + w - 1)/8)).any? { |i|
      (Math.max(0, y/8)..Math.min(15, (y + h - 1)/8)).any? { |j|
        Globals.map.flag(i, j, flag)}}
  end

  def self.solid_at(x, y, w, h)
    tile_flag_at(x, y, w, h, 0)
  end

  def ice_at(x, y, w, h)
    tile_flag_at(x, y, w, h, 4)
  end

end