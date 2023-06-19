--デモンズ・ゴーレム
--
--Script by Trishula9
function c100346032.initial_effect(c)
	aux.AddCodeList(c,70902743)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100346032.target)
	e1:SetOperation(c100346032.activate)
	c:RegisterEffect(e1)
end
function c100346032.rmfilter(c)
	return c:IsAttackAbove(2000) and c:IsFaceup() and c:IsAbleToRemove()
end
function c100346032.cfilter(c)
	return (c:IsCode(70902743) or (aux.IsCodeListed(c,70902743) and c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_MZONE)))
		and c:IsFaceup()
end
function c100346032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100346032.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100346032.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c100346032.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local cg=Duel.GetMatchingGroup(c100346032.cfilter,tp,LOCATION_ONFIELD,0,nil)
	e:SetLabel(cg:GetCount())
end
function c100346032.stfilter(c)
	return c:IsCode(50078509) and c:IsSSetable()
end
function c100346032.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(100346032,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c100346032.retcon)
		e1:SetOperation(c100346032.retop)
		e1:SetLabel(Duel.GetTurnCount())
		Duel.RegisterEffect(e1,tp)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100346032.stfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:GetLabel()>0 and g:GetCount()>0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(100346032,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sc=g:Select(tp,1,1,nil)
			if sc then
				Duel.SSet(tp,sc)
			end
		end
	end
end
function c100346032.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(100346032)~=0
end
function c100346032.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end