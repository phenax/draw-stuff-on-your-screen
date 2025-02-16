require "sdl"

module Dsoys
  abstract class Drawable
    property color : Color?

    abstract def update(point : SDL::Point)
    abstract def draw(renderer : SDL::Renderer)
  end

  class FreeDraw < Drawable
    property points = [] of SDL::Point

    def update(point : SDL::Point)
      points.push(point)
    end

    def draw(renderer)
      renderer.draw_color = color || Color[255]
      renderer.draw_thick_line(points, 3)
    end
  end
end
