--クロック・リザード
--Clock Lizard
--Script by nekrozar
function c101007047.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2,2)
	--fusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007047,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101007047.spcost)
	e1:SetTarget(c101007047.sptg)
	e1:SetOperation(c101007047.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007047,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c101007047.atkcon)
	e2:SetTarget(c101007047.atktg)
	e2:SetOperation(c101007047.atkop)
	c:RegisterEffect(e2)
end
function c101007047.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101007047.spfilter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c101007047.spfilter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c101007047.spfilter2(c,e,tp,m,f,chkf)
	return (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,true) and c:CheckFusionMaterial(m,nil,chkf)
end
function c101007047.spfilter3(c,e,tp,chkf)
	if not c:IsType(TYPE_FUSION) or not c:IsAbleToExtra() then return false end
	local mg=Duel.GetMatchingGroup(c101007047.spfilter0,tp,LOCATION_GRAVE,0,c)
	local res=c101007047.spfilter2(c,e,tp,mg,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=c101007047.spfilter2(c,e,tp,mg,mf,chkf)
		end
	end
	return res
end
function c101007047.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local chkf=tp
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101007047.spfilter3(chkc,e,tp,chkf) end
	if chk==0 then return Duel.GetLocationCountFromEx(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c101007047.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,chkf) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101007047.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101007047.spfilter3),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,chkf)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
		local mg1=Duel.GetMatchingGroup(c101007047.spfilter1,tp,LOCATION_GRAVE,0,nil,e)
		local mgchk1=c101007047.spfilter2(tc,e,tp,mg1,nil,chkf)
		local mg2=nil
		local mgchk2=false
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			mgchk2=c101007047.spfilter2(tc,e,tp,mg2,mf,chkf)
		end
		if (Duel.GetLocationCountFromEx(tp)>0 and mgchk1) or mgchk2 then
			if mgchk1 and (not mgchk2 or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	end
end
function c101007047.atkfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c101007047.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_CYBERSE)
	and Duel.IsExistingMatchingCard(c101007047.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c101007047.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101007047.atkfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	local atk=Duel.GetMatchingGroupCount(Card.IsRace,tp,LOCATION_GRAVE,0,nil)*400
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
