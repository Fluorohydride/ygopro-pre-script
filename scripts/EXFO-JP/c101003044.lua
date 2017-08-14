--スリーバーストショット・ドラゴン
--Three Burst Blast Dragon
--Scripted by Larry126
function c101003044.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsType,TYPE_TOKEN)),2)
	c:EnableReviveLimit()
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101003044,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c101003044.negcon)
	e1:SetTarget(c101003044.negtg)
	e1:SetOperation(c101003044.negop)
	c:RegisterEffect(e1) 
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101003044,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101003044)
	e3:SetCost(c101003044.spcost)
	e3:SetTarget(c101003044.sptg)
	e3:SetOperation(c101003044.spop)
	c:RegisterEffect(e3)
end
function c101003044.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and Duel.GetCurrentPhase()==PHASE_DAMAGE
end
function c101003044.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101003044.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c101003044.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101003044.spfilter1(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLink()<=2 
end
function c101003044.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_DRAGON) and c:IsLevelBelow(4)
end
function c101003044.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c101003044.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) and (ft>0 or e:GetHandler():GetSequence()<5) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c101003044.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c101003044.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		if Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)>0 
		and Duel.IsExistingMatchingCard(c101003044.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			if Duel.SelectYesNo(tp,aux.Stringid(101003044,2)) then
				local g2=Duel.SelectMatchingCard(tp,c101003044.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if g2:GetCount()>0 then
					Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
