--魔界台本「火竜の住処」
--Abyss Script - Abode of the Fire Dragon
--Scripted by Eerie Code, modification by mercury233
function c100405025.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100405025.target)
	e1:SetOperation(c100405025.operation)
	c:RegisterEffect(e1)
	--destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100405025,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100405025)
	e2:SetCondition(c100405025.rmcon2)
	e2:SetTarget(c100405025.rmtg2)
	e2:SetOperation(c100405025.rmop2)
	c:RegisterEffect(e2)
end
function c100405025.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x11ed)
end
function c100405025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100405025.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100405025.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100405025.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100405025.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetDescription(aux.Stringid(100405025,0))
		e1:SetCategory(CATEGORY_REMOVE)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetOperation(c100405025.rmop1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c100405025.rmop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()==0 then return end
	local ct=3
	if g:GetCount()<3 then ct=g:GetCount() end
	Duel.Hint(HINT_CARD,0,100405025)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local mg=g:FilterSelect(1-tp,Card.IsAbleToRemove,ct,ct,nil,tp)
	if mg:GetCount()>0 then
		Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
	end
end
function c100405025.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c100405025.filter,tp,LOCATION_EXTRA,0,1,nil)
end
function c100405025.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c100405025.rmop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil,tp)
	if mg:GetCount()>0 then
		Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
	end
end
