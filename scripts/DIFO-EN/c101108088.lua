--Libromancer Realized
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--You can reveal 1 "Libromancer" Ritual Monster in your hand: Special Summon 1 "Fire Token" (Cyberse/FIRE/ATK 0/DEF 0) with the same Level as the revealed monster. While you control that Token, you cannot Special Summon monsters, except "Libromancer" monsters. You can only use this effect of "Libromancer Realized" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetLabel(0)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x17c) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and not c:IsPublic()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,0,0,c:GetLevel(),RACE_CYBERSE,ATTRIBUTE_FIRE)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	e:SetLabel(tc:GetLevel())
	Duel.ShuffleHand(tp)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local l=e:GetLabel()==100
	if chk==0 then e:SetLabel(0) return l and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id+o,0,TYPES_TOKEN_MONSTER,0,0,lv,RACE_CYBERSE,ATTRIBUTE_FIRE) then
		local tk=Duel.CreateToken(tp,id+o)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(lv)
		tk:RegisterEffect(e1)
		Duel.SpecialSummon(tk,0,tp,tp,false,false,POS_FACEUP)
	end
end
