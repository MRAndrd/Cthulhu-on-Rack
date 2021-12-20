module Logic
  def self.change_params(request, name)
    Rack::Response.new do |response|
      response.set_cookie(name, request.cookies[name.to_s].to_i + 5) if request.cookies[name.to_s].to_i < 100

      need = ($NEEDS - [name]).sample

      response.set_cookie(need, request.cookies[need.to_s].to_i - 5)

      response.redirect('/start')
    end
  end
end
