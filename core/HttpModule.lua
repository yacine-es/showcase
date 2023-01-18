local HttpModule = {
	HttpService = game:GetService("HttpService"),
	Limit = 250,
	Current = 0,
}

function HttpModule.RequestGet(URL,Cache,Header)
	local TimeOut = 0
	if not Cache then
		Cache = false
	end
	if HttpModule.Limit > HttpModule.Current then
		HttpModule.Current = HttpModule.Current + 1
		return HttpModule.Get(URL,Cache,Header)
	else
		repeat
			wait(10)
			TimeOut = TimeOut + 1
		until TimeOut >= 6 or HttpModule.Limit > HttpModule.Current
		if TimeOut < 6 and HttpModule.Limit > HttpModule.Current then
			HttpModule.Current = HttpModule.Current + 1
			return HttpModule.Get(URL,Cache,Header)
		else
			return false
		end
	end
end

function HttpModule.RequestPost(URL,Headers,Body)
	local TimeOut = 0
	if HttpModule.Limit > HttpModule.Current then
		HttpModule.Current = HttpModule.Current + 1
		return HttpModule.Request(URL,"POST",Headers,Body)
	else
		repeat
			wait(10)
			TimeOut = TimeOut + 1
		until TimeOut >= 6 or HttpModule.Limit > HttpModule.Current
		if TimeOut < 6 and HttpModule.Limit > HttpModule.Current then
			HttpModule.Current = HttpModule.Current + 1
			return HttpModule.Request(URL,"POST",Headers,Body)
		else
			return false
		end
	end
end

function HttpModule.Get(URL,Cache,Header)
	local Success, Response = pcall(function()
		HttpModule.HttpService:GetAsync(URL,Cache,Header)
	end)
	if Success and Response then
		return Response
	else
		return false
	end
end

function HttpModule.Request(URL,Method,Headers,Body)
	local Success, Response = pcall(function()
		HttpModule.HttpService:GetAsync({
			Url = URL,
			Method = Method,
			Headers = Headers,
			Body = HttpModule.HttpService:JSONEncode(Body)
			
		})
	end)
	if Success and Response then
		return Response
	else
		return false
	end
end

function HttpModule.Load()
	coroutine.resume(coroutine.create(function()
		while wait(60) do
			HttpModule.Current = 0
		end
	end))
end

return HttpModule