--防火防守者
--Script by 奥克斯
function c101112001.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCountLimit(1,101112001)
	e1:SetCondition(c101112001.spcon)
	e1:SetCost(c101112001.spcost)
	e1:SetTarget(c101112001.sptg)
	e1:SetOperation(c101112001.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101112001,ACTIVITY_SPSUMMON,c101112001.counterfilter)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101112002)
	e2:SetTarget(c101112001.reptg)
	e2:SetValue(c101112001.repval)
	e2:SetOperation(c101112001.repop)
	c:RegisterEffect(e2)
end

function c101112001.counterfilter(c)
	return c:IsRace(RACE_CYBERSE)
end
function c101112001.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and rc:IsRace(RACE_CYBERSE) 
end
function c101112001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101112001,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101112001.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101112001.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end
function c101112001.spfilter(c,e,tp)
	return not c:IsCode(101112001) and c:IsSetCard(0x28f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101112001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101112001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101112001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c101112001.repfilter(c,tp)
	return not c:IsReason(REASON_REPLACE) and c:IsFaceup() and c:IsSetCard(0x28f) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c101112001.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c101112001.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101112001.repval(e,c)
	return c101112001.repfilter(c,e:GetHandlerPlayer())
end
function c101112001.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end