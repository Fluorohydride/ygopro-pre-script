--闪电释放
function c100417035.initial_effect(c)
	aux.AddCodeList(c,100417125)
	
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100417035,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100417035+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100417035.con1)
	e1:SetTarget(c100417035.tar1)
	e1:SetOperation(c100417035.op1)
	c:RegisterEffect(e1)
end

function c100417035.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,100417125)
end

function c100417035.filter1(c)
	return c:IsFaceup() and c:GetEquipCount()>0 and c:GetEquipGroup():IsExists(aux.IsCodeListed,1,nil,100417125)
end

function c100417035.filter2(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end

function c100417035.efilter(c,tp)
	return c:IsType(TYPE_EQUIP) and aux.IsCodeListed(c,100417125) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end

function c100417035.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c100417035.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100417035.filter1,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c100417035.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	local dg=Duel.GetMatchingGroup(c100417035.filter2,tp,0,LOCATION_MZONE,nil,g:GetFirst():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end

function c100417035.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local dg=Duel.GetMatchingGroup(c100417035.filter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())	 
		if Duel.Destroy(dg,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100417035.efilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) 
			and Duel.SelectYesNo(tp,aux.Stringid(100417035,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100417035,1))
			local eg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100417035.efilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100417035,2))
			local mg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Equip(tp,eg:GetFirst(),mg:GetFirst())
		end
	end
end