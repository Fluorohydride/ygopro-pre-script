--電幻機塊コンセントロール
--Appliancer Socketroll
--Scripted by TheBoos2569
function c100266035.initial_effect(c)
	--Special Summon self
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100266035,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100266035)
	e1:SetCondition(c100266035.spcon1)
	e1:SetTarget(c100266035.sptg1)
	e1:SetOperation(c100266035.spop1)
	c:RegisterEffect(e1)
	--Special Summon from Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100266035,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100266035+100)
	e2:SetCondition(c100266035.spcon2)
	e2:SetTarget(c100266035.sptg2)
	e2:SetOperation(c100266035.spop2)
	c:RegisterEffect(e2)
end
function c100266035.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x24b)
end
function c100266035.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100266035.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c100266035.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100266035.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c100266035.cfilter2(c,tp)
	return c:IsFaceup() and c:IsCode(100266035) and c:IsControler(tp)
end
function c100266035.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c100266035.cfilter2,1,nil,tp)
end
function c100266035.spfilter(c,e,tp)
	return c:IsCode(100266035) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100266035.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100266035.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100266035.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100266035.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
