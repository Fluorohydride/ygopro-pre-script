--メタルフォーゼ・アダマンテ
--Metalphosis Adamante
--Script by nekrozar
function c100909043.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe1),aux.FilterBoolFunction(Card.IsAttackBelow,2500),true)
end
