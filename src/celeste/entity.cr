require "crsfml"


class Entity
  property :collidable, :pos, :hitbox
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
    return Util.solid_at(self.pos.x + self.hitbox.left + pos.x, self.pos.y + self.hitbox.top + pos.y, self.hitbox.width, self.hitbox.height) || self.check(FallFloor, pos) || self.check(FakeWall, pos)
  end

  def collide(cls : Class, pos)
    Globals.objects.each do |other|
      if other != nil && other.class == cls && other != self &&
         other.collidable && other.pos.x + other.hitbox.left + other.hitbox.width > self.pos.x + self.hitbox.left + pos.x
        # TODO: add the other AABB conditions.
        return other
      end
    end
    return nil
  end

  def check(cls : Class, pos)
    self.collide(cls, pos) != nil
  end

  def move(pos)
    if pos.is_a? Tuple
      pos = SF.vector2(pos[0], pos[1])
    end
    # [x] get move amount
    @rem.x += pos.x
    amount = @rem.x.round.to_i
    @rem.x -= amount
    self.move_x(amount, 0)

    # [y] get move amount
    @rem.y += pos.y
    amount = @rem.y.round.to_i
    @rem.y -= amount
    self.move_y(amount)
  end

  def move_x(amount, start)
    if @solids
      step = amount.sign
      (start..amount.abs).each do |i|
        if ! self.solid?(SF.vector2(step, 0))
          @pos.x += step
        else
          @spd.x = 0
          @rem.x = 0.0_f32
          break
        end
      end
    else
      @pos.x += amount
    end
  end

  def move_y(amount)
    if @solids
      step = amount.sign
      (0..amount.abs).each do |i|
        if ! self.solid?(SF.vector2(0, step))
          @pos.y += step
        else
          @spd.y = 0
          @rem.y = 0.0_f32
          break
        end
      end
    else
      @pos.y += amount
    end
  end

  
end
