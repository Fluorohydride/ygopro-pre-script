--天威の拳僧
function c101009043.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c101009043.matfilter,1,1)
	c:EnableReviveLimit()
end
function c101009043.matfilter(c)
	return c:IsLinkSetCard(0x22d) and not c:IsLinkType(TYPE_LINK)
end
