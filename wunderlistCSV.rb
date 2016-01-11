# userfile = ARGV.join

ENV['SSL_CERT_FILE'] = 'cacert.pem'

require 'open-uri'
require 'openssl'
require 'json'
require 'csv'
require 'pp'
require 'oauth2'
require 'yaml'
require 'launchy'
load 'wunderfunctions.rb'
# load 'secrets.rb'

###### Basic Config Information #####
config = YAML.load_file('config.yaml')
client_url = 'https://a.wunderlist.com/api/vi'
client_redirect_url = 'http://michaelburnley.com/wunderlistCSV.htm'
CLIENT_ID = config[:CLIENT_ID]
CLIENT_SECRET = config[:CLIENT_SECRET]
state = ('a'..'z').to_a.shuffle[0,12].join # Create Randomized State Variable
###### End Basic Config Information #####

###### Authorization Code Check #####
if config[:CODE].nil?

	puts "Please open the following address in your browser and authorize WunderlistCSV:"
	Launchy.open("https://www.wunderlist.com/oauth/authorize?client_id=#{CLIENT_ID}&redirect_uri=#{client_redirect_url}&state=#{state}")
	code = gets.chomp

	##### Add info to YAML #####
	config[:CODE] = "#{code}"
	File.open('config.yaml','a') do |h|
		h.write config.to_yaml
	end
else
	code = config[:CODE]
end
###### End Authorization Code Check #####

###### OAUTH2 Authorization #####
client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, :token_url => '/oauth/access_token', :site =>'https://wunderlist.com')
authorize_url = client.auth_code.authorize_url(:redirect_uri => client_redirect_url, :response_type => 'code', :state => "#{state}")
TOKEN_REQUEST = client.auth_code.get_token(code, :redirect_uri => client_redirect_url)
TOKEN_STRING = TOKEN_REQUEST.token
###### End OAUTH2 Authorization #####

lists = getLists()

puts "which task list do you want"
listname = gets.chomp
selectedlist = lists.select {|x| x['title'] == listname}
listid = selectedlist[0]['id']
getTasks(listid)

puts "Done!"

###### Add info to YAML #####
#config['code'] = "#{code}"
#File.open('config.yml','a') do |h|
#	h.write config.to_yaml
#end


##### Add info to YAML #####
# YAMLFILE = File.open("test.yaml", 'a')
# YAMLFILE.puts("CODE = "#{code}"")
# YAMLFILE.close

##### Does CODE already exist? #####
#
#

# code = '7ba6b4df7309c8cdecd7'

##### lists #####

# response = TOKEN_REQUEST.get('https://a.wunderlist.com/api/v1/lists', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" })
# lists = JSON.parse(response.body)
# lists.each {|x| puts x['title']}


# Find list by first column

# addTask(listid, selectedlist, duedate)

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

# https://www.wunderlist.com/oauth/authorize?client_id=ID&redirect_uri=URL&state=RANDOM