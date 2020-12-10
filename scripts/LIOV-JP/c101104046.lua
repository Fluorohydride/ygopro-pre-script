--クラリアの蠱惑魔

--Scripted by mallu11
function c101104046.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT+RACE_PLANT),2,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101104046.imcon)
	e1:SetValue(c101104046.efilter)
	c:RegisterEffect(e1)
	--set instead of send to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101104046.setcon)
	e2:SetOperation(c101104046.setop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101104046,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101104046)
	e3:SetCondition(c101104046.spcon)
	e3:SetTarget(c101104046.sptg)
	e3:SetOperation(c101104046.spop)
	c:RegisterEffect(e3)
end
function c101104046.imcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101104046.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c101104046.setcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and rc:GetType()==TYPE_TRAP and rc:IsSetCard(0x4c,0x89) and rc:IsRelateToEffect(re) and rc:IsCanTurnSet() and rc:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c101104046.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,101104046)==0 and Duel.SelectYesNo(tp,aux.Stringid(101104046,1)) then
		local rc=re:GetHandler()
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN)
		Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		Duel.RegisterFlagEffect(tp,101104046,RESET_PHASE+PHASE_END,0,0)
	end
end
function c101104046.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101104046.spfilter(c,e,tp)
	return c:IsSetCard(0x108a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101104046.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101104046.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101104046.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101104046.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101104046.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
