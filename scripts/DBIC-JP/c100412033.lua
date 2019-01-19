--呪眼領閾－パレイドリア－
--
--Scripted by Maru
function c100412033.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100412033+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100412033.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100412033.rfcon)
	e2:SetTarget(c100412033.rftg)
	e2:SetOperation(c100412033.rfop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c100412033.thcon)
	e3:SetTarget(c100412033.thtg)
	e3:SetOperation(c100412033.thop)
	c:RegisterEffect(e3)
end
function c100412033.filter(c)
	return c:IsSetCard(0x226) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100412033.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100412033.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100412033,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c100412033.filter1(c)
	return c:IsCode(100412032) and c:IsFaceup()
end
function c100412033.rfcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100412033.filter1,tp,LOCATION_SZONE,0,1,nil)
end
function c100412033.rftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return d~=nil and d:IsControler(tp) and d:IsSetCard(0x226) end
end
function c100412033.rfop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetOperation(c100412033.damop)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e1,tp)
	end
end
function c100412033.damop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		Duel.ChangeBattleDamage(1-ep,ev,false)
	end
end
function c100412033.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_FZONE)
end
function c100412033.thfilter(c)
	return c:IsSetCard(0x226) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100412033.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100412033.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100412033.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100412033.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100412033.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
