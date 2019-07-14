--オールド・マインド

--Scripted by nekrozar
function c101010066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101010066+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101010066.target)
	e1:SetOperation(c101010066.activate)
	c:RegisterEffect(e1)
end
function c101010066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
end
function c101010066.filter(c,type)
	return c:IsType(type) and c:IsDiscardable(REASON_EFFECT)
end
function c101010066.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)==0 then return end
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(tp,1)
	local tc=g:GetFirst()
	Duel.ConfirmCards(tp,tc)
	local type=bit.band(tc:GetType(),0x7)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101010066.filter,tp,LOCATION_HAND,0,nil,type)
	local op=0
	if g:GetCount()>0 and tc:IsDiscardable(REASON_EFFECT) and c:IsRelateToEffect(e) and c:GetLeaveFieldDest()==0 and Duel.IsPlayerCanDraw(tp,1) then
		op=Duel.SelectOption(tp,aux.Stringid(101010066,0),aux.Stringid(101010066,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(101010066,1))+1
	end
	if op==0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=g:Select(tp,1,1,nil)
		sg:AddCard(tc)
		if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)~=0 and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			c:CancelToGrave()
			if Duel.SendtoHand(c,1-tp,REASON_EFFECT)~=0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	else
		Duel.BreakEffect()
		Duel.SetLP(tp,Duel.GetLP(tp)-1000)
		Duel.ShuffleHand(1-tp)
	end
end
