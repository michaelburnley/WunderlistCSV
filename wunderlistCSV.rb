# userfile = ARGV.join

ENV['SSL_CERT_FILE'] = 'cacert.pem'
# ENV["OAUTH_SECRET"]

require 'open-uri'
require 'openssl'
require 'json'
require 'csv'
require 'pp'
require 'oauth2'
load 'wunderfunctions.rb'
load 'secrets.rb'

client_url = 'https://a.wunderlist.com/api/vi'
client_redirect_url = 'http://michaelburnley.com/wunderlistCSV'

client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, :token_url => '/oauth/access_token', :site =>'https://wunderlist.com')
authorize_url = client.auth_code.authorize_url(:redirect_uri => client_redirect_url, :response_type => 'code', :state => 'erwjlkajdfhjhakjhfda')
TOKEN_REQUEST = client.auth_code.get_token(code, :redirect_uri => client_redirect_url)
TOKEN_STRING = TOKEN_REQUEST.token

##### lists #####

lists = getLists()
# response = TOKEN_REQUEST.get('https://a.wunderlist.com/api/v1/lists', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" })
# lists = JSON.parse(response.body)
# lists.each {|x| puts x['title']}


# Find list by first column



puts "which task list do you want"
listname = gets.chomp
selectedlist = lists.select {|x| x['title'] == listname}
listid = selectedlist[0]['id']
getTasks(listid)

addTask(listid, title, duedate)

# body = JSON.generate({ 'list_id' => listid, 'title' => "Hello, Wunderlist!", 'due_date' => "2016-01-08"})
# puts body
# response = TOKEN_REQUEST.post('https://a.wunderlist.com/api/v1/tasks', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}", "Content-Type" => "application/json" }, :params => {'list_id' => listid}, :body => "#{body}")

#tasks = JSON.parse(response.body)

# response = TOKEN_REQUEST.get('https://a.wunderlist.com/api/v1/tasks', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" }, :params => {'list_id' => listid})
# tasks = JSON.parse(response.body)
# tasks.each do |i|
# 	puts i['title']
# end

# lists.each {|key, value| puts "#{key} => #{value}"}

##### end lists #####

#def getTasks(listid)
#	response = TOKEN_REQUEST.get('https://a.wunderlist.com/api/v1/tasks', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{client_id}" }, :params => {'list_id' => listid})
#	tasks = JSON.parse(response.body)
#	tasks.each do |i|
#		puts i['title']
#	end
#end





# puts lists[230036412]

# => '230036412'

# csvFile = CSV.read(userfile)
# CSV.foreach('customers.csv') do |row|
#   puts row.inspect
# end

puts "Done!"

# https://www.wunderlist.com/oauth/authorize?client_id=ID&redirect_uri=URL&state=RANDOM