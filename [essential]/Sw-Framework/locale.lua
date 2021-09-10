Locales = {}

function _(str, ...)  -- Translate string

	if Locales['fr'] ~= nil then

		if Locales['fr'][str] ~= nil then
			return string.format(Locales['fr'][str], ...)
		else
			return 'Translation [fr][' .. str .. '] does not exist'
		end

	else
		return 'Locale [fr] does not exist'
	end

end

function _U(str, ...) -- Translate string first char uppercase
	return tostring(_(str, ...):gsub("^%l", string.upper))
end