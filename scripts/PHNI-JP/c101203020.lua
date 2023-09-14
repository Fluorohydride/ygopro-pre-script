--粛声の竜賢姫サフィラ
--scripted by REIKAI
local s,id,o=GetID()
function s.initial_effect(c)
	--to grave search
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,id)
	e0:SetCost(s.tscost)
	e0:SetTarget(s.tstg)
	e0:SetOperation(s.tsop)
	c:RegisterEffect(e0)
	--Ritual Summon
	local e1=aux.AddRitualProcGreater2(c,s.filter,LOCATION_HAND,nil,nil,true)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id+o)
	e1:SetCost(aux.bfgcost)
	c:RegisterEffect(e1)
end
function s.tscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.tsfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function s.tstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tsfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.thcheck(c)
	return c:IsRace(RACE_DRAGON+RACE_WARRIOR) and c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tsfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thcheck),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thcheck),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function s.filter(c,e,tp,chk)
	return c:IsRace(RACE_DRAGON+RACE_WARRIOR) and c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_LIGHT) and (not chk or c~=e:GetHandler())
end