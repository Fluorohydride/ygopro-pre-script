--デフラドラグーン
--Defradragun
--Scripted by Eerie Code
function c101004011.initial_effect(c)
	--special summon (hand)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101004011)
	e1:SetCondition(c101004011.hspcon)
	e1:SetOperation(c101004011.hspop)
	c:RegisterEffect(e1)
	--special summon (grave)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101004011+100)
	e2:SetCost(c101004011.spcost)
	e2:SetTarget(c101004011.sptg)
	e2:SetOperation(c101004011.spop)
	c:RegisterEffect(e2)
end
function c101004011.hspcfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c101004011.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c101004011.hspcfilter,tp,LOCATION_HAND,0,1,c)
end
function c101004011.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101004011.hspcfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101004011.spcfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101004011.spcfilter2,tp,LOCATION_GRAVE,0,2,c,c:GetCode())
end
function c101004011.spcfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c101004011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101004011.spcfilter1,tp,LOCATION_GRAVE,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101004011.spcfilter1,tp,LOCATION_GRAVE,0,1,1,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c101004011.spcfilter2,tp,LOCATION_GRAVE,0,2,2,g:GetFirst(),g:GetFirst():GetCode())
	g:Merge(g2)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101004011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101004011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
