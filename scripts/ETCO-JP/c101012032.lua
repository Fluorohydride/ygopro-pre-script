--トリアス・ヒエラルキア

--Scripted by mallu11
function c101012032.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,101012032)
	e1:SetCondition(c101012032.spcon)
	e1:SetCost(c101012032.spcost)
	e1:SetTarget(c101012032.sptg)
	e1:SetOperation(c101012032.spop)
	c:RegisterEffect(e1)
end
function c101012032.spfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsControler(tp)
end
function c101012032.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101012032.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_FAIRY) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,3,nil,RACE_FAIRY)
	e:SetLabel(Duel.Release(g,REASON_COST))
end
function c101012032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local ct=e:GetLabel()
	local cat=CATEGORY_SPECIAL_SUMMON
	if ct==3 then
		cat=cat+CATEGORY_DRAW
		e:SetCategory(cat)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101012032.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
		local ct=e:GetLabel()
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		if (ct>=2 and g:GetCount()>0) or ct==3 then
			if ct>=2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101012032,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dg=g:Select(tp,1,1,nil)
				Duel.HintSelection(dg)
				res=Duel.Destroy(dg,REASON_EFFECT)
			end
			if ct==3 and Duel.IsPlayerCanDraw(tp,2) and Duel.SelectYesNo(tp,aux.Stringid(101012032,2)) then
				Duel.BreakEffect()
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	end
end
