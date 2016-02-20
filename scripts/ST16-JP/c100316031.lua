--EMショーダウン
--Performapal Showdown
--Scripted by Eerie Code-7005
function c100316031.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100316031.target)
	e1:SetOperation(c100316031.operation)
	c:RegisterEffect(e1)
end

function c100316031.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c100316031.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c100316031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sc=Duel.GetMatchingGroupCount(c100316031.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c100316031.filter(chkc) end
	if chk==0 then return sc>0 and Duel.IsExistingTarget(c100316031.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100316031.filter,tp,0,LOCATION_MZONE,1,sc,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c100316031.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=tg:GetFirst()
	while tc do
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENCE)
	end
	tc=tg:GetNext()
	end
end
