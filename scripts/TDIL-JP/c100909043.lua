--メタルフォーゼ・アダマンテ
--Metalphosis Adamante
--Script by nekrozar
function c100909043.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe2),c100909043.matfilter,1,1,true)
end
function c100909043.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()<=3000
end
