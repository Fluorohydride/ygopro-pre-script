--凶導の葬列
--
--Script by JoyJ
function c101107054.initial_effect(c)
	aux.AddCodeList(c,40352445,101107035)
	local e1=aux.AddRitualProcGreater2(c,c101107054.filter,LOCATION_HAND+LOCATION_GRAVE,c101107054.mfilter)
	local e2=e1:Clone()
	e2:SetCountLimit(1,101107054+EFFECT_COUNT_CODE_OATH)
	e2:SetOperation(c101107054.operation(e1:GetOperation()))
	e1:Reset()
	c:RegisterEffect(e2)
end
function c101107054.operation(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsExistingMatchingCard(c101107054.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,40352445)
			and Duel.IsExistingMatchingCard(c101107054.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,101107035) then
			local g1=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
			local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
			if #g1==0 and #g2==0 then return end
			Duel.BreakEffect()
			local g=nil
			if #g1~=0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(101107054,0),aux.Stringid(101107054,1))==0) then
				g=g1
			else
				g=g2
			end
			Duel.ConfirmCards(tp,g)
			if Duel.SelectYesNo(tp,aux.Stringid(101107054,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local tg=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		end
	end
end
function c101107054.opfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c101107054.filter(c)
	return c:IsSetCard(0x145)
end
function c101107054.mfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end
