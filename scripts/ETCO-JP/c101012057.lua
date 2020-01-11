--逆巻く炎の宝札

--Scripted by mallu11
function c101012057.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101012057+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101012057.condition)
	e1:SetCost(c101012057.cost)
	e1:SetTarget(c101012057.target)
	e1:SetOperation(c101012057.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101012057,ACTIVITY_SUMMON,c101012057.counterfilter)
	Duel.AddCustomActivityCounter(101012057,ACTIVITY_SPSUMMON,c101012057.counterfilter)
end
function c101012057.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c101012057.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end
function c101012057.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101012057,tp,ACTIVITY_SUMMON)==0
		and Duel.GetCustomActivityCount(101012057,tp,ACTIVITY_SPSUMMON) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101012057.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c101012057.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_FIRE)
end
function c101012057.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and Duel.IsPlayerCanDraw(tp,c:GetLink())
end	
function c101012057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101012057.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101012057.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101012057.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	local lk=g:GetFirst():GetLink()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(lk)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,lk)
end
function c101012057.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
