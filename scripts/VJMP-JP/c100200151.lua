--デストーイ・マイスター
--Frightfur Meister
--Script by nekrozar
function c100200151.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200151,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,100200151)
	e1:SetCost(c100200151.spcost1)
	e1:SetTarget(c100200151.sptg1)
	e1:SetOperation(c100200151.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200151,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100200251)
	e2:SetTarget(c100200151.sptg2)
	e2:SetOperation(c100200151.spop2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100200151,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100200351)
	e3:SetCost(c100200151.spcost3)
	e3:SetTarget(c100200151.sptg3)
	e3:SetOperation(c100200151.spop3)
	c:RegisterEffect(e3)
end
function c100200151.costfilter1(c,e,tp)
	return c:IsLevelBelow(4) and (c:IsSetCard(0xa9) or c:IsSetCard(0xad) or c:IsSetCard(0xc3))
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c100200151.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel(),c:GetCode())
end
function c100200151.spfilter1(c,e,tp,lv,code)
	return c:IsRace(RACE_FIEND) and c:IsLevel(lv) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100200151.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100200151.costfilter1,1,nil,e,tp) end
	local rg=Duel.SelectReleaseGroup(tp,c100200151.costfilter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	e:SetValue(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
end
function c100200151.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100200151.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	local code=e:GetValue()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100200151.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100200151.spfilter2(c,e,tp)
	return (c:IsSetCard(0xa9) or c:IsSetCard(0xad) or c:IsSetCard(0xc3)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100200151.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100200151.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100200151.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100200151.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100200151.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100200151.splimit(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c100200151.costfilter(c)
	return c:IsLevelAbove(1) and c:IsRace(RACE_FIEND)
end
function c100200151.fselect(c,e,tp,rg,sg)
	sg:AddCard(c)
	local res=c100200151.fgoal(e,tp,sg) or rg:IsExists(c100200151.fselect,1,sg,e,tp,rg,sg)
	sg:RemoveCard(c)
	return res
end
function c100200151.lvcheck(g)
	local lv=0
	local tc=g:GetFirst()
	while tc do
		lv=lv+tc:GetLevel()
		tc=g:GetNext()
	end
	return lv
end
function c100200151.fgoal(e,tp,sg)
	if sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
		local lv=c100200151.lvcheck(sg)
		Duel.SetSelectedCard(sg)
		return Duel.CheckReleaseGroup(tp,nil,0,nil) and Duel.IsExistingMatchingCard(c100200151.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
	else return false end
end
function c100200151.spfilter3(c,e,tp,lv)
	return c:IsSetCard(0xad) and c:IsType(TYPE_FUSION) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c100200151.relfilter(c,g)
	return g:IsContains(c)
end
function c100200151.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp):Filter(c100200151.costfilter,nil)
	local g=Group.CreateGroup()
	if chk==0 then return rg:IsExists(c100200151.fselect,1,nil,e,tp,rg,g) end
	while true do
		local mg=rg:Filter(c100200151.fselect,g,e,tp,rg,g)
		if mg:GetCount()==0 or (c100200151.fgoal(e,tp,g) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectReleaseGroup(tp,c100200151.relfilter,1,1,nil,mg)
		g:Merge(sg)
	end
	local lv=c100200151.lvcheck(g)
	e:SetLabel(lv)
	Duel.Release(g,REASON_COST)
end
function c100200151.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100200151.spop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100200151.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
		end
	end
end
