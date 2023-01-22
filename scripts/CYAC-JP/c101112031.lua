--陷溺追蜂族！
--Script by 奥克斯
function c101112031.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112031,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,101112031)
	e1:SetCost(c101112031.setcost)
	e1:SetTarget(c101112031.settg)
	e1:SetOperation(c101112031.setop)
	c:RegisterEffect(e1)
end
function c101112031.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101112031.seqfilter(c)
	return c:GetSequence()<5
end
function c101112031.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c101112031.getct(tp)
	local cct=Duel.GetMatchingGroupCount(c101112031.seqfilter,tp,0,LOCATION_SZONE,nil)
	return 5-cct
end
function c101112031.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=c101112031.getct(tp)
	if ct==0 then return false end
	local g=Duel.GetDecktopGroup(tp,ct)
	if chk==0 then 
		return ct>0 and #g>=ct 
	end
end
function c101112031.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c101112031.getct(tp)
	if ct==0 then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	if #g==0 then return false end
	Duel.ConfirmDecktop(tp,ct)
	local sg=g:Filter(c101112031.setfilter,nil)
	local ct1=#g
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(101112031,1)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SET)
		local setc=sg:Select(tp,1,1,nil):GetFirst()
		if Duel.SSet(tp,setc)>0 then ct1=ct1-1 end
	end
	if ct1>0 then
		Duel.SortDecktop(tp,tp,ct1)
		for i=1,ct1 do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
end