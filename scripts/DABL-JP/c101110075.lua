--肆世壊の双牙
--Script by JoyJ
function c101110075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c101110075.cost)
	e1:SetTarget(c101110075.target)
	e1:SetOperation(c101110075.activate)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110075,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE)
	e2:SetCondition(c101110075.cacon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c101110075.caop)
	c:RegisterEffect(e2)
end
function c101110075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101110075.desfilter(c,tc,ec)
	return c:GetEquipTarget()~=tc and c~=ec
end
function c101110075.costfilter(c,ec,tp)
	if not c:IsSetCard(0x17a) then return false end
	return Duel.IsExistingTarget(c101110075.desfilter,tp,0,LOCATION_ONFIELD,2,c,c,ec)
end
function c101110075.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc~=c end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c101110075.costfilter,1,c,c,tp)
		else
			return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,2,c)
		end
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local sg=Duel.SelectReleaseGroup(tp,c101110075.costfilter,1,1,c,c,tp)
		Duel.Release(sg,REASON_COST)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,2,2,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c101110075.actfilter(c)
	return c:IsCode(56099748) and c:IsFaceup()
end
function c101110075.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsExistingMatchingCard(c101110075.actfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
	else
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c101110075.cacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsLinkAbove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,3)
end
function c101110075.caop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c101110075.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101110075.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_MZONE)
end