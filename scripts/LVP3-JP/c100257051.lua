--幻獣機アウローラドン

--Scripted by mallu11
function c100257051.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_MACHINE),2)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100257051,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c100257051.tkcon)
	e1:SetTarget(c100257051.tktg)
	e1:SetOperation(c100257051.tkop)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100257051,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c100257051.rlcost)
	e2:SetTarget(c100257051.rltg)
	e2:SetOperation(c100257051.rlop)
	c:RegisterEffect(e2)
end
function c100257051.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c100257051.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100257151,0x101b,0x4011,0,0,3,RACE_MACHINE,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
end
function c100257051.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100257151,0x101b,0x4011,0,0,3,RACE_MACHINE,ATTRIBUTE_WIND) then
		local ct=3
		while ct>0 do
			local token=Duel.CreateToken(tp,100257151)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			ct=ct-1
		end
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100257051.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100257051.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c100257051.rlfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c100257051.fselect(g,tp)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g) then
		Duel.SetSelectedCard(g)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c100257051.spfilter(c,e,tp)
	return c:IsSetCard(0x101b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100257051.thfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c100257051.rlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
	local ct=g:GetCount()
	local b1=ct>0 and g:CheckSubGroup(c100257051.fselect,1,1,tp)
	local b2=ct>1 and g:IsExists(c100257051.rlfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c100257051.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local b3=ct>2 and Duel.IsExistingMatchingCard(c100257051.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local off=0
	local ops={}
	local opval={}
	off=1
	if b1 then
		ops[off]=aux.Stringid(100257051,2)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100257051,3)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(100257051,4)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
	local rg=nil
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		rg=g:SelectSubGroup(tp,c100257051.fselect,false,1,1,tp)
	elseif opval[op]==2 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			rg=g:FilterSelect(tp,c100257051.rlfilter,1,1,nil,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg2=g:Select(tp,1,1,g1:GetFirst())
			rg:Merge(rg2)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			rg=g:Select(tp,2,2,nil)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		rg=g:Select(tp,3,3,nil)
	end
	Duel.Release(rg,REASON_COST)
end
function c100257051.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sel=e:GetLabel()
	local cat=e:GetCategory()
	if sel==1 then
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		e:SetCategory(bit.bor(cat,CATEGORY_DESTROY))
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
	elseif sel==2 then
		e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(bit.bor(cat,CATEGORY_TOHAND))
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function c100257051.rlop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif sel==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100257051.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100257051.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
