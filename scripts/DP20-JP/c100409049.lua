--魔界劇団のカーテンコール
--Abyss Actors Curtain Call
--Scripted by Eerie Code
function c100409049.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100409049+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100409049.condition)
	e1:SetTarget(c100409049.target)
	e1:SetOperation(c100409049.activate)
	c:RegisterEffect(e1)
	--activity check
	Duel.AddCustomActivityCounter(100409049,ACTIVITY_CHAIN,c100409049.chainfilter)
end
function c100409049.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsSetCard(0x20ec))
end
function c100409049.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(100409049,tp,ACTIVITY_CHAIN)>0
end
function c100409049.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c100409049.spfilter(c,e,tp)
	return c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100409049.ctfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x20ec)
end
function c100409049.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100409049.ctfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100409049.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100409049.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c100409049.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	local ct=Duel.GetMatchingGroupCount(c100409049.ctfilter,tp,LOCATION_GRAVE,0,nil)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,c100409049.thfilter,tp,LOCATION_EXTRA,0,1,ct,nil)
	if hg:GetCount()>0 and Duel.SendtoHand(hg,nil,REASON_EFFECT)~=0 then
		local sct=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,tp)
		local sg=Duel.GetMatchingGroup(c100409049.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),sg:GetCount())
		if sct>0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(100409049,0)) then
			Duel.BreakEffect()
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			local g=Group.CreateGroup()
			repeat
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=sg:Select(tp,1,1,nil):GetFirst()
				g:AddCard(tc)
				sg:Remove(Card.IsCode,nil,tc:GetCode())
			until sct==g:GetCount() or ft==g:GetCount() or not Duel.SelectYesNo(tp,210)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100409049.splimit(e,c)
	return not (c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM))
end
