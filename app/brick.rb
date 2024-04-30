class Brick
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x,
    :tile_y, :tile_w, :tile_h, :flip_horizontally,
    :flip_vertically, :angle_anchor_x, :angle_anchor_y, :id,
    :angle_x, :angle_y, :z,
    :source_x, :source_y, :source_w, :source_h, :blendmode_enum,
    :source_x2, :source_y2, :source_x3, :source_y3, :x2, :y2, :x3, :y3,
    :anchor_x, :anchor_y, :base_health, :health, :health_multiplier

  def initialize(x:, y:, w:, h:, base_health:, health_multiplier:)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.base_health = base_health
    self.health_multiplier = health_multiplier
    self.health = base_health * health_multiplier
    set_path
  end

  def set_path
    @path = case health / health_multiplier
    when ...1 then 'sprites/square/red.png'
    when ...2 then 'sprites/square/orange.png'
    when ...3 then 'sprites/square/yellow.png'
    when ...4 then 'sprites/square/green.png'
    when ...5 then 'sprites/square/blue.png'
    when ...6 then 'sprites/square/indigo.png'
    when ...7 then 'sprites/square/violet.png'
    end
  end

  def take_damage(damage)
    p damage_dealt = damage.clamp(0, health)
    self.health -= damage_dealt
    set_path
    damage_dealt
  end

  def primitive_marker
    :sprite
  end
end

