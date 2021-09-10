--ゴーストリック・セイレーン
--
--Script by Trishula9
function c101107014.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c101107014.sumcon)
	c:RegisterEffect(e1)
	--discard deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107014,0))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c101107014.distg)
	e2:SetOperation(c101107014.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	--turn set
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c101107014.postg)
	e4:SetOperation(c101107014.posop)
	c:RegisterEffect(e4)
end
function c101107014.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8d)
end
function c101107014.sumcon(e)
	return not Duel.IsExistingMatchingCard(c101107014.sfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101107014.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c101107014.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x8d)
end
function c101107014.thfilter(c)
	return c:IsSetCard(0x8d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c101107014.stfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:IsCanTurnSet()
end
function c101107014.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c101107014.cfilter,nil)
	if ct>0 then
		local b1=Duel.IsExistingMatchingCard(c101107014.thfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(c101107014.stfilter,tp,0,LOCATION_MZONE,1,nil)
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(101107014,1)
			opval[off]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(101107014,2)
			opval[off]=2
			off=off+1
		end
		ops[off]=aux.Stringid(101107014,3)
		opval[off]=0
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c101107014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		elseif sel==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=Duel.SelectMatchingCard(tp,c101107014.stfilter,tp,0,LOCATION_MZONE,1,1,nil)
			Duel.HintSelection(sg)
			Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c101107014.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(101107014)==0 end
	c:RegisterFlagEffect(101107014,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c101107014.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
