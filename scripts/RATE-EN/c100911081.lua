--Sea Monster of Theseus
--Scripted by Eerie Code
function c100911081.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_TUNER),2,true)
end
