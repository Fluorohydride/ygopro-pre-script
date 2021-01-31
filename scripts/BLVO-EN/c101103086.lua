--Breath of Acclamation

--Scripted by mallu11
function c101103086.initial_effect(c)
	aux.AddRitualProcEqual2(c,c101103086.ritual_filter)
end
function c101103086.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_WIND)
end
