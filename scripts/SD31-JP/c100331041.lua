--星刻の魔術師
--Startime Magician
--Scripted by Eerie Code
--Summon limit temporary, might require core update
function c100331041.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c100331041.matfilter,4,2)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c100331041.splimit)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100331041,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c100331041.thcost)
	e2:SetTarget(c100331041.thtg)
	e2:SetOperation(c100331041.thop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c100331041.reptg)
	e3:SetValue(c100331041.repval)
	c:RegisterEffect(e3)
end
function c100331041.matfilter(c)
	return c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)
end
function c100331041.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
		and (not se or se:GetHandler():IsCode(73860462)))
end
function c100331041.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100331041.thfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToHand()
end
function c100331041.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100331041.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100331041.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100331041.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0) then
		Duel.NegateEffect(0)
		return
	end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tc)
end
function c100331041.repfilter(c,tp)
	local seq=c:GetSequence()
	return c:IsFaceup() and c:IsControler(tp)
		and (c:IsLocation(LOCATION_MZONE) or (c:IsLocation(LOCATION_SZONE) and (seq==6 or seq==7)))
		and c:IsType(TYPE_PENDULUM) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c100331041.repcfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGrave()
end
function c100331041.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c100331041.repfilter,nil,tp)
	local g=Duel.GetMatchingGroup(c100331041.repcfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return ct>0 and g:GetCount()>0 end
	if Duel.SelectYesNo(tp,aux.Stringid(100331041,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		return true
	else return false end
end
function c100331041.repval(e,c)
	return c100331041.repfilter(c,e:GetHandlerPlayer())
end
