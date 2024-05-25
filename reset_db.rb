require 'json'
database = {
  "users_data" => {},
  "used_mails" => [],
  "Secure-mail" => {}
}
File.open(path='./database.json', mode='w') do |file|
  file.write(JSON.generate(database))
end

Dir.foreach('./imgs/') do |file|
  if file.chars.length > 5
    File.delete("./imgs/" + file)
  end
end

Dir.foreach('./imgs/icons') do |file|
  if file.chars.length > 2
    File.delete("./imgs/icons/#{file}")
  end
end