require "./src/dsoys"

SDL.init(SDL::Init::VIDEO)
at_exit { SDL.quit }

window = SDL::Window.new("Basic window", 0, 0)
window.fullscreen = SDL::Window::Fullscreen::FULLSCREEN_DESKTOP
window.bordered = false
window.grab = false
renderer = SDL::Renderer.new(window)
renderer.draw_blend_mode = SDL::BlendMode::ADD
LibSDL.set_window_opacity(window, 0.8)

drawables = [] of Dsoys::Drawable
current_drawable = Dsoys::FreeDraw.new

loop do
  event = SDL::Event.wait

  renderer.draw_color = SDL::Color[0]
  renderer.clear

  case event
  when SDL::Event::Quit
    break
  when SDL::Event::Keyboard
    break if event.sym.q?
  when SDL::Event::MouseButton
    if event.pressed?
      current_drawable = Dsoys::FreeDraw.new
    else
      drawables.push current_drawable unless current_drawable.nil?
      current_drawable = nil
    end
  when SDL::Event::MouseMotion
    if event.pressed? && !current_drawable.nil?
      current_drawable.update(SDL::Point.new(event.x, event.y))
    end
  end

  drawables.each { |d| d.draw(renderer) }
  unless current_drawable.nil?
    current_drawable.draw(renderer)
  end

  window.update
  renderer.present
end
