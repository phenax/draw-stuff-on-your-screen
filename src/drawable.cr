require "sdl"

module Dsoys
  class Drawable
    def update(point : SDL::Point)
    end

    def draw(renderer : SDL::Renderer)
      renderer.draw_color = SDL::Color[255, 0, 0]
    end
  end

  class FreeDraw < Drawable
    property points = [] of SDL::Point

    def update(point : SDL::Point)
      points.push(point)
    end

    def draw(renderer)
      super renderer

      renderer.draw_thick_line(points, 3)
    end
  end
end
