--ドラゴンロイド

--Scripted by mallu11
function c100278011.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100278011)
	e1:SetCost(c100278011.cost)
	e1:SetTarget(c100278011.target)
	e1:SetOperation(c100278011.operation)
	c:RegisterEffect(e1)
	--race change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100278011.rctg)
	e2:SetOperation(c100278011.rcop)
	c:RegisterEffect(e2)
end
function c100278011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100278011.thfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WIND) and c:IsSetCard(0x16) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100278011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100278011.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,100278011)==0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100278011,0),aux.Stringid(100278011,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100278011,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100278011,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function c100278011.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100278011.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if op==1 and Duel.GetFlagEffect(tp,100278011)==0 then
		local c=e:GetHandler()
		--inactivatable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_INACTIVATE)
		e1:SetValue(c100278011.efilter)
		Duel.RegisterEffect(e1,tp)
		--act limit
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetCondition(c100278011.limcon)
		e2:SetOperation(c100278011.limop)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_END)
		e3:SetOperation(c100278011.limop2)
		Duel.RegisterEffect(e3,tp)
		Duel.RegisterFlagEffect(tp,100278011,RESET_PHASE+PHASE_END,0,1)
	end
end
function c100278011.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsHasCategory(CATEGORY_FUSION_SUMMON)
end
function c100278011.limfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c100278011.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100278011.limfilter,1,nil,tp)
end
function c100278011.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c100278011.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		Duel.RegisterFlagEffect(tp,100278111,0,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c100278011.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c100278011.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,100278111)
	e:Reset()
end
function c100278011.limop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,100278111)~=0 then
		Duel.SetChainLimitTillChainEnd(c100278011.chainlm)
	end
end
function c100278011.chainlm(e,rp,tp)
	return tp==rp
end
function c100278011.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsRace(RACE_DRAGON) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c100278011.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_DRAGON)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
