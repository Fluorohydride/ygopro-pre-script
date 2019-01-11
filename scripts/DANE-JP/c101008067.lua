--強制切断
--
--Scripted By-GimBlocks
function c101008067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101008067+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101008067.target)
	e1:SetOperation(c101008067.activate)
	c:RegisterEffect(e1)
end
function c101008067.filter1(c)
	local tp=c:GetControler()
	return c:IsFaceup() and not c:IsType(TYPE_LINK)
		and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c101008067.filter2(c)
	local tp=c:GetControler()
	return c:IsFaceup() and c:IsType(TYPE_LINK)
		and c:IsAbleToChangeControler() and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_CONTROL)>0
end
function c101008067.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101008067.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c101008067.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c101008067.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,c101008067.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function c101008067.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local a=g:GetFirst()
	local b=g:GetNext()
	if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) then
		Duel.SwapControl(a,b)
	end
end
