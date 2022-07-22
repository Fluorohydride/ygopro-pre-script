--Spirit Cucomeback Horse
--Scripted by: XGlitchy30

function c101110036.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--selfremoval
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetCondition(c101110036.selftogy)
	c:RegisterEffect(e1)
	--SS
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110036,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101110036)
	e2:SetLabel(0)
	e2:SetCost(c101110036.spcost)
	e2:SetTarget(c101110036.sptg)
	e2:SetOperation(c101110036.spop)
	c:RegisterEffect(e2)
end
function c101110036.selftogy()
	local ph=Duel.GetCurrentPhase()
	return ph<PHASE_BATTLE_START or ph>PHASE_BATTLE
end

function c101110036.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_PLANT) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0 and (c:IsFaceup() or not c:IsOnField())
end
function c101110036.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.IsExistingMatchingCard(c101110036.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101110036.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c101110036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res = e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		e:SetLabel(0)
		return res and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
end
function c101110036.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101110036.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToChain(0) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g0=Group.FromCards(c)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(101110036,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c101110036.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(101110036,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101110036.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
			if #g>0 then
				Duel.BreakEffect()
				if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
					g:GetFirst():RegisterFlagEffect(101110036,RESET_EVENT+RESETS_STANDARD,0,1,fid)
					g0:AddCard(g:GetFirst())
				end
			end
		end
		if #g0>0 then
			g0:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(g0)
			e1:SetCondition(c101110036.tgcon)
			e1:SetOperation(c101110036.tgop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c101110036.tgfilter(c,fid)
	return c:GetFlagEffectLabel(101110036)==fid
end
function c101110036.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if g and not g:IsExists(c101110036.tgfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return true
end
function c101110036.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject():Filter(c101110036.tgfilter,nil,e:GetLabel())
	Duel.SendtoGrave(tg,REASON_EFFECT)
end