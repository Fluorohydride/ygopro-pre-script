--カオス・コア

--Scripted by mallu11
function c100338002.initial_effect(c)
	c:EnableCounterPermit(0x57)
	aux.AddCodeList(c,6007213,32491822,69890967)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100338002,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BECOME_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100338002)
	e1:SetTarget(c100338002.counttg)
	e1:SetOperation(c100338002.countop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCondition(c100338002.countcon)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c100338002.reptg)
	e3:SetOperation(c100338002.repop)
	c:RegisterEffect(e3)
end
function c100338002.countcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c100338002.tgfilter(c)
	return c:IsCode(6007213,32491822,69890967) and c:IsAbleToGrave()
end
function c100338002.counttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c100338002.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and c:IsCanAddCounter(0x57,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100338002.countop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100338002.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,g:GetCount())
	if sg:GetCount()>0 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		if ct>0 and c:AddCounter(0x57,ct) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c100338002.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
		and e:GetHandler():IsCanRemoveCounter(tp,0x57,1,REASON_EFFECT) 
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c100338002.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x57,1,REASON_EFFECT)
end
