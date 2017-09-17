--紫宵の機界騎士
--Mekk-Knight of the Purple Dusk
--Scripted by Eerie Code
function c101003020.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101003020)
	e1:SetCondition(c101003020.hspcon)
	e1:SetValue(c101003020.hspval)
	c:RegisterEffect(e1)
	--banish & search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101003020,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101003020+100)
	e2:SetTarget(c101003020.thtg)
	e2:SetOperation(c101003020.thop)
	c:RegisterEffect(e2)
end
function c101003020.cfilter(c,tp,seq)
	local s=c:GetSequence()
	if c:IsLocation(LOCATION_SZONE) and s==5 then return false end
	if c:IsControler(tp) then
		return s==seq or (seq==1 and s==5) or (seq==3 and s==6)
	else
		return s==4-seq or (seq==1 and s==6) or (seq==3 and s==5)
	end
end
function c101003020.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	for i=0,4 do
		if Duel.GetMatchingGroupCount(c101003020.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,i)>=2 then
			zone=zone+math.pow(2,i)
		end
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101003020.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	for i=0,4 do
		if Duel.GetMatchingGroupCount(c101003020.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,i)>=2 then
			zone=zone+math.pow(2,i)
		end
	end
	return 0,zone
end
function c101003020.rmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20c) and c:IsAbleToRemove()
end
function c101003020.thfilter(c)
	return c:IsSetCard(0x20c) and c:IsType(TYPE_MONSTER) and not c:IsCode(101003020) and c:IsAbleToHand()
end
function c101003020.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101003020.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101003020.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101003020.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101003020.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101003020.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0
		and tc:IsLocation(LOCATION_REMOVED) then
		local ct=1
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then ct=2 end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c101003020.retcon)
		e1:SetOperation(c101003020.retop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
		end
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(101003020,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101003020.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c101003020.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	return e:GetLabelObject():GetFlagEffect(101003020)~=0
end
function c101003020.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
