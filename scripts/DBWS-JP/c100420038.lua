--Recette de Viande～肉料理のレシピ～
--Script by 小壶
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,100420030)
	aux.AddRitualProcGreater2(c,s.filter,LOCATION_HAND,nil,nil,false,s.extraop)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x293)
end
function s.extraop(e,tp,eg,ep,ev,re,r,rp,tc,mat)
	if not tc then return end
	if tc:IsCode(100420030) and Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_DEFENSE) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_DEFENSE)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		end
	end
end
