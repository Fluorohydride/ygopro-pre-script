--H·C ナックル・ナイフ
--
--Script by Trishula9
function c101108015.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108015,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101108015)
	e1:SetCondition(c101108015.spcon)
	e1:SetTarget(c101108015.sptg)
	e1:SetOperation(c101108015.spop)
	c:RegisterEffect(e1)
	--lv change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108015,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101108015+100)
	e2:SetTarget(c101108015.lvtg)
	e2:SetOperation(c101108015.lvop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101108015.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f) and not c:IsLevel(1)
end
function c101108015.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101108015.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c101108015.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101108015.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101108015.lvfilter(c,lv)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsLevelAbove(1) and not c:IsLevel(lv)
end
function c101108015.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101108015.lvfilter(chkc,lv) end
	if chk==0 then return lv>0 and Duel.IsExistingTarget(c101108015.lvfilter,tp,LOCATION_MZONE,0,1,c,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101108015.lvfilter,tp,LOCATION_MZONE,0,1,1,c,lv)
end
function c101108015.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsLevel(c:GetLevel()) then
		local g=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101108015,2))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		g:RemoveCard(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetLevel())
		g:GetFirst():RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101108015.atktg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c101108015.atktg(e,c)
	return not c:IsType(TYPE_XYZ)
end
