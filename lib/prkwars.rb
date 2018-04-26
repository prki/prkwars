PRKWARS_ROOT = File.dirname(File.expand_path(__FILE__))

require_relative './prkwars/modules'
Dir[File.join(PRKWARS_ROOT, '/prkwars/*.rb')].each { |f| require f }
Gosu::Image.autoload_dirs << File.join(File.expand_path('../../', __FILE__))

Game.new.show()