--獣・魔・導
--Beast Magic
--Scripted by Eerie Code
function c101005063.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101005063,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101005063+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(2)
	e1:SetCost(c101005063.cost)
	e1:SetTarget(c101005063.thtg)
	e1:SetOperation(c101005063.thop)
	c:RegisterEffect(e1)
	--spsummon (mythical)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(101005063,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetLabel(4)
	e2:SetTarget(c101005063.sptg1)
	e2:SetOperation(c101005063.spop1)
	c:RegisterEffect(e2)
	--spsummon (generic)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101005063,2))
	e3:SetLabel(6)
	e3:SetTarget(c101005063.sptg2)
	e3:SetOperation(c101005063.spop2)
	c:RegisterEffect(e3)
end
function c101005063.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.RemoveCounter(tp,1,0,0x1,ct,REASON_COST)
end
function c101005063.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10d) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c101005063.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005063.thfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_MZONE)
end
function c101005063.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c101005063.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c101005063.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x10d) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005063.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c101005063.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101005063.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101005063.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if tc:IsCanAddCounter(0x1,2) and Duel.SelectYesNo(tp,aux.Stringid(101005063,3)) then
			tc:AddCounter(0x1,2)
		end
	end
end
function c101005063.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005063.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c101005063.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101005063.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101005063.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
