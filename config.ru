require './app/cthulhu'


use Rack::Reloader, 0
use Rack::Static, urls: ["/styles"]

run Cthulhu
