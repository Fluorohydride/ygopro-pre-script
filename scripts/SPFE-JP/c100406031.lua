--召喚獣メガラニカ
--Magallanica the Eidolon Beast
--Script by nekrozar
function c100406031.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,100406026,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),1,true,true)
end
