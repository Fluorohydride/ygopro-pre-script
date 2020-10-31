--ドラグマ・ジェネシス
--
--"Lua By REIKAI 2404873791"
function c101103070.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c101103070.target)
	e1:SetOperation(c101103070.activate)
	c:RegisterEffect(e1) 
end
function c101103070.filter(c,tp)
	local ctype=bit.band(c:GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
	return c:IsFaceup() and ctype~=0 and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(c101103070.filter2,tp,0,LOCATION_MZONE,1,nil,ctype)
end
function c101103070.filter2(c,ctype)
	return c:IsFaceup() and c:IsType(ctype) and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c101103070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c101103070.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101103070.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101103070.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,tp)
	local ctype=bit.band(g:GetFirst():GetType(),TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
	local dg=Duel.SelectTarget(tp,c101103070.filter2,tp,0,LOCATION_MZONE,1,1,nil,ctype)
	g:Merge(dg)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,1,0,0)
end
function c101103070.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=2 then return end
	local tc1=tg:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local tc2=tg:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	if Duel.SendtoDeck(tc1,nil,0,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e2)
	end
end