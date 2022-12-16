--BF－下弦のサルンガ
--Script by 奥克斯
function c100297008.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100297008+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100297008.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,100297008+100+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c100297008.descon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100297008.destg)
	e2:SetOperation(c100297008.desop)
	c:RegisterEffect(e2)
end
function c100297008.filter(c)
	return c:IsAttackAbove(2000) and c:IsFaceup()
end
function c100297008.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100297008.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c100297008.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO)
end
function c100297008.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100297008.cfilter,tp,LOCATION_MZONE,0,nil)
	return #g>0
end
function c100297008.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100297008.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end