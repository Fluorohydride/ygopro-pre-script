--セットアッパー
--
--Script by mercury233
function c101009078.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,101009078+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101009078.condition)
	e1:SetTarget(c101009078.target)
	e1:SetOperation(c101009078.activate)
	c:RegisterEffect(e1)
end
function c101009078.cfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function c101009078.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(c101009078.cfilter,nil,tp):GetFirst()
	if not tc then return false end
	local atk=tc:GetAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	return true
end
function c101009078.spfilter(c,e,tp,atk)
	return c:IsAttackBelow(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c101009078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101009078.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101009078.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101009078.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
