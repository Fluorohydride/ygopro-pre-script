--メタルフォーゼ・カーディナル
--Metalphosis Cardinal
--Script by mercury233
function c100909045.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe2),aux.FilterBoolFunction(Card.IsAttackBelow,3000),2,2,true)
end
