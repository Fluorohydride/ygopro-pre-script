--The suppression PLUTO
--Script by nekrozar
function c100206010.initial_effect(c)
	--announce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100206010,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c100206010.target)
	e1:SetOperation(c100206010.operation)
	c:RegisterEffect(e1)
end
function c100206010.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c100206010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
		or Duel.IsExistingMatchingCard(c100206010.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c100206010.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
		local tg=g:Filter(Card.IsCode,nil,ac)
		local g1=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil)
		local g2=Duel.GetMatchingGroup(c100206010.desfilter,tp,0,LOCATION_ONFIELD,nil)
		if tg:GetCount()>0 and (g1 or g2) then
			Duel.BreakEffect()
			if g1 and g2 then
				op=Duel.SelectOption(tp,aux.Stringid(100206010,1),aux.Stringid(100206010,2))
			elseif g1 then
				op=Duel.SelectOption(tp,aux.Stringid(100206010,1))
			else
				op=Duel.SelectOption(tp,aux.Stringid(100206010,2))+1
			end
			if op==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
				local g=g1:Select(tp,1,1,nil)
				local tc=g:GetFirst()
				if tc and not Duel.GetControl(tc,tp) then
					if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
						Duel.Destroy(tc,REASON_EFFECT)
					end
				end
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=g2:Select(tp,1,1,nil)
				local tc=g:GetFirst()
				if not tc then return end
				Duel.HintSelection(g)
				if Duel.Destroy(g,REASON_EFFECT)~=0 and (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
					and not tc:IsLocation(LOCATION_HAND+LOCATION_DECK)
					and tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable()
					and Duel.SelectYesNo(tp,aux.Stringid(100206010,3)) then
					Duel.BreakEffect()
					Duel.SSet(tp,tc)
					Duel.ConfirmCards(1-tp,tc)
				end
			end
		end
		Duel.ShuffleHand(1-tp)
	end
end
