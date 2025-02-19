require "./sdl"

module Dsoys
  class Controls
    COLORS = [
      Color[26, 188, 156],
      Color[231, 76, 60],
      Color[52, 152, 219],
      Color[155, 89, 182],
      Color[127, 140, 141],
      Color[241, 196, 15],
    ]

    property buttons = [] of Button
    property draw_color = COLORS[0]
    property cursor_position = Point.new(0, 0)

    def initialize
      x = 40
      y = 100
      @visible = true
      COLORS.each_with_index do |color, index|
        buttons.push(color_btn(Point.new(x, y + 40*index), color))
      end
    end

    def toggle_visible
      @visible = !@visible
    end

    def draw(renderer : SDL::Renderer)
      return unless @visible

      buttons.each do |btn|
        btn.draw(renderer, btn.is_active(cursor_position.x, cursor_position.y))
      end

      renderer.draw_color = draw_color
      renderer.fill_rect(26, 26, 28, 28)
    end

    def activate(x : Int, y : Int)
      buttons.each do |btn|
        btn.activate if btn.is_active(x, y)
      end
    end

    private def color_btn(pos : Point, color : Color)
      btn = Button.new(pos) { @draw_color = color }
      btn.bg = color
      btn.size = 14
      btn
    end
  end

  class Button
    property bg : Color = Color[20, 20, 20]
    property size : Int32 = 14

    def initialize(@position : Point, &@on_click)
    end

    def is_active(x : Int, y : Int)
      @position.distance(Point[x, y]) <= @size
    end

    def draw(renderer : SDL::Renderer, is_active : Bool = false)
      if is_active
        renderer.draw_color = Color[255]
        renderer.fill_circle(@position, @size + 2)
      end
      renderer.draw_color = bg
      renderer.fill_circle(@position, @size)
    end

    def activate
      @on_click.call
    end
  end
end
