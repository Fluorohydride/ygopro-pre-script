--デュエリスト・アドベント
--Duelist Alliance
--Scripted by Eerie Code
function c100912063.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100912063+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100912063.condition)
	e1:SetTarget(c100912063.target)
	e1:SetOperation(c100912063.activate)
	c:RegisterEffect(e1)
end
function c100912063.cfilter(c)
	return c:GetSequence()==6 or c:GetSequence()==7
end
function c100912063.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100912063.cfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c100912063.filter(c)
	if not c:IsAbleToHand() then return false end
	if c:IsType(TYPE_MONSTER) then
		return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0xf2) or c:IsCode(92746535,75195825,69512157,7127502,16178681,47075569))
	else
		return c:IsSetCard(0xf2) or c:IsCode(65646587,37803970,2359348,76660409,53208660,100214004,68477598,60434189,77826734,74926274,69982329,83461421)
	end
end
function c100912063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100912063.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100912063.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100912063.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
