--竜輝巧－バンα
function c97148796.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c97148796.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=aux.AddDrytronSpSummonEffect(c,c97148796.extraop) 
	e2:SetDescription(aux.Stringid(97148796,0)) 
	e2:SetCountLimit(1,97148796)
end
if Auxiliary.AddDrytronSpSummonEffect==nil then
	function Auxiliary.AddDrytronSpSummonEffect(c,func) 
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
		e1:SetCost(Auxiliary.DrytronSpSummonCost)
		e1:SetTarget(Auxiliary.DrytronSpSummonTarget)
		e1:SetOperation(Auxiliary.DrytronSpSummonOperation(func))
		c:RegisterEffect(e1)
		Duel.AddCustomActivityCounter(97148796,ACTIVITY_SPSUMMON,Auxiliary.DrytronCounterFilter)
		return e1
	end
end
function Auxiliary.DrytronCounterFilter(c)
	return not c:IsSummonableCard()
end
function Auxiliary.DrytronCostFilter(c,tp)
	return (c:IsSetCard(0x154) or c:IsType(TYPE_RITUAL)) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
		and (c:IsControler(tp) or c:IsFaceup())
end
function Auxiliary.DrytronExtraCostFilter(c,tp)
	return c:IsAbleToRemove() and c:IsHasEffect(101106066,tp)
end
function Auxiliary.DrytronSpSummonCost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Auxiliary.DrytronCostFilter,e:GetHandler(),tp)
	local g2=Duel.GetMatchingGroup(Auxiliary.DrytronExtraCostFilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return #g1>0 and Duel.GetCustomActivityCount(97148796,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(Auxiliary.DrytronSpSummonLimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--cant special summon summonable card check
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(97148796)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g1:Select(tp,1,1,nil)
	local tc=rg:GetFirst()
	local te=tc:IsHasEffect(101106066,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		Auxiliary.UseExtraReleaseCount(rg,tp)
		Duel.Release(tc,REASON_COST)
	end
end
function Auxiliary.DrytronSpSummonLimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsSummonableCard()
end
function Auxiliary.DrytronSpSummonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==100 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function Auxiliary.DrytronSpSummonOperation(func) 
	return function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			if not c:IsRelateToEffect(e) then return end
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then func(e,tp) end
		end
end
function c97148796.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x154)
end
function c97148796.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c97148796.extraop(e,tp)
	local g=Duel.GetMatchingGroup(c97148796.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(97148796,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
