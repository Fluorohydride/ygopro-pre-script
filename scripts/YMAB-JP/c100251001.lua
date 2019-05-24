--真エクゾディア
--
--Scripted by 龙骑
function c100251001.initial_effect(c)
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100251001.condition)
	e1:SetOperation(c100251001.operation)
	c:RegisterEffect(e1)
end
function c100251001.winfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x40) and c:IsType(TYPE_NORMAL)
end
function c100251001.cfilter(c)
	return not c100251001.winfilter(c)
end
function c100251001.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100251001.winfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	local ct=g:GetClassCount(Card.GetCode)
	return ct==4 and not Duel.IsExistingMatchingCard(c100251001.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c100251001.operation(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_EXODIA = 0x10
	Duel.Win(1-tp,WIN_REASON_EXODIA)
end
