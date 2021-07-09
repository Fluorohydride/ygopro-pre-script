--竜輝巧－ルタδ
function c22420202.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c22420202.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=aux.AddDrytronSpSummonEffect(c,c22420202.extraop)
	e2:SetDescription(aux.Stringid(22420202,0))
	e2:SetCountLimit(1,22420202)
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
end
function c22420202.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x154)
end
function c22420202.drfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER+TYPE_SPELL) and not c:IsPublic()
end
function c22420202.extraop(e,tp)
	local g=Duel.GetMatchingGroup(c22420202.drfilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22420202,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg=g:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
