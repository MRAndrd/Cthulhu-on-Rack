require 'erb'
require './app/lib/logic'

class Cthulhu
  include Logic

  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
    @asleep = false
    @lives = 10
    @mood = 10
    @stuff_in_belly = 10
    @stuff_in_intestine = 0
    @energy = 10
    @powers = 5
    @blood_lust = 5
    @cleanness = 10
    @intelligence = 1
    $NEEDS = %w[lives mood stuff_in_belly stuff_in_intestine energy powers blood_lust cleanness intelligence]
  end

  def response
    case @request.path
    when '/'
      Rack::Response.new(render('form.html.erb'))

    when '/initialize'
      Rack::Response.new do |response|
        response.set_cookie('lives', @lives)
        response.set_cookie('mood', @mood)
        response.set_cookie('stuff_in_belly', @stuff_in_belly)
        response.set_cookie('stuff_in_intestine', @stuff_in_intestine)
        response.set_cookie('energy', @energy)
        response.set_cookie('blood_lust', @blood_lust)
        response.set_cookie('cleanness', @cleanness)
        response.set_cookie('intelligence', @intelligence)
        response.set_cookie('name', @request.params['name'])
        response.redirect('/start')
      end

    when '/exit'
      Rack::Response.new('Game Over', 404)
      Rack::Response.new(render('complete.html.erb'))

    when '/start'
      Rack::Response.new(render('index.html.erb'))

    when '/change'
      return Logic.change_params(@request, 'mood') if @request.params['mood']
      return Logic.change_params(@request, 'lives') if @request.params['lives']
      return Logic.change_params(@request, 'powers') if @request.params['powers']
      return Logic.change_params(@request, 'stuff_in_belly') if @request.params['stuff_in_belly']
      return Logic.change_params(@request, 'stuff_in_intestine') if @request.params['stuff_in_intestine']
      return Logic.change_params(@request, 'energy') if @request.params['energy']
      return Logic.change_params(@request, 'blood_lust') if @request.params['blood_lust']
      return Logic.change_params(@request, 'cleanness') if @request.params['cleanness']
      return Logic.change_params(@request, 'intelligence') if @request.params['intelligence']
    else
      Rack::Response.new('Not Found', 404)
    end
  end

  def render(template)
    path = File.expand_path("../pages/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end

  def name
    name = @request.cookies['name'].delete(' ')
    name.empty? ? 'Cthulhu' : @request.cookies['name']
  end

  def get(attr)
    @request.cookies[attr.to_s].to_i
  end
end
