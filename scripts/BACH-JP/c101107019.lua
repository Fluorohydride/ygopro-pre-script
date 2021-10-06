--変異体ミュートリア
--
--Script by Trishula9
function c101107019.initial_effect(c)
	--self spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101107019)
	e1:SetCondition(c101107019.sscon)
	e1:SetTarget(c101107019.sstg)
	e1:SetOperation(c101107019.ssop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101107019+100)
	e2:SetCost(c101107019.spcost)
	e2:SetTarget(c101107019.sptg)
	e2:SetOperation(c101107019.spop)
	c:RegisterEffect(e2)
end
function c101107019.ssfilter(c)
	return c:IsSetCard(0x157) and c:IsFaceup()
end
function c101107019.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101107019.ssfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101107019.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101107019.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101107019.spcostexcheckfilter(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(code)
end
function c101107019.spcostexcheck(c,e,tp)
	local result=false
	if c:IsType(TYPE_MONSTER) then
		result=result or Duel.IsExistingMatchingCard(c101107019.spcostexcheckfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,e,tp,34695290)
	end
	if c:IsType(TYPE_SPELL) then
		result=result or Duel.IsExistingMatchingCard(c101107019.spcostexcheckfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,e,tp,61089209)
	end
	if c:IsType(TYPE_TRAP) then
		result=result or Duel.IsExistingMatchingCard(c101107019.spcostexcheckfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c,e,tp,7574904)
	end
	return result
end
function c101107019.spcostfilter(c,e,tp)
	return c:IsSetCard(0x157) and c:IsAbleToRemoveAsCost() and c101107019.spcostexcheck(c,e,tp)
end
function c101107019.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(100)
		return Duel.IsExistingMatchingCard(c101107019.spcostfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
			and e:GetHandler():IsReleasable() and Duel.GetMZoneCount(tp,e:GetHandler())>0
	end
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,c101107019.spcostfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	e:SetLabel(cost:GetType())
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end
function c101107019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101107019.spopfilter(c,e,tp,typ)
	return (((typ & TYPE_MONSTER)>0 and c:IsCode(34695290))
		or ((typ & TYPE_SPELL)>0 and c:IsCode(61089209))
		or ((typ & TYPE_TRAP)>0 and c:IsCode(7574904)))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101107019.spop(e,tp,eg,ep,ev,re,r,rp)
	local typ=e:GetLabel()
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101107019.spopfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,typ):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SetLP(tp,Duel.GetLP(tp)-tc:GetTextAttack())
	end
end