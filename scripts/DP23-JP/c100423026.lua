--シンクロ・チェイス

--Scripted by mallu11
function c100423026.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100423026,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100423026)
	e2:SetCondition(c100423026.spcon)
	e2:SetTarget(c100423026.sptg)
	e2:SetOperation(c100423026.spop)
	c:RegisterEffect(e2)
	--can not chain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c100423026.ccon)
	e3:SetOperation(c100423026.ccop)
	c:RegisterEffect(e3)
end
function c100423026.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsType(TYPE_SYNCHRO) and (c:IsSetCard(0x66) or c:IsSetCard(0x1017) or c:IsSetCard(0xa3))
end
function c100423026.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100423026.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100423026.cfilter,1,nil) and rp==tp
end
function c100423026.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=eg:Filter(c100423026.cfilter,nil):GetFirst():GetMaterial()
	if chkc then return mg:IsContains(chkc) and c100423026.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and mg:IsExists(c100423026.spfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:FilterSelect(tp,c100423026.spfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100423026.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c100423026.ccon(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return re:GetHandlerPlayer()==tp and tc:IsType(TYPE_SYNCHRO) and (tc:IsSetCard(0x66) or tc:IsSetCard(0x1017) or tc:IsSetCard(0xa3))
end
function c100423026.ccop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c100423026.chainlm)
end
function c100423026.chainlm(e,rp,tp)
	return tp==rp
end
