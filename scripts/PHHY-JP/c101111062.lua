--巨强投球
function c101111062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101111062.reg)
	c:RegisterEffect(e1)
  --summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111062,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101111062)
	e2:SetCondition(c101111062.spcon)
	e2:SetTarget(c101111062.sptg)
	e2:SetOperation(c101111062.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101111062,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101111062)
	e3:SetCost(c101111062.cost)
	e3:SetTarget(c101111062.target)
	e3:SetOperation(c101111062.activate)
	c:RegisterEffect(e3)
end
function c101111062.cfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and not c:IsPublic()
			and Duel.IsExistingMatchingCard(c101111062.cfilter2,tp,LOCATION_MZONE,0,1,nil,e,c:GetAttack(),tp)
end
function c101111062.cfilter2(c,e,atk,tp)
	return c:IsRace(RACE_INSECT) and c:IsCanBeEffectTarget(e) and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0 and c:IsAttackBelow(atk)
end
function c101111062.cfilter3(c,e,tp)
	return c:IsFaceup() and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0 and c:IsCanBeEffectTarget(e)
end
function c101111062.cfilter4(c,e,atk,tp)
	return c:IsFaceup() and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0 and c:IsCanBeEffectTarget(e) and c:IsAttackBelow(atk)
end
function c101111062.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c101111062.cfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local emg=Duel.GetMatchingGroup(c101111062.cfilter3,tp,0,LOCATION_MZONE,nil,e,tp)
	if chk==0 then return #mg>0 and #emg>0  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101111062.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.ShuffleHand(tp)
end
function c101111062.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chekc then return true end 
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c101111062.cfilter3,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local atk=e:GetLabel()
	local g2=Duel.SelectTarget(tp,c101111062.cfilter4,tp,LOCATION_MZONE,0,1,1,nil,e,atk,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function c101111062.activate(e,tp,eg,ep,ev,re,r,rp)
	local ex,g=Duel.GetOperationInfo(0,CATEGORY_CONTROL)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=nil
	local tc2=nil
	local key=0
	for c in aux.Next(g) do
		if key==0 then
			tc=c
		else 
			tc2=c
		end
		key=key+1
	end
	if tc and tc2 then
		if Duel.SwapControl(tc,tc2,0,0)~=0 then
		   local e3=Effect.CreateEffect(e:GetHandler())
		   e3:SetType(EFFECT_TYPE_SINGLE)
		   e3:SetCode(EFFECT_CHANGE_RACE)
		   e3:SetValue(RACE_INSECT)
		   e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc2:RegisterEffect(e3) 
		end
	end
end
function c101111062.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(101111062,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101111062.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101111062)~=0
end
function c101111062.filter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101111062.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101111062.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101111062.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101111062.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end