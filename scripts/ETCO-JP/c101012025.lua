--天雷震龍－サンダー・ドラゴン

--Scripted by mallu11
function c101012025.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101012025.spcon)
	e1:SetOperation(c101012025.spop)
	c:RegisterEffect(e1)
	--effect target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012025,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c101012025.etcon)
	e2:SetCost(c101012025.etcost)
	e2:SetTarget(c101012025.ettg)
	e2:SetOperation(c101012025.etop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101012025,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101012025.tgcon)
	e3:SetTarget(c101012025.tgtg)
	e3:SetOperation(c101012025.tgop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101012025,ACTIVITY_CHAIN,c101012025.chainfilter)
end
function c101012025.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsRace(RACE_THUNDER) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c101012025.spfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsLevelBelow(8) and c:IsRace(RACE_THUNDER) and c:IsAbleToRemoveAsCost()
end
function c101012025.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetCustomActivityCount(101012025,tp,ACTIVITY_CHAIN)~=0
		or Duel.GetCustomActivityCount(101012025,1-tp,ACTIVITY_CHAIN)~=0)
		and Duel.IsExistingMatchingCard(c101012025.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
end
function c101012025.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c101012025.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101012025.etcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c101012025.fselect(g)
	return g:IsExists(Card.IsRace,1,nil,RACE_THUNDER)
end
function c101012025.etcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c101012025.fselect,2,2) end
	local rg=g:SelectSubGroup(tp,c101012025.fselect,false,2,2)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c101012025.etfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_THUNDER)
end
function c101012025.ettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101012025.etfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101012025.etfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101012025.etfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101012025.etop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetValue(c101012025.tgoval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
end
function c101012025.tgoval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
function c101012025.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101012025.tgfilter(c)
	return c:IsSetCard(0x11c) and c:IsAbleToGrave()
end
function c101012025.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012025.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101012025.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101012025.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
