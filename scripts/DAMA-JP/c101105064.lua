--二量合成
--
--Script by mercury233
function c101105064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105064,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101105064)
	e1:SetTarget(c101105064.target)
	e1:SetOperation(c101105064.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105064,3))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101105064+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101105064.atktg)
	e2:SetOperation(c101105064.atkop)
	c:RegisterEffect(e2)
end
function c101105064.thfilter1(c)
	return c:IsCode(65959844) and c:IsAbleToHand()
end
function c101105064.thfilter2(c)
	return c:IsCode(25669282) and c:IsAbleToHand()
end
function c101105064.thfilter3(c)
	return c:IsSetCard(0xeb) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101105064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c101105064.thfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c101105064.thfilter2,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c101105064.thfilter3,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(101105064,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(101105064,2)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local res=opval[op]
	e:SetLabel(res)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,res,tp,LOCATION_DECK)
end
function c101105064.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101105064.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.IsExistingMatchingCard(c101105064.thfilter2,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c101105064.thfilter3,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.SelectMatchingCard(tp,c101105064.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c101105064.thfilter3,tp,LOCATION_DECK,0,1,1,nil)
			g1:Merge(g2)
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g1)
		end
	end
end
function c101105064.tgfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c101105064.atkfilter(c)
	return c:GetAttack()>0 and c:GetBaseAttack()>0
end
function c101105064.tgcheck(g)
	return g:IsExists(Card.IsDualState,1,nil) and g:IsExists(c101105064.atkfilter,1,nil)
end
function c101105064.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c101105064.tgfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c101105064.tgcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c101105064.tgcheck,false,2,2)
	Duel.SetTargetCard(sg)
end
function c101105064.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105064,4))
	local g1=g:FilterSelect(tp,c101105064.atkfilter,1,1,nil)
	if #g1<1 then return end
	local tc1=g1:GetFirst()
	local tc2=(g-g1):GetFirst()
	if tc1:IsImmuneToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(0)
	tc1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(tc1:GetBaseAttack())
	tc2:RegisterEffect(e2)
end
