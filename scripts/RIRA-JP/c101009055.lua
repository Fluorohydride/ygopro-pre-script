--フォーチュン・ヴィジョン
--
--Script by mercury233
function c101009055.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101009055+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101009055.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101009055,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101009055.indcon)
	e2:SetOperation(c101009055.indop)
	c:RegisterEffect(e2)
	--avoid battle damage
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101009055,2))
	e3:SetCondition(c101009055.damcon)
	e3:SetOperation(c101009055.damop)
	c:RegisterEffect(e3)
end
function c101009055.filter(c)
	return c:IsSetCard(0x31) and c:IsAbleToHand()
end
function c101009055.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101009055.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101009055,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101009055.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c101009055.indcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101009055.cfilter,1,nil,tp)
end
function c101009055.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101009055.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101009055.cfilter,1,nil,1-tp)
end
function c101009055.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetValue(c101009055.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,101009055,RESET_PHASE+PHASE_END,0,1)
end
function c101009055.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,101009055)==0 or bit.band(r,REASON_BATTLE)==0 then return val end
	Duel.ResetFlagEffect(tp,101009055)
	return 0
end
