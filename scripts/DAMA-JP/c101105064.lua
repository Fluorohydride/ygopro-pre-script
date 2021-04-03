--二量合成
--
--scripted by zerovoros a.k.a faultzone
function c101105064.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101105064)
	e1:SetTarget(c101105064.thtg)
	e1:SetOperation(c101105064.thop)
	c:RegisterEffect(e1)
	--change atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101105064+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101105064.postg)
	e2:SetOperation(c101105064.posop)
	c:RegisterEffect(e2)
end
function c101105064.thfilter1(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c101105064.thfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xeb) and c:IsAbleToHand()
end
function c101105064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local f1 = Duel.IsExistingMatchingCard(c101105064.thfilter1,tp,LOCATION_DECK,0,1,nil,65959844)
	local f2 = Duel.IsExistingMatchingCard(c101105064.thfilter1,tp,LOCATION_DECK,0,1,nil,25669282)
		and Duel.IsExistingMatchingCard(c101105064.thfilter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return f1 or f2 end
	if f1 or f2 then
		if f1 and f2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			e:SetLabel(Duel.SelectOption(tp,aux.Stringid(101105064,0),aux.Stringid(101105064,1)))
		elseif f1 then
			e:SetLabel(Duel.SelectOption(tp,aux.Stringid(101105064,0)))
		else
			e:SetLabel(Duel.SelectOption(tp,aux.Stringid(101105064,1))+1)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,e:GetLabel()+1,tp,LOCATION_DECK)
end
function c101105064.thop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=Duel.SelectMatchingCard(tp,c101105064.thfilter1,tp,LOCATION_DECK,0,1,1,nil,65959844)
		if #g1>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	elseif opt==1 then
		local g1=Duel.GetMatchingGroup(c101105064.thfilter1,tp,LOCATION_DECK,0,nil,25669282)
		local g2=Duel.GetMatchingGroup(c101105064.thfilter2,tp,LOCATION_DECK,0,nil)
		if #g1>0 and #g2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g1:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			sg=sg+g2:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c101105064.posfilter1(c)
	return c:IsFaceup() and c:IsDualState()
		and Duel.IsExistingTarget(c101105064.posfilter2,0,LOCATION_MZONE,nil,1,c)
end
function c101105064.posfilter2(c)
	return c:IsFaceup()
end
function c101105064.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ct=Duel.GetMatchingGroupCount(c101105064.posfilter2,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>1 and Duel.IsExistingTarget(c101105064.posfilter1,tp,LOCATION_MZONE,nil,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
	local g1=Duel.SelectTarget(tp,c101105064.posfilter1,tp,LOCATION_MZONE,nil,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACK)
	local g2=Duel.SelectTarget(tp,c101105064.posfilter2,tp,LOCATION_MZONE,nil,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g1,2,0,0)
end
function c101105064.posop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #sg~=2 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105064,2))
	local g=sg:FilterSelect(tp,Card.IsAttackAbove,1,1,nil,1)
	if #g==0 then return end
	local tc1=g:GetFirst()
	local tc2=(sg-tc1):GetFirst()
	if tc1:IsImmuneToEffect(e) then return end
	--zero ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(0)
	tc1:RegisterEffect(e1)
	--increase ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(tc1:GetBaseAttack())
	tc2:RegisterEffect(e2)
end
