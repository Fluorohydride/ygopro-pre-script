--BF-ツインシャドウ
--Script by Corvus1998
function c101110071.initial_effect(c)
	--- has dragon in content
	aux.AddCodeList(c,9012916)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,101110071+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101110071.cost)
	e1:SetTarget(c101110071.target)
	e1:SetOperation(c101110071.operate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c101110071.handcon)
	c:RegisterEffect(e2)
end
function c101110071.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33)
end
function c101110071.handcon(e)
	return Duel.GetMatchingGroupCount(c101110071.confilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>1
end
function c101110071.spfilter(c,e,tp,lv)
	if not (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) then
		return false
	end
	return (c:IsSetCard(0x33) or c:IsCode(9012916))
		and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv)
			and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c101110071.metfilter1(c,e,tp)
	local isRightCode=c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_TUNER)
	return c:IsFaceup() and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
			and isRightCode and (c:GetLevel()>0)
				and Duel.IsExistingMatchingCard(c101110071.metfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,c)
end
function c101110071.metfilter2(c,e,tp,tc)
	local isRightCode=c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
	return c:IsFaceup() and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
			and isRightCode and c:GetLevel()>0 
				and Duel.IsExistingMatchingCard(c101110071.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLevel()+tc:GetLevel())
end
function c101110071.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c101110071.metfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c101110071.metfilter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c101110071.metfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst())
	e:SetLabel(g1:GetFirst():GetLevel()+g2:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,SEQ_DECKTOP,REASON_COST)
end
function c101110071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then 
			return false
		else
			e:SetLabel(0)
			return true
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101110071.operate(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101110071.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
