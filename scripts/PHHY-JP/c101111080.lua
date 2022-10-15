--威迫矿石-召唤石
function c101111080.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101111080.target)
	e1:SetOperation(c101111080.activate)
	c:RegisterEffect(e1)
end
function c101111080.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101111080.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c101111080.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101111080.filter,tp,LOCATION_GRAVE,0,3,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,c101111080.filter,tp,LOCATION_GRAVE,0,3,3,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=g:Select(tp,1,1,nil)
	g:RemoveCard(g2:GetFirst())
	local opt=Duel.SelectOption(1-tp,aux.Stringid(101111080,0),aux.Stringid(101111080,1))
	if opt==0 then
		e:SetLabel(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	else
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c101111080.activate(e,tp,eg,ep,ev,re,r,rp)
	  local ex,g=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	  if e:GetLabel()==0 then 
		 if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		 end
	  else 
		 local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		  if g:GetCount()>0 and ct>0 then
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			   g:Select(tp,ct,ct,nil)
			   local tc=g:GetFirst()
			   while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					tc=g:GetNext()
			   end
			  Duel.SpecialSummonComplete()
		  end
	  end
end




