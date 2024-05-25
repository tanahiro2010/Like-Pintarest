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

config = YAML.load_file('./config.yml')
server_port = config["Server"]["port"]
max = config["Account"]["Max"]
puts "Max: #{max}"
puts "PORT: #{server_port}"

database_str = ''
File.open('./database.json', 'r') do |file|
  file.each do |text|
    database_str += text
  end
end
database = JSON.parse(database_str)

post_str = ""
File.open(path='./post_data.json', mode="r") do |file|
  file.each do |text|
    post_str += text
  end
end
post_data = JSON.parse post_str

# author
author_obj = {}

# functions
def save path="./database.json", data
  save_data = JSON.generate data
  File.open(path=path, mode='w') do |file|
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

get '/favicon.ico' do
  send_file './imgs/PhotFlick.png'
end

get '/Menu' do
  send_file './Web/Menu.html', :type => 'text/html', :disposition => 'inline', :cache_control => 'no-cache'
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
    icon = params[:icon][:tempfile].read

    puts "Try sign in\nname: #{name}\nid: #{user_id}\nmail: #{mail}\npass: #{pass}"

    secure_id = SecureRandom.uuid_v4

    File.open(path="./imgs/icons/#{mail}.png", mode="wb") do |file|
      file.write icon
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
        Author_id = SecureRandom.uuid_v4
        author_obj[Author_id] = {
          "secure_id" => secure_id,
          "no" => 0
        }
        return Author_id
      end
    end
    puts "Test"
    'False'
  end
  'False'
end

get '/api/get-images' do
  JSON.generate post_data
end

post '/api/session' do
  session_id = params[:session_id]
  puts "Session_id: #{session_id}"
  session_ids = author_obj.keys
  if session_ids.include?(session_id)
    author_id = author_obj[session_id]['secure_id']
    puts "Author id: #{author_id}"
    author_obj[session_id]['no'] += 1
    if author_obj[session_id]['no'] == max
      author_obj.delete(session_id)
    end
    return JSON.generate(database['users_data'][author_id])
  end
  "False"
end

get '/api/get-icon' do
  send_file "./imgs/icons/#{params[:id]}.png"
end

get '/api/get-img' do
  send_file "./imgs/#{params[:id]}.png"
end

post '/api/post-image' do
  session_id = params[:session_id]
  title = params[:title]
  text = params[:text]
  file_byte = params[:file][:tempfile].read

  puts "Try post\nSession_id: #{session_id}\ntitle: #{title}\ntext: #{text}"

  file_id = SecureRandom.uuid_v4
  File.open(path="./imgs/#{file_id}.png", mode="wb") do |file|
    file.write file_byte
  end

  author_keys = author_obj.keys
  puts author_keys
  if author_keys.include?(session_id)
    author_id = author_obj[session_id]['secure_id']
    puts "POST::Author_id: #{author_id}"
    save_data = {
      'title' => title,
      'text' => text,
      'create_day' => Time.now.strftime("%Y-%m-%d %H:%M:%S")
    }
    puts database['users_data']
    database['users_data'][author_id]['my_post'] << file_id
    post_data[file_id] = save_data
    save database
    save path="./post_data.json", post_data
    return JSON.generate file_id
  else
    "False:Login"
  end

end