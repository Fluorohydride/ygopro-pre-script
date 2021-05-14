--クリバビロン
--Script by XyLeN
function c100278005.initial_effect(c)
	--special summon itself
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(100278005,0)) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,100278005)
	e1:SetCondition(c100278005.spcon1)
	e1:SetTarget(c100278005.sptg1)
	e1:SetOperation(c100278005.spop1)
	c:RegisterEffect(e1)
	--gains atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(c100278005.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone() 
	e3:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e3)
	--special summon in grave
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(100278005,1)) 
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE) 
	e4:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_END)
	e4:SetCountLimit(1,100278005)
	e4:SetCondition(c100278005.spcon2)
	e4:SetTarget(c100278005.sptg2)
	e4:SetOperation(c100278005.spop2)
	c:RegisterEffect(e4)
end
function c100278005.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function c100278005.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100278005.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100278005.atkfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xa4) 
end
function c100278005.atkval(e)
	return Duel.GetMatchingGroupCount(c100278005.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil)*300
end
function c100278005.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp
		and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c100278005.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c100278005.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c100278005.spfilter,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,100278001)
		and Duel.IsExistingMatchingCard(c100278005.spfilter,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,100278002)
		and Duel.IsExistingMatchingCard(c100278005.spfilter,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,100278003)
		and Duel.IsExistingMatchingCard(c100278005.spfilter,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,100278004)
		and Duel.IsExistingMatchingCard(c100278005.spfilter,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,40640057)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,5,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c100278005.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100278005.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp,100278001)
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100278005.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp,100278002)
		local g3=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100278005.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp,100278003)
		local g4=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100278005.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp,100278004)
		local g5=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100278005.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp,40640057)
		if g1:GetCount()>0 and g2:GetCount()>0 and g3:GetCount()>0 and g4:GetCount()>0 and g5:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g2:Select(tp,1,1,nil)
			sg1:Merge(sg2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg3=g3:Select(tp,1,1,nil)
			sg1:Merge(sg3)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg4=g4:Select(tp,1,1,nil)
			sg1:Merge(sg4)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg5=g5:Select(tp,1,1,nil)
			sg1:Merge(sg5)
			Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end
