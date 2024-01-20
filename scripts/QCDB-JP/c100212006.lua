--コード・オブ・ソウル
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --extra material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,id+o)
    e2:SetOperation(s.sumop)
    c:RegisterEffect(e2)
    --link summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCondition(s.lkcon)
    e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.lktg)
	e3:SetOperation(s.lkop)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.lmfilter(c,lc,tp,og,lmat)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsLinkCode(lc:GetCode()) and c:IsLinkType(TYPE_LINK)
		and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL)
		and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function s.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.lmfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
end
function s.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,s.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end
function s.mattg(e,c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_LINK)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
    e1:SetCountLimit(1,id+o*3)
	e1:SetCondition(s.linkcon)
	e1:SetOperation(s.linkop)
	e1:SetValue(SUMMON_TYPE_LINK)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetTarget(s.mattg)
	e2:SetLabelObject(e1)
    e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.lmfilter,tp,LOCATION_MZONE,0,1,nil,c,tp,og,lmat)
end
function s.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,s.lmfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp,og,lmat)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end
function s.mattg(e,c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_LINK)
end
function s.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function s.lkfilter(c)
	return c:IsLinkSummonable(nil) and c:IsLinkAbove(3) and c:IsRace(RACE_CYBERSE)
end
function s.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.lkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.lkfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,nil)
	end
end
