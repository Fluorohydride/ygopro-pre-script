--夢幻崩界イヴリース
--Destroymare Iblee
--Scripted by Eerie Code
function c101004017.initial_effect(c)
	--spsummon link
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c101004017.sptg)
	e1:SetOperation(c101004017.spop)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c101004017.splimit)
	c:RegisterEffect(e2)
	--spsummon opp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101004017,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101004017)
	e3:SetCondition(c101004017.condition)
	e3:SetTarget(c101004017.target)
	e3:SetOperation(c101004017.operation)
	c:RegisterEffect(e3)
end
function c101004017.get_zone(c,seq)
	local zone=0
	if seq<4 and c:IsLinkMarker(LINK_MARKER_LEFT) then zone=bit.bor(zone,math.pow(2,seq-1)) end
	if seq>0 and seq<5 and c:IsLinkMarker(LINK_MARKER_RIGHT) then zone=bit.bor(zone,math.pow(2,seq+1)) end
	return zone
end
function c101004017.spfilter(c,e,tp,seq)
	local zone=c101004017.get_zone(c,seq)
	return zone~=0 and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101004017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local seq=e:GetHandler():GetSequence()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101004017.spfilter(chkc,e,tp,seq) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101004017.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,seq) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101004017.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,seq)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101004017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and tc:IsRelateToEffect(e) then
		local zone=c101004017.get_zone(tc,c:GetSequence())
		if zone~=0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CHANGE_ATTACK_FINAL)
			e3:SetValue(0)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		Duel.SpecialSummonComplete()
	end
end
function c101004017.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsType(TYPE_LINK)
end
function c101004017.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():GetPreviousControler()==tp
end
function c101004017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101004017.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end
