--精霊の祝福
--Fairy's Blessing
--Script by nekrozar
function c100910064.initial_effect(c)
	aux.AddRitualProcEqual2(c,c100910064.ritual_filter)
end
function c100910064.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_LIGHT) 
end
