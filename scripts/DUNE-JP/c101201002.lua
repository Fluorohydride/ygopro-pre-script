--coded by Lyris
--not fully implemented
--Revolution Synchron
local s, id, o = GetID()
function s.initial_effect(c)
	--hand synchro HOpT
	--snip 1: edited from "Malefic Paradox Gear"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(id)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,id)
	c:RegisterEffect(e0)
	--end snip 1
	--register HOpT
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_PRE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e1:SetLabelObject(e0)
	e1:SetCondition(s.hsregcon)
	e1:SetOperation(s.hsynreg)
	c:RegisterEffect(e1)
	--spsum self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--hand synchro --! may need EFFECT_EXTRA_SYNCHRO_MATERIAL
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(s.syncon)
	e3:SetTarget(s.syntg)
	e3:SetOperation(aux.SynOperation())
	e3:SetValue(SUMMON_TYPE_SYNCHRO)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_HAND)
	e4:SetTargetRange(LOCATION_EXTRA,0)
	e4:SetTarget(aux.TargetBoolFunction(s.hsynfilter))
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function s.hsynfilter(c)
	return c:IsType(TYPE_SYNCHRO) and (c:IsLevel(7,8) and c:IsRace(RACE_DRAGON) or c:IsSetCard(0xc2))
end
function s.hsregcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SYNCHRO and s.hsynfilter(c:GetReasonCard()) and c:IsPreviousLocation(LOCATION_HAND)
end
function s.hsynreg(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():UseCountLimit(tp)
end
function s.hsfilter(c,tp,f)
	return c:IsHasEffect(id,tp) and (not f1 or f1(tc))
end
function s.syncon(e,c,smat,mg1,min,max)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) then return false end
	local mt=getmetatable(c)
	local f1,f4,f2,f3=mt.material_reqs[1],mt.material_reqs[2],mt.material_reqs[3],mt.material_reqs[4]
	if not mt.material_reqs or #(mt.material_reqs)==0 then f1=aux.Tuner(nil) f2=nil f3=nil f4=nil end
	local tc=Duel.GetFirstMatchingCard(s.hsfilter,tp,LOCATION_HAND,0,nil,tp,f1)
	if not tc then return false end
	local minc,maxc=aux.GetMaterialListCount(c)
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1
		mgchk=true
	else
		mg=aux.GetSynMaterials(tp,c)
	end
	return mg:IsExists(aux.SynMixFilter2,1,tc,f2,f3,f4,minc,maxc,c,mg,smat,tc,gc,mgchk)
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
	local mt=getmetatable(c)
	local f1,f4,f2,f3=mt.material_reqs[1],mt.material_reqs[2],mt.material_reqs[3],mt.material_reqs[4]
	if not mt.material_reqs or #(mt.material_reqs)==0 then f1=aux.Tuner(nil) f2=nil f3=nil f4=nil end
	local minc,maxc=aux.GetMaterialListCount(c)
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
		if minc>maxc then return false end
	end
	local g=Group.CreateGroup()
	local mg
	local mgchk=false
	if mg1 then
		mg=mg1
		mgchk=true
	else
		mg=aux.GetSynMaterials(tp,c)
	end
	if smat~=nil then mg:AddCard(smat) end
	local c1=(Duel.GetMatchingGroup(s.hsfilter,tp,LOCATION_HAND,0,nil,tp,f1):SelectSubGroup(tp,aux.TRUE,true,1,1) or Group.CreateGroup()):GetFirst()
	if not c1 then return false end
	g:AddCard(c1)
	if f2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local c2=(mg:Filter(aux.SynMixFilter2,c1,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc,mgchk):SelectSubGroup(tp,aux.TRUE,true,1,1) or Group.CreateGroup()):GetFirst()
		if not c2 then return false end
		g:AddCard(c2)
		if f3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local c3=(mg:Filter(aux.SynMixFilter3,Group.FromCards(c1,c2),f3,f4,minc,maxc,c,mg,smat,c1,c2,gc,mgchk):SelectSubGroup(tp,aux.TRUE,true,1,1) or Group.CreateGroup()):GetFirst()
			if not c3 then return false end
			g:AddCard(c3)
		end
	end
	local g4=Group.CreateGroup()
	for i=0,maxc-1 do
		local mg2=mg:Clone()
		if f4 then
			mg2=mg2:Filter(f4,g,c)
		else
			mg2:Sub(g)
		end
		local cg=mg2:Filter(aux.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,gc,mgchk)
		if #cg==0 then break end
		local minct=1
		if aux.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,gc,mgchk) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=cg:SelectSubGroup(tp,aux.TRUE,true,minct,1)
		if tg then
			if #tg==0 then break end
			g4:Merge(tg)
		else return false end
	end
	g:Merge(g4)
	if #g>0 and g:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),#g,#g,c) then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(7) and c:IsType(TYPE_SYNCHRO)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
--snip 2: edited from "Glow-Up Bulb"
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)~=0 then
		local oc=Duel.GetOperatedGroup():GetFirst()
		local c=e:GetHandler()
		if oc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			--snip 3: edited from "Gagaga Girl"
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1,true)
			--end snip 3
		end
		Duel.SpecialSummonComplete()
	end
end
--end snip 2
