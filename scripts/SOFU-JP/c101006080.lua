--素早きは三文の徳
--The Nimble Manta Catches the Worm
--Scripted by Eerie Code
function c101006080.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101006080)
	e1:SetCondition(c101006080.condition)
	e1:SetTarget(c101006080.target)
	e1:SetOperation(c101006080.activate)
	c:RegisterEffect(e1)
end
function c101006080.cfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c101006080.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==3 and g:FilterCount(c101006080.cfilter,nil)==3
		and g:GetClassCount(Card.GetCode)==1
end
function c101006080.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101006080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c101006080.filter,tp,LOCATION_DECK,0,1,nil)
		return aux.SelectUnselectGroup(g,e,tp,3,3,c101006080.thcheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK)
end
function c101006080.thcheck(sg,e,tp,mg)
	return sg:GetClassCount(Card.GetCode)==1
end
function c101006080.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c101006080.filter,tp,LOCATION_DECK,0,1,nil)
	local g=aux.SelectUnselectGroup(dg,e,tp,3,3,c101006080.thcheck,tp,HINTMSG_ATOHAND)
	if #g==3 and Duel.SendtoHand(g,nil,REASON_EFFECT)==3 then
		local tc=g:GetFirst()
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetCode(EFFECT_CANNOT_ACTIVATE)
		e0:SetTargetRange(1,0)
		e0:SetValue(c101006080.aclimit)
		e0:SetLabelObject(tc)
		e0:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e0,tp)
		local e1=e0:Clone()
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTarget(c101006080.splimit)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SET)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e33,tp)
	end	
end
function c101006080.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c101006080.splimit(e,c,sump,sumtype,sumpos,targetp)
	local tc=e:GetLabelObject()
	return not c:IsCode(tc:GetCode())
end
