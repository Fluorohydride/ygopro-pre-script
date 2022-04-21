--メルフィーとにらめっこ
--
--Script by JoyJ
function c101109063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101109063)
	e1:SetCost(c101109063.cost)
	e1:SetTarget(c101109063.target)
	e1:SetOperation(c101109063.operation)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43175027,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101109063+100)
	e2:SetCondition(c101109063.atkcon)
	e2:SetTarget(c101109063.atktg)
	e2:SetOperation(c101109063.atkop)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c101109063.atkval)
	c:RegisterEffect(e3)
	e3:SetLabelObject(e2)
end
function c101109063.cfilter(c,tp)
	return not c:IsPublic() and c:IsRace(RACE_BEAST) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c101109063.cfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function c101109063.cfilter2(c,oc)
	return not c:IsCode(oc:GetCode()) and c:IsAbleToHand() and c:IsSetCard(0x146) and c:IsType(TYPE_MONSTER)
end
function c101109063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(1)
		return Duel.IsExistingMatchingCard(c101109063.cfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c101109063.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabelObject(g:GetFirst())
end
function c101109063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b=e:GetLabel()
		e:SetLabel(0)
		return b==1
	end
	e:GetLabelObject():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetLabelObject(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101109063.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101109063.cfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
	end
end
function c101109063.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c101109063.atkfilter(c)
	return not c:IsPublic() and c:IsSetCard(0x146) and c:IsType(TYPE_MONSTER)
end
function c101109063.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101109063.atkfilter,tp,LOCATION_HAND,0,1,nil) end
end
function c101109063.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101109063,2))
	local g=Duel.SelectMatchingCard(tp,c101109063.atkfilter,tp,LOCATION_HAND,0,1,99,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetDescription(66)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(101109063,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	end
	g:KeepAlive()
	local g2=e:GetLabelObject()
	if g2 then g2:DeleteGroup() end
	e:SetLabelObject(g)
end
function c101109063.sum(c)
	if c:GetFlagEffect(101109063)==0 then return 0 end
	return c:GetAttack()+c:GetDefense()
end
function c101109063.atkval(e,c)
	local g=e:GetLabelObject():GetLabelObject()
	if g and #g>0 then
		return -g:GetSum(c101109063.sum)
	end
	return 0
end
