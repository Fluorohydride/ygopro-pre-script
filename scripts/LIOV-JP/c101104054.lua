--スプリガンズ・ブーティー
--Sprigguns Booty
--Scripted by Kohana Sonogami
function c101104054.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104054,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,101104054)
	e2:SetCondition(c101104054.actcon)
	e2:SetTarget(c101104054.actg)
	e2:SetOperation(c101104054.actop)
	c:RegisterEffect(e2)
	--play fieldspell
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101104054,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c101104054.afcost)
	e3:SetTarget(c101104054.aftg)
	e3:SetOperation(c101104054.afop)
	c:RegisterEffect(e3)
end
function c101104054.actfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
		and c:IsReason(REASON_EFFECT) and c:GetPreviousTypeOnField()&TYPE_XYZ~=0
end
function c101104054.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101104054.actfilter,1,nil,tp)
end
function c101104054.cfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101104054.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101104054.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101104054.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101104054,2))
	Duel.SelectTarget(tp,c101104054.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101104054.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101104054.afcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101104054.affilter(c,tp)
	return c:IsCode(60884672) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c101104054.aftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104054.affilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function c101104054.afop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101104054.affilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
