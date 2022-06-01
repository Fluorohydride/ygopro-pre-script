--Dimension Dice
local s,id,o=GetID()
function s.initial_effect(c)
	--If you control a card that has an effect that requires a die roll: Tribute 1 monster; Special Summon 1 monster from your hand or Deck that has a monster effect that requires a die roll.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetLabel(0)
	e1:SetCondition(s.con)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.act)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c.toss_dice
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.tfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.tfilter,1,nil,tp) end
	Duel.Release(Duel.SelectReleaseGroup(tp,s.tfilter,1,1,nil,tp),REASON_COST)
end
function s.filter(c,e,tp)
	return c.toss_dice and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(84046493,47558785,77994337)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local l=e:GetLabel()==1
	if chk==0 then e:SetLabel(0) return (l or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.act(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp),0,tp,tp,false,false,POS_FACEUP)
end
