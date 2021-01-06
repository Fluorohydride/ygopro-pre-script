--ブービーゲーム
--Booby game
--Scripted コハナ(Kohana)
function c101104079.initial_effect(c)
	--If a monster(s) battles, you take no damage from that battle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104079,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c101104079.atcon)
	e1:SetOperation(c101104079.atop)
	c:RegisterEffect(e1)
	--If face-down card is destroyed: you can set up to 2 Trap cards
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104079,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101104079)
	e2:SetCondition(c101104079.setcon)
	e2:SetTarget(c101104079.settg)
	e2:SetOperation(c101104079.setop)
	c:RegisterEffect(e2)
end
function c101104079.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
function c101104079.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c101104079.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_DESTROY+REASON_EFFECT)==REASON_DESTROY+REASON_EFFECT and rp==1-tp and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c101104079.setfilter(c)
	return c:GetType()==TYPE_TRAP and not c:IsCode(101104079) and c:IsSSetable()
end
function c101104079.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101104079.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101104079.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c101104079.setfilter,tp,LOCATION_GRAVE,0,1,2,nil)
end
function c101104079.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SSet(tp,tg)
	for tc in aux.Next(tg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
