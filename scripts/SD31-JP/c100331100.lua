--時空のペンデュラムグラフ
--Pendulumgraph of Spacetime
--Scripted by Eerie Code
function c100331100.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c100331100.target)
	c:RegisterEffect(e1)
	--Cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e2:SetValue(c100331100.evalue)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100331100,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c100331100.descost)
	e3:SetTarget(c100331100.destg)
	e3:SetOperation(c100331100.desop)
	c:RegisterEffect(e3)
end
function c100331100.evalue(e,re,rp)
	return re:IsActiveType(TYPE_TRAP) and rp~=e:GetHandlerPlayer()
end
function c100331100.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	if c100331100.descost(e,tp,eg,ep,ev,re,r,rp,0) and c100331100.destg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		c100331100.descost(e,tp,eg,ep,ev,re,r,rp,1)
		c100331100.destg(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetOperation(c100331100.desop)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c100331100.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100331100)==0 end
	Duel.RegisterFlagEffect(tp,100331100,RESET_PHASE+PHASE_END,0,1)
end
function c100331100.desfilter(c)
	local seq=c:GetSequence()
	return c:IsFaceup() and c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)
		and (c:IsLocation(LOCATION_MZONE) or (seq==6 or seq==7))
end
function c100331100.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100331100.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c100331100.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c100331100.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)~=2 then
		local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100331100,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g2:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
