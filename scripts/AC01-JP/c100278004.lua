--クリベー
--Script by REIKAI
function c100278004.initial_effect(c)
	aux.AddCodeList(c,40640057)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100278004,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetCost(c100278004.atkcost)
	e1:SetTarget(c100278004.atktg)
	e1:SetOperation(c100278004.atkop)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100278004,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100278004.thcost)
	e3:SetTarget(c100278004.thtg)
	e3:SetOperation(c100278004.thop)
	c:RegisterEffect(e3)
end
c100278004.spchecks=aux.CreateChecks(Card.IsCode,{100278001,100278002,100278003,40640057})
function c100278004.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100278004.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa4)
end
function c100278004.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100278004.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100278004.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100278004.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100278004.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c100278004.rlfilter(c,tp)
	return c:IsCode(100278001,100278002,100278003,40640057) and (c:IsControler(tp) or c:IsFaceup())
end
function c100278004.rlcheck(sg,c,tp)
	local g=sg:Clone()
	g:AddCard(c)
	return Duel.GetMZoneCount(tp,g)>0 and Duel.CheckReleaseGroupEx(tp,aux.IsInGroup,#g,nil,g)
end
function c100278004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp,true):Filter(c100278004.rlfilter,c,tp)
	if chk==0 then return c:IsReleasable() and g:CheckSubGroupEach(c100278004.spchecks,c100278004.rlcheck,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroupEach(tp,c100278004.spchecks,false,c100278004.rlcheck,c,tp)
	aux.UseExtraReleaseCount(rg,tp)
	rg:AddCard(c)
	Duel.Release(rg,REASON_COST)
end
function c100278004.thfilter(c)
	return c:IsCode(16404809) and c:IsAbleToHand()
end
function c100278004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100278004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100278004.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_FIEND)
end
function c100278004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100278004.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(c100278004.sumfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(100278004,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c100278004.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
			if sg:GetCount()>0 then
				local tc=sg:GetFirst()
				Duel.Summon(tp,tc,true,nil)
			end
		end
	end
end
