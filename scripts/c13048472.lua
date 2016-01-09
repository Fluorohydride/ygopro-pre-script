--Pre-Preparation of Rites
function c13048472.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13048472+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c13048472.target)
	e1:SetOperation(c13048472.activate)
	c:RegisterEffect(e1)
end

function c13048472.filter(c,tp)
	local m=_G["c"..c:GetCode()]
	if not m or m.fit_monster==nil then return false end
	local no=m.fit_monster[1]
	if no==nil then return false end
	local no2=nil
	if m.fit_monster[2]~=nil then
		no2=m.fit_monster[2]
	end
	if no and no2 then
		return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c13048472.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,no,no2)
	else
		return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand() and Duel.IsExistingMatchingCard(c13048472.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,no)
	end
end
function c13048472.filter2(c,no,no2)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() and (c:GetCode()==no or c:GetCode()==no2) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c13048472.filter3(c,no)
	if no==nil then return false end
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand() and c:GetCode()==no and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c13048472.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13048472.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13048472.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c13048472.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local m=_G["c"..g:GetFirst():GetCode()]
		local no=m.fit_monster[1]
		local no2=nil
		if m.fit_monster[2]~=nil then
			no2=m.fit_monster[2]
		end
		local mg=nil
		if no2~=nil then
			mg=Duel.GetMatchingGroup(c13048472.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,no,no2)
		else
			mg=Duel.GetMatchingGroup(c13048472.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,no)
		end
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
