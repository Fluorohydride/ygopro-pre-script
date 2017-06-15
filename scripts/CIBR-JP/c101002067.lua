--サイバース・ビーコン
--Cyberse Beacon
--Scripted by Larry126
function c101002067.initial_effect(c)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,101002067)
	e1:SetCondition(c101002067.condition)
	e1:SetTarget(c101002067.target)
	e1:SetOperation(c101002067.activation)
	c:RegisterEffect(e1)
	if not c101002067.global_check then
		c101002067.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c101002067.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101002067.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetOwnerPlayer()) or bit.band(r,REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(ep,101002067,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101002067.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101002067)~=0
end
function c101002067.filter(c)
	return c:IsAbleToHand() and c:IsRace(RACE_CYBERS) and c:IsLevelBelow(4)
end
function c101002067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101002067.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101002067.activation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101002067.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
