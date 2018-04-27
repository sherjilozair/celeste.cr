require "crsfml"

class Entity
  def initialize(@pos : SF::Vector2i)
    @collidable = true
    @solids = true
    @flipX = false
    @flipY = false
    @hitbox = SF.int_rect(0, 0, 8, 8)
    @spd = SF.vector2i(0, 0)
    @rem = SF.vector2f(0, 0)
  end

  def solid?(pos : SF::Vector2i)
    if pos.y > 0 && !self.check(Platform, SF.vector2(pos.x, 0)) && self.check(Platform, pos)
      return true
    end
    return solid_at(self.pos.x + self.hitbox.x + pos.x, self.pos.y + self.hitbox.y + pos.y, self.hitbox.w, self.hitbox.h) || self.check(FallFloor, pos) || self.check(FakeWall, pos)
  end

  def collide(cls : Class, pos)
    Globals.objects.each do |other|
      if other != nil && other.class == cls && other != self &&
         other.collidable && other.pos.x + other.hitbox.x + other.hitbox.w > self.pos.x + self.hitbox.x + pos.x
        # TODO: add the other AABB conditions.
        return other
      end
    end
    return nil
  end

  def solid_at(x, y, w, h)
    tile_flag_at(x, y, w, h, 0)
  end

  def ice_at(x, y, w, h)
    tile_flag_at(x, y, w, h, 4)
  end

  def tile_flag_at(x, y, w, h, flag)
    (Math.max(0, x/8)..Math.min(15, (x + w - 1)/8)).any? { |i|
      Math.max(0, y/8)..Math.min(15, (y + h - 1)/8).any? { |j|
        Globals.map.flag(i, j) && flag
      }
    }
  end

  # TODO: add the mechanic where you don't die
  # if you're going away from the spike.
  def spikes_at(x : Int32, y : Int32, w : Int32, h : Int32)
    (Math.max(0, x/8)..Math.min(15, (x + w - 1)/8)).any? { |i|
      (Math.max(0, y/8)..Math.min(15, (y + h - 1)/8)).any? { |j|
        t = Globals.map.tile(i, j)
        [17, 27, 43, 59].includes? t
      }
    }
  end

  def check(cls : Class, pos)
    self.collide(cls, pos) != nil
  end

  def move(pos)
    # [x] get move amount
    self.rem.x += ox
    amount = self.rem.x.round
    self.rem.x -= amount
    self.move_x(amount, 0)

    # [y] get move amount
    self.rem.y += oy
    amount = obj.rem.y.round
    self.rem.y -= amount
    self.move_y(amount)
  end

  def move_x(amount, start)
    if self.solids
      step = amount.sign
      (start..amount.abs).each do |i|
        if !self.is_solid(step, 0)
          self.pos.x += step
        else
          self.spd.x = 0
          self.rem.x = 0
          break
        end
      end
    else
      self.x += amount
    end
  end

  def move_y(amount)
    if self.solids
      step = amount.sign
      (0..amount.abs).each do |i|
        if !self.is_solid(0, step)
          self.pos.y += step
        else
          self.spd.y = 0
          self.rem.y = 0
          break
        end
      end
    else
      self.y += amount
    end
  end

  def appr(val, target, amount)
    if val > target
      max(val - amount, target)
    else
      min(val + amount, target)
    end
  end
end
