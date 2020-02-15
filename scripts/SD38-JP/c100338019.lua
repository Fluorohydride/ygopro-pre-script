--Cerulean Sky Fire
--Scripted by: XGlitchy30
function c100338019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--alternate summon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100338019,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c100338019.alt_con)
	e2:SetOperation(c100338019.alt_op)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,32491822))
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100338019,1))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c100338019.negcon)
	e4:SetOperation(c100338019.negop)
	c:RegisterEffect(e4)
	--damage protection
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100338019,3))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c100338019.protcon)
	e5:SetOperation(c100338019.protop)
	c:RegisterEffect(e5)
end
--ALTERNATE SUMMON PROC
--filters
function c100338019.spfilter(c)
	if not c:IsAbleToGraveAsCost() then return false end
	return (c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS) or (c:IsFacedown() and c:IsType(TYPE_SPELL))
end
---------
function c100338019.alt_con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-2 then return false end
	if ft<=0 then
		local ct=-ft+1
		return Duel.IsExistingMatchingCard(c100338019.spfilter,tp,LOCATION_MZONE,0,ct,nil)
			and Duel.IsExistingMatchingCard(c100338019.spfilter,tp,LOCATION_ONFIELD,0,3,nil)
	else
		return Duel.IsExistingMatchingCard(c100338019.spfilter,tp,LOCATION_ONFIELD,0,3,nil)
	end
end
function c100338019.alt_op(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.GetMatchingGroup(c100338019.spfilter,tp,LOCATION_ONFIELD,0,nil)
		local ct=-ft+1
		local g1=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<3 then
			sg:Sub(g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=sg:Select(tp,3-ct,3-ct,nil)
			g1:Merge(g2)
		end
		Duel.SendtoGrave(g1,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100338019.spfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
--NEGATE
--filters
function c100338019.cfilter(c)
	return c:IsFaceup() and c:IsCode(32491822) and c:IsAttackPos()
end
---------
function c100338019.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100338019.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(100338019)<=0
end
function c100338019.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(100338019,2)) then
		if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c100338019.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSITION)
			local g=Duel.SelectMatchingCard(tp,c100338019.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE)
			end
		end
		e:GetHandler():RegisterFlagEffect(100338019,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
--DAMAGE PROTECTION
--filters
function c100338019.protfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
		and (c:GetPreviousCodeOnField()==32491822 or c:GetPreviousCodeOnField()==6007213 or c:GetPreviousCodeOnField()==69890967)
end
---------
function c100338019.protcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100338019.protfilter,1,nil,tp) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c100338019.protop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end