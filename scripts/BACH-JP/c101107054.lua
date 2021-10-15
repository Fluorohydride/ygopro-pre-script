--凶導の葬列
--
--Script by mercury233
function c101107054.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,c101107054.filter,LOCATION_HAND+LOCATION_GRAVE,c101107054.mfilter)
	local e2=e1:Clone()
	e2:SetOperation(c101107054.operation(e1:GetOperation()))
	e1:Reset()
	c:RegisterEffect(e2)
end
function c101107054.operation(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsExistingMatchingCard(c101107054.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,40352445)
			and Duel.IsExistingMatchingCard(c101107054.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,101107035) then
			Duel.BreakEffect()
			local g=nil
			if Duel.SelectOption(tp,aux.Stringid(101107054,0),aux.Stringid(101107054,1))==0 then
				g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
			else
				g=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
			end
			Duel.ConfirmCards(tp,g)
			if Duel.SelectYesNo(tp,aux.Stringid(101107054,2)) then
				g=g:Filter(Card.IsAbleToGrave,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				g=g:Select(tp,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end

function c101107054.opfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c101107054.filter(c)
	return c:IsSetCard(0x106)
end
function c101107054.mfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end