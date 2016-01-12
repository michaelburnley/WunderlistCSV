def getTasks(listid)
	response = TOKEN_REQUEST.get("https://a.wunderlist.com/api/v1/tasks", :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" }, :params => {'list_id' => listid})
	tasks = JSON.parse(response.body)
	tasks.each do |i|
		puts i['title']
		subTasks(i['id'])
	end
end

def subTasks(taskid)
	response = TOKEN_REQUEST.get("https://a.wunderlist.com/api/v1/subtasks", :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" }, :params => {'task_id' => taskid})
	subtasks = JSON.parse(response.body)
	subtasks.each do |i|
		puts i['title']
	end
end

def getLists()
	response = TOKEN_REQUEST.get("https://a.wunderlist.com/api/v1/lists", :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}" })
	lists = JSON.parse(response.body)
	return lists
end

def addTask(body, listid)
	response = TOKEN_REQUEST.post("https://a.wunderlist.com/api/v1/tasks", :headers => { "X-Access-Token" => "#{TOKEN_STRING}", "X-Client-ID" => "#{CLIENT_ID}", "Content-Type" => "application/json" }, :params => {'list_id' => listid}, :body => "#{body}")
end

def getCSV()
	wunderlistTasks = CSV.read('wunderlist.csv')
	return wunderlistTasks
end

def uploadCSV(lists, wunderlistTasks)
	CSV.foreach("wunderlist.csv") do |row|
		listTitle = row[0]
		selectedlist = lists.select {|x| x['title'] == listTitle}
		list_id = selectedlist[0]['id']
		taskname = row[1]
		due_date = row[2]
		starred = row[3]
		body = JSON.generate({ 'list_id' => list_id, 'title' => taskname, 'due_date' => "#{due_date}"}, 'starred' => starred)
		addTask(body, list_id)
	end
end