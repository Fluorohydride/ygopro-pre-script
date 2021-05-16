--栗子珠
--Script by REIKAI

function c100278004.initial_effect(c)
   --atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100278004,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE)
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
	e3:SetCost(c100278004.scost)
	e3:SetTarget(c100278004.stg1)
	e3:SetOperation(c100278004.sop1)
	c:RegisterEffect(e3)
end
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
function c100278004.filter1(c,code1,code2,code3,code4)
	return not c:IsCode(code1,code2,code3,code4)
end
function c100278004.rlfilter(g)
	return not g:IsExists(c100278004.filter1,1,nil,40640057,100278002,100278003,100278004) and aux.dncheck(g)
end
function c100278004.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsReleasable,tp,LOCATION_ONFIELD+LOCATION_HAND,0,e:GetHandler())
	if chk==0 then return e:GetHandler():IsReleasable() and g:CheckSubGroup(c100278004.rlfilter,4,4) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=g:SelectSubGroup(tp,c100278004.rlfilter,false,4,4)
	g1:AddCard(e:GetHandler())
	Duel.Release(g1,REASON_COST)
end
function c100278004.sfilter1(c)
	return c:IsCode(16404809) and c:IsAbleToHand()
end
function c100278004.stg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100278004.sfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100278004.sumfilter(c)
	return c:IsSummonable(true,nil) and c:IsRace(RACE_FIEND)
end
function c100278004.sop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100278004.sfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,tp,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			if Duel.IsExistingMatchingCard(c100278004.sumfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(100278004,2)) then
				local sg=Duel.SelectMatchingCard(tp,c100278004.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
				if sg:GetCount()>0 then
					local tc=sg:GetFirst()
					Duel.Summon(tp,c,true,nil)
				end
			end
		end
	end
end