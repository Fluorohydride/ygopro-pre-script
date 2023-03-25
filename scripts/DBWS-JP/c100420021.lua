--VS 龍帝ヴァリウス
--scripted by JoyJ
function c100420021.initial_effect(c)
	--return and spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420021,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c100420021.sptg)
	e1:SetOperation(c100420021.spop)
	c:RegisterEffect(e1)
	--show earth to immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420021,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,100420021+100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c100420021.imcost)
	e2:SetTarget(c100420021.imtg)
	e2:SetOperation(c100420021.imop)
	c:RegisterEffect(e2)
	--show earth and fire and dark for destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100420021,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,100420021+100)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100420021.descost)
	e3:SetTarget(c100420021.destg)
	e3:SetOperation(c100420021.desop)
	c:RegisterEffect(e3)
end
function c100420021.spfilter(c)
	return c:IsSetCard(0x195) and c:IsFaceup() and c:IsAbleToHand() and not c:IsRace(RACE_DRAGON)
		and Duel.GetMZoneCount(tp,c,tp)>0
end
function c100420021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100420021.spfilter(chkc,tp) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c100420021.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and c:GetFlagEffect(100420021)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c100420021.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	c:RegisterFlagEffect(100420021,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100420021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and Duel.SendtoHand(tc,nil,REASON_EFFECT) and c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100420021.imcfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsPublic()
end
function c100420021.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100420021.imcfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c100420021.imcfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c100420021.imtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(100420021)==0 end
	c:RegisterFlagEffect(100420021,RESET_CHAIN,0,1)
end
function c100420021.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100420021.efilter)
	c:RegisterEffect(e1)
end
function c100420021.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c100420021.descfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_DARK+ATTRIBUTE_FIRE) and not c:IsPublic()
end
function c100420021.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100420021.descfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.dabcheck,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dabcheck,false,3,3)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
end
function c100420021.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	if chk==0 then return #g>0 and c:GetFlagEffect(100420021)==0 end
	c:RegisterFlagEffect(100420021,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100420021.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToChain() then c=nil end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.Destroy(g,REASON_EFFECT)
end