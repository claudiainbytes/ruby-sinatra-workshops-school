require "sinatra"

def workshop_content(name)
  File.read("workshops/#{name}.txt")
rescue Errno::ENOENT
  return nil
end

def save_workshop(name, description)
  File.open("workshops/#{name}.txt", "w") do |file|
    file.print(description)
  end
end

def delete_workshop(name)
  File.delete("workshops/#{name}.txt")
end

get '/' do
  @files = Dir.entries("workshops")
  @files = @files.reject { |v| v == ".DS_Store" }
  erb :home, layout: :main
end

get '/create' do
  erb :create, layout: :main
end

get '/:name' do
  @name = params[ :name ]
  @description = workshop_content(@name)
  erb :workshop, layout: :main
end

get '/:name/edit' do
  @name = params[:name]
  @description = workshop_content(@name)
  erb :edit, layout: :main
end

post '/create' do
  @name = params["name"]
  @description = params["description"]
  save_workshop(params["name"], params["description"])
  @message = "created"
  erb :message, layout: :main
end

delete '/:name' do
  @name = params[:name]
  delete_workshop(@name)
  @message = "deleted"
  erb :message, layout: :main
end

put '/:name' do
  save_workshop(params[:name], params["description"])
  redirect URI.escape("/#{params[:name]}")
end
