--死の王 ヘル

--Scripted by nekrozar
function c100413032.initial_effect(c)
	c:SetUniqueOnField(1,0,100413032)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100413032,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100413032)
	e1:SetCost(c100413032.spcost)
	e1:SetTarget(c100413032.sptg)
	e1:SetOperation(c100413032.spop)
	c:RegisterEffect(e1)
end
function c100413032.costfilter(c,e,tp)
	return (c:IsSetCard(0x134) or c:IsRace(RACE_ZOMBIE)) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c100413032.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c100413032.spfilter(c,e,tp,code)
	return (c:IsSetCard(0x134) or c:IsRace(RACE_ZOMBIE)) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100413032.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100413032.costfilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c100413032.costfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
end
function c100413032.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local code=e:GetLabel()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100413032.spfilter(chkc,e,tp,code) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100413032.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,code)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100413032.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
