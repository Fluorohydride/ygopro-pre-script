--Battle Royal Mode－Joining
--
--Script by Trishula9 & mercury233
function c100287036.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c100287036.target)
	e1:SetOperation(c100287036.tgop)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TARGET)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2)
	e2:SetValue(c100287036.indct)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c100287036.rccon)
	e3:SetOperation(c100287036.rcop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100287036,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c100287036.spcon)
	e4:SetOperation(c100287036.spop)
	c:RegisterEffect(e4)
end
function c100287036.filter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c100287036.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100287036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100287036.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100287036.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c100287036.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c100287036.indct(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c100287036.rccon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_BATTLE)
end
function c100287036.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	Duel.Recover(tc:GetReasonPlayer(),2000,REASON_EFFECT)
end
function c100287036.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=Duel.GetTurnPlayer()
end
function c100287036.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100287036.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(ep,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c100287036.spfilter,ep,LOCATION_HAND+LOCATION_DECK,0,nil,e,ep)
	if g:GetCount()>0 and Duel.SelectYesNo(ep,aux.Stringid(100287036,1)) then
		Duel.Hint(HINT_SELECTMSG,ep,HINTMSG_SPSUMMON)
		local sc=g:Select(ep,1,1,nil)
		if Duel.SpecialSummon(sc,0,ep,ep,false,false,POS_FACEUP)>0 then
			Duel.SetLP(ep,Duel.GetLP(ep)-2000)
		end
	end
end
