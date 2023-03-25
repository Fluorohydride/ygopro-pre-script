--VS ラゼン
--scripted by JoyJ
function c100420016.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100420016,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100420016)
	e1:SetTarget(c100420016.thtg)
	e1:SetOperation(c100420016.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--show fire for indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100420016,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,100420016+100)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100420016.indescost)
	e3:SetTarget(c100420016.indestg)
	e3:SetOperation(c100420016.indesop)
	c:RegisterEffect(e3)
	--show fire and dark for destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100420016,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,100420016+100)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c100420016.descost)
	e4:SetTarget(c100420016.destg)
	e4:SetOperation(c100420016.desop)
	c:RegisterEffect(e4)
end
function c100420016.thfilter(c)
	return c:IsSetCard(0x195) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c100420016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c100420016.thfilter,tp,LOCATION_DECK,0,1,nil)
		and c:GetFlagEffect(100420016)==0 end
	c:RegisterFlagEffect(100420016,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100420016.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100420016.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100420016.indescfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and not c:IsPublic()
end
function c100420016.indescost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100420016.indescfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c100420016.indescfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c100420016.indestg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(100420016)==0 end
	c:RegisterFlagEffect(100420016,RESET_CHAIN,0,1)
end
function c100420016.indesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	c:RegisterEffect(e1)
end
function c100420016.descfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_DARK) and not c:IsPublic()
end
function c100420016.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100420016.descfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.gfcheck,2,2,Card.IsAttribute,ATTRIBUTE_FIRE,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.gfcheck,false,2,2,Card.IsAttribute,ATTRIBUTE_FIRE,ATTRIBUTE_DARK)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
end
function c100420016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	if chk==0 then return #g>0 and c:GetFlagEffect(100420016)==0 end
	c:RegisterFlagEffect(100420016,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c100420016.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	local g=c:GetColumnGroup():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.Destroy(g,REASON_EFFECT)
end