--净琉璃朋克惊愕梨割
function c100417012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100417012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100417012.destg)
	e1:SetOperation(c100417012.desop)
	c:RegisterEffect(e1) 
end
function c100417012.filter(c,tp)
	return c:IsFacedown() or (c:IsFaceup() and Duel.IsExistingMatchingCard(c100417012.cfilter,tp,LOCATION_MZONE,0,1,nil))
end
function c100417012.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x26f)
end
function c100417012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c100417012.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100417012.filter,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100417012.filter,tp,0,LOCATION_ONFIELD,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100417012.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end