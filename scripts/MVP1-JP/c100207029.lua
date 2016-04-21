--ファイナル・ギアス
--Final Geas
--Script by dest
function c100207029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_TOGRAVE)
	e1:SetTarget(c100207029.target)
	e1:SetOperation(c100207029.activate)
	c:RegisterEffect(e1)	
	if not c100207029.global_check then
		c100207029.global_check=true
		c100207029[0]=false
		c100207029[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c100207029.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c100207029.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100207029.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLevelAbove(7) and tc:IsPreviousLocation(LOCATION_MZONE) then
			c100207029[tc:GetPreviousControler()]=true
		end
		tc=eg:GetNext()
	end
end
function c100207029.clear(e,tp,eg,ep,ev,re,r,rp)
	c100207029[0]=false
	c100207029[1]=false
end
function c100207029.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c100207029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100207029.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return c100207029[0] and c100207029[1] and g:GetCount()>0 end	
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function c100207029.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100207029.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100207029.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup():Filter(c100207029.spfilter,nil,e,tp)
		if og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100207029,0)) then
			Duel.BreakEffect()
			local sg=og:GetMaxGroup(Card.GetLevel)
			if sg:GetCount()>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				sg=sg:Select(tp,1,1,nil)
			end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
