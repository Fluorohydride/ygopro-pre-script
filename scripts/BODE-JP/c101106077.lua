--魔鍵錠-瓶-
--scripted by XyLeN
function c101106077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c101106077.cost)
	e1:SetTarget(c101106077.target)
	e1:SetOperation(c101106077.activate)
	c:RegisterEffect(e1)
end
function c101106077.cfilter(c)
	return not c:IsType(TYPE_TOKEN) and (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x165)) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c101106077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101106077.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c101106077.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c101106077.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) or c:IsSetCard(0x165) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101106077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101106077.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then return g:CheckWithSumEqual(Card.GetLevel,8,1,ft) end
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,8,1,ft)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101106077.syncsumfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x165) and c:IsSynchroSummonable(nil)
end
function c101106077.xyzsumfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x165) and c:IsXyzSummonable(nil)
end
function c101106077.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if g:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	local res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	local b1=Duel.IsExistingMatchingCard(c101106077.syncsumfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c101106077.xyzsumfilter,tp,LOCATION_EXTRA,0,1,nil)
	if res~=0 and (b1 or b2) then
		Duel.BreakEffect()
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(101106077,0)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(101106077,1)
			opval[off]=1
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=Duel.SelectMatchingCard(tp,c101106077.syncsumfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.SynchroSummon(tp,sg1:GetFirst(),nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=Duel.SelectMatchingCard(tp,c101106077.xyzsumfilter,tp,LOCATION_EXTRA,0,1,1,nil)
			Duel.XyzSummon(tp,sg2:GetFirst(),nil)
		end
	end
end
