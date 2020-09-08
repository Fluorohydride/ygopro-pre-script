--Successor Soul
--Scripted by TOP
function c100271246.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100271246,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100271246,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100271246.cost)
	e1:SetTarget(c100271246.target)
	e1:SetOperation(c100271246.activate)
	c:RegisterEffect(e1)
	--Check
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetOperation(c100271246.check)
    e2:SetLabelObject(e1)
    Duel.RegisterEffect(e2,0)
	Duel.AddCustomActivityCounter(100271246,ACTIVITY_ATTACK,c100271246.counterfilter)
end
function c100271246.counterfilter(c,tp)
    return Duel.GetFlagEffect(tp,100271246)~=0
end
function c100271246.costfilter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)
end
function c100271246.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c100271246.costfilter,1,nil,tp) end
    local g=Duel.SelectReleaseGroup(tp,c100271246.costfilter,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
	--cannot attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetCondition(c100271246.atkcon)
    e2:SetTarget(c100271246.atktg)
    Duel.RegisterEffect(e2,tp)
end
function c100271246.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100271246.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToGrave()
end
function c32302078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(c100271246.filter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c100271246.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,c100271246.filter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c32302078.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.SendtoGrave(tc,REASON_EFFECT) and Duel.GetOperatedGroup():GetFirst():IsLocation(LOCATION_GRAVE) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c100271246.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.BreakEffect()
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
end
function c100271246.atkcon(e)
    return Duel.GetFlagEffect(tp,100271246)~=0
end
function c100271246.atktg(e,c)
    return c:GetFieldID()~=e:GetLabel()
end
function c100271246.checkop(e,tp,eg,ep,ev,re,r,rp)
    local fid=eg:GetFirst():GetFieldID()
	local p=eg:GetFirst():GetControler()
	if Duel.GetFlagEffect(p,100271246)~=0 and Duel.GetFlagEffectLabel(p,100271246)~=fid then
        Duel.SetFlagEffectLabel(p,100271246,0)
	else
		Duel.RegisterFlagEffect(p,100271246,RESET_PHASE+PHASE_END,0,1,fid)
	end
end
