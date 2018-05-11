--鉄の檻
--Iron Cage
--Script by dest
function c100227012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100227012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100227012.target)
	e1:SetOperation(c100227012.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100227012,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c100227012.spcon)
	e2:SetTarget(c100227012.sptg)
	e2:SetOperation(c100227012.spop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c100227012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	if Duel.IsEnvironment(100227010) then
		loc=LOCATION_MZONE
	end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_MZONE,loc,1,nil) end
end
function c100227012.operation(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	if Duel.IsEnvironment(100227010) then
		loc=LOCATION_MZONE
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_MZONE,loc,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		tc:RegisterFlagEffect(100227012,RESET_EVENT+0x1fe0000,0,0)
		e:SetLabelObject(tc)
	end
end
function c100227012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100227012.filter(c,e,tp)
	return c==e:GetLabelObject():GetLabelObject() and c:GetFlagEffect(100227012)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100227012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c100227012.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100227012.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100227012.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100227012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
