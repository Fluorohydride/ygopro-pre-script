--覇王龍ズァーク
--Supreme King Dragon Zarc
--Scripted by Eerie Code
function c100912039.initial_effect(c)
	c:EnableReviveLimit()
	--fusion procedure to be added
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c100912039.fuscon)
	e0:SetOperation(c100912039.fusop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c100912039.limval)
	c:RegisterEffect(e2)
	--destroy drawn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100912039,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100912039.ddcon)
	e3:SetTarget(c100912039.ddtg)
	e3:SetOperation(c100912039.ddop)
	c:RegisterEffect(e3)
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100912039,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c100912039.destg)
	e4:SetOperation(c100912039.desop)
	c:RegisterEffect(e4)
	--Immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(c100912039.tgvalue)
	c:RegisterEffect(e6)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(100912039,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCondition(aux.bdocon)
	e7:SetTarget(c100912039.sptg)
	e7:SetOperation(c100912039.spop)
	c:RegisterEffect(e7)
	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(100912039,3))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(c100912039.pencon)
	e8:SetTarget(c100912039.pentg)
	e8:SetOperation(c100912039.penop)
	c:RegisterEffect(e8)
end
function c100912039.fusfilter_sf(c,mg,ts,chkf)
	if not c:IsRace(RACE_DRAGON) or not aux.FConditionCheckF(c,chkf) then return false end
	if ts==TYPE_FUSION or ts==TYPE_SYNCHRO or ts==TYPE_XYZ or ts==TYPE_PENDULUM then
		return c:IsType(ts)
	else
		if bit.band(ts,TYPE_FUSION) and c:IsType(TYPE_FUSION) then
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,ts-TYPE_FUSION) then return true end
		end
		if bit.band(ts,TYPE_SYNCHRO) and c:IsType(TYPE_SYNCHRO) then
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,ts-TYPE_SYNCHRO) then return true end
		end
		if bit.band(ts,TYPE_XYZ) and c:IsType(TYPE_XYZ) then
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,ts-TYPE_XYZ) then return true end
		end
		if bit.band(ts,TYPE_PENDULUM) and c:IsType(TYPE_PENDULUM) then
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,ts-TYPE_PENDULUM) then return true end
		end
		return false
	end
end
function c100912039.fusfilter_s(c,mg,ts)
	if not c:IsRace(RACE_DRAGON) then return false end
	if ts==TYPE_FUSION or ts==TYPE_SYNCHRO or ts==TYPE_XYZ or ts==TYPE_PENDULUM then
		return c:IsType(ts)
	else
		if bit.band(ts,TYPE_FUSION) and c:IsType(TYPE_FUSION) then
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,ts-TYPE_FUSION) then return true end
		end
		if bit.band(ts,TYPE_SYNCHRO) and c:IsType(TYPE_SYNCHRO) then
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,ts-TYPE_SYNCHRO) then return true end
		end
		if bit.band(ts,TYPE_XYZ) and c:IsType(TYPE_XYZ) then
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,ts-TYPE_XYZ) then return true end
		end
		if bit.band(ts,TYPE_PENDULUM) and c:IsType(TYPE_PENDULUM) then
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,ts-TYPE_PENDULUM) then return true end
		end
		return false
	end
end
function c100912039.fusfilter_a(c)
	if not c:IsRace(RACE_DRAGON) then return false,false,false,false end
	return c:IsType(TYPE_FUSION),c:IsType(TYPE_SYNCHRO),c:IsType(TYPE_XYZ),c:IsType(TYPE_PENDULUM)
end
function c100912039.get_type(c)
	if c:IsType(TYPE_FUSION) then return TYPE_FUSION
	elseif c:IsType(TYPE_SYNCHRO) then return TYPE_SYNCHRO
	elseif c:IsType(TYPE_XYZ) then return TYPE_XYZ
	else return TYPE_PENDULUM end
end
function c100912039.group_check(c,g2,g3,g4)
	if not g4 and not g3 then
		return g2:IsExists(aux.TRUE,1,c)
	elseif not g4 then
		local n2=g2:Clone() n2:RemoveCard(c)
		local n3=g3:Clone() n3:RemoveCard(c)
		return n2:IsExists(c100912039.group_check,1,nil,n3)
	else
		local n2=g2:Clone() n2:RemoveCard(c)
		local n3=g3:Clone() n3:RemoveCard(c)
		local n4=g4:Clone() n4:RemoveCard(c)
		return n2:IsExists(c100912039.group_check,1,nil,n3,n4)
	end
end
function c100912039.fuscon(e,g,gc,chkfnf)
	if g==nil then return false end
	local chkf=bit.band(chkfnf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		local bf,bs,bx,bp=c100912039.fusfilter_a(gc)
		local at=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM
		if bf then
			local mg2=mg:Clone()
			mg2:RemoveCard(gc)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,at-TYPE_FUSION) then return true end
		end
		if bs then
			local mg2=mg:Clone()
			mg2:RemoveCard(gc)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,at-TYPE_SYNCHRO) then return true end
		end
		if bx then
			local mg2=mg:Clone()
			mg2:RemoveCard(gc)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,at-TYPE_XYZ) then return true end
		end
		if bp then
			local mg2=mg:Clone()
			mg2:RemoveCard(gc)
			if mg2:IsExists(c100912039.fusfilter_s,1,nil,mg2,at-TYPE_PENDULUM) then return true end
		end
		return false
	end
	local g1=Group.CreateGroup() local g2=Group.CreateGroup() local g3=Group.CreateGroup() local g4=Group.CreateGroup() local fs=false
	local tc=mg:GetFirst()
	while tc do
		if c100912039.fusfilter_s(tc,nil,TYPE_FUSION) then
			g1:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then fs=true end
		end
		if c100912039.fusfilter_s(tc,nil,TYPE_SYNCHRO) then
			g2:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then fs=true end
		end
		if c100912039.fusfilter_s(tc,nil,TYPE_XYZ) then
			g3:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then fs=true end
		end
		if c100912039.fusfilter_s(tc,nil,TYPE_PENDULUM) then
			g4:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then fs=true end
		end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		return fs and g1:IsExists(c100912039.group_check,1,nil,g2,g3,g4)
	else
		return g1:IsExists(c100912039.group_check,1,nil,g2,g3,g4)
	end
end
function c100912039.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local chkf=bit.band(chkfnf,0xff)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	local at=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM
	if gc then
		local g1=Group.FromCards(gc)
		local bf,bs,bx,bp=c100912039.fusfilter_a(gc)
		local mg=g:Clone()
		mg:RemoveCard(gc)
		local ts=at
		if bf then
			ts=ts-TYPE_FUSION
		elseif bs then
			ts=ts-TYPE_SYNCHRO
		elseif bx then
			ts=ts-TYPE_XYZ
		else 
			ts=ts-TYPE_PENDULUM
		end
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg=mg:FilterSelect(tp,c100912039.fusfilter_s,1,1,nil,mg,ts)
			g1:AddCard(sg:GetFirst())
			mg:RemoveCard(sg:GetFirst())
			ts=ts-c100912039.get_type(sg:GetFirst())
		end
		Duel.SetFusionMaterial(g1)
		return
	end
	local g1=Group.CreateGroup()
	local ts=at
	local mg=g:Clone()
	local sg=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		sg=mg:FilterSelect(tp,c100912039.fusfilter_sf,1,1,nil,mg,ts,chkf)
	else
		sg=mg:FilterSelect(tp,c100912039.fusfilter_s,1,1,nil,mg,ts)
	end
	g1:AddCard(sg:GetFirst())
	mg:RemoveCard(sg:GetFirst())
	ts=ts-c100912039.get_type(sg:GetFirst())
	for i=2,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=mg:FilterSelect(tp,c100912039.fusfilter_s,1,1,nil,mg,ts)
		g1:AddCard(sg2:GetFirst())
		mg:RemoveCard(sg2:GetFirst())
		ts=ts-c100912039.get_type(sg2:GetFirst())
	end
	Duel.SetFusionMaterial(g1)
end
function c100912039.limval(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and not rc:IsImmuneToEffect(e)
end
function c100912039.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c100912039.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c100912039.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=nil
	if eg then g=eg:Filter(c100912039.ddfilter,nil,tp) end
	if chk==0 then return g and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100912039.ddop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c100912039.ddfilter,nil,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c100912039.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100912039.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c100912039.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c100912039.spfilter(c,e,tp)
	return c:IsSetCard(0x21fb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100912039.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100912039.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100912039.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100912039.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100912039.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c100912039.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c100912039.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
