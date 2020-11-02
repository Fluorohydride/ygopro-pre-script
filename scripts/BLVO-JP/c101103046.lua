--スプリガンズ・シップ エクスブロウラー

--Scripted by mallu11
function c101103046.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,nil,nil,99)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103046,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101103046)
	e1:SetTarget(c101103046.seqtg)
	e1:SetOperation(c101103046.seqop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103046,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_END)
	e2:SetCountLimit(1,101103146)
	e2:SetCondition(c101103046.rmcon)
	e2:SetTarget(c101103046.rmtg)
	e2:SetOperation(c101103046.rmop)
	c:RegisterEffect(e2)
end
function c101103046.desfilter(c)
	if c:IsLocation(LOCATION_SZONE) then
		return c:GetSequence()<5
	else
		return true
	end
end
--str2 to str6 is Spell&Trap Zone(from right to left)
--str7 to str13 is Monster Zone(from right to left)
function c101103046.seqfilter(c,i,chk)
	local seq=c:GetSequence()
	if i==11 then
		return (seq==5 or (chk and seq==1)) and c:IsLocation(LOCATION_MZONE)
	elseif i==12 then
		return (seq==6 or (chk and seq==3)) and c:IsLocation(LOCATION_MZONE)
	else
		local loc
		local j
		if i<6 then
			loc=LOCATION_MZONE
			j=0
		else
			loc=LOCATION_SZONE
			j=5
		end
		if c:IsLocation(loc) then
			return seq==i-j-1
		else
			if i==7 then
				return seq==i-j or seq==i-j-1 or seq==i-j-2 or seq==5
			elseif i==9 then
				return seq==i-j or seq==i-j-1 or seq==i-j-2 or seq==6
			else
				return (seq==i-j or seq==i-j-1 or seq==i-j-2) and seq<5
			end
		end
	end
end
function c101103046.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(c101103046.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local b={}
	for i=1,12 do
		b[i]=Duel.IsExistingMatchingCard(c101103046.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i)
	end
	local off=0
	local ops={}
	local opval={}
	off=1
	for i=1,12 do
		if b[i] then
			ops[off]=aux.Stringid(101103046,i+1)
			opval[off-1]=i
			off=off+1
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(101103046,opval[op]+1))
	local g=Duel.GetMatchingGroup(c101103046.seqfilter,tp,0,LOCATION_ONFIELD,nil,opval[op],true)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101103046.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local i=e:GetLabel()
	if not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c101103046.seqfilter,tp,0,LOCATION_ONFIELD,nil,i,true)
	if ct<=0 or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local count=c:RemoveOverlayCard(tp,1,ct,REASON_EFFECT)
	if count<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c101103046.seqfilter,tp,0,LOCATION_ONFIELD,count,count,nil,i,true)
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function c101103046.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==1-tp
		and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c101103046.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c101103046.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c101103046.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101103046.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
