--ディーヴジャン
function c100214005.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100214005,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100214005)
	e1:SetCost(c100214005.spcost)
	e1:SetTarget(c100214005.sptg)
	e1:SetOperation(c100214005.spop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100214005,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100214105)
	e2:SetTarget(c100214005.destg)
	e2:SetOperation(c100214005.desop)
	c:RegisterEffect(e2)
end
function c100214005.cfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsCode(100214005) and c:IsReleasable()
end
function c100214005.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local rg=Duel.GetMatchingGroup(c100214005.cfilter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return rg:GetCount()==Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,100214005):GetCount() and rg:GetCount()~=0 and Duel.GetMZoneCount(tp,rg)>0 end
	local ct=Duel.Release(rg,REASON_COST)*2
	e:SetLabel(ct)
end
function c100214005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,100214105,0,TYPES_TOKEN_MONSTER,200,200,1,RACE_MACHINE,ATTRIBUTE_FIRE) end
	local ct=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c100214005.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=e:GetLabel()
	if ft>0 and ct>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,100214105,0,TYPES_TOKEN_MONSTER,200,200,1,RACE_MACHINE,ATTRIBUTE_FIRE) then
		local count=math.min(ft,ct)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then count=1 end
		if count>1 then
			local num={}
			local i=1
			while i<=count do
				num[i]=i
				i=i+1
			end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100214005,2))
			count=Duel.AnnounceNumber(tp,table.unpack(num))
		end
		for i=1,count do
			local token=Duel.CreateToken(tp,100214105)
			if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(100214005,3))
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_LEAVE_FIELD)
				e1:SetLabel(tp)
				e1:SetOperation(c100214005.damop)
				token:RegisterEffect(e1,true)
			end
		end
		Duel.SpecialSummonComplete()
	end
end
function c100214005.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetLabel()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
	e:Reset()
end
function c100214005.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TOKEN)
end
function c100214005.desfilter2(c,e)
	return c100214005.desfilter(c) and c:IsCanBeEffectTarget(e)
end
function c100214005.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c100214005.desfilter(chkc) end
	local g=Duel.GetMatchingGroup(c100214005.desfilter2,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:GetCount()~=0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,g:GetCount(),nil)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c100214005.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end