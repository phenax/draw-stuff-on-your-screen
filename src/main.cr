require "./dsoys"

app = Dsoys::App.new
at_exit { app.finalize }

loop do
  break if app.loop == :quit
end
