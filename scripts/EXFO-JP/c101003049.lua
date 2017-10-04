--副話術士クララ＆ルーシカ
--Ventriloquists Clara & Lucika
--Script by nekrozar
function c101003049.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSummonType,SUMMON_TYPE_NORMAL),1,1)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetCost(c101003049.spcost)
	c:RegisterEffect(e1)
end
function c101003049.spcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)~=SUMMON_TYPE_LINK then return true end
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
