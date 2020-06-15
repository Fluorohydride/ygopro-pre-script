--Number 3: Cicada King
function c100266028.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100266028,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100266028)
	e1:SetTarget(c100266028.sptg)
	e1:SetOperation(c100266028.spop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100266028,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,100266028+100)
	e2:SetCost(c100266028.discost)
	e2:SetTarget(c100266028.distg)
	e2:SetOperation(c100266028.disop)
	c:RegisterEffect(e2)
end
function c100266028.tgfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100266028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and
		Duel.IsExistingMatchingCard(c100266028.tgfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c100266028.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100266028.tgfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if not g then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end

function c100266028.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100266028.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsFaceup()
end
function c100266028.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=re:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c100266028.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and not tc:IsDisabled() and tc:IsControler(1-tp) and tc:IsOnField() and tc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tc)
end

function c100266028.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE_EFFECT)
		e1:SetValue(RESET_TURN_SET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if Duel.IsExistingMatchingCard(c100266028.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			local opt=Duel.SelectOption(tp,aux.Stringid(100266028,2),aux.Stringid(100266028,3),aux.Stringid(100266028,4))
			if opt==2 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local g=Duel.SelectMatchingCard(tp,c100266028.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
			if not g then return end
			if opt==0 then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				e3:SetValue(500)
				tc:RegisterEffect(e3)
			else
				Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEDOWN_ATTACK,POS_FACEUP_ATTACK,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end