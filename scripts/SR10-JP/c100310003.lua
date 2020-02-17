--マシンナーズ・ラディエーター

--Scripted by mallu11
function c100310003.initial_effect(c)
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100310003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100310003)
	e1:SetCost(c100310003.spcost1)
	e1:SetTarget(c100310003.sptg1)
	e1:SetOperation(c100310003.spop1)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100310003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100310103)
	e2:SetTarget(c100310003.sptg2)
	e2:SetOperation(c100310003.spop2)
	c:RegisterEffect(e2)
end
function c100310003.cfilter(c)
	return c:IsSetCard(0x36) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c100310003.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100310003.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c100310003.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c100310003.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100310003.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c100310003.desfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and Duel.IsExistingMatchingCard(c100310003.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode(),c:GetLevel())
end
function c100310003.spfilter(c,e,tp,code,lv)
	return c:IsSetCard(0x36) and not c:IsCode(code) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100310003.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100310003.desfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100310003.desfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100310003.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100310003.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100310003.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetCode(),tc:GetLevel())
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
