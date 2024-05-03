class Shop
  def menu args

  args.state.upgrades = [
      Upgrade.new(label_text: "Ball Speed", cost: 5, proc: -> { args.state.ball_speed += 1 }),
      Upgrade.new(label_text: "Brick Health Mult", cost: 5, proc: -> { args.state.brick_health_multiplier *= 10 }),
      Upgrade.new(label_text: "Ball Damage", cost: 5, proc: -> { args.state.ball_damage*= 2 })
    ]

    args.state.buttons ||= []

    if args.state.buttons.empty?
      args.state.upgrades.each_with_index do |upgrade, index|
        args.state.buttons << Button.new(x: (100 + 250 * index), y: 100, w: 200, h: 200, label_text: upgrade.label_text, proc: upgrade)
      end
    end


    args.state.buttons.each do |button|
      args.outputs.labels << button.label
      args.outputs.sprites << button
    end

    if args.inputs.mouse.click
      args.state.buttons.each do |upgrade|
        next unless args.inputs.mouse.inside_rect? upgrade
        upgrade.call args
        break
      end
    end

    args.outputs.labels << { x: 25, y: 45, text: "To Game" }

    if (args.inputs.mouse.click && (args.inputs.mouse.inside_rect? args.state.state_button))
      args.state.current_scene = :game
    end

    args.outputs.sprites << args.state.state_button
    args.outputs.labels << [640, 700, "Ball Speed: #{args.state.ball_speed}", 5, 1, 255, 255, 255]
    args.outputs.labels << [640, 650, "Brick Health Mult: #{args.state.brick_health_multiplier}", 5, 1, 255, 255, 255]
    args.outputs.labels << [640, 600, "Ball Damage: #{args.state.ball_damage}", 5, 1, 255, 255, 255]
    args.outputs.labels << [50, 700, "$#{args.state.wallet}", 5, 1, 0, 255, 150]
  end
end

class Upgrade
  attr_accessor :label_text, :cost, :proc

  def initialize(label_text:, cost:, proc:)
    @label_text = label_text
    @cost = cost
    @proc = proc
  end

  def call args
    return if cost > args.state.wallet

    args.state.wallet -= cost
    proc.call
  end
end

class Button
  attr_accessor :x, :y, :w, :h, :path, :angle, :a, :r, :g, :b, :tile_x,
  :tile_y, :tile_w, :tile_h, :flip_horizontally,
  :flip_vertically, :angle_anchor_x, :angle_anchor_y, :id,
  :angle_x, :angle_y, :z,
  :source_x, :source_y, :source_w, :source_h, :blendmode_enum,
  :source_x2, :source_y2, :source_x3, :source_y3, :x2, :y2, :x3, :y3,
  :anchor_x, :anchor_y

  def initialize(x:, y:, w:, h:, label_text:, proc:)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    @proc = proc
    @label_text = label_text
  end

  def call(...)
    @proc.call(...)
  end

  def label
    { x: (x), y: (y + h/2), h: h, w: w, text: @label_text, r: 0, g: 0, b: 0}
  end

  def path
    'sprites/ours/button.png'
  end

  def primitive_marker
    :sprite
  end
end
