--魔界劇団－ハイパー・ディレクター

--Scripted by mallu11
function c100257076.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c100257076.mfilter,1,1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100257076,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100257076)
	e1:SetTarget(c100257076.sptg)
	e1:SetOperation(c100257076.spop)
	c:RegisterEffect(e1)
end
function c100257076.mfilter(c)
	return c:IsLinkSetCard(0x10ec) and c:IsLinkType(TYPE_PENDULUM)
end
function c100257076.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100257076.stfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,c:GetCode())
end
function c100257076.stfilter(c,code)
	return (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x10ec) and not c:IsCode(code) and not c:IsForbidden()
end
function c100257076.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c100257076.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100257076.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100257076.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100257076.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		local code=tc:GetCode()
		local g=Duel.SelectMatchingCard(tp,c100257076.stfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,code)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100257076.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c100257076.splimit(e,c)
	return not c:IsSetCard(0x10ec)
end
