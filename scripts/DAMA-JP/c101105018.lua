--機巧猪－伊服岐雹荒神
--
--Script by XyleN5967
function c101105018.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101105018)
	e1:SetCondition(c101105018.spcon)
	e1:SetTarget(c101105018.sptg)
	e1:SetOperation(c101105018.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105018,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101105018+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101105018.tgtg)
	e2:SetOperation(c101105018.tgop)
	c:RegisterEffect(e2)
end
function c101105018.cfilter(c)
	return c:IsFaceup() and aux.AtkEqualsDef(c) and c:IsRace(RACE_MACHINE)
end
function c101105018.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101105018.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101105018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101105018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101105018.tcfilter(c,tp)
	local lv=c:GetLevel()
	return c:IsFaceup() and lv>0 and aux.AtkEqualsDef(c) and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(c101105018.tgfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function c101105018.tgfilter(c,lv)
	return aux.AtkEqualsDef(c) and c:GetLevel()<lv
		and c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function c101105018.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101105018.tcfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101105018.tcfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101105018.tcfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101105018.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c101105018.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel())
	local sc=sg:GetFirst()
	if sc and Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) then
		local lv=sc:GetLevel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
