--オノマト選択
--
--Script by mercury233
function c100423037.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100423037+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100423037.activate)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100423037,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,100423037+100)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c100423037.target)
	e2:SetOperation(c100423037.operation)
	c:RegisterEffect(e2)
end
function c100423037.filter(c)
	return c:IsAbleToHand() and (c:IsSetCard(0x239) or c:IsCode(8512558)) and not c:IsCode(100423037)
end
function c100423037.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100423037.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100423037,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c100423037.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x8f,0x54,0x59,0x82)
end
function c100423037.filter2(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c100423037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100423037.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100423037.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100423037.filter2,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100423037.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100423037.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c100423037.filter2,tp,LOCATION_MZONE,0,tc)
		local lc=g:GetFirst()
		local lv=tc:GetLevel()
		while lc do
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(lv)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			lc:RegisterEffect(e2)
			lc=g:GetNext()
		end
	end
end
