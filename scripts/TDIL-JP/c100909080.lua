--検問
--Examination
--Script by nekrozar
function c100909080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c100909080.condition)
	e1:SetTarget(c100909080.target)
	e1:SetOperation(c100909080.activate)
	c:RegisterEffect(e1)
end
function c100909080.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c100909080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c100909080.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
		if tg:GetCount()>0 and Duel.NegateAttack() then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local hg=tg:Select(tp,1,1,nil)
			Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
		end
		Duel.ShuffleHand(1-tp)
	end
end
