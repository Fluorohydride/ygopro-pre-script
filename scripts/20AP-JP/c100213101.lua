--熱き決闘者たち
--Passionate Duelists
--Scripted by Eerie Code
function c100213101.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100213101,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c100213101.atkcon)
	e2:SetTarget(c100213101.atktg)
	e2:SetOperation(c100213101.atkop)
	c:RegisterEffect(e2)
	--prevent set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c100213101.setcon1)
	e3:SetTarget(c100213101.settg)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetTargetRange(0,1)
	e4:SetCondition(c100213101.setcon2)
	c:RegisterEffect(e4)
	--prevent attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c100213101.spcon)
	e5:SetOperation(c100213101.spop)
	c:RegisterEffect(e5)
	--add tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(100213101,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PREDRAW)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(c100213101.thcon)
	e6:SetTarget(c100213101.thtg)
	e6:SetOperation(c100213101.thop)
	c:RegisterEffect(e6)
	--Check for single Set
	if not c100213101.global_check then
		c100213101.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c100213101.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c100213101.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		Duel.RegisterFlagEffect(rp,100213101,RESET_PHASE+PHASE_END,0,1)
	end
end
function c100213101.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100213101.atkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100213101.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c100213101.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100213101.atkfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100213101.atkfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100213101.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.NegateAttack() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c100213101.setcon1(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),100213101)>0
end
function c100213101.setcon2(e)
	return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),100213101)>0
end
function c100213101.settg(e,c)
	return c:IsLocation(LOCATION_HAND)
end
function c100213101.spfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c100213101.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c100213101.spfilter,1,nil)
end
function c100213101.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c100213101.spfilter,1,nil)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
end
function c100213101.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c100213101.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100213101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100213101.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c100213101.thop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100213101.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
