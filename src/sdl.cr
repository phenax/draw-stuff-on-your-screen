require "sdl"

lib LibSDL
  fun set_window_opacity = SDL_SetWindowOpacity(window : Window*, opacity : Float)
  fun get_window_opacity = SDL_GetWindowOpacity(window : Window*) : Float
  # fun set_capture_mouse = SDL_CaptureMouse(grabbed : Bool)
  # fun set_window_mouse_grab = SDL_SetWindowMouseGrab(window : Window*, grabbed : Bool)
end

@[Link("SDL2_gfx")]
lib LibSDLGfx
  VERSION = {% `pkg-config sdl2_gfx --modversion`.strip %}

  alias Int = LibC::Int
  alias Renderer = LibSDL::Renderer
  alias Color = LibSDL::Color

  fun draw_thick_line = thickLineColor(
    surface : Renderer*,
    x1 : Int, y1 : Int, x2 : Int, y2 : Int,
    thickness : Int, color : Color,
  )

  fun fill_circle = filledCircleColor(
    surface : Renderer*,
    x : Int, y : Int,
    radius : Int, color : Color,
  )

  fun draw_circle = circleColor(
    surface : Renderer*,
    x : Int, y : Int,
    radius : Int, color : Color,
  )
end

module SDL
  class Renderer
    def draw_thick_line(p1 : Point, p2 : Point, thickness : Int)
      LibSDLGfx.draw_thick_line(self, p1.x, p1.y, p2.x, p2.y, thickness, draw_color)
    end

    def draw_thick_line(points : Array(Point), thickness : Int)
      points.each_cons_pair do |p1, p2|
        draw_thick_line(p1, p2, thickness)
      end
    end

    def fill_circle(p : Point, radius : Int)
      LibSDLGfx.fill_circle(self, p.x, p.y, radius, draw_color)
    end

    def draw_circle(p : Point, radius : Int)
      LibSDLGfx.draw_circle(self, p.x, p.y, radius, draw_color)
    end
  end

  struct Point
    def distance(p)
      Math.sqrt((self.x - p.x)**2 + (self.y - p.y)**2)
    end

    def midpoint(p)
      midX = (x + p.x) / 2
      midY = (y + p.y) / 2
      Point[midX.to_i, midY.to_i]
    end
  end
end
