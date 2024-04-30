class Shop
  def menu args

  # args.gtk.log upgrades: args.state.upgrades

    args.state.ball_speed ||= 5
    args.state.upgrades ||= []

    if args.state.upgrades.empty?
      args.state.upgrades << Upgrade.new(x: 100, y: 100, w: 200, h: 200, r: 255, g: 0, b: 0, **upgrades_hash(args).ball_speed)
      args.state.upgrades << Upgrade.new(x: 400, y: 100, w: 200, h: 200, r: 255, g: 0, b: 0, **upgrades_hash(args).brick_health)
      args.state.upgrades << Upgrade.new(x: 700, y: 100, w: 200, h: 200, r: 255, g: 0, b: 0, **upgrades_hash(args).ball_damage)
    end


    args.state.upgrades.each do |upgrade|
      args.outputs.labels << upgrade.label
      args.outputs.borders << upgrade
    end

    if args.inputs.mouse.click
      args.state.upgrades.each do |upgrade|
        next unless args.inputs.mouse.inside_rect? upgrade
        upgrade.call
        break
      end
    end

    args.outputs.labels << [640, 700, "Ball Speed: #{args.state.ball_speed}", 5, 1, 0, 0, 0]
    args.outputs.labels << [640, 650, "Brick Health Mult: #{args.state.brick_health_multiplier}", 5, 1, 0, 0, 0]
    args.outputs.labels << [640, 600, "Ball Damage: #{args.state.ball_damage}", 5, 1, 0, 0, 0]
  end

  def upgrades_hash args
    {
      ball_speed: { label_text: "Ball Speed", cost: 10, proc: -> { args.state.ball_speed += 1 }},
      brick_health: { label_text: "Brick Health Mult", cost: 20, proc: -> { args.state.brick_health_multiplier += 1 }},
      ball_damage: { label_text: "Ball Damage", cost: 20, proc: -> { args.state.ball_damage += 1 } }
      # "paddle_width" => { name: "Paddle Width", cost: 30, proc: -> { args.state.upgrade_3_count += 1 } }
    }
  end
end

class Upgrade
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x,
  :tile_y, :tile_w, :tile_h, :flip_horizontally,
  :flip_vertically, :angle_anchor_x, :angle_anchor_y, :id,
  :angle_x, :angle_y, :z,
  :source_x, :source_y, :source_w, :source_h, :blendmode_enum,
  :source_x2, :source_y2, :source_x3, :source_y3, :x2, :y2, :x3, :y3,
  :anchor_x, :anchor_y

  def initialize(x:, y:, w:, h:, r:, g:, b:, label_text:, proc:, cost: 0)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.r = r
    self.g = g
    self.b = b
    @proc = proc
    @label_text = label_text
    @cost = cost
  end

  def call
    @proc.call
  end

  # omg the work we'll have to do to render labels that fit into a box and in the right
  # spot and making sure it's not too long is going to be so annoying,
  # so we might just put that part off, but like a button class that does
  # something like that might be good.

  def label
    { x: (x), y: (y + h/2), h: h, w: w, text: @label_text, r: 0, g: 0, b: 0}
  end

  def primitive_marker
    :border
  end
end
