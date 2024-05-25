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
  puts 'Access index'
  send_file './Web/app.html', :type => 'text/html', :disposition => 'inline', :cache_control => 'no-cache'
end

get '/post' do
  send_file './Web/post.html', :type => 'text/html', :disposition => 'inline', :cache_control => 'no-cache'
end

get '/account' do
  send_file './Web/account.html', :type => 'text/html', :disposition => 'inline', :cache_control => 'no-cache'
end

get '/app' do
  send_file './Web/app.html', :type => 'text/html', :disposition => 'inline', :cache_control => 'no-cache'
end

get '/import-file' do
  file = params[:file]
  type = params[:type]
  puts file
  send_file "./Web/#{file}", :type => ( type == "js" ? 'application/javascript' : "text/#{type}"), :disposition => 'inline', :cache_control => 'no-cache'
end

get '/import-site' do
  Net::HTTP::get_response(params[:url]).content
end

# API
post '/api/account' do
  type = params[:type]
  if type == "signin"
    name = params[:name]
    mail = params[:mail]
    pass = params[:pass]
    user_id = params[:id]
    icon = params[:icon]

    puts "Try sign in\nname: #{name}\nid: #{user_id}\nmail: #{mail}\npass: #{pass}"

    secure_id = SecureRandom.uuid_v4

    File.open(path="./imgs/icons/#{secure_id}.png", mode="wb") do |file|
      file.write icon.read
    end

    if not database['used_mails'].include?(mail)
      database['users_data'][secure_id] = {
        "mail" => mail,
        "name" => name,
        "pass" => Base64.encode64(pass).chomp!,
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
    puts "Try login\nMail: #{mail}\npass: #{pass}"
    if database['used_mails'].include?(mail)
      puts "Include mail"
      secure_id = database['Secure-mail'][mail]
      puts "secure_id: #{secure_id}"
      user_data = database['users_data'][secure_id]
      password = database['users_data'][secure_id]['pass']
      puts "password: #{password}"
      if Base64.encode64(pass).chomp! == password
        user_data.delete('pass')
        puts user_data
        return JSON.generate(user_data)
      end
    end
    puts "Test"
    'False'
  end
  'False'
end

get '/api/get-images' do
  "Test"
end