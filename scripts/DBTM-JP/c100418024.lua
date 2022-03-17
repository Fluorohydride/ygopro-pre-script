--フェアーウェルカム・ラビュリンス
--
--Script by Trishula9
function c100418024.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c100418024.condition)
	e1:SetTarget(c100418024.target)
	e1:SetOperation(c100418024.activate)
	c:RegisterEffect(e1)
end
function Auxiliary.LabrynthDestroyOp(e,tp,res)
	local c=e:GetHandler()
	local chk=not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsSetCard(0x1280) and c:GetType()==TYPE_TRAP and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	local exc=nil
	if c:IsStatus(STATUS_LEAVE_CONFIRMED) then exc=c end
	if chk and Duel.IsPlayerAffectedByEffect(tp,100418021)
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,exc)
		and Duel.SelectYesNo(tp,aux.Stringid(100418021,0)) then
		if res>0 then Duel.BreakEffect() end
		Duel.Hint(HINT_CARD,0,100418021)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exc)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
		local te=Duel.IsPlayerAffectedByEffect(tp,100418021)
		te:UseCountLimit(tp)
	end
end
function c100418024.cfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c100418024.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100418024.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100418024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100418024.stfilter(c)
	return c:GetType()==TYPE_TRAP and not c:IsSetCard(0x280) and c:IsSSetable()
end
function c100418024.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local res=0
	if Duel.NegateAttack() and tc:IsRelateToEffect(e) then
		res=Duel.Destroy(tc,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c100418024.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		if res>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100418024,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg)
		end
	end
	aux.LabrynthDestroyOp(e,tp,res)
end
