--ドレミコード・フォーマル

--Scripted by mallu11
function c100416026.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100416026+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100416026.condition)
	e1:SetTarget(c100416026.target)
	e1:SetOperation(c100416026.activate)
	c:RegisterEffect(e1)
end
function c100416026.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x265)
end
function c100416026.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100416026.confilter,tp,LOCATION_PZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and rp==1-tp
end
function c100416026.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck()
end
function c100416026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100416026.tdfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
end
function c100416026.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c100416026.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100416026.tdfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK)
		and Duel.IsExistingMatchingCard(c100416026.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
		e1:SetValue(c100416026.efilter)
		e1:SetLabelObject(re)
		e1:SetReset(RESET_EVENT+RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetTargetRange(LOCATION_PZONE,0)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_REMOVE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,1)
		e3:SetTarget(c100416026.rmlimit)
		Duel.RegisterEffect(e3,tp)
	end
end
function c100416026.efilter(e,re)
	return re==e:GetLabelObject()
end
function c100416026.rmlimit(e,c,tp,r,re)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(LOCATION_PZONE) and r&REASON_EFFECT~=0 and re and re==e:GetLabelObject()
end
