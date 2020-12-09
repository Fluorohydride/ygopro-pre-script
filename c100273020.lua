--サンヴァイン・クロスブリード
--Sunvine Cross Breed
--LUA by Kohana Sonogami
--
function c100273020.initial_effect(c)
	--Special Summon 1 Plant Monster from your GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100273020+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100273020.cost)
	e1:SetTarget(c100273020.target)
	e1:SetOperation(c100273020.activate)
	c:RegisterEffect(e1)
end
function c100273020.costfilter(c,tp)
	return c:IsType(TYPE_LINK) and (c:IsControler(tp) or c:IsFaceup())
end
function c100273020.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100273020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c100273020.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100273020.spfilter(chkc,e,tp) and chkc~=e:GetLabelObject() end
	if chk==0 then 
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.CheckReleaseGroup(tp,c100273020.costfilter,1,false,nil,tp)
		else
			return Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		end
	end
	local rg=nil
	if e:GetLabel()==1 then
		e:SetLabel(0)
		rg=Duel.SelectReleaseGroup(tp,c100273020.costfilter,1,1,false,nil,tp)
		Duel.Release(rg,REASON_COST)
		e:SetLabelObject(rg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100273020.spfilter,tp,LOCATION_GRAVE,0,1,1,rg,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100273020.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
