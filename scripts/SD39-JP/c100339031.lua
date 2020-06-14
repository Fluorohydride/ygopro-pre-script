--憑依連携
--
--Script by JustFish
function c100339031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100339031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,100339031)
	e1:SetTarget(c100339031.target)
	e1:SetOperation(c100339031.activate)
	c:RegisterEffect(e1)
	--to field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100339031,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100339031)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100339031.tftg)
	e2:SetOperation(c100339031.tfop)
	c:RegisterEffect(e2)
end
function c100339031.filter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsDefense(1500)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function c100339031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100339031.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c100339031.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100339031.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local spos=0
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then spos=spos+POS_FACEUP_ATTACK end
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
		if spos~=0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,spos) end
		if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	end
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if mg:GetClassCount(Card.GetAttribute)>=2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100339031,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c100339031.tffilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0xc0) and not c:IsForbidden()
end
function c100339031.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c100339031.tffilter(chkc) and c:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100339031.tffilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c100339031.tffilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c100339031.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
