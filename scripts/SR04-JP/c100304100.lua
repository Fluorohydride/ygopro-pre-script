--生存境界
--Survival Line
--Script by mercury233
function c100304100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c100304100.target)
	e1:SetOperation(c100304100.activate)
	c:RegisterEffect(e1)
	--destory
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c100304100.descost)
	e2:SetTarget(c100304100.destg)
	e2:SetOperation(c100304100.desop)
	c:RegisterEffect(e2)
end
function c100304100.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c100304100.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_DINOSAUR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100304100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100304100.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	and Duel.IsExistingMatchingCard(c100304100.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c100304100.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100304100.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100304100.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local n=Duel.Destroy(g,REASON_EFFECT)
	if n~=0 then
		Duel.BreakEffect()
		local tg=Duel.GetMatchingGroup(c100304100.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ct<0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		ct=math.min(ct,n)
		if ct>0 and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=tg:Select(tp,1,ct,nil)
			if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local sg2=Duel.GetOperatedGroup()
				local fid=e:GetHandler():GetFieldID()
				local tc=sg2:GetFirst()
				while tc do
					tc:RegisterFlagEffect(100304100,RESET_EVENT+0x1fe0000,0,0,fid)
					tc=sg2:GetNext()
				end
				sg2:KeepAlive()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(sg2)
				e1:SetCondition(c100304100.descon2)
				e1:SetOperation(c100304100.desop2)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c100304100.desfilter2(c,fid)
	return c:GetFlagEffectLabel(100304100)==fid
end
function c100304100.descon2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c100304100.desfilter2,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c100304100.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c100304100.desfilter2,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
function c100304100.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100304100.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DINOSAUR)
end
function c100304100.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100304100.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c100304100.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c100304100.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
