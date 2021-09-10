-- \(^o^)/ 

cfg_ratelimit = {}

--cfg_ratelimit
cfg_ratelimit.RateLimit = 100 -- Per 10s
cfg_ratelimit.ResetRateLimit = 5000 -- 10000 = 10s it's in milliseconds

--LOGS
cfg_ratelimit.WebhookLink = "https://discord.com/api/webhooks/821810602963370064/F6YKy2wbaGnoiCHCrY47Nu8i6iq4p75y4HMZIEjGI2sP8qMkTrPknUyN85WPCAi0zCSp"

--KICK
cfg_ratelimit.KickMessage = "Vous n'êtes pas autorisé d'exécuter autant de requête en peu de temps."

--BAN
cfg_ratelimit.BanSystem = false
cfg_ratelimit.BanMessage = "Pourquoi tu cheat ? C'est pas bien tu sais :o"

--BLACKLIST
cfg_ratelimit.BlacklistEvent = {}