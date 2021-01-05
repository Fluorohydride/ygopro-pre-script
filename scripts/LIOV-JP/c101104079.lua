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
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101104079)
	e2:SetCondition(c101104079.setcon)
	e2:SetTarget(c101104079.settg)
	e2:SetOperation(c101104079.setop)
	c:RegisterEffect(e2)
end
	--If a monster(s) battles, during damage calculation
function c101104079.atcon(e,tp,eg,ep,ev,re,r,rp)
	local ga=Duel.GetAttacker()
	local gt=Duel.GetAttackTarget()
	return ga and gt and ga:IsRelateToBattle() and gt:IsRelateToBattle() 
end
	--You take no damage from that battles
function c101104079.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
	--Check filter of Normal Trap Card
function c101104079.setfilter(c)
	return c:GetType()==TYPE_TRAP and not c:IsCode(101104079) and c:IsSSetable()
end
	--If this setdown card is destroyed by a card
function c101104079.setcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsFacedown()
end
	--Check target of 2 Normal Trap Card
function c101104079.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101104079.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101104079.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c101104079.setfilter,tp,LOCATION_GRAVE,0,1,2,nil)
end
	--Set up to 2 Normal Traps to your field
function c101104079.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		Duel.SSet(tp,tg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
