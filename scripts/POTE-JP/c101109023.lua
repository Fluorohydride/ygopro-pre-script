--童话动物·小海豹
function c101109023.initial_effect(c)
	if not c101109023.reg then
		c101109023.reg = true
		--condition
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_TO_HAND)
		e0:SetOperation(c101109023.operation)
		Duel.RegisterEffect(e0,0)
	end
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101109023,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101109023)
	e1:SetCondition(c101109023.syncon)
	e1:SetTarget(c101109023.syntg)
	e1:SetOperation(c101109023.synop)
	c:RegisterEffect(e1)
	--be material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101109023,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101109023+100)
	e2:SetCondition(c101109023.xyzcon)
	e2:SetTarget(c101109023.xyztg)
	e2:SetOperation(c101109023.xyzop)
	c:RegisterEffect(e2)
end
function c101109023.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:GetPreviousRaceOnField() & RACE_BEAST)>0
		and c:IsPreviousPosition(POS_FACEUP)
end
function c101109023.operation(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c101109023.cfilter,1,nil,0) then
		Duel.RegisterFlagEffect(0,101109023,RESET_PHASE+PHASE_END,0,1)
	elseif eg:IsExists(c101109023.cfilter,1,nil,1) then
		Duel.RegisterFlagEffect(1,101109023,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101109023.syncon(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(Duel.GetFlagEffect(tp,101109023))
	return Duel.GetFlagEffect(tp,101109023)>0
end
function c101109023.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101109023.synhfilter(c,sc,tuner)
	return c:IsCanBeSynchroMaterial(sc,tuner) and c:IsRace(RACE_BEAST)
end
function c101109023.synfilter(c,mc)
	local mg=Duel.GetMatchingGroup(c101109023.synhfilter,tp,LOCATION_HAND,0,nil,c,mc)
	return c:IsSynchroSummonable(mc,mg) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c101109023.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(c101109023.synfilter,tp,LOCATION_EXTRA,0,1,nil,c) and Duel.SelectYesNo(tp,aux.Stringid(101109023,2)) then
		Duel.BreakEffect()
		local fc=Duel.SelectMatchingCard(c101109023.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,c):GetFirst()
		local mg=Duel.GetMatchingGroup(c101109023.synhfilter,tp,LOCATION_HAND,0,nil,fc,c)
		Duel.SynchroSummon(tp,fc,c,mg)
	end
end
function c101109023.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101109023.xyzfilter(c,mc)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_BEAST) and c:IsFaceup() and mc:IsCanBeXyzMaterial(c)
end
function c101109023.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101109023.xyzfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c101109023.xyzfilter,tp,LOCATION_MZONE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101109023.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,c)
end
function c101109023.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Debug.Message(tc:IsRelateToEffect(e))
	Debug.Message(c:IsRelateToEffect(e))
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not c:IsImmuneToEffect(e) and not tc:IsImmuneToEffect(e)  then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
