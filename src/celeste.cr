require "./celeste/*"
require "crsfml"

game = Game.new

window = SF::RenderWindow.new(
  SF::VideoMode.new(game.size[:x]*game.scale, game.size[:y]*game.scale),
  game.name, settings: SF::ContextSettings.new(depth: 24, antialiasing: 8)
)
window.framerate_limit = 30
window.vertical_sync_enabled = true

while window.open?
  while event = window.poll_event
    window.close if event.is_a?(SF::Event::Closed)
  end

  game.update
  window.clear
  window.draw game
  window.display
end
