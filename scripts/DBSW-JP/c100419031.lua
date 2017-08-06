--雨天気スレット
--Cloudy Weathery Sleet
--Scripted by Eerie Code
function c100419031.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100419031,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100419031.tfcon)
	e1:SetTarget(c100419031.tftg)
	e1:SetOperation(c100419031.tfop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c100419031.spreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100419031,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c100419031.spcon)
	e3:SetTarget(c100419031.sptg)
	e3:SetOperation(c100419031.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c100419031.tfcfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x207) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c100419031.tfcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100419031.tfcfilter,1,e:GetHandler(),tp)
end
function c100419031.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x207) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c100419031.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100419031.tffilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100419031.tffilter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_SZONE),2)
	local g=Duel.SelectTarget(tp,c100419031.tffilter,tp,LOCATION_GRAVE,0,1,ct,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
end
function c100419031.tfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<=0 then return end
	local ct=math.min(2,Duel.GetLocationCount(tp,LOCATION_SZONE))
	if ct<1 then return end
	if g:GetCount()>ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		g=g:Select(tp,1,ct,nil)
	end
	for tc in aux.Next(g) do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c100419031.spreg(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsReason(REASON_COST) and rc:IsSetCard(0x207) then
		e:SetLabel(Duel.GetTurnCount()+1)
		c:RegisterFlagEffect(100419031,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
	end
end
function c100419031.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(100419031)>0
end
function c100419031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():ResetFlagEffect(100419031)
end
function c100419031.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
