--メタルフォーゼ・カーディナル
--Metalphosis Cardinal
--Script by mercury233
function c100909045.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe2),c100909045.matfilter,2,2,true)
end
function c100909045.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()<=3000
end
