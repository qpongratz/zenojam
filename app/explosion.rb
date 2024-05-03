class Explosion
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x,
    :tile_y, :tile_w, :tile_h, :flip_horizontally,
    :flip_vertically, :angle_anchor_x, :angle_anchor_y, :id,
    :angle_x, :angle_y, :z,
    :source_x, :source_y, :source_w, :source_h, :blendmode_enum,
    :source_x2, :source_y2, :source_x3, :source_y3, :x2, :y2, :x3, :y3,
    :anchor_x, :anchor_y, :radius, :alive_time, :animation_speed

  def initialize(radius:, x:, y:, w:, h:)
    self.x = (x - w / 2)
    self.y = (y - h / 2)
    self.w = w
    self.h = h
    self.radius = radius
    self.alive_time = 0
    self.animation_speed = 2
  end

  def path
    "sprites/misc/explosion-#{frame}.png"
  end

  def dead?
    frame > 6
  end

  def frame
    (alive_time / animation_speed).to_i
  end

  def advance
    self.alive_time += 1
  end

  def primitive_marker
    :sprite
  end
end
