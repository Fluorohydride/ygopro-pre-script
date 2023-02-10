--Recette de Poisson～鱼料理的食谱～ 
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,100420029,m)
	aux.AddRitualProcGreater2(c,cm.filter,LOCATION_HAND,nil,nil,false,cm.op)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x293)
end
function cm.opf1(c)
	return c:IsSetCard(0x294) and c:IsAbleToHand() and not c:IsCode(m) and c:GetType()&0x82==0x82
end
function cm.op(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	if not tc then return end
	if tc:IsCode(100420029) and Duel.IsExistingMatchingCard(cm.opf1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.opf1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
