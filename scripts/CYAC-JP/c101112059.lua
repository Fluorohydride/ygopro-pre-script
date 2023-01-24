--ネムレリアの寝姫楼
--Script by 奥克斯
function c101112059.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101112059)
	e1:SetCost(c101112059.cost)
	e1:SetTarget(c101112059.target)
	e1:SetOperation(c101112059.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101112059,ACTIVITY_SPSUMMON,c101112059.counterfilter)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101112059.repcon)
	e2:SetTarget(c101112059.reptg)
	e2:SetValue(c101112059.repval)
	e2:SetOperation(c101112059.repop)
	c:RegisterEffect(e2)
end
function c101112059.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_PENDULUM)
end
function c101112059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetCustomActivityCount(101112059,tp,ACTIVITY_SPSUMMON)==0
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil):Filter(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)
	if chk==0 then return #g>=2 and check end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101112059.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,2,2,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function c101112059.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_PENDULUM)
end
function c101112059.filter(c)
	return c:IsLevel(10) and c:IsRace(RACE_BEAST) and c:IsAbleToHand()
end
function c101112059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101112059.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c101112059.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101112059.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(c101112059.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if not sg then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function c101112059.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_PENDULUM)
end 
function c101112059.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove(tp,POS_FACEDOWN,REASON_EFFECT)
end
function c101112059.repcon(e)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsFaceup,Card.IsCode),e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil,101112015)
	return #g>0 
end
function c101112059.repfilter(c,tp)
	return not c:IsReason(REASON_REPLACE) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x292)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) 
end
function c101112059.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101112059.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then return eg:IsExists(c101112059.repfilter,1,nil,tp) and #g>0 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101112059.repval(e,c)
	return c101112059.repfilter(c,e:GetHandlerPlayer())
end
function c101112059.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101112059)
	local g=Duel.GetMatchingGroup(c101112059.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:Select(tp,1,1,nil)
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT+REASON_REPLACE)
end