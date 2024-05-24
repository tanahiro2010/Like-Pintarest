require 'sinatra'
require 'json'
require 'yaml'
require 'securerandom'
require 'base64'
require 'net/http'

config_text = ''
File.open('./config.yml', 'r') do |file|
  file.each do |text|
    config_text += text
  end
end
config = YAML.load_file('config.yml')
server_port = config["Server"]["port"]
puts "PORT: #{server_port}"

database_str = ''
File.open('./database.json', 'r') do |file|
  file.each do |text|
    database_str += text
  end
end
database = JSON.parse(database_str)

# functions
def save data
  save_data = JSON.generate data
  File.open(path='./database.json', mode='w') do |file|
    file.write save_data
  end
  true
end

# Web
set :port, server_port

get '/' do
  send_file './Web/index.html'
end

get '/post' do
  send_file './Web/post.html'
end

get '/account' do
  send_file './Web/account.html'
end

get '/import-file' do
  send_file "./Web/#{params[:file]}"
end

get '/import-site' do
  Net::HTTP::get_response(params[:url]).content
end

get '/app' do
  send_file './Web/app.html'
end

# API
post '/api/account' do
  type = params[:type]
  if type == "signin"
    name = params[:name]
    mail = params[:mail]
    pass = params[:pass]
    user_id = params[:id]
    secure_id = SecureRandom.uuid_v4
    if database['used_mails'].include?(mail)
      database['users_data'][secure_id] = {
        "mail" => mail,
        "name" => name,
        "pass" => Base64.encode64(pass),
        "id" => user_id,
        "my_post" => []
      }

      database['Secure-mail'][mail] = secure_id
      database['used_mails'] << mail
      save database
      'True'
    else
      return "Used-email"
    end

  elsif type == "login"
    mail = params[:mail]
    pass = params[:pass]
    if database['used_mails'].include?(mail)
      secure_id = database['Secure-mail'][mail]
      user_data = database['users_data'][secure_id]
      if Base64.encode64(pass) == user_data["pass"]
        delete user_data['pass']
        puts "Test"
        return user_data
      end
    end
    puts "Test"
    'False'
  end
  'False'
end