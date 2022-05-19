--变形斗士·变换装置
--Script by Ruby
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate(Atk_Position)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
    --Activate(Def_Position)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.atkfilter(c,e,tp)
	return c:IsFaceup() and c:IsPosition(POS_ATTACK) and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
        and Duel.IsExistingMatchingCard(s.atkspfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function s.atkspfilter(c,e,tp,code)
        return c:IsSetCard(0x26) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.atkfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.atkfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.atkfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.deffilter(c,e,tp)
    --and c:IsCanChangePosition()
	return c:IsFaceup() and c:IsPosition(POS_DEFENSE) and c:IsRace(RACE_MACHINE)
        and Duel.IsExistingMatchingCard(s.defspfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function s.defspfilter(c,e,tp)
        return c:IsRace(RACE_MACHINE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.deffilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.deffilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.deffilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.deffilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return
    elseif tc:IsPosition(POS_ATTACK) and tc:IsFaceup() then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,s.atkspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
            Duel.BreakEffect()
            Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
        end
    elseif tc:IsPosition(POS_DEFENSE) and Duel.ChangePosition(tc,POS_FACEUP_ATTACK)~=0  then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g2=Duel.SelectMatchingCard(tp,s.defspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
        if g2:GetCount()>0 then
            Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end