--N·As·H Knight
--
--Script by Trishula9
function c100426003.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--battle indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c100426003.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100426003,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100426003)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(c100426003.ovcon)
	e2:SetCost(c100426003.ovcost)
	e2:SetTarget(c100426003.ovtg)
	e2:SetOperation(c100426003.ovop)
	c:RegisterEffect(e2)
end
function c100426003.indfilter(c)
	return c:IsSetCard(0x48) and c:IsFaceup()
end
function c100426003.indcon(e)
	return Duel.IsExistingMatchingCard(c100426003.indfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c100426003.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100426003.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c100426003.ovfilter(c,sc)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return no and no>=101 and no<=107 and c:IsCanBeXyzMaterial(sc)
end
function c100426003.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100426003.ovfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
end
function c100426003.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100426003,0))
	local mg=Duel.SelectMatchingCard(tp,c100426003.ovfilter,tp,LOCATION_EXTRA,0,1,1,nil,c)
	Duel.Overlay(c,mg)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100426003,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100426003,0))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if not tc:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			Duel.Overlay(c,Group.FromCards(tc))
		end
	end
end