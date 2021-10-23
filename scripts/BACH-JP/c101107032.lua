--ピースリア
--
--Script by Trishula9
function c101107032.initial_effect(c)
	c:EnableCounterPermit(0x161)
	c:SetCounterLimit(0x161,4)
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetTarget(c101107032.cttg)
	e2:SetOperation(c101107032.ctop)
	c:RegisterEffect(e2)
end
function c101107032.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and e:GetHandler():IsCanAddCounter(0x161,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x161)
end
function c101107032.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x161,1)
		local ct=c:GetCounter(0x161)
		local dg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)
		if ct==1 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101107032,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101107032,1))
			local g=dg:Select(tp,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.ShuffleDeck(tp)
				Duel.MoveSequence(tc,0)
				Duel.ConfirmDecktop(tp,1)
			end
		end
		if ct==2 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(101107032,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		local mg=Duel.GetMatchingGroup(c101107032.mfilter,tp,LOCATION_DECK,0,nil)
		if ct==3 and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101107032,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=mg:Select(tp,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
		local cg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_DECK,0,nil)
		if ct==4 and cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101107032,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=cg:Select(tp,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function c101107032.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
