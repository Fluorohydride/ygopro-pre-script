--ふわんだりぃずと謎の地図
--Script By JSY1728
function c101106058.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Remove + Normal Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106058,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,101106058)
	e1:SetTarget(c101106058.rmtg)
	e1:SetOperation(c101106058.rmop)
	c:RegisterEffect(e1)
	--Normal Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106058,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFEECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,101106058+100)
	e2:SetCondition(c101106058.sumcon)
	e2:SetTarget(c101106058.sumtg)
	e2:SetOperation(c101106058.sumop)
	c:RegisterEffect(e2)
end
function c101106058.rmcfilter(c,tp,code)
	return c:IsLevel(1) and c:IsSetCard(0x270) and c:IsSummonable(true,nil) not c:IsPublic()
		and Duel.IsExistingMatchingCard(c101106058.rmfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c101106058.rmfilter(c,code)
	return c:IsSetCard(0x270) and not c:IsCode(code) and c:IsAbleToRemove()
end
function c101106058.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106058.rmcfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c101106058.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,c101106058.rmcfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g1)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c101106058.rmfilter,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst():GetCode())
	if g2:GetCount()==0 then return end
	Duel.BreakEffect()
	if Duel.Remove(g2,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,g2)
	Duel.BreakEffect()
	Duel.Summon(tp,g1,true,nil)
end
function c101106058.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c101106058.sumfilter(c)
	return c:IsSetCard(0x270) and c:IsSummonable(true,nil)
end
function c101106058.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106058.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c101106058.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c101106058.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end