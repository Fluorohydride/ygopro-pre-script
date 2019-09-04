--クロノダイバー・パーペチュア

--Scripted by nekrozar
function c100258044.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100258044,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100258044)
	e1:SetCost(c100258044.spcost)
	e1:SetTarget(c100258044.sptg)
	e1:SetOperation(c100258044.spop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100258044,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100258144)
	e2:SetTarget(c100258044.mattg)
	e2:SetOperation(c100258044.matop)
	c:RegisterEffect(e2)
end
function c100258044.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100258044.spfilter(c,e,tp)
	return c:IsSetCard(0x126) and not c:IsCode(100258044) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100258044.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100258044.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100258044.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100258044.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100258044.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100258044.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c100258044.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100258044.tgfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c100258044.tgfilter,tp,LOCATION_MZONE,0,1,c)
		and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x126) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100258044.tgfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c100258044.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0x126)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
