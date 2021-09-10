RegisterNetEvent("::{razzway.xyz}::gcPhone:twitter_getTweets")
AddEventHandler("::{razzway.xyz}::gcPhone:twitter_getTweets", function(tweets)
	SendNUIMessage({event = 'twitter_tweets', tweets = tweets})
end)

RegisterNetEvent("::{razzway.xyz}::gcPhone:twitter_getFavoriteTweets")
AddEventHandler("::{razzway.xyz}::gcPhone:twitter_getFavoriteTweets", function(tweets)
	SendNUIMessage({event = 'twitter_favoritetweets', tweets = tweets})
end)

RegisterNetEvent("::{razzway.xyz}::gcPhone:twitter_newTweets")
AddEventHandler("::{razzway.xyz}::gcPhone:twitter_newTweets", function(tweet)
	SendNUIMessage({event = 'twitter_newTweet', tweet = tweet})
end)

RegisterNetEvent("::{razzway.xyz}::gcPhone:twitter_updateTweetLikes")
AddEventHandler("::{razzway.xyz}::gcPhone:twitter_updateTweetLikes", function(tweetId, likes)
	SendNUIMessage({event = 'twitter_updateTweetLikes', tweetId = tweetId, likes = likes})
end)

RegisterNetEvent("::{razzway.xyz}::gcPhone:twitter_setAccount")
AddEventHandler("::{razzway.xyz}::gcPhone:twitter_setAccount", function(username, password, avatarUrl)
	SendNUIMessage({event = 'twitter_setAccount', username = username, password = password, avatarUrl = avatarUrl})
end)

RegisterNetEvent("::{razzway.xyz}::gcPhone:twitter_createAccount")
AddEventHandler("::{razzway.xyz}::gcPhone:twitter_createAccount", function(account)
	SendNUIMessage({event = 'twitter_createAccount', account = account})
end)

RegisterNetEvent("::{razzway.xyz}::gcPhone:twitter_showError")
AddEventHandler("::{razzway.xyz}::gcPhone:twitter_showError", function(title, message)
	SendNUIMessage({event = 'twitter_showError', message = message, title = title})
end)

RegisterNetEvent("::{razzway.xyz}::gcPhone:twitter_showSuccess")
AddEventHandler("::{razzway.xyz}::gcPhone:twitter_showSuccess", function(title, message)
	SendNUIMessage({event = 'twitter_showSuccess', message = message, title = title})
end)

RegisterNetEvent("::{razzway.xyz}::gcPhone:twitter_setTweetLikes")
AddEventHandler("::{razzway.xyz}::gcPhone:twitter_setTweetLikes", function(tweetId, isLikes)
	SendNUIMessage({event = 'twitter_setTweetLikes', tweetId = tweetId, isLikes = isLikes})
end)

RegisterNUICallback('twitter_login', function(data, cb)
	_TriggerServerEvent('::{razzway.xyz}::gcPhone:twitter_login', data.username, data.password)
end)
RegisterNUICallback('twitter_changePassword', function(data, cb)
	_TriggerServerEvent('::{razzway.xyz}::gcPhone:twitter_changePassword', data.username, data.password, data.newPassword)
end)

RegisterNUICallback('twitter_createAccount', function(data, cb)
	_TriggerServerEvent('::{razzway.xyz}::gcPhone:twitter_createAccount', data.username, data.password, data.avatarUrl)
end)

RegisterNUICallback('twitter_getTweets', function(data, cb)
	_TriggerServerEvent('::{razzway.xyz}::gcPhone:twitter_getTweets', data.username, data.password)
end)

RegisterNUICallback('twitter_getFavoriteTweets', function(data, cb)
	_TriggerServerEvent('::{razzway.xyz}::gcPhone:twitter_getFavoriteTweets', data.username, data.password)
end)

RegisterNUICallback('twitter_postTweet', function(data, cb)
	_TriggerServerEvent('::{razzway.xyz}::gcPhone:twitter_postTweets', data.username or '', data.password or '', data.message)
end)

RegisterNUICallback('twitter_toggleLikeTweet', function(data, cb)
	_TriggerServerEvent('::{razzway.xyz}::gcPhone:twitter_toogleLikeTweet', data.username or '', data.password or '', data.tweetId)
end)

RegisterNUICallback('twitter_setAvatarUrl', function(data, cb)
	_TriggerServerEvent('::{razzway.xyz}::gcPhone:twitter_setAvatarUrl', data.username or '', data.password or '', data.avatarUrl)
end)