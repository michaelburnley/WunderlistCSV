# userfile = ARGV.join

ENV['SSL_CERT_FILE'] = 'cacert.pem'

###### Required gems and files #####
require 'open-uri'
require 'openssl'
require 'json'
require 'csv'
require 'pp'
require 'oauth2'
require 'yaml'
require 'launchy'
load 'wunderfunctions.rb'
###### End Required gems and files #####

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
wunderlistTasks = getCSV()
uploadCSV(lists, wunderlistTasks)

puts "Done!"