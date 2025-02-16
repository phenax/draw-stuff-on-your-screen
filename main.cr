require "sdl"

lib LibSDL
  fun set_window_opacity = SDL_SetWindowOpacity(window : Window*, opacity : Float)
end

SDL.init(SDL::Init::VIDEO)
at_exit { SDL.quit }

window = SDL::Window.new("Basic window", 0, 0)
window.fullscreen = true
renderer = SDL::Renderer.new(window)
renderer.draw_blend_mode = LibSDL::BlendMode::BLEND
LibSDL.set_window_opacity(window, 0.5)

loop do
  event = SDL::Event.wait

  case event
  when SDL::Event::Quit
    break
  when SDL::Event::Keyboard
    if event.mod.lctrl? && event.sym.q?
      break
    end
  end

  renderer.clear
  renderer.present

  # window.surface.fill(0, 0, 0, 0)
  window.update
end
