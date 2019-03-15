--天威の鬼神
function c101009045.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,c101009045.lcheck)
	c:EnableReviveLimit()
end
function c101009045.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
