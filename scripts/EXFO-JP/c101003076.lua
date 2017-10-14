--センサー万別
--Sensor Differentiation
--Scripted by Eerie Code and edo9300
function c101003076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c101003076.acttg)
	e1:SetOperation(c101003076.actop)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c101003076.adjustop)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c101003076.sumlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e6)
end
c101003076[0]=nil
c101003076[1]=nil
function c101003076.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(c101003076.rmfilter,tp,LOCATION_MZONE,0,1,nil,c:GetRace())
end
function c101003076.rmfilter(c,rc)
	return c:IsFaceup() and c:IsRace(rc)
end
function c101003076.filter(c,g,pg)
	if pg:IsContains(c) then return false end
	local rc=c:GetRace()
	return g:IsExists(Card.IsRace,1,c,rc) or pg:IsExists(Card.IsRace,1,c,rc)
end
function c101003076.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	c101003076[0]=Group.CreateGroup()
	c101003076[0]:KeepAlive()
	c101003076[1]=Group.CreateGroup()
	c101003076[1]:KeepAlive()
end
function c101003076.actop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local race=1
		while race<RACE_CYBERSE+1 do
			local rg=g:Filter(Card.IsRace,nil,race)
			local rc=rg:GetCount()
			if rc>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local dg=rg:Select(tp,rc-1,rc-1,nil)
				Duel.SendtoGrave(dg,REASON_EFFECT)
				local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
			end
			race=race*2
		end
	end
end
function c101003076.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	if c:GetFlagEffect(101003076)==0 then
		c:RegisterFlagEffect(101003076,RESET_EVENT+0x1ff0000,0,1)
		c101003076[0]:Clear()
		c101003076[1]:Clear()
	end
	for p=0,1 do
		local pg=c101003076[p]
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		local dg=g:Filter(c101003076.filter,nil,g,pg)
		if dg:GetCount()==0 or Duel.SendtoGrave(dg,REASON_EFFECT)==0 then
			pg:Clear()
			pg:Merge(g)
			pg:Sub(dg)
		else
			g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
			pg:Clear()
			pg:Merge(g)
			pg:Sub(dg)
			Duel.Readjust()
		end
	end
end
