require "./sdl_app_base"
require "./app_state"

module Dsoys
  class App < SDLAppBase
    include AppState

    def loop
      event = SDL::Event.wait
      action = handle_event event

      renderer.draw_color = SDL::Color[0, 0, 0, 0]
      renderer.clear
      draw
      renderer.present

      return action
    end

    private def draw
      drawables.each { |d| draw_drawable(d, d.color) }
      draw_drawable current_drawable

      controls.draw(renderer)
    end

    private def draw_drawable(drawable, color = controls.draw_color)
      return if drawable.nil?

      drawable.color ||= color
      drawable.draw(renderer)
    end
  end
end
