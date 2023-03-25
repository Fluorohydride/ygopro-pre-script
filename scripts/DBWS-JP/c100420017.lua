--VS パンテラ
--scripted by JoyJ
function c100420017.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100420017)
	e1:SetCondition(c100420017.spcon)
	e1:SetTarget(c100420017.sptg)
	e1:SetOperation(c100420017.spop)
	c:RegisterEffect(e1)
	--show earth for indes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100420017,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,100420017+100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c100420017.indescost)
	e2:SetTarget(c100420017.indestg)
	e2:SetOperation(c100420017.indesop)
	c:RegisterEffect(e2)
	--show earth and fire for destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100420017,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,100420017+100)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100420017.descost)
	e3:SetTarget(c100420017.destg)
	e3:SetOperation(c100420017.desop)
	c:RegisterEffect(e3)
end
function c100420017.spcfilter(c)
	return c:GetSequence()<5
end
function c100420017.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100420017.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100420017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetFlagEffect(100420017)==0 end
	c:RegisterFlagEffect(100420017,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100420017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain(0) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100420017.indescfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsPublic()
end
function c100420017.indescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100420017.indescfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c100420017.indescfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c100420017.indestg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(100420017)==0 end
	c:RegisterFlagEffect(100420017,RESET_CHAIN,0,1)
end
function c100420017.indesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain(0) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	c:RegisterEffect(e1)
end
function c100420017.descfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_DARK) and not c:IsPublic()
end
function c100420017.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100420017.descfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_EARTH,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_EARTH,ATTRIBUTE_DARK)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
end
function c100420017.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_SZONE)
	if chk==0 then return #g>0 and c:GetFlagEffect(100420017)==0 end
	c:RegisterFlagEffect(100420017,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c100420017.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain(0) then return end
	local g=c:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_SZONE)
	Duel.Destroy(g,REASON_EFFECT)
end