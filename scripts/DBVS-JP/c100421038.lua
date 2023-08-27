--ヴァルモニカ・イントナーレ
--Valmonica Intonare
--coded by Lyris
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.hfilter(c)
	return c:IsLevel(4) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,nil,0x2a3) and tp or 1-tp
	local c=e:GetOwner()
	local b1,b2=c:GetFlagEffect(100421031)>0,c:GetFlagEffect(100421032)>0
	if not (b1 or b2) then b1,b2=true,true end
	local op=aux.SelectFromOptions(p,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)}) end
	if op==1 then
		if Duel.Recover(tp,500,REASON_EFFECT)<1 then return end
		local g=Duel.SelectMatchingCard(1-tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif Duel.Damage(tp,500,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.hfilter),tp,LOCATION_GRAVE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
