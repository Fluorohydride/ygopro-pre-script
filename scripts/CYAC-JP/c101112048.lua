--プロテクトコード・トーカー
--Script by 奥克斯
function c101112048.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101112048.imetg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101112048.imetg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101112048,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_ATTACK+TIMING_MAIN_END)
	e3:SetCountLimit(1,101112048)
	e3:SetCondition(c101112048.spcon)
	e3:SetCost(c101112048.spcost)
	e3:SetTarget(c101112048.sptg)
	e3:SetOperation(c101112048.spop)
	c:RegisterEffect(e3)
end
function c101112048.imetg(e,c)
	return c:IsType(TYPE_LINK) and c:IsLinkAbove(4)
end
function c101112048.filter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x28f)
end
function c101112048.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c101112048.filter,tp,LOCATION_MZONE,0,nil)
	return #g>0
end
function c101112048.rmfilter(c)
	return c:IsType(TYPE_LINK) and c:IsLinkBelow(3) and c:IsAbleToRemoveAsCost()
end
function c101112048.fselect(g)
	return g:GetSum(Card.GetLink)==3
end
function c101112048.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101112048.rmfilter,tp,LOCATION_GRAVE,0,c)
	if chk==0 then return g:CheckSubGroup(c101112048.fselect,1,#g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c101112048.fselect,false,1,#g)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c101112048.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101112048.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
