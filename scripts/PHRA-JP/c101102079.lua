--魔獣の大餌

--Scripted by mallu11
function c101102079.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c101102079.target)
	e1:SetOperation(c101102079.activate)
	c:RegisterEffect(e1)
end
function c101102079.rmfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c101102079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil,tp,POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c101102079.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_EXTRA)
end
function c101102079.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,nil,tp,POS_FACEDOWN)
	local g2=Duel.GetMatchingGroup(c101102079.rmfilter,tp,0,LOCATION_EXTRA,nil)
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,#g2,nil)
		if Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)~=0 and sg1:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
			local og1=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			local sg2=g2:RandomSelect(tp,#og1)
			if Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 and sg2:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
				local c=e:GetHandler()
				local fid=c:GetFieldID()
				local og2=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
				local tc=og2:GetFirst()
				while tc do
					tc:RegisterFlagEffect(101102079,RESET_EVENT+RESETS_STANDARD,0,1,fid)
					tc=og2:GetNext()
				end
				og2:KeepAlive()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetLabel(fid)
				e1:SetLabelObject(og2)
				e1:SetCountLimit(1)
				e1:SetCondition(c101102079.retcon)
				e1:SetOperation(c101102079.retop)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c101102079.retfilter(c,fid)
	return c:GetFlagEffectLabel(101102079)==fid
end
function c101102079.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c101102079.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c101102079.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c101102079.retfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end
