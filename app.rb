require 'json'
require 'sinatra'

require './models'

configure do
  set :default_content_type, :json
end

def resp(message, status = 200)
  [status, JSON.generate({message: message, status: status})]
end

def getBodyJSON(body)
  body.rewind
  JSON.parse request.body.read
end

not_found do
  resp("No such endpoint", 403)
end

## ---- Start of Routes ---- ##

get '/' do
  resp("Hello, World!")
end

post '/funfacts' do
  data = getBodyJSON(request.body)

  f = FunFact.from_json(data)
  f.save()

  resp(f.to_hash)
end

get '/funfacts' do
  resp(
    FunFact.all.map {|x|
      x.to_hash
    }
  )
end

get '/funfacts/random' do
  fact = FunFact.all.shuffle.pop
  resp(
    fact ? fact.to_hash : nil
  )
end

get '/funfacts/category/:category' do |category| 
  facts = FunFact.filter {|funfact|
    funfact.is_category(category)
  }

  resp(
    facts.map {|x|
      x.to_hash
    }
  )
end

get '/funfacts/category/:category/random' do |category|
  facts = FunFact.filter {|funfact|
    funfact.is_category(category)
  }

  fact = facts.shuffle.pop
  resp(
    fact ? fact.to_hash : nil
  )
end




