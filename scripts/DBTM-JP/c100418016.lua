--白銀の城の召使い アリアーヌ
--
--Script by Trishula9
function c100418016.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100418016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100418016)
	e1:SetCost(c100418016.spcost)
	e1:SetTarget(c100418016.sptg)
	e1:SetOperation(c100418016.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100418016,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100418016+100)
	e2:SetCondition(c100418016.drcon)
	e2:SetTarget(c100418016.drtg)
	e2:SetOperation(c100418016.drop)
	c:RegisterEffect(e2)
end
function c100418016.costfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFacedown()) and c:GetType()==TYPE_TRAP and c:IsAbleToGraveAsCost()
end
function c100418016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418016.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100418016.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100418016.spfilter(c,e,tp)
	return not c:IsCode(100418016) and c:IsRace(RACE_FIEND) and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100418016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100418016.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100418016.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100418016.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c100418016.cfilter(c,tp,re,r,rp)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0 and bit.band(r,REASON_EFFECT)~=0 and rp==tp
		and re:GetHandler():GetType()==TYPE_TRAP and re:IsActiveType(TYPE_TRAP)
end
function c100418016.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100418016.cfilter,1,nil,tp,re,r,rp)
end
function c100418016.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100418016.spfilter2(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100418016.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local off=1
		local ops={}
		local opval={}
		local spg=Duel.GetMatchingGroup(c100418016.spfilter2,tp,LOCATION_HAND,0,nil,e,tp)
		local stg=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil)
		if #spg>0 then
			ops[off]=aux.Stringid(100418016,2)
			opval[off-1]=1
			off=off+1
		end
		if #stg>0 then
			ops[off]=aux.Stringid(100418016,3)
			opval[off-1]=2
			off=off+1
		end
		ops[off]=aux.Stringid(100418016,4)
		opval[off-1]=0
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=spg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
		if opval[op]==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=stg:Select(tp,1,1,nil)
			Duel.SSet(tp,sg,tp,false)
		end
	end
end
