--防火龙·奇点
--Script by 奥克斯
function c101112047.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--return tohand 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112047,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,101112047)
	e1:SetTarget(c101112047.thtg)
	e1:SetOperation(c101112047.thop)
	c:RegisterEffect(e1)	
	--Special Summon 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c101112047.regcon)
	e2:SetOperation(c101112047.regop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c101112047.regcon2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101112047,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_CUSTOM+101112047)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101112048)
	e4:SetTarget(c101112047.sptg)
	e4:SetOperation(c101112047.spop)
	c:RegisterEffect(e4)
end

function c101112047.filter(c)   
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c101112047.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c101112047.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return #g>0 and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local ct=0
	for i,type in ipairs({TYPE_RITUAL,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ}) do
		if g:IsExists(Card.IsType,1,nil,type) then
			ct=ct+1
		end
	end
	Debug.Message(ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,ct,nil)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		local loc=LOCATION_GRAVE 
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) then
			loc=LOCATION_ONFIELD+LOCATION_GRAVE 
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,1-tp,loc)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	end
end
function c101112047.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)   
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

function c101112047.cfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:IsPreviousControler(1-tp) then seq=seq+16 end
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function c101112047.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112047.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c101112047.cfilter2(c,tp,zone)
	return not c:IsReason(REASON_BATTLE) and c101112047.cfilter(c,tp,zone)
end
function c101112047.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112047.cfilter2,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c101112047.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+101112047,e,0,tp,0,0)
end
function c101112047.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112047.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101112047.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101112047.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101112047.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101112047.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end  