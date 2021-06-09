--ふわんだりぃずと未知の風
--Script By JSY1728
function c101106059.initial_effect(c)
	--Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106059,0))
	e1:SetTyoe(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c101106059.otcon)
	e1:SetTarget(c101106059.ottg)
	e1:SetOperation(c101106059.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	--Send to Deck & Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106059,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101106059)
	e2:SetTarget(c101106059.drtg)
	e2:SetOperation(c101106059.drop)
	c:RegisterEffect(e2)
end
function c101106059.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,0,LOCATION_ONFIELD,1,nil)
end
function c101106059.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2 and c:IsType(TYPE_MONSTER)
end
function c101106059.otop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c101106059.drfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAbleToDeck() and not c:IsPublic()
end
function c101106059.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c101106059.drfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c101106059.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c101106059.drfilter,p,LOCATION_HAND,0,1,2,nil)
	local ct=g:GetCount()
	if ct>0 then
		Duel.ConfirmCards(1-p,ct)
		Duel.SortDecktop(p,p,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(mg:GetFirst(),1)
			Duel.BreakEffect()
			Duel.Draw(p,ct,REASON_EFFECT)
			Duel.ShuffleHand(p)
		end
	end
end