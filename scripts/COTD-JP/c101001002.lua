--バックアップ・セクレタリー
--Backup Secretary
--Scripted by Eerie Code
function c101001002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101001002,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101001002)
	e1:SetCondition(c101001002.spcon)
	c:RegisterEffect(e1)
end
function c101001002.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERS)
end
function c101001002.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101001002.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
