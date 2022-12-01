--陰の光
--Script by 奥克斯
function c100297006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100297006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100297006)
	e1:SetCost(c100297006.cost1)
	e1:SetTarget(c100297006.target)
	e1:SetOperation(c100297006.activate)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100297006,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100297006+100)
	e2:SetCondition(c100297006.sumcon)
	e2:SetCost(c100297006.cost2)
	e2:SetTarget(c100297006.sumtg)
	e2:SetOperation(c100297006.sumop)
	c:RegisterEffect(e2)
end
function c100297006.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100297006.filter(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
		and c:GetOriginalLevel()>0
		and Duel.IsExistingMatchingCard(c100297006.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c100297006.spfilter(c,e,tp,tc)
	local b1=c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	return c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:GetOriginalRace()==tc:GetOriginalRace()
		and c:GetOriginalLevel()==tc:GetOriginalLevel()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (b1 or b2)
end
function c100297006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100297006.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100297006.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100297006.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c100297006.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100297006.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100297006.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,100297006)==0
end
function c100297006.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c100297006.cost1(e,tp,eg,ep,ev,re,r,rp,0) and c:IsAbleToRemove() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c100297006.cost1(e,tp,eg,ep,ev,re,r,rp,1)
end
function c100297006.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
end
function c100297006.sumop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(100297006,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,100297006,RESET_PHASE+PHASE_END,0,1)
end
