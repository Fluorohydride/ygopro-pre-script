--H-C ヤールングレイプ
--
--Script by Trishula9
function c101108045.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),1,2)
	c:EnableReviveLimit()
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101108045.indtg)
	e1:SetValue(c101108045.indct)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101108045)
	e2:SetCost(c101108045.spcost)
	e2:SetTarget(c101108045.sptg)
	e2:SetOperation(c101108045.spop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101108045+100)
	e3:SetCondition(c101108045.rccon)
	e3:SetOperation(c101108045.rcop)
	c:RegisterEffect(e3)
end
function c101108045.indtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c101108045.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c101108045.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c101108045.spfilter(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and (c:IsLevel(4) or c:IsRank(4)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101108045.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101108045.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101108045.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101108045.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101108045.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and c:IsRelateToEffect(e) and c:IsFaceup() and not c:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c101108045.rccon(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetBattleMonster(1-tp)
	return tc and tc:IsRelateToBattle()
end
function c101108045.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetBattleMonster(1-tp)
	if tc and tc:IsRelateToBattle() then
		Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)
	end
end