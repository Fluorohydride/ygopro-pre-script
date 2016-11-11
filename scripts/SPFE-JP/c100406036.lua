--法の聖典
--Scripture of Law
--Script by nekrozar
function c100406036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100406036)
	e1:SetLabel(0)
	e1:SetCost(c100406036.cost)
	e1:SetTarget(c100406036.target)
	e1:SetOperation(c100406036.activate)
	c:RegisterEffect(e1)
end
function c100406036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c100406036.filter1(c,e,tp)
	return c:IsSetCard(0x1f4) and Duel.IsExistingMatchingCard(c100406036.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalAttribute())
end
function c100406036.filter2(c,e,tp,att)
	return c:IsSetCard(0x1f4) and c:GetOriginalAttribute()~=att and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial()
end
function c100406036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c100406036.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c100406036.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetOriginalAttribute())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100406036.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local att=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100406036.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,att)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
		end
	end
end
