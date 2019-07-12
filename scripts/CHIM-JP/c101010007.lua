--ダイナレスラー・バーリオニクス

--Scripted by nekrozar
function c101010007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101010007.sprcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c101010007.immcon)
	e2:SetValue(c101010007.efilter)
	c:RegisterEffect(e2)
end
function c101010007.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c101010007.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x11a) and c:IsLinkAbove(3)
end
function c101010007.immcon(e)
	return Duel.IsExistingMatchingCard(c101010007.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101010007.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER) and re:IsActivated()
end
