--天空の聖水
--
--scripted by XyLeN
function c100312053.initial_effect(c)
	aux.AddCodeList(c,56433456)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,100312053)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100312053.target)
	e1:SetOperation(c100312053.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100312053+100)
	e2:SetTarget(c100312053.reptg)
	e2:SetValue(c100312053.repval)
	e2:SetOperation(c100312053.repop)
	c:RegisterEffect(e2)
end
function c100312053.actfilter(c,tp)
	return c:IsCode(56433456) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c100312053.thfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,56433456) and c:IsAbleToHand()
end
function c100312053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100312053.actfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c100312053.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
end
function c100312053.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x44,0x26b)
end
function c100312053.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c100312053.actfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c100312053.thfilter,tp,LOCATION_DECK,0,1,nil)
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(100312053,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100312053,1)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	local resolve=false
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c100312053.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			local te=tc:GetActivateEffect()
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			resolve=true
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100312053.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			resolve=true
		end
	end
	local check=Duel.IsEnvironment(56433456) or Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,56433456)
	local ct=Duel.GetMatchingGroupCount(c100312053.recfilter,tp,LOCATION_MZONE,0,nil)
	if resolve and check and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(100312053,2)) then
		Duel.BreakEffect()
		Duel.Recover(tp,ct*500,REASON_EFFECT)
	end
end
function c100312053.repfilter(c,tp)
	return c:IsFaceup() and aux.IsCodeListed(c,56433456)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c100312053.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100312053.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c100312053.repval(e,c)
	return c100312053.repfilter(c,e:GetHandlerPlayer())
end
function c100312053.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
