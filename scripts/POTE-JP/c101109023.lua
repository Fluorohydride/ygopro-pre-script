--メルフィー・ラッシィ
--
--Script by JoyJ
function c101109023.initial_effect(c)
	--synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101109023,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101109023)
	e1:SetHintTiming(0,TIMING_CHAIN_END+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
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
	--
	if not c101109023.global_check then
		c101109023.global_check=true
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_TO_HAND)
		e0:SetOperation(c101109023.regop)
		Duel.RegisterEffect(e0,0)
	end
end
function c101109023.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:GetPreviousRaceOnField()&RACE_BEAST)>0
		and c:IsPreviousPosition(POS_FACEUP)
end
function c101109023.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(c101109023.cfilter,1,nil,p) then
			Duel.RegisterFlagEffect(p,101109023,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c101109023.syncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101109023)>0
end
function c101109023.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101109023.synhfilter(c,sc,tuner)
	return c:IsCanBeSynchroMaterial(sc,tuner) and c:IsSetCard(0x146)
end
function c101109023.synfilter(c,mc,tp)
	local mg=Duel.GetMatchingGroup(c101109023.synhfilter,tp,LOCATION_HAND,0,nil,c,mc)
	mg:AddCard(mc)
	return c:IsSynchroSummonable(mc,mg) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c101109023.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.IsExistingMatchingCard(c101109023.synfilter,tp,LOCATION_EXTRA,0,1,nil,c,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(101109023,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local fc=Duel.SelectMatchingCard(tp,c101109023.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,c,tp):GetFirst()
		local mg=Duel.GetMatchingGroup(c101109023.synhfilter,tp,LOCATION_HAND,0,nil,fc,c)
		mg:AddCard(c)
		Duel.SynchroSummon(tp,fc,c,mg)
	end
end
function c101109023.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101109023.xyzfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_BEAST) and c:IsFaceup()
end
function c101109023.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101109023.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101109023.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101109023.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c101109023.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
