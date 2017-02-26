--暗黒界の洗脳
--Dark World Brainwashing
--Scripted by Eerie Code
function c101001074.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101001074.target1)
	e1:SetOperation(c101001074.operation1)
	c:RegisterEffect(e1)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101001074,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c101001074.condition2)
	e2:SetTarget(c101001074.target)
	e2:SetOperation(c101001074.operation2)
	c:RegisterEffect(e2)
end
function c101001074.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end
function c101001074.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=3
end
function c101001074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101001074.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101001074.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101001074.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.HintSelection(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101001074.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6) and c:IsAbleToHand()
end
function c101001074.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101001074.cfilter(chkc) end
	if chk==0 then return true end
	e:SetLabel(0)
	local ct=Duel.GetCurrentChain()
	if ct==1 or not c101001074.condition(e,tp,eg,ep,ev,re,r,rp)
		or not c101001074.target(e,tp,eg,ep,ev,re,r,rp,0) then
		return false
	end
	local pe=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=pe:GetHandler()
	if pe:IsActiveType(TYPE_EFFECT) and pe:IsControler(1-tp)
		and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		c101001074.target(e,tp,eg,ep,ev,re,r,rp,1)
		e:SetLabel(1)
	end
end
function c101001074.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()~=1 or not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ct-1,g)
		Duel.ChangeChainOperation(ct-1,c101001074.repop)
	end
end
function c101001074.condition2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>=3
end
function c101001074.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c101001074.repop)
	end
end
