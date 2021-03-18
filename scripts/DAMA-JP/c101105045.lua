--黒熔龍騎ヴォルニゲシュ
--
--Script by XyleN5967
function c101105045.initial_effect(c)
	--xyz procedure
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105045,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c101105045.descost)
	e1:SetTarget(c101105045.destg)
	e1:SetOperation(c101105045.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone() 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c101105045.matcon)
	c:RegisterEffect(e2)
end
function c101105045.matcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_DRAGON)
end
function c101105045.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c101105045.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101105045.checkfilter(c,tp)
	return (c:IsPreviousControler(tp) or c:IsPreviousControler(1-tp)) and c:GetPreviousTypeOnField()&TYPE_MONSTER~=0
end
function c101105045.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:IsExists(c101105045.checkfilter,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(101105045,1)) then
			if tc:IsType(TYPE_XYZ) then atk=tc:GetRank() else atk=tc:GetLevel() end
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst() 
			if tc then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(atk*300)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				tc:RegisterEffect(e1)
			end
		end
	end
end
