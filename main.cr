require "./src/dsoys"

app = Dsoys::App.new

loop do
  break if app.loop == :quit
end
