--報復の隠し歯

--Scripted by mallu11
function c100260013.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,100260013+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100260013.target)
	e1:SetOperation(c100260013.activate)
	c:RegisterEffect(e1)
end
function c100260013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,2,e:GetHandler()) end
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,2,0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c100260013.desfilter(c,def)
	return c:IsFaceup() and c:GetAttack()<=def
end
function c100260013.cfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c100260013.desfilter,tp,0,LOCATION_MZONE,1,nil,c:GetDefense())
end
function c100260013.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,0,2,2,nil)
	if g:GetCount()==2 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		local sg=Duel.GetOperatedGroup()
		if sg:GetCount()>0 and Duel.NegateAttack() and sg:IsExists(c100260013.cfilter,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100260013,0))
			local cg=sg:FilterSelect(tp,c100260013.cfilter,1,1,nil)
			Duel.HintSelection(cg)
			local dg=Duel.GetMatchingGroup(c100260013.desfilter,tp,0,LOCATION_MZONE,nil,cg:GetFirst():GetDefense())
			if Duel.Destroy(dg,REASON_EFFECT)~=0 then
				Duel.BreakEffect()
				local turnp=Duel.GetTurnPlayer()
				Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
				Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetTargetRange(1,0)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,turnp)
			end
		end
	end
end
