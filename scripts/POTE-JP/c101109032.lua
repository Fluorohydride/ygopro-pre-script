--地霊媒師アウス
--
--Script by Trishula9
function c101109032.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101109032)
	e1:SetCost(c101109032.srcost)
	e1:SetTarget(c101109032.srtg)
	e1:SetOperation(c101109032.srop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101109032+100)
	e2:SetCondition(c101109032.spcon)
	e2:SetTarget(c101109032.sptg)
	e2:SetOperation(c101109032.spop)
	c:RegisterEffect(e2)
end
function c101109032.filter(c,sc,tp)
	if not (c:IsAttribute(ATTRIBUTE_EARTH) and c:IsDiscardable()) then return false end
	local race=c:GetOriginalRace()|sc:GetOriginalRace()
	return Duel.IsExistingMatchingCard(c101109032.srfilter,tp,LOCATION_DECK,0,1,nil,race)
end
function c101109032.srfilter(c,race)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsAttackBelow(1850) and c:IsAbleToHand()
		and c:GetOriginalRace()&race>0
end
function c101109032.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101109032.filter,tp,LOCATION_HAND,0,1,c,c,tp) and c:IsDiscardable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c101109032.filter,tp,LOCATION_HAND,0,1,1,c,c,tp)
	e:SetLabelObject(g:GetFirst())
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c101109032.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()==100
		e:SetLabel(0)
		return res
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101109032.srop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	local race=c:GetOriginalRace()|sc:GetOriginalRace()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101109032.srfilter,tp,LOCATION_DECK,0,1,1,nil,race)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c101109032.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101109032.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_EARTH)
end
function c101109032.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_EARTH)~=0
end
function c101109032.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101109032.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c101109032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101109032.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
