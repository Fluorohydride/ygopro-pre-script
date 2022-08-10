--御巫神楽
--
--Script by Trishula9
function c100419034.initial_effect(c)
	local e1=aux.AddRitualProcGreater2(c,c100419034.filter,LOCATION_HAND,nil,nil,false,c100419034.extraop)
	e1:SetCountLimit(1,100419034+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function c100419034.filter(c,e,tp)
	return c:IsSetCard(0x28c)
end
function c100419034.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	if not tc then return end
	local ct=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_EQUIP):GetClassCount(Card.GetCode)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100419034,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,ct,nil)
		Duel.Damage(1-tp,Duel.Destroy(sg,REASON_EFFECT)*1000,REASON_EFFECT)
	end
end