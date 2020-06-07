--Eternal Chaos
function c100268010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100268010)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100268010.target)
	e1:SetOperation(c100268010.activate)
	c:RegisterEffect(e1)
end
function c100268010.deckfilter(c,attr)
	return c:IsAttribute(attr) and c:IsAbleToGrave()
end
function c100268010.findlowest(tp,attr)
	local g=Duel.GetMatchingGroup(c100268010.deckfilter,tp,LOCATION_DECK,0,nil,attr)
	if g:GetCount()<1 then return -1 end
	local fc=g:GetFirst()
	local lowest=99999
	while fc do
		if fc:IsType(TYPE_MONSTER) then
			local atk=fc:GetAttack()
			if atk<lowest then
				lowest=atk
			end
		end
		fc=g:GetNext()
	end
	return lowest
end
function c100268010.tgfilter(c,atk)
	return c:IsType(TYPE_MONSTER) and c:IsAttackAbove(atk)
end
function c100268010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local atkdark=c100268010.findlowest(tp,ATTRIBUTE_DARK)
		local atklight=c100268010.findlowest(tp,ATTRIBUTE_LIGHT)
		if atkdark<0 or atklight<0 then return false end
		local atk=atkdark+atklight
		return Duel.IsExistingTarget(c100268010.tgfilter,tp,0,LOCATION_MZONE,1,nil,atk)
	end
	Duel.SelectTarget(tp,c100268010.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c100268010.tgfilter3(c,atk,attr)
	return c:IsAttackBelow(atk) and c:IsAttribute(attr)
end
function c100268010.tgfilter2(c,tp,atk,attr)
	local attr2=ATTRIBUTE_DARK
	if attr==ATTRIBUTE_DARK then attr2=ATTRIBUTE_LIGHT end
	atk=atk-c:GetAttack()
	if atk<0 then return false end
	return c:IsAttribute(attr2) and Duel.IsExistingMatchingCard(c100268010.tgfilter3,tp,LOCATION_DECK,0,1,nil,atk,attr)
end
function c100268010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local atk=tc:GetAttack()
	local atkdark=c100268010.findlowest(tp,ATTRIBUTE_DARK)
	local atklight=c100268010.findlowest(tp,ATTRIBUTE_LIGHT)
	if atkdark<0 or atklight<0 then return false end
	if atk<atkdark+atklight then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.GetMatchingGroup(c100268010.tgfilter2,tp,LOCATION_DECK,0,nil,tp,atk,ATTRIBUTE_DARK)
	local g2=Duel.GetMatchingGroup(c100268010.tgfilter2,tp,LOCATION_DECK,0,nil,tp,atk,ATTRIBUTE_LIGHT)
	g1:Merge(g2)
	local g3=Group.CreateGroup()
	while g3:GetCount()<2 do
		local fc=g1:SelectUnselect(g3,tp,false,false,2,2)
		if not fc then break end
		local atk2=atk-fc:GetAttack()
		if g3:IsContains(fc) then
			atk2=atk
		end
		local g4=Duel.GetMatchingGroup(c100268010.tgfilter2,tp,LOCATION_DECK,0,nil,tp,atk2,ATTRIBUTE_DARK)
		local g5=Duel.GetMatchingGroup(c100268010.tgfilter2,tp,LOCATION_DECK,0,nil,tp,atk2,ATTRIBUTE_LIGHT)
		g1:Clear()
		if g3:IsContains(fc) then
			g3:RemoveCard(fc)
			g1:Merge(g4)
			g1:Merge(g5)
		else
			g3:AddCard(fc)
			if fc:IsAttribute(ATTRIBUTE_DARK) then
				g1:Merge(g4)
			end
			if fc:IsAttribute(ATTRIBUTE_LIGHT) then
				g1:Merge(g5)
			end
		end
	end
	if g3:GetCount()==2 then
		Duel.SendtoGrave(g3,REASON_EFFECT)
		if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(c100268010.regcon)
		e1:SetOperation(c100268010.regop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,0)
		e2:SetCondition(c100268010.actcon)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end

function c100268010.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and (re:GetActivateLocation()&LOCATION_GRAVE)==LOCATION_GRAVE and re:IsActiveType(TYPE_MONSTER)
end
function c100268010.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,100268010,RESET_PHASE+PHASE_END,0,1)
end
function c100268010.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,100268010)>0 and (e:GetActivateLocation()&LOCATION_GRAVE)==LOCATION_GRAVE and e:IsActiveType(TYPE_MONSTER)
end
