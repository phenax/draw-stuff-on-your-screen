require "./sdl"

module Dsoys
  class Controls
    COLORS = {
      teal:   Color[26, 188, 156],
      red:    Color[231, 76, 60],
      blue:   Color[52, 152, 219],
      purple: Color[155, 89, 182],
      gray:   Color[127, 140, 141],
      yellow: Color[241, 196, 15],
    }
    TOOLS = {
      free:   {class: Dsoys::FreeDraw, icon_color: Color[255]},
      rect:   {class: Dsoys::RectDraw, icon_color: Color[255]},
      circle: {class: Dsoys::CircleDraw, icon_color: Color[255]},
      delete: {class: Dsoys::DeleteObjectDraw, icon_color: COLORS[:red]},
    }

    property buttons = [] of Button
    property draw_color = COLORS[:purple]
    property cursor_position = Point[0, 0]
    property current_tool = :free

    def initialize
      x = 40
      @visible = true

      y = 100
      COLORS.values.each_with_index do |color, index|
        buttons.push(color_btn(Point[x, y + 40 * index], color))
      end

      y = 380
      TOOLS.keys.each_with_index do |tool, index|
        buttons.push(tool_btn(Point[x, y + 35 * index], tool))
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

    def select_color(name)
      @draw_color = COLORS[name]
    end

    def select_tool(draw_tool)
      @current_tool = draw_tool
    end

    def activate(x : Int, y : Int)
      buttons.each do |btn|
        btn.activate if btn.is_active(x, y)
      end
    end

    def current_drawable_class
      TOOLS[current_tool][:class]
    end

    private def color_btn(pos : Point, color : Color)
      btn = Button.new(pos) { @draw_color = color }
      btn.bg = color
      btn.size = 14
      btn
    end

    private def tool_btn(pos : Point, draw_tool)
      btn = Button.new(pos) { @current_tool = draw_tool }
      btn.bg = Color[30, 30, 30]
      btn.size = 12
      btn.icon_drawer = ->(renderer : SDL::Renderer, size : Int32, pos : Point) do
        tool = TOOLS[draw_tool]
        renderer.draw_color = tool[:icon_color] || Color[255]
        tool[:class].draw_icon(renderer, size, pos)
      end
      btn
    end
  end

  class Button
    property bg : Color = Color[20, 20, 20]
    property size : Int32 = 14
    property position : Point
    property icon_drawer : Proc(SDL::Renderer, Int32, Point, Nil)? = nil

    def initialize(@position : Point, &@on_click)
    end

    def is_active(x : Int, y : Int)
      @position.distance(Point[x, y]) <= @size
    end

    def draw(renderer : SDL::Renderer, is_active : Bool = false)
      if is_active
        renderer.draw_color = Color[255]
        renderer.fill_circle(position, size + 2)
      end
      renderer.draw_color = bg
      renderer.fill_circle(position, size)

      d = @icon_drawer
      d.call(renderer, size, position) unless d.nil?
    end

    def activate
      @on_click.call
    end
  end
end
