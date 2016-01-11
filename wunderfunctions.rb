def getTasks(listid)
	response = TOKEN_REQUEST.get('https://a.wunderlist.com/api/v1/tasks', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" }, :params => {'list_id' => listid})
	tasks = JSON.parse(response.body)
	tasks.each do |i|
		puts i['title']
		subTasks(i['id'])
	end
end

def subTasks(taskid)
	response = TOKEN_REQUEST.get('https://a.wunderlist.com/api/v1/subtasks', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" }, :params => {'task_id' => taskid})
	subtasks = JSON.parse(response.body)
	subtasks.each do |i|
		puts i['title']
	end
end

def getLists()
	response = TOKEN_REQUEST.get('https://a.wunderlist.com/api/v1/lists', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" })
	lists = JSON.parse(response.body)
	lists.each {|x| puts x['title']}
	return lists
end

def addTask(body, listid)
	# body = JSON.generate({ 'list_id' => listid, 'title' => "#{title}", 'due_date' => "#{duedate}"})
	response = TOKEN_REQUEST.post('https://a.wunderlist.com/api/v1/tasks', :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}", "Content-Type" => "application/json" }, :params => {'list_id' => listid}, :body => "#{body}")
end

def getCSV()
	wunderlistTasks = CSV.read('wunderlist.csv')
	uploadCSV()
	findList = lists.select {|x| x['title'] == listname}
	# CSV.foreach('wunderlist.csv') do |row|
	# 	puts row.inspect
	#end
end

def uploadCSV(lists, wunderlistTasks)
	wunderlistTasks.each do |row|
		findList = lists.select {|x, y| x['title'] == wunderlistTasks[x][y]}
		body = JSON.generate({ 'list_id' => row[0], 'title' => row[1], 'due_date' => row[2]})
		addTask(body, findList)
	end
end