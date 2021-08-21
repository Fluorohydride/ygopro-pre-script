--エクソシスター・エリス
--
--Scripted by KillerDJ
function c100417013.initial_effect(c)
	aux.AddCodeList(c,100417014)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100417013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100417013)
	e1:SetCondition(c100417013.effcon)
	e1:SetTarget(c100417013.efftg)
	e1:SetOperation(c100417013.effop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100417013,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100417013+100)
	e2:SetCondition(c100417013.spcon)
	e2:SetTarget(c100417013.sptg)
	e2:SetOperation(c100417013.spop)
	c:RegisterEffect(e2)
end
function c100417013.filter(c)
	return c:IsPreviousLocation(LOCATION_GRAVE)
end
function c100417013.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x271)
end
function c100417013.cfilter1(c)
	return c:IsFaceup() and c:IsCode(100417014)
end
function c100417013.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100417013.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100417013.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100417013.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c100417013.cfilter1,tp,LOCATION_MZONE,0,1,nil) then
			Duel.BreakEffect()
			Duel.Recover(tp,800,REASON_EFFECT)
	end
end
function c100417013.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c100417013.filter,1,nil)
end
function c100417013.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x696) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c100417013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c100417013.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100417013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100417013.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
