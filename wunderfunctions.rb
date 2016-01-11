def getTasks(listid)
	response = TOKEN_REQUEST.get('https://a.wunderlist.com/api/v1/tasks', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" }, :params => {'list_id' => listid})
	tasks = JSON.parse(response.body)
	tasks.each do |i|
		puts i['title']
	end
end

def getLists()
	response = TOKEN_REQUEST.get('https://a.wunderlist.com/api/v1/lists', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" })
	lists = JSON.parse(response.body)
	lists.each {|x| puts x['title']}
	return lists
end

def addTask(listid, title, duedate)
	body = JSON.generate({ 'list_id' => listid, 'title' => "#{title}", 'due_date' => "#{duedate}"})
	puts body
	response = TOKEN_REQUEST.post('https://a.wunderlist.com/api/v1/tasks', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}", "Content-Type" => "application/json" }, :params => {'list_id' => listid}, :body => "#{body}")
end

def getCSV()
	wunderlistTasks = CSV.read('wunderlist.csv')
	findList = lists.select {|x| x['title'] == listname}
	# CSV.foreach('wunderlist.csv') do |row|
	# 	puts row.inspect
	#end
end

def uploadCSV(lists, wunderlistTasks)
	findList = lists.select {|x, y| x['title'] == wunderlistTasks[x][y]}
	
	wunderlistTasks.each do |row|
		body = JSON.generate()
		addTask(findlist)
end