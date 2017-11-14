--白の咆哮
--White Howling
--Scripted by Eerie Code
function c100224010.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100224010.condition)
	e1:SetTarget(c100224010.target)
	e1:SetOperation(c100224010.activate)
	c:RegisterEffect(e1)
end
function c100224010.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c100224010.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100224010.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100224010.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c100224010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c100224010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100224010.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c100224010.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100224010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		--disable
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetTargetRange(0,LOCATION_SZONE)
		e2:SetTarget(c100224010.distg)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2)
		--disable effect
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetRange(LOCATION_MZONE)
		e3:SetOperation(c100224010.disop)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3)
	end
end
function c100224010.distg(e,c)
	return c:IsType(TYPE_SPELL)
end
function c100224010.disop(e,tp,eg,ep,ev,re,r,rp)
	local tl,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_PLAYER)
	if tl==LOCATION_SZONE and p~=tp and re:IsActiveType(TYPE_SPELL) then
		Duel.NegateEffect(ev)
	end
end
