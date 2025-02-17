require "sdl"

module Dsoys
  class SDLAppBase
    property window : SDL::Window
    property renderer : SDL::Renderer

    def initialize
      SDL.init(SDL::Init::VIDEO)

      @window = SDL::Window.new("Dsoys", 0, 0,
        SDL::Window::Position::UNDEFINED, SDL::Window::Position::UNDEFINED,
        SDL::Window::Flags::SHOWN | SDL::Window::Flags::ALWAYS_ON_TOP | SDL::Window::Flags::ALLOW_HIGHDPI)
      window.fullscreen = SDL::Window::Fullscreen::FULLSCREEN_DESKTOP
      window.bordered = false
      window.grab = false

      @renderer = SDL::Renderer.new(window, flags: SDL::Renderer::Flags::ACCELERATED | SDL::Renderer::Flags::PRESENTVSYNC)
      renderer.draw_blend_mode = SDL::BlendMode::BLEND
      LibSDL.set_window_opacity(window, 0.5)

      @cursor = LibSDL.create_system_cursor(LibSDL::SystemCursor::HAND)
      LibSDL.set_cursor(@cursor)
    end

    def finalize
      SDL.quit
      LibSDL.free_cursor(@cursor)
    end
  end
end
