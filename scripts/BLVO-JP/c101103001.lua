--アームド・ドラゴン・サンダー LV10

--Scripted by mallu11
function c101103001.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101103001.regcon)
	e1:SetOperation(c101103001.regop)
	c:RegisterEffect(e1)
end
c101103001.lvup={59464593}
c101103001.lvdn={101103002,101103003,101103004}
function c101103001.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x111)
end
function c101103001.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(59464593)
	e1:SetLabel(1)
	e1:SetCondition(c101103001.condition)
	c:RegisterEffect(e1)
	--control
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e2:SetLabel(10)
	c:RegisterEffect(e2)
	--battle indes
	local e3=e1:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	e3:SetLabel(100)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101103001,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1)
	e4:SetLabel(1000)
	e4:SetCondition(c101103001.condition)
	e4:SetCost(c101103001.descost)
	e4:SetTarget(c101103001.destg)
	e4:SetOperation(c101103001.desop)
	c:RegisterEffect(e4)
	--destroy2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101103001,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetLabel(10000)
	e5:SetCondition(c101103001.condition)
	e5:SetTarget(c101103001.destg2)
	e5:SetOperation(c101103001.desop2)
	c:RegisterEffect(e5)
end
function c101103001.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(e:GetLabel()) and (e:GetLabel()~=1000 or Duel.GetTurnPlayer()==1-tp)
end
function c101103001.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101103001.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101103001.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c101103001.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101103001.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
end
