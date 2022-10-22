--G・ボール・シュート
--Script by 神数不神 & mercury233
function c101111062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101111062.reg)
	c:RegisterEffect(e1)
	--spsummon
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
	--control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101111062,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101111062)
	e3:SetTarget(c101111062.target)
	e3:SetOperation(c101111062.activate)
	c:RegisterEffect(e3)
end
function c101111062.reg(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101111062,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c101111062.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101111062)~=0
end
function c101111062.spfilter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101111062.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101111062.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101111062.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101111062.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101111062.costfilter(c,e,tp)
	return c:IsRace(RACE_INSECT) and not c:IsPublic()
			and Duel.IsExistingMatchingCard(c101111062.sfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,c:GetAttack())
end
function c101111062.sfilter(c,e,tp,atk)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsCanBeEffectTarget(e) and c:GetAttack()<atk
		and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c101111062.ofilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
		and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c101111062.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c101111062.costfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local emg=Duel.GetMatchingGroup(c101111062.ofilter,tp,0,LOCATION_MZONE,nil,e,1-tp)
	if chk==0 then return e:IsCostChecked() and #mg>0 and #emg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101111062.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	local atk=g:GetFirst():GetAttack()
	e:SetLabel(atk)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c101111062.sfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,atk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,c101111062.ofilter,tp,0,LOCATION_MZONE,1,1,nil,e,1-tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function c101111062.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	local tc=g:Filter(Card.IsControler,nil,tp):GetFirst()
	local tc2=g:Filter(Card.IsControler,nil,1-tp):GetFirst()
	if tc and tc2 then
		if Duel.SwapControl(tc,tc2)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetValue(RACE_INSECT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
		end
	end
end
