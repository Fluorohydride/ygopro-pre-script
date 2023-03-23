--Recette de Poisson～魚料理のレシピ～
--Script by 小壶
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,100420029)
	aux.AddRitualProcGreater2(c,s.filter,LOCATION_HAND,nil,nil,false,s.extraop)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x196)
end
function s.thfilter(c)
	return c:IsSetCard(0x197) and c:IsAbleToHand() and not c:IsCode(id) and c:GetType()&0x82==0x82
end
function s.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	if not tc then return end
	if tc:IsCode(100420029) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
